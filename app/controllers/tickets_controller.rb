class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update]
  before_action :staff_access, only: [:edit, :update, :index]

  def show; end

  def index
    ticket = Ticket.search(params[:term])

    if params[:term].nil?
      @tickets = Ticket.all
    elsif ticket.kind_of?(Ticket)
      redirect_to ticket
    elsif !ticket.nil?
      @tickets = ticket
    else
      redirect_to root_path
      flash[:danger] = 'No match Found !'
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
    if @ticket.update(update_params)
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

    def update_params
      params.require(:ticket).permit(:status_id)
    end

    def staff_access
      redirect_to root_path unless signed_in?
    end
end
