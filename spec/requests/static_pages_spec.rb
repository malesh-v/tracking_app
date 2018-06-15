require 'rails_helper'

describe 'Static pages' do
  describe 'Home page' do

    it 'should have the content "Tracking App"' do
      visit '/static_pages/home'
      expect(page).to have_content('Tracking App')
    end

    it 'should have the title "Home"' do
      visit '/static_pages/home'
      expect(page).to have_title('Tracking App | Home')
    end
  end

  describe 'Help page' do

    it 'should have the content "Help"' do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end
end
