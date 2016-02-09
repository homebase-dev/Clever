class RenameTesteeIdToUserIdInTests < ActiveRecord::Migration
  def change
    rename_column :tests, :testee_id, :user_id
  end
end
