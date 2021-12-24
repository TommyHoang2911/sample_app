class UsersController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user_by_params_id, except: %i(index show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy(User.all, items: Settings.length.digit_20)
  end

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

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "notice.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "notice.delete_success"
    else
      flash[:danger] = t "error.delete_failed"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "notice.please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user_by_params_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.user_not_found"
    redirect_to signup_path
  end
end
