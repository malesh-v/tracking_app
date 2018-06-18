class AddRememberTokenToStaffMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :staff_members, :remember_token, :string
    add_index  :staff_members, :remember_token
  end
end
