class WorkspaceSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :user_id
end
