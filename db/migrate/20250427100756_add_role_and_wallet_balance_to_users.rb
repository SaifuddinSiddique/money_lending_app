class AddRoleAndWalletBalanceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string, default: "user"
    add_column :users, :wallet_balance, :decimal, precision: 15, scale: 2, default: 10000
  end
end
