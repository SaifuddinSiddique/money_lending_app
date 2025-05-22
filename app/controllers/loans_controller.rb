class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_loan, only: [ :show, :confirm, :accept_adjustment, :reject_adjustment, :request_readjustment, :repay ]
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
    if @loan.waiting_for_adjustment_acceptance? || @loan.waiting_for_readjustment_acceptance?
      @loan.process_wallet_transaction
      @loan.update(state: "open", total_amount: @loan.amount)
      redirect_to @loan, notice: "Loan opened successfully after adjustment!"
    else
      redirect_to @loan, alert: "Invalid loan state for acceptance."
    end
  end

  # User rejects the loan approval or adjustment
  def reject_adjustment
    if @loan.requested? || @loan.waiting_for_adjustment_acceptance? || @loan.waiting_for_readjustment_acceptance?
      @loan.update(state: "rejected")
      redirect_to @loan, notice: "Loan request rejected!"
    else
      redirect_to @loan, alert: "Invalid loan state for rejection."
    end
  end

  # User requests another adjustment (readjustment)
  def request_readjustment
    if @loan.waiting_for_adjustment_acceptance?
      @loan.update(state: "readjustment_requested")
      redirect_to @loan, notice: "Readjustment requested!"
    else
      redirect_to @loan, alert: "Cannot request readjustment at this stage."
    end
  end

  # User repays loan
  def repay
    if @loan.open?
      @loan.process_closed_loan_transaction
      @loan.update(state: "closed")
      redirect_to @loan, notice: "Loan repaid and closed!"
    else
      redirect_to @loan, alert: "Loan cannot be repaid right now."
    end
  end

  def confirm_approval
    @loan = Loan.find(params[:id])

    if @loan.user == current_user && @loan.approved?
      # Update the loan state to 'open' and process wallet transaction
      if @loan.process_wallet_transaction
        @loan.update(state: :open, total_amount: @loan.amount)  # Update the state of the loan to 'open'
        redirect_to user_dashboard_path, notice: "Loan confirmed. It is now open!"
      else
        redirect_to user_dashboard_path, alert: "Admin does not have enough balance to approve the loan."
      end
    else
      redirect_to user_dashboard_path, alert: "Loan not found or already processed."
    end
  end

  def reject_approval
    @loan = Loan.find(params[:id])
    if @loan.user == current_user && @loan.approved?
      @loan.update(state: :rejected)
      redirect_to user_dashboard_path, notice: "Loan rejected."
    else
      redirect_to user_dashboard_path, alert: "Loan not found or already processed."
    end
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
