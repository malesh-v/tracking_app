require 'rails_helper'

describe 'Status pages' do
  describe 'list page' do

    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }

    it 'page "Statuses list"' do
      first = Status.create!(name: 'test')
      count = Status.count

      visit statuses_path
      expect(page).to have_content('Statuses list')
      expect(page).to have_title('Statuses')

      have_link('New status', href: new_status_path, count: 1)
      have_link('Edit',       href: edit_status_path(first), count: count)
      have_link('Destroy',    href: statuses_path(first), count: count)
    end
  end
end