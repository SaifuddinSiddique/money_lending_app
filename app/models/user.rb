class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :loans
  after_create :initialize_wallet_balance

  enum role: { user: 'user', admin: 'admin' }

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  private

  def initialize_wallet_balance
    if admin?
      update_column(:wallet_balance, 10_00_000) # 10 lakh rupees
    else
      update_column(:wallet_balance, 10_000) # 10 thousand rupees
    end
  end
end
