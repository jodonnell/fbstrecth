class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :fbid, :bigint
      t.string :email
      t.string :username
      t.references :gender
      t.references :interested_in
      t.string :access_token
      t.references :friends
      t.references :interested_in_local
      t.references :myself_friend

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
