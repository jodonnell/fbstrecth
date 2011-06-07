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
  end
end