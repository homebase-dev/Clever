class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user, index: true
      t.decimal :amount, precision: 5, scale: 2
      t.string :message
      t.string :transaction_id
      t.string :transaction_code
      t.string :transaction_text
      t.boolean :success

      t.timestamps
    end
  end
end
