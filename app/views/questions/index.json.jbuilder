json.array!(@questions) do |question|
  json.extract! question, :id, :text, :category_id, :creator_id, :published
  json.url question_url(question, format: :json)
end
