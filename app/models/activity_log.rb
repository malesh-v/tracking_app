class ActivityLog < ApplicationRecord
  belongs_to :ticket

  def self.prepare_log_message(update_params, ticket)

    message = ''
    if update_params[:status_id].to_i != ticket.status_id
      message += ' changed status to ' + Status.find_by_id(update_params[:status_id]).name + ','
    end
    if update_params[:staff_member_id] != ticket.staff_member_id.to_s
      if update_params[:staff_member_id] == ''
        message += ' changed ticket owner Unassigned,'
      else
        message += ' assigned to ' + StaffMember.find_by_id(update_params[:staff_member_id]).login + ','
      end
    end
    if update_params[:department_id].to_i != ticket.department_id
      message += ' changed department to ' + Department.find_by_id(update_params[:department_id]).name + ','
    end

    message.chomp!(',')
  end
end
