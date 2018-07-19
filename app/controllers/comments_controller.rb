class CommentsController < ApplicationController

  def create
    @comment = sender.comments << Comment.new(ticket_id: comment_params[:ticket_id],
                                   content: comment_params[:content])
  end

  private

    def sender
      if current_staffmember.nil?
        Ticket.find(param_id).client
      else
        current_staffmember
      end
    end

    def comment_params
      params.require(:comment).permit(:content, :ticket_id)
    end
end
