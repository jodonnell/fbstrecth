require 'facebook_api'

class HomeController < ApplicationController
  def index
    fb_api = FacebookAPI.new
    redirect_to fb_api.get_login_link
  end

  def login
    fb_api = FacebookAPI.new
    session[:access_token] = fb_api.get_access_token params[:code]

    fb_to_db = FbToDb.new session[:access_token]
    fb_to_db.fb_to_db

    redirect_to :action => :show_matches
  end

  def local
    raise if Rails.env != 'development'

    user = User.find_by_username "jacobodonnell"
    session[:access_token] = user.access_token

    redirect_to :action => :show_matches
  end

  def show_matches
    user = User.find_by_access_token session[:access_token]
    set_interested_in(user) unless params[:interested_in_id].nil?

    @potential_matches = user.get_potential_crushes
    @current_orientation = user.interested_in_local_id
    @current_list = user.active_list
  end

  def submit_list
    user = User.find_by_access_token session[:access_token]
    return redirect_to :action => :show_matches if params[:ids].blank?

    potentials = params[:ids].collect do |potential_id|
      id = potential_id.sub /potential_/, ''
      Potential.find id
    end
    
    user.create_list potentials
    user.make_matches
    
    redirect_to :action => :show_matches
  end

  def set_interested_in user
    user.interested_in_local = Gender.find params[:interested_in_id]
    user.save!
  end
end
