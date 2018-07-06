require 'rails_helper'
require 'support/utilities'

describe 'Authentication' do

  let(:admin) { FactoryGirl.create(:admin) }

  before do
    Status.create!(name: 'status')

    sign_in admin
    visit statuses_path
  end

  describe 'create new status with diff params', js: true do
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

  describe 'delete and update status', js: true do

    let(:name) { 'new status name' }

    it 'delete status' do
      expect do
        accept_confirm do
          first('a',{ text: 'Destroy' }).click
        end
        assert_selector('div.alert.alert-info')
      end.to change(Status, :count).by(-1)
    end

    it 'update status' do
      first('a',{ text: 'Edit', class: 'badge', id: 'edit_link' }).click
      fill_in 'Name', with: name
      click_button 'Save'
      assert_selector('div.alert.alert-info')
      assert_selector('li.list-group-item', text: name, count: 1)

      Status.find_by(name: name).should_not be_nil
    end

    it 'update with blank input' do
      first('a',{ text: 'Edit', class: 'badge', id: 'edit_link' }).click
      fill_in 'Name', with: ''
      click_button 'Save'
      have_selector('div.alert.alert-danger')
      assert_selector('form#status_form', count: 1)
    end
  end
end