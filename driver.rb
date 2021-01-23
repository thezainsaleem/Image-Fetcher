require_relative 'scraper_worker'

# Chose this method, based on research from the following article
# https://tjay.dev/howto-working-efficiently-with-large-files-in-ruby/
# ideal results for large files [time and space]

file_name = ARGV[0]
if file_name
  file = File.foreach(file_name)
  file.each_entry do  |url|
    url.strip!
    unless url.empty?
      ScraperWorker.perform_async({
        "targetted_url" => url.chomp,
        "path_to" => "#{Dir.pwd}/scraped_images"
        })
    end
  end
  puts "Head over to output folder or look at scraper.log"
end
