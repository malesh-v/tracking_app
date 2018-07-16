class AddClientidToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :client_id, :integer
  end
end