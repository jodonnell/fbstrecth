class AddBirthdayToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :birthday, :datetime
  end

  def self.down
    drop_column :friends, :birthday
  end
end
