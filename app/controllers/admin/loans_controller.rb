class Admin::LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @loans = Loan.requested.or(Loan.readjustment_requested).paginate(page: params[:page], per_page: 10)
    @wallet_balance = current_user.wallet_balance
  end

  def approve
    @loan = Loan.find(params[:id])
    @loan.approve!
    @loan.update!(admin_id: current_user.id)
    redirect_to admin_loans_path, notice: "Loan approved"
  end

  def reject
    @loan = Loan.find(params[:id])
    @loan.reject!
    redirect_to admin_loans_path, notice: "Loan rejected"
  end

  def edit
    @loan = Loan.find(params[:id])
  end

  def update
    @loan = Loan.find(params[:id])
    @loan.update(amount: params[:loan][:amount], interest_rate: params[:loan][:interest_rate], admin_id: current_user.id)
    if @loan.readjustment_requested?
      @loan.adjust_readjustment!
    else
      @loan.request_adjustment!
    end
    redirect_to admin_loans_path, notice: "Loan adjustment sent"
  end

  private

  def admin_only
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
