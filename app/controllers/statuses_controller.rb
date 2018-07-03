class StatusesController < ApplicationController
  before_action :set_status, only: [:edit, :update, :destroy]
  before_action :admin_access

  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def edit; end

  def create
    @status = Status.create(status_params)

    respond_to do |format|
      format.html { redirect_to statuses_path }
      format.js
    end
=begin
    if @status.save
      redirect_to statuses_path
      flash[:info] = 'Status was successfully created.'
    else
      render :new
    end
=end
  end

  def update
    @status = Status.find(params[:id])
    @status.update_attributes(status_params)

    respond_to do |f|
      f.html { redirect_to statuses_path }
      f.js
    end
  end

  def destroy
    if @status.destroy
      render 'destroy'
    end
  end

  private

    def set_status
      @status = Status.find(params[:id])
    end

    def status_params
      params.require(:status).permit(:name)
    end
end
