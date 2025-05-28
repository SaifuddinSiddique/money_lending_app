# app/services/loan_approval_service.rb
class LoanApprovalService
  def initialize(loan, current_user)
    @loan = loan
    @current_user = current_user
  end

  def confirm_approval
    if @loan.user == @current_user && @loan.approved?
      if @loan.process_wallet_transaction
        @loan.update(state: :open, total_amount: @loan.amount, opened_at: Time.current)
        return { success: true, notice: "Loan confirmed. It is now open!" }
      else
        return { success: false, alert: "Admin does not have enough balance to approve the loan." }
      end
    end
    { success: false, alert: "Loan not found or already processed." }
  end

  def reject_approval
    if @loan.user == @current_user && @loan.approved?
      @loan.update(state: :rejected)
      return { success: true, notice: "Loan rejected." }
    end
    { success: false, alert: "Loan not found or already processed." }
  end
end
