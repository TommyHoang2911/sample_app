class PasswordResetsController < ApplicationController
  include SessionsHelper
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "notice.send_email_instructions"
      redirect_to root_url
    else
      flash.now[:danger] = t "error.not_found_email"
      render :new
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("error.cannot_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column(:reset_digest, nil)
      flash[:success] = t "notice.update_pass_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t "error.user_not_found"
    redirect_to root_url
  end

  def valid_user
    redirect_to root_url unless check_valid_user?
  end

  def check_valid_user?
    @user && @user.activated? && @user.authenticated?(:reset, params[:id])

  end

  def check_expiration
    return unless  @user.password_reset_expired?

    flash[:danger] = t "error.link_expired"
    redirect_to new_password_reset_url
  end
end
