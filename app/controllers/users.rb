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

get '/users/reset_password/:token' do |token|
  @token = token
  erb :"users/reset_password"
end

get '/users/reset_password' do
  erb :"users/reset_password_email"
end

post '/users/reset_password_email' do
  user = User.first(:email => params[:email])
  password_token = (1..64).map{('A'..'Z').to_a.sample}.join
  password_token_timestamp = Time.now
  user.password_token = password_token
  user.password_token_timestamp = password_token_timestamp
  user.save
  email = user.email
  user.send_reset_message(email, password_token)
  flash[:notice] = "Your reset password link is on its way!"
end
  

post '/users/new_password' do
  @user = User.first(password_token: params[:token])
  password              = params[:password]
  password_confirmation = params[:password_confirmation]
  if @user.password_token_timestamp.to_time >= Time.now - 3600
     @user.update(  password:                 password, 
                    password_confirmation:    password_confirmation,
                    password_token:           nil,
                    password_token_timestamp: nil)
    flash[:notice] = "password changed"
  elsif password != password_confirmation
    flash[:notice] = "Sorry, your passwords don't match."
  else
    flash[:notice] = "Sorry, your password reset email has expired."
  end
end

delete '/users/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "Good bye!"
  redirect to('/')
end