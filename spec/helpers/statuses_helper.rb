require 'rails_helper'

shared_context 'shared requests' do
  describe 'GET statuses list' do
    specify do
      visit statuses_path
      expect(current_path).to eq root_path
    end
  end

  describe 'GET #new' do
    specify do
      visit new_status_path
      expect(current_path).to eq root_path
    end
  end

  describe 'GET #edit' do
    specify do
      status = Status.create!(name:'some name')
      visit edit_status_path(status)
      expect(current_path).to eq root_path
    end
  end
end

shared_context 'shared requests admin' do
  describe 'admin can see statuses list' do
    specify do
      visit statuses_path
      expect(current_path).to eq statuses_path
    end
  end

  describe 'admin able to see create new status page' do
    specify do
      visit new_status_path
      expect(current_path).to eq new_status_path
    end
  end

  describe 'admin is able to status edit page' do
    specify do
      status = Status.create!(name:'some name')
      visit statuses_path
      assert_selector('a',{class: 'badge', id: 'edit_link'})
      #click_link_or_button('Edit')
      sleep 1

      visit edit_status_path(status)
      assert_selector(:xpath, "//input[@class='form-control']")


      li_item = 'li[@id=status_' + "#{status.id}" + ']'
      form_item = 'form[@action=' + "#{edit_status_path(status)}" + ']'
      input = "input[@class='form-control' and @value='" + status.name + "']"

      assert_selector(:xpath, "//#{li_item}/#{form_item}/#{input}")

      have_field('Email', :type => 'email')
      expect(current_path).to eq current_path
    end
  end
end