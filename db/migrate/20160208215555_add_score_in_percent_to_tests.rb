class AddScoreInPercentToTests < ActiveRecord::Migration
  def change
    add_column :tests, :userscore_percent, :decimal, precision: 5, scale: 2, default: nil
  end
end
