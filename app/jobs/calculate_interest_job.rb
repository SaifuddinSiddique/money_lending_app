class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform
    Loan.where(state: 'open').find_each do |loan|
      interest = loan.amount * (loan.interest_rate / 100) * (5.0 / (365 * 24 * 60))
      updated_total_amount = (loan.total_amount.to_f + interest).round(2)
      loan.update!(total_amount: updated_total_amount )
    end
  end
end
