require 'spec_helper'
require './app/bookmark-manager'

feature "a list of available tags is displayed on the homepage" do 

before (:each) {
		Link.create(:url => "http://www.makersacademy.com",
								:title => "Makers Academy",
								:tags => [Tag.first_or_create(:text => 'education')])
end

scenario "when opening the home page expect to see list of tags" do 
	visit'/'
	expect(page).to have_content ("education")
end