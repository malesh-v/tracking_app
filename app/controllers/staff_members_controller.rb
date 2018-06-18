class StaffMembersController < ApplicationController

  def index
    @staff_members = StaffMember.paginate(page: params[:page])
  end

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

  def update
    @staffmember = StaffMember.find(params[:id])
    if @staffmember.update_attributes(user_params)
      redirect_to staffmembers_path
      flash[:success] = 'Profile updated'
    else
      render 'edit'
    end
  end

  def destroy
    StaffMember.find(params[:id]).destroy
    flash[:success] = 'Staffmember destroyed.'
    redirect_to staffmembers_path
  end

  private

    def user_params
      params.require(:staff_member).permit(:login, :password, :password_confirmation)
    end
end
