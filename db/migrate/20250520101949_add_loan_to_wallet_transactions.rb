class AddLoanToWalletTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :wallet_transactions, :loan, foreign_key: true
  end
end
