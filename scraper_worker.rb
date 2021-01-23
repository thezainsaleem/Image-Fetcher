require_relative 'scraper'
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = {
    db: 1
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    db: 1
  }
end


class ScraperWorker
  include Sidekiq::Worker

  def perform(options = {})
    Scraper.new(options).run
  end
end