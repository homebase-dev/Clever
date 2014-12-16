json.array!(@categories) do |category|
  json.extract! category, :id, :name, :description, :creator_id, :quiz_id, :published
  json.url category_url(category, format: :json)
end
