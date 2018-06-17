class StaffMembersController < ApplicationController

  def new
    @staffmember = StaffMember.new
  end

  def create
    @staffmember = StaffMember.new(user_params)
    if @staffmember.save
      flash[:info] = 'Staff is added !'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @staffmember = StaffMember.find(params[:id])
  end

  private

    def user_params
      params.require(:staff_member).permit(:login, :password, :password_confirmation)
    end
end
