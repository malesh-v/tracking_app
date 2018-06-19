require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_selector('h1', text: 'Sign in') }
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_selector('div.alert.alert-danger', text: 'Invalid') }
    end

    describe 'with valid information' do
      let(:staffmember) { FactoryGirl.create(:staff_member) }
      before do
        fill_in 'Login',    with: staffmember.login
        fill_in 'Password', with: staffmember.password
        click_button 'Sign in'
      end

      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe 'followed by signout' do
        before { click_link 'Sign out' }
        it { should have_link('Log in') }
      end
    end

    describe 'non admin logged' do

      let(:staffmember) { FactoryGirl.create(:staff_member) }
      before do
        fill_in 'Login',    with: staffmember.login
        fill_in 'Password', with: staffmember.password
        click_button 'Sign in'
      end

      describe 'submitting to view all staffmembers' do
        before { post staff_members_path }
        specify { expect(response).to redirect_to(root_path) }
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
end