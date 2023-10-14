class User < ApplicationRecord
  has_many :workspaces
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'user_id'
  has_many :user_workspaces
  has_many :workspaces, through: :user_workspaces
  has_many :user_projects
  has_many :projects, through: :user_projects
  
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

  def self.exists_with_email?(email)
    where(email: email).exists?
  end

  def recipient_email_has_account?(email)
    user = User.find_by(email: email)
    return user.present?
  end
end
