json.array!(@question_contexts) do |question_context|
  json.extract! question_context, :id, :content, :category_id, :creator_id, :published
  json.url question_context_url(question_context, format: :json)
end
