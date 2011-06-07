require 'spec_helper'
require 'facebook_api'

describe "fb_to_db" do
  before(:each) do
    @fb_return = Hashie::Mash.new email: "jacobodonnell@gmail.com", first_name: "Jacob",
    gender: "male", id: "3800139", last_name: "O'Donnell", link: "http://www.facebook.com/jacobodonnell",
    locale: "en_US", location: (Hashie::Mash.new id:"108424279189115", name: "New York, New York"),
    name: "Jacob O'Donnell", timezone: -4, updated_time: "2011-05-18T01:35:55+0000", username:"jacobodonnell",
    verified: true
    
    @fb_to_db = FbToDb.new 'token'
    fb_double = stub('FacebookAPI')
    fb_double.stub(:get_my_info).and_return(@fb_return)
    @fb_to_db.fb_api = fb_double
    @user = @fb_to_db.store_my_info
  end

  it "stores my info to db on first use" do 
    @user.fbid.should == 3800139
    @user.myself_friend.id.should == 1
  end

  it "edits the user on subsequent logins when their data changes" do
    @user = @fb_to_db.store_my_info
    @user.gender.gender.should == 'male'
    @fb_return.gender = 'female'
    user = @fb_to_db.store_my_info
    user.gender.gender.should == 'female'
  end
  
end
