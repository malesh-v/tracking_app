require 'rails_helper'

describe 'Staffmember' do
  describe 'non admin logged' do

    let(:staffmember) { FactoryGirl.create(:staff_member) }

    before do
      sign_in staffmember
      have_link('Sign out', href: signout_path)
    end

    describe 'submitting to view all staffmembers' do
      before { post staff_members_path }
      specify { expect(response).to redirect_to(root_path)}
    end

    describe 'submitting to the create new staffmember' do
      before { post newstaffmember_path }
      specify { expect(response).to redirect_to(root_path) }
    end

    describe 'submitting to the edit staffmember' do
      before { get edit_staff_member_path(staffmember) }
      specify { expect(response).to redirect_to(root_path) }
    end

    describe 'submitting to the delete staffmember' do
      before { delete staff_member_path(staffmember) }
      specify { expect(response).to redirect_to(root_path) }
    end
  end
end