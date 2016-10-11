require 'twilio-ruby'
require 'builder'

class TwilioController < ApplicationController
  include ActionView::Helpers::TextHelper
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :set_order
  http_basic_authenticate_with :name => "twilioapi", :password => "TwilioPass"

  def index
    respond_to do |format|
      format.xml
    end
  end

  def call_customer
    if @order.notify_method == "phone call"
      data = {
        'From' => CALLER_ID,
        'To' => @order.phone,
        'Url' => BASE_URL + "/notify_customer.xml?order=#{@order.id}"
      }
      begin
        client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
        client.account.calls.create data
      rescue StandardError => bang
        redirect_to public_order_failure_path, :alert => "Error #{bang}"
        return
      end
    else
      text_customer
    end
    if @order.cart.delivers
      text_driver
    end
    #redirect_to public_order_success_path,
    #  :notice => "Calling #{params['number']}..."
    respond_to do |format|
      format.xml
    end
  end

  def notify_customer
    #@redirectto = public_order_success_url
    #@redirectto = BASE_URL + "/goodbye.xml"
    if @order.cart.delivers
      text_driver
      @the_wait = @order.total_wait
      @ready_or_deliver = "delivered"
    else
      @the_wait = @order.total_wait
      @ready_or_deliver = "ready"
    end
    respond_to do |format|
      #format.xml { @redirectto }
      format.xml {@the_wait}
    end
  end

  def order_placed
    @postto = BASE_URL + "/confirm_order.xml?order=#{@order.id}"
    #
    respond_to do |format|
      format.xml { @postto }
    end
  end

  def order_placed_recite
    @postto = BASE_URL + "/confirm_order.xml?order=#{@order.id}"
    #
    respond_to do |format|
      format.xml { @postto }
    end
  end

  def confirm_order
    if params['Digits'] == '1'
      @order.update_attribute(:status, "confirmed")
      begin
        PrivatePub.publish_to("/orders/#{@order.id}/status_update", :order_status => "#{@order.status}")
      rescue EOFError
        # Reached the end of the response
      end
      #broadcast("/orders/#{@order.id}/status_update", "#{@order.status}")
      redirect_to BASE_URL + "/estimated_wait.xml?order=#{@order.id}"
      return
    elsif params['Digits'] == '2'
      redirect_to BASE_URL + "/order_placed_recite.xml?order=#{@order.id}"
      return
    end
=begin
    if !params['Digits'] or params['Digits'] == '2'
      redirect_to BASE_URL + "/deny_order.xml?order=#{@order.id}"
      return
    end
=end
    @redirectto = BASE_URL + "/confirm_order.xml?order=#{@order.id}"
    respond_to do |format|
      format.xml { @redirectto }
    end
  end

  def estimated_wait
    @postto = BASE_URL + "/goodbye.xml?order=#{@order.id}"
    respond_to do |format|
      format.xml { @postto }
    end
  end

  def goodbye
    @redirectto = ""
    if params['Digits']
      @order.update_attribute(:estimated_wait, params['Digits'])
      #@redirectto = BASE_URL + "/call_customer.xml?order=#{@order.id}"
      #OrderMailer.order_confirmation(@order).deliver
    end
    unless @order.status == "confirmed"
      @order.update_attribute(:status, "unconfirmed")
      begin
        PrivatePub.publish_to("/orders/#{@order.id}/status_update", :order_status => "#{@order.status}")
      rescue EOFError
        # Reached the end of the response
      end
    end
    respond_to do |format|
      #format.xml { @redirectto }
      format.xml
    end
  end

  def restaurant_status
    @call_status = CallStatus.new(:call_sid => params[:CallSid], :status => params[:CallStatus])
    @call_status.orders = [@order]
    @call_status.save
    unless @order.status == "confirmed"
      alert_dispatcher("restaurant", @order.status)
    end
    # Add try/catch for email here
    begin
      OrderMailer.order_confirmation(@order).deliver
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      #
    end
    redirect_to BASE_URL + "/call_customer.xml?order=#{@order.id}"
    #  return
    #end
    #render :nothing => true
  end

  def customer_status
    render :nothing => true
  end

  def error
    notify_of_error

    respond_to do |format|
      format.xml
    end
  end

  private

    def set_order
      @order = Order.find(params[:order]) ? Order.find(params[:order]) : nil
    end

    def text_driver
      @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
      @account = @client.account
      @drivers = DeliveryDriver.joins(:locations).where("locations.id = ?", @order.location.id)
      @driver_avail = false
      @drivers.each do |driver|
        if driver.is_delivering?
          @driver_avail = true
          message = @account.sms.messages.create({:from => '555-555-5555',
            :to => driver.phone,
            :body => truncate("Order #{@order.id} conf. #{@order.identification_no} to #{@order.billing_address.first_name} #{@order.billing_address.last_name} #{@order.phone} from #{@order.restaurant_name} to #{@order.deliver_address} Est.Wait: #{@order.total_wait}", :length => 155)})
          puts message
        end
      end
      if @driver_avail
        @order.update_attribute(:status, "delivering")
        begin
          PrivatePub.publish_to("/orders/#{@order.id}/status_update", :order_status => "#{@order.status}")
        rescue EOFError
          # Reached the end of the response
        end
      end
      #broadcast("/orders/#{@order.id}/status_update", "#{@order.status}")
      #respond_to do |format|
      #  format.xml
      #end
    end

    def text_customer
      @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
      @account = @client.account
      if @order.cart.delivers
        @txt_body = "Your order from #{@order.restaurant_name} will be delivered in #{@order.total_wait} minutes."
      else
        @txt_body = "Your order from #{@order.restaurant_name} will be ready in #{@order.total_wait} minutes."
      end
      @message = @account.sms.messages.create({#:from => '555-555-5555',
        :from => '555-555-5555',
        :to => @order.phone,
        :body => truncate(@txt_body, :length => 155)})
      puts @message
      #respond_to do |format|
      #  format.xml
      #end
    end

    def alert_dispatcher(called, status)
      DispatchMailer.dispatch_message(@order).deliver
      @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
      @account = @client.account
      if called == "restaurant"
        @alert_txt = "ChowBrowser order failed to be confirmed by #{@order.restaurant_name} #{@order.location.main_phone_number}. Order #{@order.id}."
      else
        #
      end
      # clint
      @message = @account.sms.messages.create({:from => '555-555-5555',
        :to => '555-555-5555',
        :body => truncate(@alert_txt, :length => 155)})
      puts @message
    end

    def notify_of_error
      @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
      @account = @client.account
      @alert_txt = "ChowBrowser order error. [Order id: #{@order.id}, Order status: #{@order.status}]"
      # to clint
      @message = @account.sms.messages.create({:from => '555-555-5555',
        :to => '555-555-5555',
        :body => truncate(@alert_txt, :length => 155)})
      puts @message
=begin
      # to joseph
      @message = @account.sms.messages.create({:from => '806-300-0522',
        :to => '806-441-3469',
        :body => truncate(@alert_txt, :length => 155)})
      puts @message
      # to brian stockton
      @message = @account.sms.messages.create({:from => '806-300-0522',
        :to => '806-790-1699',
        :body => truncate(@alert_txt, :length => 155)})
      puts @message
=end
    end
end
