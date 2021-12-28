class UsersController < ApplicationController
  include SessionsHelper
  before_action :load_user_by_params_id, only: %i(show)

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "notice.welcome"
      redirect_to @user
    else
      flash.now[:danger] = t "error.signup_failure"
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def load_user_by_params_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.user_not_found"
    redirect_to signup_path
  end
end
