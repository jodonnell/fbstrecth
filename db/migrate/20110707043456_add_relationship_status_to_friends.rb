class AddRelationshipStatusToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :relationship_status, :string
  end

  def self.down
    drop_column :friends, :relationship_status
  end
end
