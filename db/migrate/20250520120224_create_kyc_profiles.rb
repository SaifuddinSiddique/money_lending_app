class CreateKycProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :kyc_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.date :dob
      t.string :phone
      t.text :address
      t.string :nationality
      t.string :id_document
      t.string :selfie
      t.string :address_proof
      t.string :status

      t.timestamps
    end
  end
end
