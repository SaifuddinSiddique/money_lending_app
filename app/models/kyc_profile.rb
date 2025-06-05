class KycProfile < ApplicationRecord
  belongs_to :user

  has_one_attached :id_document
  has_one_attached :selfie
  has_one_attached :address_proof
  before_create :set_default_status

  enum status: { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :full_name, :dob, :phone, :address, :nationality, presence: true

  private

  def set_default_status
    self.status = 'pending'
  end
end
