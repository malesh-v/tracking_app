require 'rails_helper'
require 'support/utilities'
require 'helpers/tickets_helper'

describe 'Ticket' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }

  before { sign_in staffmember }

  describe 'as staff' do

    let(:ticket) { FactoryGirl.create(:ticket) }

    before do
      FactoryGirl.create(:ticket_invalid)

      ticket2 = FactoryGirl.create(:ticket)
      ticket2.subject += ' example'
      ticket2.content += ' example content'
      ticket2.save
    end

    describe 'search on subject' do
      before do
        term_to_cookie(ticket.subject)

        fill_in :term, with: ticket.subject
      end
      include_context 'tickets page'
    end

    describe 'search on content' do
      before do
        term_to_cookie(ticket.content)

        fill_in :term, with: ticket.content
      end
      include_context 'tickets page'
    end

    describe 'search on unique code' do
      before do
        fill_in :term, with: ticket.uniques_code
        click_button 'Search'
      end
      specify 'redirect to ticket' do
        expect(current_path).to eq ticket_path(ticket)

        assert_selector('li.filter > a.list-group-item', count: 0)
        assert_selector("a[href='#{tickets_path}']", text: 'All Tickets', count: 1)
        assert_selector("a[href='#{tickets_path}']", text: 'Back', count: 1)

        visit edit_ticket_path(ticket)
        assert_selector('li.filter > a.list-group-item', count: 0)
        assert_selector("a[href='#{tickets_path}']", text: 'All Tickets', count: 1)
        assert_selector("a[href='#{tickets_path}']", text: 'Back', count: 1)
      end

    end
  end

  describe 'four views', js: true do
    before do
      on_hold_id = Status.find_by_name('On Hold').id
      closed_id = Status.find_by_name('Completed').id

      FactoryGirl.create(:ticket, subject: 'optional subj', content: 'temporary')
      FactoryGirl.create(:ticket, subject: 'optional22',    content: 'temporary222')
      FactoryGirl.create(:ticket, subject: 'optional3',     content: 'temp orar y 3')

      FactoryGirl.create(:ticket, subject: 'closed 1',   status_id: closed_id)
      FactoryGirl.create(:ticket, subject: 'closed 123', status_id: closed_id)

      FactoryGirl.create(:ticket, subject: 'on hold',   status_id: on_hold_id)
      FactoryGirl.create(:ticket, subject: 'on hold22', status_id: on_hold_id)
      FactoryGirl.create(:ticket, subject: 'onhold221', status_id: on_hold_id)

      FactoryGirl.create(:ticket, subject: 'closed 1212', staff_member_id: staffmember.id)

      visit tickets_path
    end

    let(:new_unassigned_count) { Ticket.unassigned_open_tickets.count }
    let(:open_ticket_count)    { Ticket.all_open_tickets.count }
    let(:on_hold_count)        { Ticket.on_hold_tickets.count }
    let(:closed_count)         { Ticket.completed_tickets.count }

    it 'New unassigned tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets',
                                           count: 1)
      click_link 'New unassigned tickets'

      assert_selector('div#header-tickets > h1', text: 'New unassigned tickets',
                                                 count: 1)
      assert_selector('a.list-group-item.is-active', text: 'New unassigned tickets',
                                                     count: 1)
      assert_selector('a.list-group-item', text: 'Open tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'On hold tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'Closed tickets',
                                           count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',
                                           count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket',
                      count: new_unassigned_count)
      assert_selector('a', text: 'Edit', count: new_unassigned_count)
    end
    it 'Open tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'Open tickets'

      assert_selector('div#header-tickets > h1', text: 'Open tickets',
                                                 count: 1)
      assert_selector('a.list-group-item', text: 'New unassigned tickets',
                                           count: 1)
      assert_selector('a.list-group-item.is-active', text: 'Open tickets',
                                                     count: 1)
      assert_selector('a.list-group-item', text: 'On hold tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'Closed tickets',
                                           count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',
                       count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: open_ticket_count)
      assert_selector('a', text: 'Edit', count: open_ticket_count)
    end
    it 'On hold tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'On hold tickets'

      assert_selector('div#header-tickets > h1', text: 'On hold tickets',
                                                 count: 1)
      assert_selector('a.list-group-item', text: 'New unassigned tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'Open tickets',
                                           count: 1)
      assert_selector('a.list-group-item.is-active', text: 'On hold tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'Closed tickets',
                                           count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',
                                           count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: on_hold_count)
      assert_selector('a', text: 'Edit', count: on_hold_count)
    end
    it 'Closed tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'Closed tickets'

      assert_selector('div#header-tickets > h1', text: 'Closed tickets',
                                                 count: 1)
      assert_selector('a.list-group-item', text: 'New unassigned tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'Open tickets',
                                           count: 1)
      assert_selector('a.list-group-item', text: 'On hold tickets',
                                           count: 1)
      assert_selector('a.list-group-item.is-active', text: 'Closed tickets',
                                           count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',
                                           count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: closed_count)
      assert_selector('a', text: 'Edit', count: closed_count)
    end
  end
end