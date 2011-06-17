require 'spec_helper'
require 'facebook_api'

describe "fb_to_db" do
  before(:each) do
    @fb_return_user = fb_api_return_user
    @fb_return_family = fb_api_return_family
    @fb_return_friends = fb_api_return_friends
    
    fb_double = stub_fb_api
    @fb_to_db = create_fb_to_db fb_double
    @user = @fb_to_db.store_my_info
  end

  describe "my information is stored correctly" do
    it "stores my info to db on first use" do 
      @user.fbid.should == 3800139
      @user.myself_friend.id.should == 1
    end

    it "edits the user on subsequent logins when their data changes" do
      @user.gender.gender.should == 'male'

      @fb_return_user.gender = 'female'
      user = @fb_to_db.store_my_info
      user.gender.gender.should == 'female'
    end
  end
    
  describe "family information is stored correctly" do
    it "stores the family information" do
      @fb_to_db.store_family @user
      @user.families[0].fbid.should == 1700652
    end

    it "removes old family" do
      @fb_to_db.store_family @user

      @fb_return_family[0].uid = '2'
      @fb_to_db.store_family @user
      @user.families[0].fbid.should == 2
      @user.families.length.should == 1
    end
  end
    
  describe "friend information is stored correctly" do
    it "creates new friends" do
      @fb_to_db.store_friends @user
      @user.friends.length.should == 10
    end

    it "does not add family to your friends" do 
      @fb_to_db.store_family @user
      @fb_to_db.store_friends @user

      @user.friends.should_not include(Friend.find_by_fbid 1700652)
    end

    it "removes old friends" do
      @fb_to_db.store_friends @user
      @fb_return_friends.pop

      @fb_to_db.store_friends @user
      @user.friends.length.should == 9
    end

    it "can accept a nil gender" do
      @fb_return_friends[0].sex = ''
      @fb_to_db.store_friends @user
    end
    
    it "edits friends data on subsequent logins" do
      @fb_to_db.store_friends @user
      @fb_return_friends[0].name = 'Poop McBucket'

      @fb_to_db.store_friends @user
      @user.friends[0].name.should == 'Poop McBucket'

      Friend.count.should == 11
    end
  end
    
  
  private
  def stub_fb_api
    fb_double = stub('FacebookAPI')
    fb_double.stub(:get_my_info).and_return(@fb_return_user)
    fb_double.stub(:get_family_info).and_return(@fb_return_family)
    fb_double.stub(:get_my_friends_info).and_return(@fb_return_friends)
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
    [Hashie::Mash.new(uid: "1700652")]
  end

  def fb_api_return_friends
    [Hashie::Mash.new(uid:108154,name:"Juan Gutierrez",profile_url:"http:\/\/www.facebook.com\/profile.php?id=108154",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/27411_108154_6390_s.jpg",sex:"male"),
     Hashie::Mash.new(uid:405604,name:"Audrey Rasizer",profile_url:"http:\/\/www.facebook.com\/AudreyR",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/23069_405604_5776_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:906043,name:"Sarah Templeton",profile_url:"http:\/\/www.facebook.com\/profile.php?id=906043",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/202847_906043_6781830_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:929899,name:"Abby Garner",profile_url:"http:\/\/www.facebook.com\/profile.php?id=929899",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/49300_929899_8628_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:1301222,name:"Andrew Herbert",profile_url:"http:\/\/www.facebook.com\/profile.php?id=1301222",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/41633_1301222_9411_s.jpg",sex:"male"),
     Hashie::Mash.new(uid:1408582,name:"Alexa Baz",profile_url:"http:\/\/www.facebook.com\/profile.php?id=1408582",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/187089_1408582_5635254_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:1700652,name:"Lil O'Donnell",profile_url:"http:\/\/www.facebook.com\/lilod",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/186506_1700652_609825_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:1700812,name:"Brady Messmer",profile_url:"http:\/\/www.facebook.com\/profile.php?id=1700812",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/202845_1700812_8086425_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:2419802,name:"Katherine Don",profile_url:"http:\/\/www.facebook.com\/profile.php?id=2419802",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/195514_2419802_8781_s.jpg",sex:"female"),
     Hashie::Mash.new(uid:2517719,name:"Jen",profile_url:"http:\/\/www.facebook.com\/jenhwang",pic:"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-snc4\/41427_2517719_3166_s.jpg",sex:"female")]
  end
end
