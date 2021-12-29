class AccountActivationsController < ApplicationController
  include SessionsHelper

  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "notice.account_activated"
      redirect_to user
    else
      flash[:danger] = t "error.invalid_link_active"
      redirect_to root_url
    end
  end
end
