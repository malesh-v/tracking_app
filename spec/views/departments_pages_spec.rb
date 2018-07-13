require 'rails_helper'
require 'spec_helper'

describe 'Departments page' do
  describe 'list page' do

    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }

    it 'page "Departments list"' do
      first = Department.create!(name: 'test')
      count = Department.count

      visit departments_path
      expect(page).to have_content('Departments list')
      expect(page).to have_title('Departments')

      have_link('New Department', href: new_department_path, count: 1)
      have_link('Edit',           href: edit_department_path(first), count: count)
      have_link('Destroy',        href: department_path(first), count: count)
    end

    it 'page "Editing Department"' do
      Department.create!(name: 'example')

      visit departments_path
      first('li.list-group-item').click_link('Edit')

      expect(page).to have_content('Editing Department')
      expect(page).to have_title('Editing Department')

      have_link('Back', href: departments_path)
    end

    it 'page "New Department"' do
      visit departments_path
      click_link 'New Department'
      expect(page).to have_content('New Department')
      expect(page).to have_title('New Department')

      have_link('Back', href: departments_path)
    end
  end
end