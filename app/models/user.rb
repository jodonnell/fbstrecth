class User < ActiveRecord::Base
  belongs_to :gender
  belongs_to :interested_in, :class_name => "Gender"
  has_and_belongs_to_many :friends
  belongs_to :interested_in_local, :class_name => "Gender"
  belongs_to :myself_friend, :class_name => "Friend"
  has_many :families
  has_many :matches

  validates_presence_of :gender_id
  
  def self.create_from_api fb_info, token
    friend = Friend.find_by_fbid(fb_info.id)
    friend = Friend.create(:fbid => fb_info.id, :name => fb_info.name, :gender => Gender.find_by_gender_or_get_none(fb_info.gender)) if !friend
    create(:fbid => fb_info.id, :email => fb_info.email, :username => fb_info.username, :gender => Gender.find_by_gender_or_get_none(fb_info.gender), :access_token => token, :myself_friend => friend)
  end

  def update_from_api fb_info, token
    if fb_info.id != fbid or fb_info.email != email or fb_info.username != username or fb_info.gender != gender.gender or token != access_token
      self.fbid = fb_info.id
      self.email = fb_info.email
      self.username = fb_info.username
      self.gender = Gender.find_by_gender_or_get_none(fb_info.gender)
      self.access_token = token
      save!
    end
  end

  def get_matches
    match_gender = interested_in_local || interested_in || opposite_sex
    return friends if match_gender == Gender.bisexual
    friends.find_all_by_gender_id(match_gender.id)
  end

  private
  def opposite_sex
    return Gender.find_by_gender('female') if gender.gender == 'male'
    return Gender.find_by_gender('male')
  end
end
