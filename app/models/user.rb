class User < ActiveRecord::Base
  belongs_to :gender
  belongs_to :interested_in
  belongs_to :friends
  belongs_to :interested_in_local
  belongs_to :myself_friend
end
