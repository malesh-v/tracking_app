class CommentsController < ApplicationController

  def create
    @comment = sender.comments << Comment.new(comment_params)
debugger
    if @comment.nil?

    end

    respond_to do |format|
      format.html
      format.js { render 'comments/create' }
    end
  end

  private

    def sender
      current_staffmember.nil? ? ticket.client : current_staffmember
    end

    def comment_params
      params.require(:comment).permit(:content, :ticket_id)
    end
end
