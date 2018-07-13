require 'rails_helper'
require 'support/utilities'
require 'helpers/staff_members_helper'

describe StaffMembersController do

  let(:staffmember) { FactoryGirl.create(:staff_member) }
  let(:admin)       { FactoryGirl.create(:admin) }
  let(:login)       { 'some_login' }
  let(:password)    { '123123q' }
  let(:staff_data)  { { login: login, password: password,
                          password_confirmation: password } }

  before { StaffMember.create!(login: 'temp', password: 'password',
                               password_confirmation: 'password' )}

  describe 'as quest' do
    include_context 'staffmembers requests non admin'
  end

  describe 'as staffmember logged in' do
    before { sign_in staffmember, no_capybara: true }
    include_context 'staffmembers requests non admin'
  end

  describe 'as staffmember logged in' do
    before { sign_in admin, no_capybara: true }
    include_context 'as admin'
  end
end