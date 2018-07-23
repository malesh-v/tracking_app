require 'rails_helper'

describe 'Tickets pages' do

  describe 'create as client' do

    let(:departments_count) { Department.count }
    let(:form_html)         { 'div.col-md-6 >' }

    before { visit root_path }

    it 'root page' do
      assert_selector('a.btn', text: 'Create ticket now!', count: 1)
    end

    it 'html elements' do
      #root page
      click_link 'Create ticket now!'
      expect(current_path).to eq new_ticket_path

      #new ticket page
      assert_selector('h1', text: 'New Ticket', count: 1)
      assert_selector('div.col-md-6', count: 1)

      #client name field
      assert_selector("#{form_html} label", text: 'Client name', count: 1)
      assert_selector("#{form_html} input#ticket_client_name", count: 1)

      #client email field
      assert_selector("#{form_html} label", text: 'Client email', count: 1)
      assert_selector("#{form_html} input#ticket_client_email", count: 1)

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

        fill_in 'Client name',  with: 'new_client123'
        fill_in 'Client email', with: 'email@email.ru'
        fill_in 'Subject',      with: 'new_name'
        fill_in 'Content',      with: 'this is a simple text for content'
        click_button 'Save'

        assert_selector('div.alert.alert-info', count: 1, text:
            'Your ticket has been accepted. You\'ll receive a confirmation email.')
        expect(current_path).to eq root_path
      }.to change(Ticket, :count).by(1)

      new_ticket = Ticket.last
      visit ticket_path(new_ticket)

      assert_selector('div#activity_log > div.log_item', text:
          "#{new_ticket.client.name} #{new_ticket.client.email} created ticket", count: 1)
      assert_selector('div#activity_log > div.log_item > h6', text:
          "#{time_ago_in_words(new_ticket.created_at)}", count: 1)
    end
  end
end