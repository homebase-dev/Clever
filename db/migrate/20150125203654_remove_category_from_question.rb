class RemoveCategoryFromQuestion < ActiveRecord::Migration
  def change
    remove_reference :questions, :category, index: true
  end
end
