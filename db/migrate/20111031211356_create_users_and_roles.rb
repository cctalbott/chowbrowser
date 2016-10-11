class CreateUsersAndRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end

    add_index :users, :email, :unique => true
  end

  def down
    drop_table :users
    drop_table :roles_users
    drop_table :roles
  end
end
