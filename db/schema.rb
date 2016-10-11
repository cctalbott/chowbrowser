# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120831233346) do

  create_table "billing_addresses", :force => true do |t|
    t.string   "address",    :limit => 250
    t.string   "city",       :limit => 250
    t.string   "state",      :limit => 250
    t.string   "country",    :limit => 250
    t.string   "zip",        :limit => 100
    t.integer  "order_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "first_name", :limit => 125
    t.string   "last_name",  :limit => 125
  end

  create_table "call_statuses", :force => true do |t|
    t.string   "call_sid",   :limit => 100
    t.string   "status",     :limit => 50
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "call_statuses_orders", :id => false, :force => true do |t|
    t.integer "call_status_id"
    t.integer "order_id"
  end

  create_table "carts", :force => true do |t|
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delivers",                           :default => false
    t.decimal  "tip"
    t.integer  "delivery_distance",   :limit => 8
    t.integer  "delivery_duration"
    t.integer  "delivery_address_id"
    t.integer  "delivery_driver_id"
    t.string   "driver_email",        :limit => 150
  end

  create_table "clock_in", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string "email",   :limit => 150, :null => false
    t.string "comment", :limit => 500
  end

  create_table "cuisines", :force => true do |t|
    t.string   "name",       :limit => 150, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "cuisines_restaurants", :id => false, :force => true do |t|
    t.integer "cuisine_id"
    t.integer "restaurant_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliveries", :force => true do |t|
    t.decimal  "fee"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "delivery_addresses", :force => true do |t|
    t.string   "address",    :limit => 250
    t.string   "city",       :limit => 250
    t.string   "state",      :limit => 250
    t.string   "country",    :limit => 250
    t.string   "zip",        :limit => 100
    t.integer  "order_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "delivery_drivers", :force => true do |t|
    t.string   "phone",      :limit => 50
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "delivery_drivers_locations", :id => false, :force => true do |t|
    t.integer "delivery_driver_id"
    t.integer "location_id"
  end

  create_table "delivery_hours", :force => true do |t|
    t.integer  "day",                :limit => 2
    t.integer  "start_hr",           :limit => 2
    t.integer  "start_min",          :limit => 2
    t.integer  "end_hr",             :limit => 2
    t.integer  "end_min",            :limit => 2
    t.integer  "delivery_driver_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "holidays", :force => true do |t|
    t.boolean  "all_day"
    t.integer  "start_hr",    :limit => 2
    t.integer  "start_min",   :limit => 2
    t.integer  "end_hr",      :limit => 2
    t.integer  "end_min",     :limit => 2
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "day"
  end

  create_table "item_option_sections", :force => true do |t|
    t.string   "name"
    t.integer  "position",             :limit => 2
    t.integer  "menu_section_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_multiple"
    t.integer  "multiple_limit",       :limit => 2
  end

  create_table "line_item_options", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "menu_item_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "qty",                 :limit => 2, :default => 1, :null => false
    t.string   "name"
    t.float    "price"
  end

  create_table "line_items", :force => true do |t|
    t.decimal  "unit_price"
    t.integer  "menu_section_item_id"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "instructions",         :limit => 250
    t.string   "name",                 :limit => 200
  end

  create_table "location_numbers", :force => true do |t|
    t.string   "phone",           :limit => 50
    t.string   "send_digits_ext", :limit => 20
    t.boolean  "text_number",                   :default => false
    t.integer  "location_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "main_number",                   :default => false
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "region",          :limit => 100
    t.string   "city",            :limit => 150
    t.string   "postal_code",     :limit => 50
    t.integer  "sales_office_id"
    t.string   "email",           :limit => 140
    t.boolean  "active",                         :default => true
    t.float    "lat"
    t.float    "lon"
    t.integer  "percentage",                     :default => 90,    :null => false
    t.integer  "sales_person_id"
    t.boolean  "recite_order",                   :default => false
  end

  add_index "locations", ["restaurant_id"], :name => "index_locations_on_restaurant_id"

  create_table "locations_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  create_table "logos", :force => true do |t|
    t.string   "img_path",      :default => "/logos/default.png", :null => false
    t.integer  "restaurant_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "menu_hours", :force => true do |t|
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_start_hour"
    t.integer  "menu_end_hour"
    t.integer  "menu_start_min"
    t.integer  "menu_end_min"
  end

  create_table "menu_item_options", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "menu_section_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_option_section_id"
    t.decimal  "price"
  end

  create_table "menu_section_items", :force => true do |t|
    t.string   "name",            :limit => 200
    t.text     "description"
    t.text     "price"
    t.integer  "menu_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.integer  "position",                       :default => 0
    t.boolean  "featured",                       :default => false
  end

  add_index "menu_section_items", ["menu_section_id"], :name => "index_menu_section_items_on_menu_section_id"

  create_table "menu_sections", :force => true do |t|
    t.string   "name"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                   :default => 0
    t.string   "description", :limit => 500
  end

  add_index "menu_sections", ["menu_id"], :name => "index_menu_sections_on_menu_id"

  create_table "menus", :force => true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        :limit => 150
    t.integer  "position"
  end

  add_index "menus", ["location_id"], :name => "index_menus_on_restaurant_id"

  create_table "option_relationships", :id => false, :force => true do |t|
    t.integer "item_option_section_id"
    t.integer "menu_section_item_id"
    t.integer "menu_section_id"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id"
    t.string   "ip_address"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.decimal  "tip"
    t.string   "phone",             :limit => 50
    t.string   "notify_method",     :limit => 25, :default => "phone call"
    t.string   "status",                          :default => "placed"
    t.integer  "estimated_wait",                  :default => 30
    t.integer  "user_id"
    t.string   "restaurant_name"
    t.integer  "identification_no", :limit => 8,  :default => 12345,        :null => false
  end

  create_table "printers", :force => true do |t|
    t.string   "model_name",  :limit => 140
    t.string   "service_no",  :limit => 140
    t.string   "email",       :limit => 140
    t.integer  "location_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "restaurant_hours", :force => true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day",         :limit => 2
    t.integer  "start_hr",    :limit => 2
    t.integer  "start_min",   :limit => 2
    t.integer  "end_hr",      :limit => 2
    t.integer  "end_min",     :limit => 2
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",  :limit => 500
    t.text     "ordermin"
    t.text     "ordermax"
    t.boolean  "featured"
    t.string   "report_email", :limit => 140
  end

  create_table "sales_offices", :force => true do |t|
    t.string   "name",       :limit => 150, :null => false
    t.string   "location",   :limit => 150
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "sales_people", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "reset_password_token"
    t.string   "role",                   :limit => 50
    t.string   "username",               :limit => 140
    t.string   "encrypted_password",                    :default => "", :null => false
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
