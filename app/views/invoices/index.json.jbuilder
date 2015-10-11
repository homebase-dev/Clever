json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :user_id, :amount, :message, :transaction_id, :transaction_code, :transaction_text, :success
  json.url invoice_url(invoice, format: :json)
end
