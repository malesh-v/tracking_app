require 'rails_helper'

shared_context 'shared requests' do
  describe 'GET departmentes list' do
    specify do
      visit departments_path
      expect(current_path).to eq root_path
    end
  end

  describe 'GET #new' do
    specify do
      visit new_department_path
      expect(current_path).to eq root_path
    end
  end

  describe 'GET #edit' do
    specify do
      department = Department.create!(name:'some name')
      visit edit_department_path(department)
      expect(current_path).to eq root_path
    end
  end
end

shared_context 'shared requests admin' do
  describe 'admin can see departmentes list' do
    specify do
      visit departments_path
      expect(current_path).to eq departments_path
    end
  end

  describe 'admin able to see create new department page' do
    specify do
      visit new_department_path
      expect(current_path).to eq new_department_path
    end
  end

  describe 'admin is able to department edit page' do
    specify do
      department = Department.create!(name:'some name')
      visit edit_department_path(department)
      expect(current_path).to eq edit_department_path(department)
    end
  end
end