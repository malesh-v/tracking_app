require 'rails_helper'
require 'support/utilities'

describe 'activity log' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }

  before do
    FactoryGirl.create(:ticket)
    sign_in staffmember
  end

  it 'nothing change on ticket' do
    expect {
      visit edit_ticket_path(Ticket.first)
      click_button 'Save'
    }.to change(ActivityLog, :count).by(0)
  end
  it 'change owner on ticket' do
    expect {
      visit edit_ticket_path(Ticket.first)
      find('select#ticket_staff_member_id').find(:xpath, 'option[2]').select_option

      click_button 'Save'
    }.to change(ActivityLog, :count).by(1)
    expect {
      visit edit_ticket_path(Ticket.first)
      find('select#ticket_staff_member_id').find(:xpath, "//option[text()='Unassigned']").select_option

      click_button 'Save'
    }.to change(ActivityLog, :count).by(1)
  end
  it 'change department on ticket' do
    expect {
      visit edit_ticket_path(Ticket.first)
      find('select#ticket_department_id').find(:xpath, 'option[2]').select_option

      click_button 'Save'
    }.to change(ActivityLog, :count).by(1)
  end
  it 'change status on ticket' do
    expect {
      visit edit_ticket_path(Ticket.first)
      find('select#ticket_status_id').find(:xpath, 'option[2]').select_option

      click_button 'Save'
    }.to change(ActivityLog, :count).by(1)
  end
  it 'see log on ticket' do
    visit edit_ticket_path(Ticket.first)
    find('select#ticket_department_id').find(:xpath, 'option[3]').select_option
    click_button 'Save'
    visit ticket_path(Ticket.first)

    assert_selector('div#activity_log > div.log_item', count: 1)
  end
end

