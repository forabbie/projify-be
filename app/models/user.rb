class User < ApplicationRecord
  has_many :workspace
  
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :jwt_authenticatable, jwt_revocation_strategy: self

  # def verify_password(password, password_confirmation)
  #   if password == password_confirmation
  #     self.password = password
  #   else
  #     errors.add(:password, "doesn't match")
  #     false
  #   end
  # end
end
