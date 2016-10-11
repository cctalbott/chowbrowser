class ChangeHolidays < ActiveRecord::Migration
  def up
    add_column :menu_sections, :description, :string, :limit => 500
    add_column :item_option_sections, :allow_multiple, :boolean

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    create_table :menu_hours do |t|
      t.time :menu_start
      t.time :menu_end
      t.references :menu
      t.timestamps
    end

    remove_column :menu_hours, :menu_start
    remove_column :menu_hours, :menu_end
    add_column :menu_hours, :menu_start_hour, :integer
    add_column :menu_hours, :menu_end_hour, :integer
    add_column :menu_hours, :menu_start_min, :integer
    add_column :menu_hours, :menu_end_min, :integer

    execute "UPDATE menu_hours SET menu_start_hour=null, menu_end_hour=null;"

    remove_column :restaurant_hours, :sun
    remove_column :restaurant_hours, :mon
    remove_column :restaurant_hours, :tue
    remove_column :restaurant_hours, :wed
    remove_column :restaurant_hours, :thu
    remove_column :restaurant_hours, :fri
    remove_column :restaurant_hours, :sat
    remove_column :restaurant_hours, :holidays

    add_column :restaurant_hours, :day, :integer, :limit => 1
    add_column :restaurant_hours, :start_hr, :integer, :limit => 2
    add_column :restaurant_hours, :start_min, :integer, :limit => 2
    add_column :restaurant_hours, :end_hr, :integer, :limit => 2
    add_column :restaurant_hours, :end_min, :integer, :limit => 2

    create_table :holidays do |t|
      t.boolean :all_day
      t.integer :start_hr, :limit => 2
      t.integer :start_min, :limit => 2
      t.integer :end_hr, :limit => 2
      t.integer :end_min, :limit => 2
      t.string :day, :limit => 250
      t.references :location
      t.timestamps
    end

    @restaurant_hours = RestaurantHour.all
    @restaurant_hours.each do |rh|
      rh.destroy
    end

    remove_column :holidays, :day
    add_column :holidays, :day, :date
  end

  def down
    add_column :holidays, :day, :string, :limit => 250
    remove_column :holidays, :day

    drop_table :holidays

    remove_column :restaurant_hours, :day
    remove_column :restaurant_hours, :start_hr
    remove_column :restaurant_hours, :start_min
    remove_column :restaurant_hours, :end_hr
    remove_column :restaurant_hours, :end_min

    add_column :restaurant_hours, :sun, :string
    add_column :restaurant_hours, :mon, :string
    add_column :restaurant_hours, :tue, :string
    add_column :restaurant_hours, :wed, :string
    add_column :restaurant_hours, :thu, :string
    add_column :restaurant_hours, :fri, :string
    add_column :restaurant_hours, :sat, :string
    add_column :restaurant_hours, :holidays, :string

    remove_column :menu_hours, :menu_start_min
    remove_column :menu_hours, :menu_end_min
    rename_column :menu_hours, :menu_start_hour, :menu_start
    rename_column :menu_hours, :menu_end_hour, :menu_end
    remove_column :menu_hours, :menu_start_hour
    remove_column :menu_hours, :menu_end_hour
    add_column :menu_hours, :menu_start, :time
    add_column :menu_hours, :menu_end, :time

    execute "UPDATE menu_hours SET menu_start=null, menu_end=null;"

    drop_table :menu_hours
    drop_table :sessions

    remove_column :item_option_sections, :allow_multiple
    remove_column :menu_sections, :description
  end
end
