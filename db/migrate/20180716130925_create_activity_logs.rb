class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs do |t|
      t.string  :message
      t.integer :ticket_id

      t.timestamps
    end
  end
end
