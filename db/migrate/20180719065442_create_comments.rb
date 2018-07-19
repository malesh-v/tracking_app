class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string  :content
      t.integer :ticket_id
      t.integer :commentable_id
      t.string  :commentable_type
      t.timestamps
    end
  end
end
