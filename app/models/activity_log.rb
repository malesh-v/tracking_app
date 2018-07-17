class ActivityLog < ApplicationRecord
  belongs_to :ticket

  class << self

    def prepare_log_message(update_params, ticket)
      message = ''
      if update_params[:status_id].to_i != ticket.status_id
        message += message_for_item('status', update_params[:status_id])
      end
      if update_params[:staff_member_id] != ticket.staff_member_id.to_s
        message += message_for_item('staffmember', update_params[:staff_member_id])
      end
      if update_params[:department_id].to_i != ticket.department_id
        message += message_for_item('department', update_params[:department_id])
      end

      message.chomp!(',')
    end

    def message_for_item(model, id)
      case model
      when 'status'
        ' changed status to ' + Status.find_by_id(id).name + ','
      when 'department'
        ' changed department to ' + Department.find_by_id(id).name + ','
      else
        if id == ''
          ' changed ticket owner to Unassigned,'
        else
          ' assigned ticket to ' + StaffMember.find_by_id(id).login + ','
        end
      end
    end
  end
end
