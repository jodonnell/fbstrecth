class RenameFriendsToPotentials < ActiveRecord::Migration
  def self.up
    rename_table :friends, :potentials
    rename_column :friends_users, :friend_id, :potential_id
    rename_table :friends_users, :potentials_users
    rename_column :matches, :friend_id, :potential_id
    rename_column :users, :friends_id, :potentials_id
    rename_column :users, :myself_friend_id, :myself_potential_id
  end

  def self.down
    rename_table :potentials, :friends                      
    rename_table  :potentials_users, :friends_users         
    rename_column :friends_users, :potential_id, :friend_id 
    rename_column :matches, :potential_id, :friend_id       
    rename_column :users, :potentials_id, :friends_id        
    rename_column :users, :myself_potential_id, :myself_friend_id
  end
end
