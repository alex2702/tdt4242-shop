class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  # show all existing users
  def index
    @users = User.all
    authorize User
  end

  # show a single user with the given ID
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  # update a given user with the given ID and the given parameters
  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  # destroy the user instance with the given ID
  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  # only allow whitelisted paramters
  def secure_params
    params.require(:user).permit(:role)
  end

end
