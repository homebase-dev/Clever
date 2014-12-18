json.array!(@assignations) do |assignation|
  json.extract! assignation, :id, :test_id, :question_id
  json.url assignation_url(assignation, format: :json)
end
