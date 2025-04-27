class AddAdminIdToLoans < ActiveRecord::Migration[7.2]
  def change
    add_column :loans, :admin_id, :string
    add_column :loans, :integer, :string
  end
end
