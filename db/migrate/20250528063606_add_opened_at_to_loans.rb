class AddOpenedAtToLoans < ActiveRecord::Migration[7.2]
  def change
    add_column :loans, :opened_at, :datetime
  end
end
