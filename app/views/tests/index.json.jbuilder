json.array!(@tests) do |test|
  json.extract! test, :id, :testee_id, :start, :end
  json.url test_url(test, format: :json)
end
