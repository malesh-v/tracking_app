require 'rails_helper'

describe 'Staff_members_pages' do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in admin }

  it 'staff_members_list' do
    visit staffmembers_path
    expect(page).to have_content('All staffmembers')
    expect(page).to have_title('Staffmembers')
  end

  it 'edit staff_member' do
    visit edit_staff_member_path(admin)
    expect(page).to have_content('Update staffmember')
    expect(page).to have_title('Edit staffmember')
  end

  it 'new_staff_member' do
    visit staffmembers_path
    click_link 'New staffmember'
    expect(page).to have_content('Create new staffmember')
    expect(page).to have_title('New staffmember')
  end
end