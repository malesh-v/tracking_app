class TicketsMailer < ApplicationMailer

  default from: 'ticket_info@tracking.com'

  def ticket_history(ticket, show_url, changes)
    @changes = changes
    @show_url = show_url
    @ticket = ticket
    mail to: "#{ticket.client.email}",
         subject: 'Ticket created'
  end
end
