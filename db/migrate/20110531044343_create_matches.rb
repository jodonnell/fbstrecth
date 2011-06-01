class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.references :user
      t.references :friend
      t.datetime :create_time
      t.boolean :active
      t.boolean :emailed

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
