class StaffMembersController < ApplicationController

  def new
    @staffmember = StaffMember.new
  end

  def create
    @staffmember = StaffMember.new(user_params)
    if @staffmember.save
      flash[:info] = 'Staff is added !'
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:staffmember).permit(:login, :password, :password_confirmation)
    end
end
