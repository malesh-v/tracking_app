class TicketsController < ApplicationController
  before_action :set_ticket,   only: [:edit, :update, :show]
  before_action :staff_access, only: [:edit, :update, :index]
  before_action :set_client,   only: :create

  def show; end

  def index
    params[:term].nil? ? @tickets = Ticket.all : term
    delete_term unless params['no_term'].nil?

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
      @ticket.activity_logs.create(message: "#{@ticket.client.name} <#{@ticket.client.email}> created ticket")

      redirect_to tickets_path
      flash[:info] = 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def update
    message = ActivityLog.prepare_log_message(update_params, @ticket)

    if @ticket.update(update_params)
      @ticket.activity_logs.create(message: "#{current_staffmember.login}
                                             #{message}") unless message.nil?

      redirect_to cookies[:remember_term].nil? ? tickets_path : tickets_path(term: cookies[:remember_term])
      flash[:info] = 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  private

    def term
      uniquess_code_regexp = /[A-Z]{3}-[A-Z,0-9]{2}-[A-Z]{3}-[A-Z,0-9]{2}-[A-Z]{3}/
      remember_term(params[:term]) unless uniquess_code_regexp.match(params[:term])

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
