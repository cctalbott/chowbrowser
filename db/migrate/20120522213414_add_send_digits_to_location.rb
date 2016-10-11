class AddSendDigitsToLocation < ActiveRecord::Migration
  def change
    change_table :restaurants do |t|
      t.string :report_email, :limit => 140
    end

    change_table :locations do |t|
      t.string :send_digits_ext, :limit => 20
    end
  end
end
