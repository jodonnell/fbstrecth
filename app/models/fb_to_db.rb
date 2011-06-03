require 'facebook_api'

class FbToDb
  def initialize access_token
    @access_token = access_token
    @fb_api = FacebookAPI.new
  end

  def fb_to_db
    store_my_info
  end

  def store_my_info
    me = @fb_api.get_my_info @access_token
    debugger
    user = User.find_by_fbid(me.id)
    if !user
      User.create_from_facebook(me, @access_token)
    else
      user.update_from_facebook(me, @access_token)
    end
    user
  end
end
