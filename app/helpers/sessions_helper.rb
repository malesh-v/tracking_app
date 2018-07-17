module SessionsHelper

  def sign_in(staff)
    remember_token = StaffMember.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    staff.update_attribute(:remember_token, StaffMember.encrypt(remember_token))
    @current_staffmember = staff
  end

  def current_staffmember
    remember_token = StaffMember.encrypt(cookies[:remember_token])
    @current_staffmember ||= StaffMember.find_by(remember_token: remember_token)
  end

  def current_staffmember?(staff)
    staff == current_staffmember
  end

  def signed_in?
    !current_staffmember.nil?
  end

  def sign_out
    current_staffmember.update_attribute(:remember_token, nil)
    @current_staffmember = nil
    cookies.delete(:remember_token)
  end

  def admin_access
    unless signed_in? && current_staffmember.admin?
      redirect_to root_url, status: 301
    end
  end

  def remember_term(term)
    cookies.permanent[:remember_term] = term
  end

  def delete_term
    cookies.delete(:remember_term)
    redirect_to tickets_path
  end
end