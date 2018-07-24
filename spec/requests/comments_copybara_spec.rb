require 'rails_helper'
require 'support/utilities'
require 'helpers/comments_helper'

describe 'Comments' do

  let(:staff)  { FactoryGirl.create(:staff_member) }
  let(:ticket) { FactoryGirl.create(:ticket) }
  let(:content) { 'some text content' }

  before do
    client = ticket.client
    client.comments << Comment.new(ticket_id: ticket.id, content: content)
  end

  describe 'staff write comment', js: true do

    before do
      sign_in staff

      visit ticket_path(ticket)
      click_link 'Comments'

      assert_selector('div.container.comment.color', count: 1, text: content)

    end

    include_context 'shared comments page'
  end

  describe 'comments as client', js: true do

    before do
      visit ticket_path(ticket)
      click_link 'Comments'
    end

    it 'ticket page' do
      assert_selector("a[href='#{signin_path}']")

      assert_selector('div.container.comment', count: 1, text: content)
    end
    include_context 'shared comments page'

  end
end