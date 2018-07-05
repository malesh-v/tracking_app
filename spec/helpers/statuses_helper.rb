require 'rails_helper'

shared_context 'shared requests' do
  describe 'GET statuses list' do
    specify do
      visit statuses_path
      expect(current_path).to eq root_path
    end
  end
end

shared_context 'shared requests admin', js: true do

  before do
    5.times {|i| Status.create!(name: "name ex #{i}") }
    visit statuses_path
  end

  describe 'admin is able to see status page' do
    it 'admin is able to see status page' do
      assert_selector('form#status_form', count: 0)

      assert_selector('a#edit_link',    text: 'Edit',       count: Status.count)
      assert_selector('a.badge.delete', text: 'Destroy',    count: Status.count)
      assert_selector('a.badge',        text: 'Back',       count: 0)
      assert_selector('a#new_link',     text: 'New Status', count: 1)
      assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                      count: 0)
    end
  end

  describe 'admin can use create and edit form for status' do
    specify 'edit status form' do
      status = Status.first

      #open edit form
      first('a',{ text: 'Edit', class: 'badge', id: 'edit_link' }).click
      assert_selector('a#edit_link',    text: 'Edit',       count: 0)
      assert_selector('a.badge.delete', text: 'Destroy',    count: 0)
      assert_selector('a.badge',        text: 'Back',       count: 1)
      assert_selector('a#new_link',     text: 'New Status', count: 1)
      assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                      count: 1)

      assert_selector('form#status_form', count: 1)
      assert_selector("li#status_#{status.id}>form#status_form>input.form-control[value='#{status.name}']")
    end

    specify 'new status form' do
      click_link 'New Status'

      assert_selector('ul.list-group>form#status_form>input.form-control')
      assert_selector('form#status_form', count: 1)

      assert_selector('a#new_link',     text: 'New Status', count: 0)
      assert_selector('a#edit_link',    text: 'Edit',       count: Status.count)
      assert_selector('a.badge.delete', text: 'Destroy',    count: Status.count)
      assert_selector('a.badge',        text: 'Back',       count: 1)
      assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                      count: 1)
    end
  end

  describe 'get back' do
    it 'new form and back' do
      click_link 'New Status'
      click_link 'Back'

      assert_selector('form#status_form', count: 0)

      assert_selector('a#edit_link',    text: 'Edit',       count: Status.count)
      assert_selector('a.badge.delete', text: 'Destroy',    count: Status.count)
      assert_selector('a.badge',        text: 'Back',       count: 0)
      assert_selector('a#new_link',     text: 'New Status', count: 1)
      assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                      count: 0)
    end
    it 'edit form and back' do
      first('a',{ text: 'Edit', class: 'badge', id: 'edit_link' }).click
      click_link 'Back'

      assert_selector('form#status_form', count: 0)

      assert_selector('a#edit_link',    text: 'Edit',       count: Status.count)
      assert_selector('a.badge.delete', text: 'Destroy',    count: Status.count)
      assert_selector('a.badge',        text: 'Back',       count: 0)
      assert_selector('a#new_link',     text: 'New Status', count: 1)
      assert_selector('input.btn.btn-large.btn-primary', id: 'save_status',
                      count: 0)
    end
  end
end