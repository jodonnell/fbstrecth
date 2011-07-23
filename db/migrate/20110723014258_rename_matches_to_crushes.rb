class RenameMatchesToCrushes < ActiveRecord::Migration
  def self.up
    rename_table :matches, :crushes
  end

  def self.down
    rename_table :crushes, :matches
  end
end
