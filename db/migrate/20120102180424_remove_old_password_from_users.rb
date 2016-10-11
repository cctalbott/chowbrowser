class RemoveOldPasswordFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :encrypted_password
    remove_column :users, :salt
  end
  
  def down
    add_column :users, :encrypted_password, :string
    add_column :users, :salt, :string
  end
end
