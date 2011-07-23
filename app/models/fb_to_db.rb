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
    store_potentials user
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
    family_potentials = family.collect { |f| Family.create :fbid => f.uid }
    user.families = family_potentials
    user.save!
  end

  def store_potentials user
    potentials_hash = @fb_api.get_my_friends_info @access_token
    potentials_hash = remove_family potentials_hash, user.families

    potentials = potentials_hash.collect do |f|
      potential = Potential.find_by_fbid f.uid
      if !potential
        potential = Potential.create_from_api f
      else
        potential.update_from_api f
      end
      potential
    end

    user.potentials = potentials
    user.potentials(true)
  end

  private
  def remove_family potentials_hash, family
    family_fbids = family.collect {|f| f.fbid }
    potentials_hash.select {|f| not family_fbids.include? f.uid }
  end
end
