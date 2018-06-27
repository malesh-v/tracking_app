class SessionsController < ApplicationController

  def new; end

  def create
    staffmember = StaffMember.find_by_login(params[:session][:login])
    if staffmember && staffmember.authenticate(params[:session][:password])
      sign_in staffmember
      redirect_to root_path, status: 301
    else
      flash.now[:danger] = 'Invalid login/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end
