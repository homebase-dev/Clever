json.array!(@answers) do |answer|
  json.extract! answer, :id, :text, :correct, :question_id, :creator_id, :published
  json.url answer_url(answer, format: :json)
end
