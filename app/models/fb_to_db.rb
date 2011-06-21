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
      user = User.create_from_api(me, @access_token)
    else
      user.update_from_api(me, @access_token)
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
    friends_hash = remove_family friends_hash, user.families
    debugger
    friends = friends_hash.collect do |f|
      friend = Friend.find_by_fbid f.uid
      if !friend
        friend = Friend.create_from_api f
      else
        friend.update_from_api f
      end
      friend
    end

    user.friends = friends
    user.friends(true)
  end

  private
  def remove_family friends_hash, family
    family_fbids = family.collect {|f| f.fbid }
    friends_hash.select {|f| not family_fbids.include? f.uid }
  end
end
