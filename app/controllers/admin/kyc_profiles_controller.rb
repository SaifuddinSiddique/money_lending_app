class Admin::KycProfilesController < ApplicationController
  before_action :authenticate_admin!  # You should implement admin authentication
  
  def index
    # List only pending KYC requests
    @kyc_profiles = KycProfile.where(status: :pending).includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def approve
    @kyc_profile = KycProfile.find(params[:id])
    if @kyc_profile.update(status: :approved)
      # Optionally, notify user by email here
      redirect_to admin_kyc_profiles_path, notice: "KYC approved."
    else
      redirect_to admin_kyc_profiles_path, alert: "Failed to approve KYC."
    end
  end

  def reject
    @kyc_profile = KycProfile.find(params[:id])
    if @kyc_profile.update(status: :rejected)
      # Optionally, notify user by email here
      redirect_to admin_kyc_profiles_path, notice: "KYC rejected."
    else
      redirect_to admin_kyc_profiles_path, alert: "Failed to reject KYC."
    end
  end
end
