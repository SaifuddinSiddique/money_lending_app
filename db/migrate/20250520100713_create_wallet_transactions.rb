class CreateWalletTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: { to_table: :users }  # since wallet is part of user here
      t.string :transaction_type, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.text :description
      t.references :related_user, foreign_key: { to_table: :users }
      t.references :related_loan, foreign_key: { to_table: :loans }
      t.timestamps
    end
  end
end
