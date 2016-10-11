class SorceryExternal < ActiveRecord::Migration
  def up
    case ActiveRecord::Base.connection.adapter_name
      when 'SQLite'
        change_column :menu_item_options, :price, :decimal
      when 'PostgreSQL'
        add_column :menu_item_options, :unit_price, :decimal
        mios = MenuItemOption.all
        mios.each do |mio|
          mio.unit_price = mio.price
          mio.save
        end
        remove_column :menu_item_options, :price
        add_column :menu_item_options, :price, :decimal
        mios.each do |mio|
          mio.price = mio.unit_price
          mio.save
        end
        remove_column :menu_item_options, :unit_price
      else
        raise 'Migration not implemented for this DB adapter'
      end

    create_table :users_restaurants, :id => false do |t|
      t.references :user
      t.references :restaurant
      t.timestamps
    end

    drop_table :users
    create_table :users do |t|
      t.string :username,         :default => nil
      t.string :email,            :null => false # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil

      t.timestamps
    end

    add_column :users, :remember_me_token, :string, :default => nil
    add_column :users, :remember_me_token_expires_at, :datetime, :default => nil
    add_index :users, :remember_me_token

    add_column :users, :reset_password_token, :string, :default => nil
    add_column :users, :reset_password_token_expires_at, :datetime, :default => nil
    add_column :users, :reset_password_email_sent_at, :datetime, :default => nil

    add_column :users, :role, :string, :limit => 50
    drop_table :roles_users
    drop_table :roles
    #u = User.new({:email => "user@domain.com", :password => "pass", :password_confirmation => "pass", :role => "admin"})
    #u.save

    create_table :authentications do |t|
      t.integer :user_id, :null => false
      t.string :provider, :uid, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :authentications

    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user
    end
    remove_column :users, :role

    remove_column :users, :reset_password_email_sent_at
    remove_column :users, :reset_password_token_expires_at
    remove_column :users, :reset_password_token

    remove_index :users, :remember_me_token
    remove_column :users, :remember_me_token_expires_at
    remove_column :users, :remember_me_token

    drop_table :users

    drop_table :users_restaurants

    case ActiveRecord::Base.connection.adapter_name
      when 'SQLite'
        change_column :menu_item_options, :price, :float
      when 'PostgreSQL'
        add_column :menu_item_options, :unit_price, :float
        mios = MenuItemOption.all
        mios.each do |mio|
          mio.unit_price = mio.price
          mio.save
        end
        remove_column :menu_item_options, :price
        add_column :menu_item_options, :price, :float
        mios.each do |mio|
          mio.price = mio.unit_price
          mio.save
        end
        remove_column :menu_item_options, :unit_price
      else
        raise 'Migration not implemented for this DB adapter'
      end
  end
end
