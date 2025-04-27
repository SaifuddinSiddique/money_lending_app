class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :loans

  enum role: { user: 'user', admin: 'admin' }

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end
end
