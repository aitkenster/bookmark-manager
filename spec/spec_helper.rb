ENV["RACK_ENV"] = 'test'

require './lib/bookmark-manager'
require 'capybara/rspec'

Capybara.app = BookmarkManager.new 

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
 
end
