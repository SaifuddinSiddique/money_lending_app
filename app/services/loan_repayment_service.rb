# app/services/loan_repayment_service.rb
class LoanRepaymentService
  def initialize(loan, current_user)
    @loan = loan
  end

  def repay
    if @loan.open?
      @loan.process_closed_loan_transaction
      @loan.update(state: "closed")
      return { success: true, notice: "Loan repaid and closed!" }
    end
    { success: false, alert: "Loan cannot be repaid right now." }
  end
end
