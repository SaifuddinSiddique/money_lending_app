class UpdateRelatedUserForeignKeyOnWalletTransactions < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :wallet_transactions, name: "fk_rails_5b1c96231b"

    add_foreign_key :wallet_transactions, :users, column: :related_user_id, on_delete: :nullify
  end
end
