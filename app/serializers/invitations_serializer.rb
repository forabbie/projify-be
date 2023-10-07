class InvitationsSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :recipient_email, :accepted, :workspace_id, :token

  attribute :sent_date do |invitation|
    # invitation.created_at.strftime('%b. %d, %Y at %H:%M')
    invitation.created_at.strftime('%m-%d-%Y %H:%M')
  end
end
