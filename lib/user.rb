require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String, :unique =>true, :message => "This email is already taken"
	property :password_digest, Text
	property :password_token, Text
	property :password_token_timestamp, DateTime

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user 
		else
			nil
		end
	end

	attr_reader :password
	attr_accessor :password_confirmation

	validates_confirmation_of :password, :message => "Sorry, your passwords don't match" 

  def generate_token_and_timestamp
    password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    password_token_timestamp = Time.now
    save
    puts password_token
    puts password_token_timestamp 
  end

end

