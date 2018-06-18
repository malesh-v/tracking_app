require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end

    describe 'with valid information' do
      let(:staffmember) { FactoryGirl.create(:staff_member) }
      before do
        fill_in 'Login',    with: staffmember.login
        fill_in 'Password', with: staffmember.password
        click_button 'Sign in'
      end

      it { should have_selector('title', text: staffmember.login) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end