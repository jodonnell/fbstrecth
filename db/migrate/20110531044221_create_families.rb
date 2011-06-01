class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families do |t|
      t.column :fbid, :bigint
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :families
  end
end
