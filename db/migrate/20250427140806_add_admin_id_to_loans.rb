class AddAdminIdToLoans < ActiveRecord::Migration[7.2]
  def change
    add_column :loans, :admin_id, :string
  end
end
