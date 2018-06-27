require 'rails_helper'
require 'support/utilities'

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
        sign_in staffmember
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
        sign_in staffmember
      end

      it { should have_link('Sign out', href: signout_path) }

      describe 'submitting to view all staffmembers' do
        before { post staff_members_path }
        specify { expect(response).to redirect_to(statuses_path)}
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
    # for admin

    describe 'admin logged' do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:staffmember) { FactoryGirl.create(:staff_member, login: 'example') }

      before do
        sign_in admin, no_capybara: true
        sign_in admin
      end

      it { should have_selector('a', class: 'dropdown-toggle') }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Staffmembers', href: staffmembers_path) }


      describe 'submitting to view all staffmembers' do
        specify do
          visit staffmembers_path
          expect(current_path).to eq staffmembers_path
        end
      end

      describe 'submitting to the create new staffmember' do
        it do
          expect do
            visit newstaffmember_path
            fill_in 'Login',        with: 'new_name'
            fill_in 'Password',     with: admin.password
            fill_in 'Confirmation', with: admin.password
            click_button 'Create new account'
            have_selector('div.alert.alert-success')
            expect(current_path).to eq staffmembers_path
          end.to change(StaffMember, :count).by(1)
        end
      end

      describe 'submitting to the edit staffmember' do
        before do
          visit edit_staff_member_path(admin)
          fill_in 'Login',        with: 'new_name'
          fill_in 'Password',     with: admin.password
          fill_in 'Confirmation', with: admin.password
          click_button 'Save changes'
        end

        it { should have_selector('div.alert.alert-success') }
        specify { expect(admin.reload.login).to eq 'new_name' }
        specify { expect(current_path).to eq staffmembers_path }
      end

      describe 'submitting to the delete staffmember' do
        before do
          edit_staff_member_path(staffmember)
          visit staffmembers_path
        end

        it { should_not have_link('delete', href: staff_member_path(admin)) }

        it do
          expect do
            click_link('delete', match: :first)
            have_selector('div.alert.alert-success')
          end.to change(StaffMember, :count).by(-1)
        end
      end
    end
  end
end