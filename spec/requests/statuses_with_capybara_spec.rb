require 'rails_helper'
require 'support/utilities'

describe 'Authentication' do

  let(:admin) { FactoryGirl.create(:admin) }

  before do
    sign_in admin
    visit statuses_path
  end

  describe 'create new status params', js: true do
    it 'create new status with blank input' do
      expect do
        assert_selector('a#new_link', text: 'New Status', count: 1)

        click_link 'New Status'
        click_button 'Save'

        have_selector('div.alert.alert-danger')
        assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                        count: 1)
      end.to change(StaffMember, :count).by(0)
    end
    it 'try create double status' do
      status = Status.create!(name: 'temp')
      expect do
        assert_selector('a#new_link', text: 'New Status', count: 1)

        click_link 'New Status'
        fill_in 'Name', with: status.name
        click_button 'Save'

        assert_selector('div.alert.alert-danger')
        assert_selector('form#status_form', count: 1)
      end.to change(Status, :count).by(0)
    end
    it 'create new status' do
      expect do
        assert_selector('a#new_link', text: 'New Status', count: 1)

        click_link 'New Status'
        fill_in 'Name', with: 'valid status'
        click_button 'Save'

        assert_selector('div.alert.alert-info')
        assert_selector('form#status_form', count: 0)

      end.to change(Status, :count).by(1)
    end
  end
end