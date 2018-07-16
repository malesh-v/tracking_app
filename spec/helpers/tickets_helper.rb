require 'rails_helper'

shared_context 'tickets page' do
  describe 'GET statuses list' do
    specify do
      click_button 'Search'

      #tickets path
      expect(current_path).to eq tickets_path
      assert_selector('li.list-group-item > a.show_ticket', count: 2)
      assert_selector('a.badge', text: 'Edit',              count: 2)
      assert_selector('li.filter > a.list-group-item',      count: 0)
      assert_selector('div#header-tickets > h1', text: 'Tickets list', count: 1)
    end
  end
end