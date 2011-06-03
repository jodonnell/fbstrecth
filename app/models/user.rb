class User < ActiveRecord::Base
  belongs_to :gender
  belongs_to :interested_in
  belongs_to :friends
  belongs_to :interested_in_local
  belongs_to :myself_friend

  def self.create_from_facebook fb_info, token
    friend = Friend.create(:fbid => fb_info.id, :name => fb_info.name, :gender => Gender.find_by_gender(fb_info.gender))
    create(:fbid => fb_info.id, :email => fb_info.email, :username => fb_info.username, :gender => Gender.find_by_gender(fb_info.gender), :access_token => token, :myself_friend => friend)
  end

  def update_from_facebook fb_info, token
    if fb_info.id != fbid and fb_info.email != email and fb_info.username != username and fb_info.gender != gender.gender and token != access_token
      self.fbid = fb_info.id
      self.email = fb_info.email
      self.username = fb_info.username
      self.gender.gender = fb_info.gender
      self.access_token = token
      save!
    end
  end
  
end
