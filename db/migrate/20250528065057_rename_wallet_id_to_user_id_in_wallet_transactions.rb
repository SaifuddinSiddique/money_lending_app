class RenameWalletIdToUserIdInWalletTransactions < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :wallet_transactions, column: :wallet_id

    rename_column :wallet_transactions, :wallet_id, :user_id

    add_foreign_key :wallet_transactions, :users, column: :user_id
  end
end
