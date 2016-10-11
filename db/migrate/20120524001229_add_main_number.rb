class AddMainNumber < ActiveRecord::Migration
  def up
    create_table :location_numbers do |t|
      t.string :phone, :limit => 50, :default => nil
      t.string :send_digits_ext, :limit => 20, :default => nil
      t.boolean :text_number, :default => false
      t.references :location
      t.timestamps
    end

    @locations = Location.select("id, phone, txt_no, send_digits_ext")
    @locations.each do |location|
      if !location.phone.blank?
        location_number = LocationNumber.new({:phone => location.phone, :location_id => location.id})
        location_number.save
        if !location.send_digits_ext.blank?
          location_number.update_attribute("send_digits_ext", location.send_digits_ext)
        end
      end
      if !location.txt_no.blank?
        location_number = LocationNumber.new({:phone => location.txt_no, :text_number => true, :location_id => location.id})
        location_number.save
      end
    end

    remove_column :locations, :phone
    remove_column :locations, :txt_no
    remove_column :locations, :send_digits_ext

    add_column :location_numbers, :main_number, :boolean, :default => false
    @locations = Location.joins(:location_numbers).group("locations.id")
    @locations.each do |location|
      location.location_numbers.first.update_attributes({:main_number => true})

      #location_numbers = LocationNumber.where(:location_id => location.id)
      #location_numbers.first.update_attributes({:main_number => true})
    end
  end

  def down
    remove_column :location_numbers, :main_number

    add_column :locations, :phone, :limit => 50, :default => nil
    add_column :locations, :txt_no, :limit => 50, :default => nil
    add_column :locations, :send_digits_ext, :limit => 20, :default => nil

    @location_numbers = LocationNumber.all
    @location_numbers.each do |location_number|
      location = Location.find(location_number.location_id)
      if location_number.text_number.blank?
        location.update_attribute("phone", location_number.phone)
        if !location_number.send_digits_ext.blank?
          location.update_attribute("send_digits_ext", location_number.send_digits_ext)
        end
      else
        location.update_attribute("txt_no", location_number.text_number)
      end
    end

    drop_table :location_numbers
  end
end
