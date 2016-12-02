class AddBloggerToUser < ActiveRecord::Migration
  def change
    add_column :users, :blogger, :boolean
  end
end
