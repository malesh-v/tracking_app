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

      visit ticket_path(Ticket.first)
      expect(html_part.decoded).to have_link(url_with_term)

      debugger
      find(:xpath, "//a[@href=#{url_with_term}]")

    end
    specify do

      click_button 'Search'

      find(:xpath, "//a[@href='/tickets?no_term=true']").click

      #tickets path
      expect(current_path).to eq tickets_path
      assert_selector('li.filter > a.list-group-item',                 count: 4)
      assert_selector('div#header-tickets > h1', text: 'Tickets list', count: 1)

      visit edit_ticket_path(ticket)

    end
  end
end