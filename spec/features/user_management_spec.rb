require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs in" do 

	before(:each) do 
		User.create(:email => "test@test.com",
								:password => "test",
								:password_confirmation => "test")
	end

	scenario "with correct credentials" do 
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in("test@test.com", "test")
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do 
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in("test@test.com", "wrong")
		expect(page).to have_content("The email or password is incorrect")
	end

end

feature "User signs up" do 

	scenario "when being logged in" do 
		lambda { sign_up }.should change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do
		lambda { sign_up('a@a.com','pass','wrong')}.should change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Sorry, your passwords don't match")
	end

	scenario "With an email that is already registered" do 
		lambda {sign_up}.should change(User, :count).by(1)
		lambda {sign_up}.should change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

end

feature 'User signs out' do

	before(:each) do
		User.create(:email => "test@test.com",
								:password => 'test',
								:password_confirmation => 'test')
	end

	scenario 'while being signed in' do
		sign_in('test@test.com', 'test')
		click_button "Sign out"
		expect(page).to have_content("Good bye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

feature 'User resets password' do 

	scenario 'request password email to be sent' do
		user = User.create(:email                 => "test@test.com",
											 :password              => 'test',
								       :password_confirmation => 'test')
		visit 'users/reset_password'
		fill_in "email", :with => "test@test.com" 
		click_button "Forgotten Password"
		expect(page).to have_content("Your reset password link is on its way!")
	end

	scenario 'enters a new password correctly within the time frame' do 
		user = User.create(:email                 => "test@test.com",
										 :password              => 'test',
							       :password_confirmation => 'test',
							       :password_token => 12345678,
							       :password_token_timestamp => Time.now)
		visit "users/reset_password/12345678"
		fill_in "password", :with => "newpass"
		fill_in "password_confirmation", :with => "newpass"
		click_button "New Password"
		expect(page).to have_content("password changed")
	end

	scenario 'enters a new password correctly not in the time frame' do 
		user = User.create(:email                 => "test@test.com",
											 :password              => 'test',
								       :password_confirmation => 'test',
								       :password_token => 12345678,
								       :password_token_timestamp => Time.now-3605)
		visit "users/reset_password/12345678"
		fill_in "password", :with => "newpass"
		fill_in "password_confirmation", :with => "newpass"			
		click_button "New Password"
		expect(page).to have_content("Sorry, your password reset email has expired.")
	end

	scenario 'enters a new password incorrectly' do 
		user = User.create(	:email                 => "test@test.com",
											:password              => 'test',
								     	:password_confirmation => 'test',
								      :password_token => 12345678,
								      :password_token_timestamp => Time.now-3605)
		visit "users/reset_password/12345678" 
		fill_in "password", :with => "newpass"
		fill_in "password_confirmation", :with => "newpas"			
		click_button "New Password"
		expect(page).to have_content("Sorry, your passwords don't match.")
	end

end































