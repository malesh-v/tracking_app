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
      visit edit_status_path(status)
      expect(current_path).to eq edit_status_path(status)
    end
  end
end