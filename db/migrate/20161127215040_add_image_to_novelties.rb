class AddImageToNovelties < ActiveRecord::Migration
  def change
    add_column :novelties, :image, :string
  end
end
