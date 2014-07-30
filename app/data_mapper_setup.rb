env = ENV["RACK_ENV"] || "development" 


DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")

require_relative '../lib/link'
require_relative '../lib/tag'
require_relative '../lib/user'
DataMapper.finalize