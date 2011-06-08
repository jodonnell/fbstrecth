class AddUserFriendsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :friends_users, :id => false do |t|
      t.integer :friend_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :friends_users
  end
end
