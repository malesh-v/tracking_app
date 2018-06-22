def full_title(page_title)
  base_title = 'Tracking App'
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def add_to_cookie(staff)
  remember_token = StaffMember.new_remember_token
  cookies[:remember_token] = remember_token
  staff.update_attribute(:remember_token, StaffMember.encrypt(remember_token))
end