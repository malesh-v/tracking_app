require 'rails_helper'

describe 'Status pages' do
  describe 'list page' do

    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }

    it 'should have the content "Statuses list"' do
      visit statuses_path
      expect(page).to have_content('Statuses list')
      expect(page).to have_title('Statuses')
    end

    it 'should have the content "Editing Status"' do
      Status.create!(name: 'example')
      visit statuses_path
      click_link 'Edit'
      expect(page).to have_content('Editing Status')
      expect(page).to have_title('Editing Status')
    end

    it 'should have the content "New Status"' do
      visit statuses_path
      click_link 'New Status'
      expect(page).to have_content('New Status')
      expect(page).to have_title('New Status')
    end
  end
end