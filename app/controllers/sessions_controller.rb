class SessionsController < ApplicationController
  include SessionsHelper

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        decide_remember user
        redirect_back_or user
      else
        flash[:warning] = t "error.account_unactive"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "error.signin_failure"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def decide_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
