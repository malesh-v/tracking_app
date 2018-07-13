require 'rails_helper'
require 'support/utilities'
require 'helpers/tickets_helper'

describe 'Ticket' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }

  describe 'as staff' do

    let(:ticket) { FactoryGirl.create(:ticket) }

    before do
      FactoryGirl.create(:ticket_invalid)

      sign_in staffmember
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
end