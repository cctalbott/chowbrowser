class Admin::UsersController < AdminController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    #location = @user.locations.build
    @submit_name = "Create user"
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to admin_users_path, :notice => 'Application submitted.'
    else
      redirect_to new_admin_user_path, :alert => 'Application submission failed.'
    end
  end

  def edit
    @user = User.find(params[:id])
    @submit_name = "Edit user"
  end

  def update
    # delete current_password params if password blank.
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to admin_user_path(@user), :notice => "User updated."
    else
      redirect_to edit_admin_user_path(@user), :alert => "User update failed."
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
end
