require 'spec_helper'

describe ReportMailer do
  describe "orders_report" do
    let(:cart) { FactoryGirl.create(:cart_purchased) }
    let(:orders) { FactoryGirl.create_list(:order_confirmed, 3, cart: cart) }
    let(:mail) { ReportMailer.orders_report(orders) }

    it "sends orders report" do
      mail.subject.should eq("ChowBrowser orders report")
      mail.to.should eq([orders.first.restaurant.report_email])
      mail.from.should eq(["info@domain.com"])
      mail.reply_to.should eq(["info@domain.com"])
    end
=begin
    it "renders the body" do
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
=end
  end
end
