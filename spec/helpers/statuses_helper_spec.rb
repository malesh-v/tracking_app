require 'rails_helper'

RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'shared requests', :shared_context => :metadata do
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

RSpec.shared_context 'shared requests admin', :shared_context => :metadata do
  describe 'GET statuses list' do
    specify do
      visit statuses_path
      expect(current_path).to eq statuses_path
    end
  end

  describe 'GET #new' do
    specify do
      visit new_status_path
      expect(current_path).to eq new_status_path
    end
  end

  describe 'GET #edit' do
    specify do
      status = Status.create!(name:'some name')
      visit edit_status_path(status)
      expect(current_path).to eq edit_status_path(status)
    end
  end
end