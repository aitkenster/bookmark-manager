require 'sinatra/base'
require 'data_mapper'
require 'database_cleaner'
require './lib/link'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

DataMapper.finalize

DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

	set :views, './views'

  get '/' do
    @links = Link.all 
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
