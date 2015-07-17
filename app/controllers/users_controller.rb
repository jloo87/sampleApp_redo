class UsersController < ApplicationController
  #to make sure that the user is logged in before edit update
  before_action :logged_in_user, only: [:edit, :update, :index]
  #to make sure tha the user matches the profile he wants to edit update
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    #if user is successfully created
    if @user.save
      #sets session['id'] to user['id']
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #if update is success
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      #back to profile page
      redirect_to @user
    else
      #show edit page to enter details again
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # used to prevent mass assignment vulnerability attacks (strong params)
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

    # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      #stores location of page trying to access
      store_location
      #shows error message 
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    #redirect to root unless the current user == logged in user
    redirect_to(root_url) unless current_user?(@user)
  end
end
