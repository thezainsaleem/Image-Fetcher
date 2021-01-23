require_relative 'scraper'
require 'fileutils'
require 'minitest/autorun'

class ScraperTest < Minitest::Test
  def test_defaults
    scraper = Scraper.new

    assert scraper != nil
    assert scraper.options == Scraper::DEFAULT_OPTIONS
  end

  def test_options_override
    scraper = Scraper.new({
      "targetted_url" => "http://www.google.com",
      "targetted_items" => [],
      "path_to" => "/"
    })
    
    assert scraper.options[:targetted_url] == "http://www.google.com"
    assert scraper.options[:targetted_items] == []
    assert scraper.options[:path_to] == "/"
  end

end