class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_only

  def dashboard
    @wallet_balance = current_user.wallet_balance
    @loans = current_user.loans.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  private

  def user_only
    redirect_to root_path, alert: "Access denied" unless current_user.user?
  end
end
