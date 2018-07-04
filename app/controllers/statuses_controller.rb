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
      if @status.save
        format.js
      else
        format.js { render 'new' }
      end
    end
  end

  def update
    success = @status.update_attributes(status_params)

    respond_to do |format|
      if success
        format.html { redirect_to statuses_path }
        format.js
      else
        format.js { render 'edit' }
      end
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
