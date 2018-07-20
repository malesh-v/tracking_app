class CommentsController < ApplicationController
  before_action :set_data_for_forms, only: :create

  def create
    sender.comments << Comment.new(comment_params)
  end

  private

    def set_data_for_forms
      @ticket = Ticket.find(comment_params[:ticket_id])
      @ticket_comments = @ticket.comments
    end

    def sender
      current_staffmember.nil? ? @ticket.client : current_staffmember
    end

    def comment_params
      params.require(:comment).permit(:content, :ticket_id)
    end
end