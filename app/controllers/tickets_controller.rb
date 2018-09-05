class TicketsController < ApplicationController
  before_action :set_ticket,   only: [:edit, :update]
  before_action :staff_access, only: [:edit, :update, :index]
  before_action :set_client,   only: :create
  before_action :count_filter, only: :index

  UNIQUES_CODE_REGEX = /[A-Z]{3}-[A-Z,0-9]{2}-[A-Z]{3}-[A-Z,0-9]{2}-[A-Z]{3}/

  def show
    @ticket = if params[:id].nil?
                Ticket.find_by(uniques_code: params[:uniques_code])
              else
                Ticket.find(params[:id])
              end
    @comment = Comment.new
  end

  def index
    delete_term unless params['no_term'].nil?

    if params[:term].present?
      term = params[:term]
      ticket = Ticket.search_by_code(term) if UNIQUES_CODE_REGEX.match(params[:term])

      if ticket.kind_of?(Ticket)
        redirect_to ticket
      elsif term == 'all_my_tickets'
        @tickets = Ticket.all_my_tickets(current_staffmember)
      else
        @tickets = Ticket.search(term)
      end
      remember_term(term) unless UNIQUES_CODE_REGEX.match(params[:term])

    else
      @tickets = Ticket.all
    end

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
      @ticket.activity_logs.create(message: after_created_message)
      TicketsMailer.ticket_history(@ticket, generate_show_url, 'created')
                   .deliver

      redirect_to tickets_path
      flash[:info] = 'Your ticket has been accepted. You\'ll receive a confirmation email.'
    else
      render :new
    end
  end

  def update
    changes = check_changed_items

    if @ticket.update(update_params)
      unless changes.nil?
        @ticket.activity_logs.create(message: prepare_message(changes))
        TicketsMailer.ticket_history(@ticket, generate_show_url, 'changed')
                     .deliver
      end

      redirect_to cookies[:remember_term].nil? ? tickets_path
                                               : tickets_path(term: cookies[:remember_term])
      flash[:info] = changes.nil? ? 'Ticket not changed.' : 'Ticket was updated.'
    else
      render :edit
    end
  end

  private

    def count_filter
      @counts = Hash.new

      array = %w(unassigned_open all_open on_hold completed)
      array.each do |v|
        @counts[v] = Ticket.send("#{v}_tickets").count
      end
    end

    def prepare_message(changed_items)
      message = current_staffmember.login

      changed_items.each do |value|
        info = value == 'staff_member' ? 'login' : 'name'
        if @ticket.send(value).nil?
          message += ' changed ticket to unassigned,'
          next
        end
        message += " changed #{value} to #{@ticket.send(value).send(info)},"
      end

      message.chomp(',')
    end

    def check_changed_items
      changed_items = Array.new

      update_params.each do |item, value|
        unless value == @ticket.send(item).to_s
          changed_items << item.chomp('_id')
        end
      end

      changed_items.count > 0 ? changed_items : nil
    end

    def after_created_message
      "#{@ticket.client.name} #{@ticket.client.email} created ticket"
    end

    def after_updated_message(message)
      "#{current_staffmember.login} #{message}"
    end

    def generate_show_url
      show_url(uniques_code: @ticket.uniques_code)
    end

    #only client can create ticket
    def set_client
      redirect_to root_path unless current_staffmember.nil?

      @client = if Client.find_by(email: client_param['client_email']).nil?
                  Client.new(name: client_param['client_name'],
                             email: client_param['client_email'])
                else
                  Client.find_by(email: client_param['client_email'])
                end
    end

    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:subject, :content, :term, :status_id,
                                     :department_id, :staff_member_id)
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
