class CreateBlogEntries < ActiveRecord::Migration
  def change
    create_table :blog_entries do |t|
      t.string :title
      t.text :text
      t.boolean :published
      t.references :user, index: true

      t.timestamps
    end
  end
end
