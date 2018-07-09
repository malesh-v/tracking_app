class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.string :content
      t.string :uniques_code

      t.timestamps
    end
    add_index :tickets, :uniques_code, unique: true
  end
end
