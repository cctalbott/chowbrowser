# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin
["admin", "customer", "guest", "restaurant owner", "restaurant editor", "editor"].each do |name|
  Role.find_or_create_by_name(:name => name)
end
=end
#Order.create!(:first_name => "Testing", :last_name => "Tester", :card_type => "visa", :card_expires_on => "2011-12-01" :email => "test@test.com")
["Home Style", "Pizza", "Italian", "American", "BBQ", "Deli", "Mexican", "Wings", "Indian", "Burgers", "Steak", "Asian", "Cajun", "Noodles/Pasta", "Greek", "Sushi", "Lebanese", "Breakfast", "Healthy", "Salads", "Vegetarian", "Seafood", "Desert", "Late Night"].each do |name|
  Cuisine.find_or_create_by_name(:name => name)
end
