require 'rails_helper'

describe 'staff pages' do

  subject { page }

  describe 'staffnew page' do
    before { visit newstaffmember_path }

    it { should have_content('Create new staff') }
    it { should have_title('Create new staff | Tracking App') }
    it { should have_selector('a', text: 'Home') }
    it { should have_selector('a', text: 'Tracking app') }
    it { should have_selector('a', text: 'Help') }
  end

  let(:submit) { 'Create new account' }

  describe 'with invalid information' do
    before { visit newstaffmember_path }

    it 'should not create a StaffMember' do
      expect { click_button submit }.not_to change(StaffMember, :count)
    end
  end

  describe 'with valid information' do
    before do
      fill_in 'login',            with: 'logintest123456'
      fill_in 'password',         with: '123456'
      fill_in 'confirm_password', with: '123456'
    end

    it 'should create a StaffMember' do
      expect { click_button submit }.to change(StaffMember, :count).by(1)
    end
  end
end
