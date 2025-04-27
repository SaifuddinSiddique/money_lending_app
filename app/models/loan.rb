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
  end
end
