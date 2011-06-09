class Friend < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :gender
  has_many :matches
end
