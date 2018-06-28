require 'rails_helper'
require 'helpers/statuses_helper'

describe 'request' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }
  let(:admin)       { FactoryGirl.create(:admin) }

  describe 'non logged' do
    include_context 'shared requests'
  end

  describe 'logged non admin' do
    before { sign_in staffmember }
    include_context 'shared requests'
  end

  describe 'admin logged' do
    before { sign_in admin }
    include_context 'shared requests admin'
  end
end