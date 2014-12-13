class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title
      t.text :text
      t.boolean :published
      t.integer :priority

      t.timestamps
    end
  end
end
