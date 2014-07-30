require 'sinatra/base'
require 'data_mapper'
require 'database_cleaner'
require 'rack-flash'
require 'rest-client'
require_relative 'data_mapper_setup'
require './lib/user'
require './lib/tag'
require './lib/link'



class BookmarkManager < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret'
  use Rack::Flash

  get '/' do
    @links = Link.all 
    erb :index
  end

  post '/links' do 
  	url = params["url"]
  	title = params["title"]
  	tags = params["tags"].split(" ").map do |tag|
  		Tag.first_or_create(:text => tag)
  	end
  	Link.create(:url => url, :title => title, :tags => tags)
  	redirect to('/')
  end

  get '/tags/:text' do 
  	tag = Tag.first(:text => params[:text])
  	@links = tag ? tag.links : []
  	erb :index
  end

  get '/users/new' do
  	@user = User.new
    erb :"users/new"
  end

  post '/users' do 
    @user = User.create(:email => params[:email],
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

  post '/sign_out' do
      session[:user_id] = nil
      flash[:notice] = "Good bye!"
      redirect to('/')
  end

  get '/users/reset_password' do
    erb :"users/reset_password_email"
  end

  post '/reset_password_email' do
    user = User.first(:email => params[:email])
    password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    password_token_timestamp = Time.now
    user.password_token = password_token
    user.password_token_timestamp = password_token_timestamp
    user.save
    email = user.email
    user.send_simple_message(email, password_token)
    "Your reset password link is on its way!"
  end
  
  get '/users/reset_password/:token' do |token|
    @token = token
    erb :"users/reset_password"
  end

  post '/new_password' do
    @user = User.first(password_token: params[:token])
    password              = params[:password]
    password_confirmation = params[:password_confirmation]
    if @user.password_token_timestamp.to_time >= Time.now - 3600
      @user.update(password: password, 
                  password_confirmation: password_confirmation,
                  password_token: nil,
                  password_token_timestamp: nil   )
      "password changed"
    elsif 
      password == password_confirmation

      "Sorry, your password reset email has expired."
    end
  end

  helpers do 
  	def current_user
  		@current_user ||=User.get(session[:user_id]) if session[:user_id]
  	end
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
