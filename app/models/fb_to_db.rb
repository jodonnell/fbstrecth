require 'facebook_api'

class FbToDb
  attr_writer :fb_api
  def initialize access_token
    @access_token = access_token
    @fb_api = FacebookAPI.new
  end

  def fb_to_db
    user = store_my_info
    store_family user
    store_friends user
  end

  def store_my_info
    me = @fb_api.get_my_info @access_token
    user = User.find_by_fbid(me.id)
    if !user
      user = User.create_from_facebook(me, @access_token)
    else
      user.update_from_facebook(me, @access_token)
    end
    user
  end

  def store_family user
    family = @fb_api.get_family_info @access_token, user
    family_friends = family.collect { |f| Family.create :fbid => f.uid }
    user.families = family_friends
    user.save!
  end

  def store_friends user
    friends_hash = @fb_api.get_my_friends_info @access_token
    friends_hash = remove_friends friends_hash, user.families

    friends = friends_hash.collect do |f|
      friend = Friend.find_by_fbid f.uid
      if !friend
        friend = Friend.create :name => f.name, :fbid => f.uid, :gender => Gender.find_by_gender(f.sex), :profile_url => f.profile_url, :pic => f.pic
      else
        friend.update_from_facebook f
      end
      friend
    end
    friends.each {|f| puts f.name; f.save!}
    user.friends = friends
    user.save!
    user.friends.each {|f| puts f.name}

  end

  private
  def remove_friends friends_hash, family
    family_fbids = family.collect {|f| f.fbid }
    friends_hash.select {|f| not family_fbids.include? f.uid }
  end
end
