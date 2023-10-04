class ProjectSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :details, :expected_completion_date, :workspace_id
end
