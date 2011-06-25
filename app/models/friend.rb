class Friend < ActiveRecord::Base
  has_many :users
  belongs_to :gender
  has_many :matches

  validates_presence_of :gender_id
  
  def self.create_from_api fb_info
    Friend.create :name => fb_info.name, :fbid => fb_info.uid, :gender => Gender.find_by_gender_or_get_none(fb_info.sex), :profile_url => fb_info.profile_url, :pic => fb_info.pic, :square_pic => fb_info.pic_square
  end

  def update_from_api fb_info
    if fb_info.name != name or fb_info.profile_url != profile_url or fb_info.pic != pic or fb_info.sex != gender.gender or fb_info.pic_square != square_pic
      self.name = fb_info.name
      self.profile_url = fb_info.profile_url
      self.pic = pic
      self.gender = Gender.find_by_gender_or_get_none fb_info.sex
      self.square_pic = fb_info.pic_square
      save!
    end
  end

end
