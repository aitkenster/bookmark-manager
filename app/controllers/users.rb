get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.new(:email => params[:email],
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

get '/users/reset_password/:token' do |token|
  @token = token
  erb :"users/reset_password"
end

get '/users/reset_password' do
  erb :"users/reset_password_email"
end

post '/users/reset_password_email' do
  user = User.first(:email => params[:email])
  user.generate_token_and_timestamp
  user.send_reset_message(user.email, user.password_token)
  flash[:notice] = "Your reset password link is on its way!"
end


post '/users/new_password' do
  @user = User.first(password_token: params[:token])

  if params[:password] != params[:password_confirmation]
      flash[:notice] = "Sorry, your passwords don't match."
  elsif @user.password_token_timestamp >= (Time.now - 3600)
    @user.update( password:                 params[:password],
                  password_confirmation:    params[:password_confirmation],
                  password_token:           nil,
                  password_token_timestamp: nil)
    flash[:notice] = "password changed"
  else
    flash[:notice] = "Sorry, your password reset email has expired."
  end
end

delete '/users/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "Good bye!"
  redirect to('/')
end