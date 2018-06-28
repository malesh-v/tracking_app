require 'rails_helper'

describe 'Sessions_controller' do

  let(:staffmember) { FactoryGirl.create(:staff_member) }

  describe 'login' do
    it 'Login' do
      visit signin_path

      expect(page).to have_content('Sign in')
      expect(page).to have_title('Sign in')
    end

    it 'have link signout' do
      sign_in staffmember
      have_link('Sign out', href: signout_path)
    end

    it 'invalid data login' do
      visit signin_path
      click_button 'Sign in'
      have_selector('div.alert.alert-danger', text: 'Invalid')
    end
  end

  describe 'login with valid information' do

    before { sign_in staffmember }

    it 'after login' do
      have_link('Sign out', href: signout_path)
      have_link('Sign in', href: signin_path, count: 0)
    end

    it 'after signout' do
      click_link 'Sign out'
      have_link('Log in')
    end
  end
end