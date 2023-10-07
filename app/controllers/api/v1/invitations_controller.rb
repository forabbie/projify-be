class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_user!, only: [:sent_invitations]

  def validate_invitation
    invitee = params[:token]
    invitation = Invitation.find_by(token: params[:token])
  
    if invitation.nil?
      render json: { error: 'Invalid invitation token.' }, status: :unprocessable_entity
    elsif invitation.accepted?
      render json: { error: 'Invitation has already been accepted.' }, status: :unprocessable_entity
    elsif invitation.expired?
      render json: { error: 'Invitation has expired.' }, status: :unprocessable_entity
    else
      invitee = User.find_by(email: invitation.recipient_email)
  
      if invitee
        render json: { error: 'Already has an account.' }, status: :unprocessable_entity
      else
        render json: {
          message: 'Valid Invitation.',
          data: InvitationsSerializer.new(invitation).serializable_hash[:data][:attributes]
        }
      end
    end
  end

  def sent_invitations
    sent_invitations = Invitation.where(user_id: current_user.id)
    render json: {
      status: { code: 200, message: 'Sent invitations retrieve successfully.' },
      data: sent_invitations.map { |sent_invitation| InvitationsSerializer.new(sent_invitation).serializable_hash[:data][:attributes] }
    }
  end

  def send_invitation
    recipient_email = params[:invitation][:recipient_email]# Get the recipient's email from the request
    workspace = Workspace.find(params[:workspace_id])
  
    if workspace.user_workspaces.exists?(user_id: User.find_by(email: recipient_email))
      render json: { error: 'The invited user is already a member of the workspace.' }, status: :unprocessable_entity
      return
    end
  
    invitation = Invitation.new(invitation_params)
    invitation.workspace = workspace
    invitation.user = current_user
    invitation.token = SecureRandom.urlsafe_base64
  
    invitation.save
    # Determine the URL based on whether the recipient has an account
    if current_user.recipient_email_has_account?(recipient_email)
      # URL for users with accounts
      invitation_url = "http://localhost:5173/auth/invitation/accept?token=#{invitation.token}"
    else
      # URL for users who need to sign up first
      invitation_url = "http://localhost:5173/auth/invitation/signup?token=#{invitation.token}"
    end
    # Send an email with the invitation link
    InvitationMailer.invitation_email(invitation, invitation_url, workspace.name).deliver_now
  
    render json: { message: 'Invitation sent successfully.' }
  end    

  def accept_invitation
    invitation = Invitation.find_by(token: params[:token])
    invitee = User.find_by(email: invitation.recipient_email)

    if invitation && invitee
      invitation.update(accepted: true)
      UserWorkspace.create(workspace: invitation.workspace, user: invitee, role: 'member')
      render json: { message: 'Invitation accepted successfully.' }
    else
      render json: { error: 'Invalid invitation token or recipient email.' }, status: :unprocessable_entity
    end
  end

  def decline_invitation
    # Validate the token and update the accepted attribute
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      invitation.update(accepted: false)
      render json: { message: 'Invitation declined.' }
    else
      render json: { error: 'Invalid invitation token.' }, status: :unprocessable_entity
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end
  
end
