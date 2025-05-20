class KycProfilesController < ApplicationController
  before_action :authenticate_user!

  def new
    debugger
    @kyc_profile = current_user.build_kyc_profile
  end

  def create
    @kyc_profile = current_user.build_kyc_profile(kyc_profile_params)
    if @kyc_profile.save
      @kyc.update(status: "pending")
      redirect_to root_path, notice: "KYC submitted successfully."
    else
      render :new
    end
  end

  private

  def kyc_profile_params
    params.require(:kyc_profile).permit(
      :full_name, :dob, :phone, :address, :nationality,
      :id_document, :selfie, :address_proof
    )
  end
end
