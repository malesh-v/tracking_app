class TicketsController < ApplicationController
  before_action :set_ticket,   only: [:edit, :update, :show]
  before_action :staff_access, only: [:edit, :update, :index]
  before_action :set_client,   only: :create

  def show; end

  def index
    params[:term].nil? ? @tickets = Ticket.all : term

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @ticket = Ticket.new
  end

  def edit; end

  def create
    @ticket = @client.tickets.build(ticket_params)

    if @ticket.save
      redirect_to tickets_path
      flash[:info] = 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def update
    message = prepare_log_message

    if @ticket.update(update_params)
      @ticket.activity_logs.create(message: message)

      redirect_to tickets_path
      flash[:info] = 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  private

    def prepare_log_message
      message = current_staffmember.login
      if update_params[:status_id].to_i != @ticket.status_id
        message += ' changed status to ' + Status.find_by_id(update_params[:status_id]).name + ','
      end
      if update_params[:staff_member_id].to_i != @ticket.staff_member_id
        message += ' assigned to ' + StaffMember.find_by_id(update_params[:staff_member_id]).login + ','
      end
      if update_params[:department_id].to_i != @ticket.department_id
        message += ' changed department to ' + Department.find_by_id(update_params[:department_id]).name + ','
      end
      message.chomp!(',')
      message + '.'
    end

    def term
      ticket = Ticket.search(params[:term])

      if ticket.kind_of?(Ticket)
        redirect_to ticket
      elsif !ticket.nil?
        @tickets = ticket
      else
        redirect_to root_path
        flash[:danger] = 'No match Found !'
      end
    end

    #only client can create ticket
    def set_client
      redirect_to root_path unless current_staffmember.nil?

      @client = Client.find_by(email: client_param['client_email'])
      @client = Client.new(name: client_param['client_name'], email: client_param['client_email']) if @client.nil?
    end

    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:subject, :content, :term, :status_id, :department_id, :staff_member_id)
    end

    def client_param
      params.require(:ticket).permit(:client_name, :client_email)
    end

    def update_params
      params.require(:ticket).permit(:status_id, :department_id, :staff_member_id)
    end

    def staff_access
      redirect_to root_path unless signed_in?
    end
end
