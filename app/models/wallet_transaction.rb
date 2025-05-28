class WalletTransaction < ApplicationRecord
    belongs_to :user
    belongs_to :related_user, class_name: "User", optional: true
    belongs_to :loan, optional: true

    enum transaction_type: {
      credit: "credit",
      debit: "debit",
      transfer: "transfer",
      adjustment: "adjustment",
      fee: "fee"
    }

    validates :transaction_type, presence: true
    validates :amount, numericality: { greater_than: 0 }
end
