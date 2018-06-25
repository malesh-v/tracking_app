def sign_in(staffmember, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = StaffMember.new_remember_token
    cookies[:remember_token] = remember_token
    staffmember.update_attribute(:remember_token, StaffMember.encrypt(remember_token))
  else
    visit signin_path
    fill_in 'Login',    with: staffmember.login
    fill_in 'Password', with: staffmember.password
    click_button 'Sign in'
  end
end