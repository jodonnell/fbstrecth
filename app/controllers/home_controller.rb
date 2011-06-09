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

  def show_matches
    @user = User.find_by_access_token session[:access_token]
  end

  def submit_matches
    user = User.find_by_access_token session[:access_token]
    params(:matches).each do
#      user.matches = 
    end
    redirect_to :action => :show_matches
  end
end
