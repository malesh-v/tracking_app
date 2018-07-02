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
    @status = Status.new(status_params)

    if @status.save
      redirect_to statuses_path
      flash[:info] = 'Status was successfully created.'
    else
      render :new
    end
  end

  def update
    if @status.update(status_params)
      redirect_to statuses_path
      flash[:info] = 'Status was successfully updated.'
    else
      render :edit
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
