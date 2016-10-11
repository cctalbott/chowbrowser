FactoryGirl.define do
  sequence(:email) do |n|
    "foo#{n}@example.com"
  end

  factory :billing_address do
    address "123 First St"
    city "Lubbock"
    state "TX"
    zip "79414"
    first_name "Harry"
    last_name "Caray"
    #order
  end

  factory :cart do
    trait :delivers do
      delivers TRUE
      delivery_distance 2
      delivery_duration 13
      delivery_address
    end
    #tip
    trait :purchased do
      purchased_at "2012-03-12 18:32:46.113274"
    end

    factory :cart_purchased do
      purchased
    end

    ignore do
      line_items_count 3
    end

    after(:create) do |cart, evaluator|
      FactoryGirl.create_list(:line_item, evaluator.line_items_count, :cart => cart)
    end
  end

  factory :delivery do
    fee 2.99
  end

  factory :delivery_address do
    address "123 First St"
    city "Lubbock"
    zip "79414"
    #order
  end

  factory :delivery_driver do
    phone "555-555-5555"
    user, strategy = :build
    #association :author, factory: :user, strategy: :build
    #user
    #delivery_hour
    ignore do
      delivery_hours_count 1
    end

    after(:create) do |delivery_driver, evaluator|
      FactoryGirl.create_list(:delivery_hour, evaluator.delivery_hours_count, :delivery_driver => delivery_driver)
    end
=begin
    factory :delivery_driver_locations do
      ignore do
        locations_count 1
      end

      after(:create) do |delivery_driver, evaluator|
        FactoryGirl.create_list(:location, evaluator.locations_count, :delivery_driver => delivery_driver)
      end
    end
=end
  end

  factory :delivery_hour do
    start_hr 00
    start_min 00
    end_hr 23
    end_min 59
    day Time.now.days_to_week_start(:sunday)
  end

  factory :holiday do
    all_day true
    #start_hr 00
    #start_min 00
    #end_hr 23
    #end_min 59
    day Time.now
  end

  factory :line_item do
    cart
    menu_section_item
    #unit_price 5.2
    #sequence(:unit_price) {|n| "1#{n}.0".to_f}
    unit_price 1.0
    quantity 1
  end

  factory :location do
    address "123 First St"
    region "TX"
    city "Lubbock"
    postal_code "79424"
    restaurant
=begin
    ignore do
      delivery_drivers_count 1
    end

    after(:create) do |location, evaluator|
      FactoryGirl.create_list(:delivery_driver, evaluator.delivery_drivers_count, :location => location)
    end
=end
    factory :location_with_orders do
      ignore do
        orders_count 3
      end

      after(:create) do |location, evaluator|
        FactoryGirl.create_list(:order_confirmed, evaluator.orders_count, :location => location)
      end
    end

    factory :location_active do
      active TRUE
      #trait :on_holiday do
      #  holiday
      #end
    end

    delivery
  end

  factory :location_number do
    phone "555-555-5555"
    main_number true
    location
  end

  factory :menu do
    location
    name "Dinner"
  end

  factory :menu_section do
    menu
    name "BBQ"
    description "BBQ'd meats."
  end

  factory :menu_section_item do
    name "Brisket"
    description "1/2lb. Sliced."
    price "5.20"
    menu_section
  end

  factory :order do
    #cart
    #delivery_address
    billing_address
    email
    phone "555-555-5555"
    card_expires_on "2014-09-01"
    card_type "visa"
    card_number "000000000000000"
    card_verification "123"
    ip_address "000.000.000.000"
    trait :confirmed do
      status "confirmed"
    end
    factory :order_confirmed do
      confirmed
    end
    trait :delivering do
      status "delivering"
    end
  end

  factory :order_transaction do
    order
    action "capture"
    amount 563
    success TRUE
  end

  factory :restaurant do
    name "Big Country BBQ"
    description "BBQ in a big country."
    report_email "youremail@domain.com"
    #location
  end

  factory :user do
    email
    password "secret"
    password_confirmation "secret"
    factory :admin do
      role "admin"
    end
    factory :customer do
      role "customer"
    end
  end
end
