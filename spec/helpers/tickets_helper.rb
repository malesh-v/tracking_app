require 'rails_helper'
require 'support/utilities'

shared_context 'tickets page' do
  describe 'GET statuses list' do

    specify do
      click_button 'Search'

      url_with_term = tickets_path(term: "#{cookies[:term]}")
      find(:xpath, "//a[@href='/tickets?no_term=true']")
      #tickets path
      expect(current_path).to eq tickets_path
      assert_selector('li.list-group-item > a.show_ticket', count: 2)
      assert_selector('a.badge', text: 'Edit',              count: 2)
      assert_selector('li.filter > a.list-group-item',      count: 0)
      assert_selector('div#header-tickets > h1', text: 'Tickets list', count: 1)

      #show ticket parh
      visit ticket_path(Ticket.first)
      assert_selector("a[href='#{url_with_term}']", text: 'Back', count: 1)

      #edit ticket path
      visit edit_ticket_path(Ticket.first)
      assert_selector("a[href='#{url_with_term}']", text: 'Back', count: 1)
    end
    specify do
      url_with_term = tickets_path(term: "#{cookies[:term]}")
      click_button 'Search'

      find(:xpath, "//a[@href='/tickets?no_term=true']")

      #tickets path
      expect(current_path).to eq tickets_path
      assert_selector('li.list-group-item > a.show_ticket', count: 2)
      assert_selector('a.badge', text: 'Edit',              count: 2)
      assert_selector('li.filter > a.list-group-item',      count: 0)
      assert_selector('div#header-tickets > h1', text: 'Tickets list', count: 1)

      #show ticket parh
      visit ticket_path(Ticket.first)
      assert_selector("a[href='#{url_with_term}']", text: 'Back', count: 1)

      #edit ticket path
      visit edit_ticket_path(Ticket.first)
      assert_selector("a[href='#{url_with_term}']", text: 'Back', count: 1)
    end
  end
end