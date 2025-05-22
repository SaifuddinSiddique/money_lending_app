class KycProfile < ApplicationRecord
  belongs_to :user

  has_one_attached :id_document
  has_one_attached :selfie
  has_one_attached :address_proof

  enum status: { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :full_name, :dob, :phone, :address, :nationality, presence: true
end
