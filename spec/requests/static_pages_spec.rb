require 'rails_helper'

describe 'Static pages' do
  describe 'Home page' do

    it 'should have the content "Tracking App"' do
      visit root_path
      expect(page).to have_content('Tracking app')
      expect(page).to have_title('Home | Tracking App')
    end
  end

  describe 'Help page' do

    it 'should have the content "Help"' do
      visit '/help'
      expect(page).to have_content('Help')
      expect(page).to have_title('Help | Tracking App')
    end
  end
end
