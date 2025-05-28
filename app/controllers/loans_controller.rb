class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_loan, only: [ :show, :confirm_approval, :reject_approval, :accept_adjustment, :reject_adjustment, :request_readjustment, :repay ]
  before_action :check_kyc_status, only: [ :new, :create ]

  def new
    @loan = Loan.new
  end

  def create
    @loan = current_user.loans.new(loan_params)
    @loan.state = "requested"

    if @loan.save
      redirect_to @loan, notice: "Loan request submitted successfully!"
    else
      render :new
    end
  end

  def show
    # Shows loan details, including state, amount, interest, total payable, etc.
  end

  def accept_adjustment
    result = LoanAdjustmentService.new(@loan, current_user).accept_adjustment
    redirect_to @loan, notice: result[:notice], alert: result[:alert]
  end

  def reject_adjustment
    result = LoanAdjustmentService.new(@loan, current_user).reject_adjustment
    redirect_to @loan, notice: result[:notice], alert: result[:alert]
  end

  def request_readjustment
    result = LoanAdjustmentService.new(@loan, current_user).request_readjustment
    redirect_to @loan, notice: result[:notice], alert: result[:alert]
  end

  def repay
    result = LoanRepaymentService.new(@loan, current_user).repay
    redirect_to @loan, notice: result[:notice], alert: result[:alert]
  end

  def confirm_approval
    result = LoanApprovalService.new(@loan, current_user).confirm_approval
    redirect_to user_dashboard_path, notice: result[:notice], alert: result[:alert]
  end

  def reject_approval
    result = LoanApprovalService.new(@loan, current_user).reject_approval
    redirect_to user_dashboard_path, notice: result[:notice], alert: result[:alert]
  end

  private

  def set_loan
    @loan = current_user.loans.find(params[:id])
  end

  def check_kyc_status
    if current_user.kyc_profile.nil? || %w[pending rejected].include?(current_user.kyc_profile.status)
      redirect_to user_dashboard_path, notice: "Your KYC is not approved yet."
    end
  end

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
