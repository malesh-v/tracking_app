require 'rails_helper'
require 'support/utilities'

RSpec.describe TicketsController, type: :controller do

  before do
    Ticket.create!(subject: 'some subj', content: 'some content test', department_id: Department.first.id,
                   client_id: Client.first.id)
  end

  let(:staffmember) { FactoryGirl.create(:staff_member) }
  let(:first_ticket) { Ticket.first }
  let(:new_ticket_data) { { subject: 'new some subj', content: 'new some content test',
                            department_id: Department.first.id } }

  describe 'ticket managment as client' do
    it 'ticket create' do
      expect {
        post :create, params: { ticket: { subject: 'some subj', content: 'some content test',
                                          department_id: Department.first.id, client_name: 'name',
                                          client_email: 'email@mail.ru'} }
      }.to change(Ticket, :count).by(1)
      Ticket.last.status.name.should eq('Waiting for Staff Response')
    end
    it 'ticket edit' do
      put :update, params: {id: first_ticket.id, ticket: new_ticket_data}
      first_ticket.reload.subject.should_not eq(new_ticket_data[:subject])
      first_ticket.reload.content.should_not eq(new_ticket_data[:content])
    end
  end

  describe 'staff can change status and owner' do
    before { sign_in staffmember, no_capybara: true }

    it 'change status' do
      open_status_id = Status.find_by(name: 'Completed').id
      new_ticket_data[:status_id] = open_status_id
      put :update, params: {id: first_ticket.id, ticket: new_ticket_data}

      first_ticket.reload.status_id.should eq(open_status_id)
    end
    it 'change departmant' do
      last_department = Department.last.id
      new_ticket_data[:department_id] = last_department

      put :update, params: {id: first_ticket.id, ticket: new_ticket_data}

      first_ticket.reload.department_id.should eq(last_department)
    end
    it 'change owner' do
      first_ticket.staff_member_id = StaffMember.first.id
      last_staff = StaffMember.last.id
      new_ticket_data[:staff_member_id] = last_staff

      put :update, params: {id: first_ticket.id, ticket: new_ticket_data}

      first_ticket.reload.staff_member_id.should eq(last_staff)
    end
    it 'try change contant and subject' do
      put :update, params: {id: first_ticket.id, ticket: new_ticket_data}

      first_ticket.reload.subject.should_not eq(new_ticket_data[:subject])
      first_ticket.reload.content.should_not eq(new_ticket_data[:content])
    end
    it 'try change reporter' do
      client = Client.create(name: 'name', email: 'email777@mail.ru')
      put :update, params: { id: first_ticket.id, ticket: { client_id: client.id }}

      first_ticket.reload.client_id.should_not eq(client.id)
    end
  end

end
