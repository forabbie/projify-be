class InvitationMailer < ApplicationMailer
  def invitation_email(invitation, invitation_url, workspace_name)
    @invitation_url = invitation_url
    @workspace_name = workspace_name
    mail(to: invitation.recipient_email, subject: 'You have been invited to join a workspace')
  end
end
