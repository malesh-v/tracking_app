require 'rails_helper'
require 'support/utilities'

describe 'Ticket' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }

  describe 'create as client' do

    let(:departments_count) { Department.count }
    let(:form_html)         { 'div.col-md-6 >' }

    before { visit root_path }

    it 'root page' do
      assert_selector('a.btn', text: 'Create ticket now!', count: 1)
    end

    it 'html elementі' do
      #root page
      click_link 'Create ticket now!'
      expect(current_path).to eq new_ticket_path

      #new ticket page
      assert_selector('h1', text: 'New Ticket', count: 1)
      assert_selector('div.col-md-6', count: 1)

      #department field
      assert_selector("#{form_html} label", text: 'Department', count: 1)
      assert_selector("#{form_html} select.form-control", id: 'ticket_department_id', count: 1)
      assert_selector("#{form_html} select#ticket_department_id > option", count: departments_count)

      #subject field
      assert_selector("#{form_html} label", text: 'Subject', count: 1)
      assert_selector("#{form_html} input#ticket_subject", count: 1)

      #content field
      assert_selector("#{form_html} label", text: 'Content', count: 1)
      assert_selector("#{form_html} textarea#ticket_content", count: 1)

      #submit
      assert_selector("#{form_html} input.btn.btn-large", count: 1)
    end

    it 'create new ticket' do
      visit new_ticket_path
      expect {
        #filling form
        find('select#ticket_department_id').find(:xpath, 'option[2]').select_option
        fill_in 'Subject', with: 'new_name'
        fill_in 'Content', with: 'this is a simple text for content'
        click_button 'Save'

        assert_selector('div.alert.alert-info', text: 'Ticket was successfully created.', count: 1)
        expect(current_path).to eq root_path
      }.to change(Ticket, :count).by(1)
    end
  end

  describe 'as staff' do

    before{ sign_in staffmember }

    let(:unique_code) { Ticket.first.uniques_code }

    it 'search on code' do
      ticket = FactoryGirl.create(:ticket)
      visit root_path
      assert_selector('form', count: 1)

      fill_in :term, with: unique_code
      click_button 'Search'

      #page with ticket
      expect(current_path).to eq ticket_path(ticket)
      assert_selector('p#uniques_code', text: ticket.uniques_code,    count: 1)
      assert_selector('p#owner',        text: 'Unassigned',           count: 1)
      assert_selector('p#status',       text: ticket.status.name,     count: 1)
      assert_selector('p#department',   text: ticket.department.name, count: 1)
      assert_selector('p#subject',      text: ticket.subject,         count: 1)
      assert_selector('p#content',      text: ticket.content,         count: 1)
      assert_selector('a.badge',        text: 'Back',                 count: 1)

      assert_selector('a.badge delete', text: 'Edit', count: 0)
    end
    it 'search on subject' do
      ticket = FactoryGirl.create(:ticket)
      ticket2 = FactoryGirl.create(:ticket)
      ticket2.subject += ' example'
      ticket2.save
debugger
      assert_selector('form', count: 1)

      fill_in :term, with: ticket.subject
      click_button 'Search'

      expect(current_path).to eq tickets_path
      assert_selector('li.list-group-item > a.show_ticket', count: 2)
      assert_selector('a.badge', text: 'Edit',              count: 2)
      assert_selector('li.filter > a.list-group-item',      count: 4)

      assert_selector('li.filter > a.list-group-item', text: 'New unassigned tickets', count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'Open tickets',           count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'On hold tickets',        count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'Closed tickets',         count: 1)
    end
    it 'search on content' do
      ticket = FactoryGirl.create(:ticket)
      ticket2 = FactoryGirl.create(:ticket)
      ticket2.content += ' example content'
      ticket2.save

      assert_selector('form', count: 1)

      fill_in :term, with: ticket.content

      click_button 'Search'

      expect(current_path).to eq tickets_path
      assert_selector('li.list-group-item > a.show_ticket', count: 2)
      assert_selector('a.badge', text: 'Edit',              count: 2)
      assert_selector('li.filter > a.list-group-item',      count: 4)

      assert_selector('li.filter > a.list-group-item', text: 'New unassigned tickets', count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'Open tickets',           count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'On hold tickets',        count: 1)
      assert_selector('li.filter > a.list-group-item', text: 'Closed tickets',         count: 1)
    end

  end



end

