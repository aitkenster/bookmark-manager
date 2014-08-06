# class BookmarkManager < Sinatra::Base

get '/' do
  @links = Link.all 
  @tags = Tag.all
 	erb :index
end

# end
