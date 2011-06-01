class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.column :fbid, :bigint
      t.string :name
      t.string :pic
      t.references :gender
      t.string :profile_url

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
