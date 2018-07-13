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
        fill_in :term, with: ticket.subject
      end
      include_context 'tickets page'
    end

    describe 'search on content' do
      before do
        fill_in :term, with: ticket.content
      end
      include_context 'tickets page'
    end
  end

  describe 'four views', js: true do

    let(:completed) { Status.find_by_name('Completed').id }
    let(:on_hold)   { Status.find_by_name('On Hold').id }
    let(:closed)    { Status.find_by_name('Completed').id }

    before do
      FactoryGirl.create(:ticket, subject: 'optional subj', content: 'temporary')
      FactoryGirl.create(:ticket, subject: 'optional22',    content: 'temporary222')
      FactoryGirl.create(:ticket, subject: 'optional3',     content: 'temp orar y 3')

      FactoryGirl.create(:ticket, subject: 'closed 1',   status_id: completed)
      FactoryGirl.create(:ticket, subject: 'closed 123', status_id: completed)

      FactoryGirl.create(:ticket, subject: 'on hold',   status_id: on_hold)
      FactoryGirl.create(:ticket, subject: 'on hold22', status_id: on_hold)

      FactoryGirl.create(:ticket, subject: 'closed 1212', staff_member_id: staffmember.id)

      visit tickets_path
    end

    let(:new_unassigned) { Ticket.unassigned_open_tickets.count }
    let(:open_ticket)    { Ticket.all_open_tickets.count }
    let(:on_hold)        { Ticket.on_hold_tickets.count }
    let(:closed)         { Ticket.completed_tickets.count }

    it 'New unassigned tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'New unassigned tickets'
      sleep 1

      assert_selector('div#header-tickets > h1',     text: 'New unassigned tickets', count: 1)
      assert_selector('a.list-group-item.is-active', text: 'New unassigned tickets', count: 1)
      assert_selector('a.list-group-item',           text: 'Open tickets',           count: 1)
      assert_selector('a.list-group-item',           text: 'On hold tickets',        count: 1)
      assert_selector('a.list-group-item',           text: 'Closed tickets',         count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',              count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: new_unassigned)
      assert_selector('a', text: 'Edit', count: new_unassigned)
    end
    it 'Open tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'Open tickets'
      sleep 1

      assert_selector('div#header-tickets > h1',     text: 'Open tickets',           count: 1)
      assert_selector('a.list-group-item',           text: 'New unassigned tickets', count: 1)
      assert_selector('a.list-group-item.is-active', text: 'Open tickets',           count: 1)
      assert_selector('a.list-group-item',           text: 'On hold tickets',        count: 1)
      assert_selector('a.list-group-item',           text: 'Closed tickets',         count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',              count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: open_ticket)
      assert_selector('a', text: 'Edit', count: open_ticket)
    end
    it 'On hold tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'On hold tickets'
      sleep 1

      assert_selector('div#header-tickets > h1',     text: 'On hold tickets',        count: 1)
      assert_selector('a.list-group-item',           text: 'New unassigned tickets', count: 1)
      assert_selector('a.list-group-item',           text: 'Open tickets',           count: 1)
      assert_selector('a.list-group-item.is-active', text: 'On hold tickets',        count: 1)
      assert_selector('a.list-group-item',           text: 'Closed tickets',         count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',              count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: on_hold)
      assert_selector('a', text: 'Edit', count: on_hold)
    end
    it 'Closed tickets' do
      assert_selector('a.list-group-item', text: 'New unassigned tickets', count: 1)
      click_link 'Closed tickets'
      sleep 1

      assert_selector('div#header-tickets > h1',     text: 'Closed tickets',         count: 1)
      assert_selector('a.list-group-item',           text: 'New unassigned tickets', count: 1)
      assert_selector('a.list-group-item',           text: 'Open tickets',           count: 1)
      assert_selector('a.list-group-item',           text: 'On hold tickets',        count: 1)
      assert_selector('a.list-group-item.is-active', text: 'Closed tickets',         count: 1)
      assert_selector('ul.nav-tickets > li.filter > a.list-group-item',              count: 4)

      assert_selector('ul.list-group > li.list-group-item > a.show_ticket', count: closed)
      assert_selector('a', text: 'Edit', count: closed)
    end
  end
end