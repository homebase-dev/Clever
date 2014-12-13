json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :name, :description, :creator_id, :published
  json.url quiz_url(quiz, format: :json)
end
