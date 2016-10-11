Takeoutapp::Application.routes.draw do
=begin
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :roles

  #match '/test' => 'test#index', :as => :test

  match '/cart' => 'public/carts#show', :as => :current_cart

  match '/twilio/index' => 'twilio#index', :as => :twilios
  match '/twilio/call_customer' => 'twilio#call_customer',
    :as => :twilio_call_customer
  match '/twilio/notify_customer' => 'twilio#notify_customer',
    :as => :twilio_notify_customer
  match '/twilio/order_placed' => 'twilio#order_placed',
    :as => :twilio_order_placed
  match '/twilio/order_placed_recite' => 'twilio#order_placed_recite',
    :as => :twilio_order_placed_recite
  match '/twilio/confirm_order' => 'twilio#confirm_order',
    :as => :twilio_confirm_order
  match '/twilio/estimated_wait' => 'twilio#estimated_wait',
    :as => :twilio_estimated_wait
  match '/twilio/goodbye' => 'twilio#goodbye', :as => :twilio_goodbye
  match '/twilio/error' => 'twilio#error', :as => :twilio_error
  match '/twilio/restaurant_status' => 'twilio#restaurant_status',
    :as => :restaurant_status
  match '/twilio/customer_status' => 'twilio#customer_status',
    :as => :customer_status

  match '/orders/:id/status_update' => 'public/orders#status_update',
    :as => :order_status

  match '/404' => 'errors#four_zero_four', :as => :four_zero_four
  match '/422' => 'errors#four_two_two', :as => :four_two_two
  match '/500' => 'errors#five_zero_zero', :as => :five_zero_zero

  namespace :public do
    resources :restaurants
    resources :menus
    resources :menu_section_items
    match 'menu_item_option/select/:id/:line_item_id' => 'menu_item_options#select',
      :as => :select_menu_item_option
    match 'cart/delivery' => 'carts#delivery', :as => :cart_delivery
    match 'cart/update_delivery' => 'carts#update_delivery', :via => [:post],
      :as => :cart_update_delivery
    match 'cart/tip' => 'carts#tip', :as => :cart_tip
    match 'cart/update_tip' => 'carts#update_tip', :via => [:post],
      :as => :cart_update_tip
    resources :carts
    #match 'orders/:year' => 'orders#index', :defaults => { :year => 'All' },
    #  :via => [:get], :as => :orders
    match 'orders/:year/:month/:day/:category' => 'orders#index', :defaults =>
      {:year => Time.now.year, :month => Time.now.month, :day => Time.now.day,
      :category => 'all'}, :via => [:get], :as => :view_orders
    match 'orders/:year/:month/:day/restaurant/:restaurant' => 'orders#restaurant_index',
      :defaults => {:year => Time.now.year, :month => Time.now.month,
      :day => Time.now.day, :category => 'restaurant'}, :via => [:get],
      :as => :orders_by_restaurant
    match 'orders/:year/:month/:day/customer/:customer' => 'orders#customer_index',
      :defaults => { :year => Time.now.year, :month => Time.now.month,
      :day => Time.now.day, :category => 'customer'}, :via => [:get],
      :as => :orders_by_customer
    #get 'orders/success'
    #get 'orders/failure'
    match 'orders/success' => 'orders#success', :as => :order_success
    match 'orders/failure' => 'orders#failure', :as => :order_failure
    #match 'orders/:id/status_update' => 'orders#status_update',
    #  :as => :order_status
    resources :orders
    match '/customer' => 'orders#show_customer', :as => :show_customer
    match '/restauraunt_orders' => 'orders#show_restaurant_orders',
      :as => :show_restaurant_orders
    resources :line_items
    match '/line_item_options/:id' => 'line_items#destroy_option',
      :as => :destroy_line_item_option
    match 'delivery_address/:id' => 'delivery_addresses#show',
      :via => [:get], :as => :delivery_address
    match 'delivery_address_distance' => 'delivery_addresses#distance',
      :via => [:get], :as => :delivery_address_distance
    match 'delivery_address_distance' => 'delivery_addresses#update_distance',
      :via => [:post], :as => :update_delivery_address_distance
  end

  match "admin" => "admin#index", :as => :admin
  namespace :admin do
    resources :users
    resources :sales_offices
    resources :sales_people
    resources :cuisines
    match 'restaurants/import_csv' => 'restaurants#import_csv',
      :as => :import_restaurants
    match 'restaurants/create_csv' => 'restaurants#create_csv',
      :as => :create_restaurants
    resources :restaurants
    match 'restaurant/:id/location/new' => 'locations#new',
      :as => :restaurant_new_location
    match 'restaurant/:id/location/create' => 'locations#create',
      :as => :restaurant_create_location
    resources :locations
    match 'location/:id/menu/new' => 'menus#new', :as => :location_new_menu
    match 'location/:id/menu/create' => 'menus#create',
      :as => :location_create_menu
    match 'location/:id/menus/import_csv' => 'menus#import_csv',
      :as => :import_menus
    match 'location/:id/menus/create_csv' => 'menus#create_csv',
      :as => :create_menus
    resources :menus
    match 'menu/:id/menu_section/new' => 'menu_sections#new',
      :as => :menu_new_menu_section
    match 'menu/:id/menu_section/create' => 'menu_sections#create',
      :as => :menu_create_menu_section
    resources :menu_sections
    match 'menu_section/:id/menu_section_item/new' => 'menu_section_items#new',
      :as => :menu_section_new_menu_section_item
    match 'menu_section/:id/menu_section_item/create' => 'menu_section_items#create',
      :as => :menu_section_create_menu_section_item
    resources :menu_section_items
    match 'menu_section_item/:id/item_option_sections/new' => 'item_option_sections#new',
      :as => :menu_section_item_new_item_option_section
    match 'menu_section_item/:id/item_option_sections/create' => 'item_option_sections#create',
      :as => :menu_section_item_create_item_option_section
    resources :item_option_sections
    match 'item_option_sections/menu/:menu_id' => "item_option_sections#index_by_menu",
      :as => :item_option_sections_by_menu
    match 'item_option_section/:id/menu_item_options/new' => 'menu_item_options#new',
      :as => :item_option_section_new_menu_item_option
    match 'item_option_section/:id/menu_item_options/create' => 'menu_item_options#create',
      :as => :item_option_section_create_menu_item_option
    resources :menu_item_options
    # ORDERS
    match 'orders/:year/:month/:day/:category' => 'orders#index',
      :defaults => {:year => Time.now.year, :month => Time.now.month,
      :day => Time.now.day, :category => 'all'}, :via => [:get],
      :as => :view_orders
    match 'orders/:year/:month/:day/restaurant/:restaurant' => 'orders#restaurant_index',
      :defaults => {:year => Time.now.year, :month => Time.now.month,
      :day => Time.now.day, :category => 'restaurant'}, :via => [:get],
      :as => :orders_by_restaurant
    match 'orders/:year/:month/:day/customer/:customer' => 'orders#customer_index',
      :defaults => {:year => Time.now.year, :month => Time.now.month,
      :day => Time.now.day, :category => 'customer'}, :via => [:get],
      :as => :orders_by_customer
    match 'orders/incomplete' => 'orders#incomplete_orders',
      :as => :incomplete_orders
    match 'orders/complete' => 'orders#complete_orders',
      :as => :complete_orders
    match 'orders/:id/update_status' => 'orders#update_status',
      :as => :update_order_status
    resources :orders
    match '/customer' => 'orders#show_customer', :as => :show_customer
    match '/restauraunt_orders' => 'orders#show_restaurant_orders',
      :as => :show_restaurant_orders
    resources :delivery_drivers
    resources :delivery_hours
    resources :printers
    match '/batches/drivers' => 'batches#drivers', :as => :batches_drivers
    resources :batches
    match '/clock_in' => "clock_in#create", :as => :clock_in
    match '/clock_out' => "clock_in#destroy", :as => :clock_out
  end

  match 'about' => 'information#about', :as => :about
  match 'faq' => 'information#faq', :as => :faq
  match 'privacy' => 'information#privacy', :as => :privacy
  match 'terms' => 'information#terms', :as => :terms
  match 'about_delivery' => 'information#delivery', :as => :about_delivery
  match 'promote_restaurant' => 'information#restaurant',
    :as => :promote_restaurant

  resources :contacts

  get "welcome/index"
  root :to => 'welcome#index'
=end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions
  # automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful
  # applications.
  # Note: This route will make all actions in every controller accessible via
  # GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
