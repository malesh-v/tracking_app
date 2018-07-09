class AddStatusIdToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :status_id, :integer
  end
end
