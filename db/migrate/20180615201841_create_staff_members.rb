class CreateStaffMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :staff_members do |t|
      t.string  :login
      t.string  :password_digest
      t.boolean :admin

      t.timestamps
    end
    add_index :staff_members, :login, unique: true
  end
end
