class DepartmentsController < ApplicationController
  before_action :set_department, only: [:edit, :update, :destroy]
  before_action :admin_access

  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def edit; end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to departments_path
      flash[:info] = 'Department was successfully created.'
    else
      render :new
    end
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path
      flash[:info] = 'Department was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_path
    flash[:info] = 'Department was successfully destroyed.'
  end

  private
      def set_department
        @department = Department.find(params[:id])
      end

      def department_params
        params.require(:department).permit(:name)
      end
end