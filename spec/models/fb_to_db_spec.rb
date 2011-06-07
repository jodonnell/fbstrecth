require 'spec_helper'
require 'facebook_api'

describe "fb_to_db" do
  before(:each) do
    @fb_return_user = fb_api_return_user
    @fb_return_family = fb_api_return_family
    
    fb_double = stub_fb_api
    @fb_to_db = create_fb_to_db fb_double
    @user = @fb_to_db.store_my_info
  end

  it "stores my info to db on first use" do 
    @user.fbid.should == 3800139
    @user.myself_friend.id.should == 1
  end

  it "edits the user on subsequent logins when their data changes" do
    @user = @fb_to_db.store_my_info
    @user.gender.gender.should == 'male'
    @fb_return_user.gender = 'female'
    user = @fb_to_db.store_my_info
    user.gender.gender.should == 'female'
  end

  it "stores the family information" do
    @fb_to_db.store_family @user
    @user.families[0].fbid.should == 1
  end

  it "removes old family" do
    @fb_to_db.store_family @user

    @fb_return_family[0].uid = '2'
    @fb_to_db.store_family @user
    @user.families[0].fbid.should == 2
    @user.families.length.should == 1
  end

  it "adds friends" do
    pending
    @fb_to_db.store_friends @user
    @user.friends.length.should = 10
  end

  private
  def stub_fb_api
    fb_double = stub('FacebookAPI')
    fb_double.stub(:get_my_info).and_return(@fb_return_user)
    fb_double.stub(:get_family_info).and_return(@fb_return_family)
    fb_double
  end

  def create_fb_to_db fb_double
    fb_to_db = FbToDb.new 'token'
    fb_to_db.fb_api = fb_double
    fb_to_db
  end

  def fb_api_return_user
    Hashie::Mash.new email: "jacobodonnell@gmail.com", first_name: "Jacob",
    gender: "male", id: "3800139", last_name: "O'Donnell", link: "http://www.facebook.com/jacobodonnell",
    locale: "en_US", location: (Hashie::Mash.new id:"108424279189115", name: "New York, New York"),
    name: "Jacob O'Donnell", timezone: -4, updated_time: "2011-05-18T01:35:55+0000", username:"jacobodonnell",
    verified: true
  end

  def fb_api_return_family
    [Hashie::Mash.new(uid: "1")]
  end
end
