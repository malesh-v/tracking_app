class ActivityLog < ApplicationRecord
  belongs_to :ticket

  class << self

    def prepare_log_message(update_params, ticket)
      message = ''

      update_params.each do |item, value|
        unless value == ticket.send(item).to_s
          model = item.chomp('_id')
          message += mess_item(model, value) + ','
        end
      end

      message.chomp!(',')
    end

    def mess_item(model_name, id)
      case model_name
      when 'status'
        ' changed status to ' + Status.find(id).name
      when 'department'
        ' changed department to ' + Department.find(id).name
      else
        id == '' ? ' changed ticket owner to Unassigned'
            : ' assigned ticket to ' + StaffMember.find(id).login
      end
    end
  end
end