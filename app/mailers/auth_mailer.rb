class AuthMailer < ApplicationMailer
  def pending_email(user)
    @user = user
    mail( to: @user.email,
    subject: 'MarketMinder Account Pending Approval' )
  end

  def approval_email(user)
    @user = user
    mail( to: @user.email,
    subject: 'MarketMinder Account has been approved!' )
  end
end
