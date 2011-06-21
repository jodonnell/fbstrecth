class AddSquarePic < ActiveRecord::Migration
  def self.up
    add_column :friends, :square_pic, :string
  end

  def self.down
    remove_column :friends, :square_pic
  end
end
