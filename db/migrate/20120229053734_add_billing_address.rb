class AddBillingAddress < ActiveRecord::Migration
  def up
    drop_table :authentications

    rename_table :users_restaurants, :locations_users
    remove_column :locations_users, :restaurant_id
    change_table :locations_users do |t|
      t.references :location
    end

    change_table :line_item_options do |t|
      t.integer :qty, :limit => 2, :null => false, :default => 1
    end
    change_table :line_items do |t|
      t.string :instructions, :limit => 250, :default => nil
    end

    create_table :deliveries do |t|
      t.decimal :fee
      t.references :location
      t.timestamps
    end
    remove_column :restaurants, :deliver_fee
    add_column :orders, :tip, :decimal
    add_column :orders, :address, :string, :limit => 500

    create_table :cuisines do |t|
      t.string :name, :limit => 150, :null => false, :default => nil
      t.timestamps
    end
    create_table :cuisines_restaurants, :id => false do |t|
      t.references :cuisine
      t.references :restaurant
    end

    create_table :contacts do |t|
      t.string :email, :limit => 150, :null => false
      t.string :comment, :limit => 500
    end

    add_column :locations, :phone, :string, :limit => 50, :default => nil
    add_column :locations, :delivers, :boolean, :default => false
    add_column :orders, :phone, :string, :limit => 50, :default => nil
    add_column :orders, :notify_method, :string, :limit => 25, :default => "phone call"
    add_column :orders, :status, :string, :limit => 150
    add_column :orders, :estimated_wait, :integer, :limit => 4

    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
      table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
      table.text     :handler                      # YAML-encoded string of the object that will do work
      table.text     :last_error                   # reason for last failure (See Note below)
      table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      table.datetime :locked_at                    # Set when a client is working on this object
      table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      table.string   :locked_by                    # Who is working on this object (if locked)
      table.string   :queue                        # The name of the queue this job is in
      table.timestamps
    end

    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

    create_table :billing_addresses do |t|
      t.string :name, :limit => 250
      t.string :address, :limit => 250
      t.string :city, :limit => 250
      t.string :state, :limit => 250
      t.string :country, :limit => 250
      t.string :zip, :limit => 100
      t.references :order
      t.timestamps
    end
  end

  def down
    drop_table :billing_addresses

    drop_table :delayed_jobs

    remove_column :locations, :phone
    remove_column :locations, :delivers
    remove_column :orders, :phone
    remove_column :orders, :notify_method
    remove_column :orders, :status
    remove_column :orders, :estimated_wait

    drop_table :contacts

    drop_table :cuisines_restaurants
    drop_table :cuisines

    remove_column :orders, :address
    remove_column :orders, :tip
    add_column :restaurants, :deliver_fee, :text
    drop_table :deliveries

    remove_column :line_items, :instructions
    remove_column :line_item_options, :qty

    rename_table :locations_users, :users_restaurants
    remove_column :locations_users, :location_id
    change_table :users_restaurants do |t|
      t.references :restaurant
    end
  end
end
