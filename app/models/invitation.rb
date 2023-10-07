class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  def expired?
    Time.now >= expiration_time
  end

  private

  def expiration_time
    created_at + 1.day
  end
end
