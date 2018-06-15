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
end
