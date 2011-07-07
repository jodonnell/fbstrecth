class AddLocationToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :location, :string
  end

  def self.down
    drop_column :friends, :location
  end
end
