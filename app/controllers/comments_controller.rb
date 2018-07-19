class CommentsController < ApplicationController

  def create
    param_id = comment_params[:ticket_id]
    ticket = Ticket.find(param_id)
    typer =  if current_staffmember.nil?
               ticket.client
             else
               current_staffmember
             end
    typer.comments << Comment.new(ticket_id: param_id,
                                  content: comment_params[:content])
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :ticket_id)
    end
end
