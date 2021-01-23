


# Setup Instructions

## Prerequisites:

- git

- redis (open credentials)


## In order to run

- git clone git@github.com:thezainsaleem/Image-Fetcher.git
- cd Image-Fetcher
- bundle install
- make sure to run redis-server
- RUBYOPT="-W0" bundle exec sidekiq -r ./scraper_worker.rb
- ruby driver.rb [filename] (input_file.txt)


## Output

- By default all images are dumped into a folder in current folder called "scraped_images"
- It can be changed invidually for each web url from driver.rb


## Gemfile

- httparty (Requesting html pages)
- nokogiri (Parsing HTML page)
- sidekiq (Multithreading - Non-blocking parsing)


## Limitations

- This app only scrapes images from webpages
- This app only parses .txt files (plaintext)

## Possible Future Enhancement

### Scraper

- Support to scrape tags other than img can be added by passing "targetted_items" array to Scraper class' intialize method (default ["img"]) 
- Furthermore, a new method to handle such tag can be added similar to `format_img_results` and case statement in `run` method

### File parsing

- File parsing can be extracted into a separate class to make it dynamic (handling other formats like csv, xlsx, etc)


## Credits

- Following article compares common read methods in ruby based on time and space utilization https://tjay.dev/howto-working-efficiently-with-large-files-in-ruby/
- Following article helps compare and explains different multithreading and multiprocessing options in ruby https://www.toptal.com/ruby/ruby-concurrency-and-parallelism-a-practical-primer