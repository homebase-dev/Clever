json.array!(@faqs) do |faq|
  json.extract! faq, :id, :title, :text, :published, :priority
  json.url faq_url(faq, format: :json)
end
