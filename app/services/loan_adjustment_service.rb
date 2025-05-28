# app/services/loan_adjustment_service.rb
class LoanAdjustmentService
  def initialize(loan, current_user)
    @loan = loan
    @current_user = current_user
  end

  def accept_adjustment
    if @loan.waiting_for_adjustment_acceptance? || @loan.waiting_for_readjustment_acceptance?
      @loan.process_wallet_transaction
      @loan.update(state: "open", total_amount: @loan.amount, opened_at: Time.current)
      return { success: true, notice: "Loan opened successfully after adjustment!" }
    end
    { success: false, alert: "Invalid loan state for acceptance." }
  end

  def reject_adjustment
    if @loan.requested? || @loan.waiting_for_adjustment_acceptance? || @loan.waiting_for_readjustment_acceptance?
      @loan.update(state: "rejected")
      return { success: true, notice: "Loan request rejected!" }
    end
    { success: false, alert: "Invalid loan state for rejection." }
  end

  def request_readjustment
    if @loan.waiting_for_adjustment_acceptance?
      @loan.update(state: "readjustment_requested")
      return { success: true, notice: "Readjustment requested!" }
    end
    { success: false, alert: "Cannot request readjustment at this stage." }
  end
end
