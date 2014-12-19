json.array!(@checks) do |check|
  json.extract! check, :id, :assignation_id, :answer_id
  json.url check_url(check, format: :json)
end
