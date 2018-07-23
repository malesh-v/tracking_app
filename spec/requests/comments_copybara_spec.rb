require 'rails_helper'
require 'support/utilities'
require 'helpers/comments_helper'

describe 'Comments' do

  let(:staff)  { FactoryGirl.create(:staff_member) }
  let(:ticket) { FactoryGirl.create(:ticket) }
  let(:content) { 'some text content' }

  describe 'staff write comment', js: true do

    before do
      sign_in staff

      client = ticket.client
      client.comments << Comment.new(ticket_id: ticket.id, content: content)

      visit ticket_path(ticket)
    end

    include_context 'shared comments page'
  end

  describe 'comments as client', js: true do

    before do
      staff = StaffMember.last
      staff.comments << Comment.new(ticket_id: ticket.id, content: content)

      visit ticket_path(ticket)
    end

    it 'ticket page' do
      assert_selector("a[href='#{signin_path}']")

      assert_selector('div.container.comment.color', count: 1, text: content)
    end
    include_context 'shared comments page'

  end
end