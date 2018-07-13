class AddStaffIdToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :staff_member_id, :integer
  end
end
