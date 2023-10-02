class WorkspaceSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :user_id
end
