class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update]
  before_action :staff_access, only: [:edit, :update]

  def show
  end

  def index
    result = Ticket.search(params[:term])

    if signed_in?
      @tickets = Ticket.all
    elsif result.nil?
      redirect_to root_path
      flash[:danger] = 'Invalid uniquess code !' if !params[:term].nil?
    else
      redirect_to result
    end
  end

  def new
    @ticket = Ticket.new
  end

  def edit; end

  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      redirect_to tickets_path
      flash[:info] = 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to tickets_path
      flash[:info] = 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  private

    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:subject, :content, :term, :status_id)
    end

    def staff_access
      redirect_to root_path unless signed_in?
    end
end
