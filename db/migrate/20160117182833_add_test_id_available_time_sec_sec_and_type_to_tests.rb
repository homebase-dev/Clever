class AddTestIdAvailableTimeSecSecAndTypeToTests < ActiveRecord::Migration
  def change
    add_column :tests, :test_id, :integer
    add_index :tests, :test_id
    add_column :tests, :description, :string
    add_column :tests, :available_time_sec, :integer
    add_column :tests, :test_type, :integer, default: 0
  end
end
