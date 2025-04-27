class Loan < ApplicationRecord
  include AASM

  belongs_to :user

  aasm column: :state do
    state :requested, initial: true
    state :approved
    state :open
    state :closed
    state :rejected
    state :waiting_for_adjustment_acceptance
    state :readjustment_requested
    state :waiting_for_readjustment_acceptance

    event :approve do
      transitions from: :requested, to: :approved
    end

    event :reject do
      transitions from: [:requested, :waiting_for_adjustment_acceptance, :readjustment_requested], to: :rejected
    end

    event :open_loan do
      transitions from: [:approved, :waiting_for_adjustment_acceptance], to: :open
    end

    event :close do
      transitions from: :open, to: :closed
    end

    event :request_adjustment do
      transitions from: :requested, to: :waiting_for_adjustment_acceptance
    end

    event :request_readjustment do
      transitions from: :waiting_for_adjustment_acceptance, to: :readjustment_requested
    end

    event :adjust_readjustment do
      transitions from: :readjustment_requested, to: :waiting_for_readjustment_acceptance
    end
  end

  def process_wallet_transaction
    return unless approved? || state == 'open'

    admin = User.find_by(id: self.admin_id)
  
    if admin.wallet_balance < amount
      errors.add(:base, "Admin does not have enough balance to approve this loan.")
      return false
    end

    admin_wallet = admin.wallet_balance - amount
    user_wallet = user.wallet_balance + amount

    admin.update!(wallet_balance: admin_wallet)
    user.update!(wallet_balance: user_wallet)

    true
  end
end
