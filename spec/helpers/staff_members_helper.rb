require 'rails_helper'

RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'staffmembers requests non admin', :shared_context => :metadata do
  describe 'try create staff' do
    it 'try create new staff' do
      post :create, params: { staff_member: staff_data}
      StaffMember.find_by_login(login).should be_nil
    end
  end

  describe 'try edit staff' do
    it 'try edit staff' do
      put :update, params: {id: staffmember.id, staff_member: staff_data}
      staffmember.reload.login.should_not eq(login)
    end
  end

  describe 'try destroy staff' do
    it 'try destroy staff' do
      expect {
        delete :destroy, params: {id: StaffMember.first.id }
      }.to change(StaffMember, :count).by(0)
    end
  end
end

RSpec.shared_context 'as admin', :shared_context => :metadata do

  describe 'admin able to create new staff' do
    it 'should create staff' do
      post :create, params: { staff_member: staff_data}
      StaffMember.find_by_login(login).should_not be_nil
    end
  end

  describe 'admin able to edit staff' do
    it 'edit the requested staff' do
      put :update, params: {id: staffmember.id, staff_member: staff_data}
      staffmember.reload.login.should eq(login)
    end
  end

  describe 'admin able to delete staff' do
    it 'destroys the requested staff' do
      expect {
        delete :destroy, params: {id: StaffMember.first.id }
      }.to change(StaffMember, :count).by(-1)
    end
  end
end