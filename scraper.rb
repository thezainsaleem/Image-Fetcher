require 'httparty'
require 'nokogiri'
require 'date'

class Scraper
  DEFAULT_OPTIONS = {
      targetted_url: 'https://www.gettyimages.com',
      targetted_items: ["img"],
      path_to: Dir.pwd
  }
  
  TARGETTED_ITEMS = {
    img: "img"
  }

  attr_accessor :options, :results

  def initialize(options = {})
      @logger = Logger.new("scraper.log")
      @options = {
        targetted_url:   options["targetted_url"]   || DEFAULT_OPTIONS[:targetted_url],
        targetted_items: options["targetted_items"] || DEFAULT_OPTIONS[:targetted_items],
        path_to:         options["path_to"]         || DEFAULT_OPTIONS[:path_to]
      }
    end

  def run
    @logger.info("
      Running Scrapper on
      URL: #{@options[:targetted_url]}
      Targets: #{@options[:targetted_items]}
    ")
    scraped_page = scrape_page(@options[:targetted_url])
    @options[:targetted_items].each do |targetted_item|
      targetted_items_collection = scraped_page.css(targetted_item)
      @logger.info("
        targetted_items_collection: #{targetted_items_collection}
      ")
      case targetted_item
      when TARGETTED_ITEMS[:img]
        format_img_results(targetted_items_collection)
      end
    end
  end

  def scrape_page(url)
    Nokogiri::HTML(HTTParty.get(url))
  end

  def format_img_results(items)
    items.each do |img_tag|
      if image_source = img_tag.attributes['src']
        begin
          # To make unique names/avoid collision
          image_file_name = "#{@options[:path_to]}/#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')}#{image_source.to_s.split("/").last}"
          response = HTTParty.get(image_source)
          case response.code
          when 200
              image_file = response.body
              File.write(image_file_name, image_file) unless image_file.nil?
            when 404
              @logger.info("
                Image not found
                Response Code: #{response.code}
                Image Source: #{image_source}
              ")
            when 500...600
              @logger.info("
                Image request Internal error
                Response Code: #{response.code}
                Image Source: #{image_source}
              ")
          end
        rescue HTTParty::Error => httparty_error
          @logger.info("
            Image request HTTParty error
            image_source: #{image_source}
            #{httparty_error.backtrace}
          ")
        rescue => exception
          @logger.info("
            Unhandled exception
            image_source: #{image_source}
            #{exception.backtrace}
          ")
        end
      end
    end
  end
end 

