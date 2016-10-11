class Admin::ClockInController < AdminController
  load_and_authorize_resource
=begin
  def new
    @printer = Printer.new
    @submit_name = "Create printer"
  end
=end
  def create
    @clock_in = ClockIn.new({:user_id => current_user.id})

    if @clock_in.save
      redirect_to root_path, :notice => 'Clocked in.'
    else
      redirect_to root_path, :alert => 'Failed to clock in.'
    end
  end

  def destroy
    @clock_in = ClockIn.find_by_user_id(current_user.id)
    @clock_in.destroy
    redirect_to root_path, :notice => "Clocked out."
  end
end