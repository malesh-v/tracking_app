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

  before { visit newstaffmember_path }

  describe 'with invalid information' do
    it 'should not create a StaffMember' do
      expect { click_button submit }.not_to change(StaffMember, :count)
    end
  end

  describe 'with invalid pass confirmation' do
    before do
      fill_in 'Login',                 with: 'logintest123456'
      fill_in 'Password',              with: '123456'
      fill_in 'Confirmation password', with: '123456789'
    end

    it 'should not create a StaffMember' do
      expect { click_button submit }.not_to change(StaffMember, :count)
    end
  end

  describe 'with valid information' do
    before do
      fill_in 'Login',                 with: 'logintest123456'
      fill_in 'Password',              with: '123456'
      fill_in 'Confirmation password', with: '123456'
    end

    it 'should create a user' do
      expect { click_button submit }.to change(StaffMember, :count).by(1)
    end
  end
end
