require 'rails_helper'
require 'support/utilities'

shared_context 'tickets page' do
  describe 'GET statuses list' do

    before { click_button 'Search' }

    specify 'observe link with term' do
      url_with_term = tickets_path(term: "#{cookies[:term]}")
      url_clear_term = tickets_path(no_term: 'true')

      assert_selector("a[href='#{url_clear_term}']", text: 'All Tickets', count: 1)

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

      find(:xpath, "//a[@href='/tickets?no_term=true']")
    end
    specify 'search and clear term' do
      url_clear_term = tickets_path(no_term: 'true')

      assert_selector("a[href='#{url_clear_term}']", text: 'All Tickets', count: 1)
      find(:xpath, "//a[@href='/tickets?no_term=true']").click

      #clear term from cookies
      assert_selector('li.filter > a.list-group-item', count: 4)
      assert_selector("a[href='#{tickets_path}']", text: 'All Tickets', count: 1)

      #show ticket parh
      visit ticket_path(Ticket.first)
      assert_selector("a[href='#{tickets_path}']", text: 'Back', count: 1)

      #edit ticket path
      visit edit_ticket_path(Ticket.first)
      assert_selector("a[href='#{tickets_path}']", text: 'Back', count: 1)
    end
  end
end