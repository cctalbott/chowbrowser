class ContactsController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @contact = Contact.new
    @submit_name = "Send Inquiry"
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if verify_recaptcha(:model => @contact) && @contact.save
        ContactMailer.contact_confirmation(@contact).deliver
        format.html { redirect_to(new_contact_path, :notice => 'Inquiry was successfully sent.') }
      else
        format.html { render :action => "new", :alert => "Inquiry failed to be sent." }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
end
