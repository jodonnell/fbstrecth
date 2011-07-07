class Friend < ActiveRecord::Base
  has_many :users
  belongs_to :gender
  has_many :matches
  has_one :myself_friend, :class_name => "User"

  validates_presence_of :gender_id
  
  def self.create_from_api fb_info
    Friend.create :name => fb_info.name, :fbid => fb_info.uid, :gender => fb_info.gender, :profile_url => fb_info.profile_url, :pic => fb_info.pic, :square_pic => fb_info.pic_square,
    :location => fb_info.location, :birthday => fb_info.birthday, :relationship_status => fb_info.relationship_status
  end

  def update_from_api fb_info
    if fb_info.name != name or fb_info.profile_url != profile_url or fb_info.pic != pic or fb_info.gender != gender or fb_info.pic_square != square_pic or fb_info.location != location or fb_info.birthday != birthday or fb_info.relationship_status != relationship_status
      self.name = fb_info.name
      self.profile_url = fb_info.profile_url
      self.pic = pic
      self.gender = fb_info.gender
      self.square_pic = fb_info.pic_square
      self.location = fb_info.location
      self.birthday = fb_info.birthday
      self.relationship_status = fb_info.relationship_status
      save!
    end
  end

  def age
    return '??' if birthday.nil?
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end
  
end
