json.array!(@novelties) do |novelty|
  json.extract! novelty, :id, :title, :text, :published, :priority
  json.url novelty_url(novelty, format: :json)
end
