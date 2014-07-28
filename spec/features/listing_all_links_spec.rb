require 'link'
require 'bookmark-manager'
require 'spec_helper'

feature "User browses the list of links" do 

	before (:each) {
		Link.create(:url => "http://www.makersacademy.com",
								:title => "Makers Academy")
		}

	scenario "when opening the home page" do 
		visit '/'
		save_and_open_page
		expect(page).to have_content("Makers Academy")
	end

end