class Friend < ActiveRecord::Base
  has_many :users
  belongs_to :gender
  has_many :matches

  def update_from_facebook fb_info
    if fb_info.name != name or fb_info.profile_url != profile_url or fb_info.pic != pic or fb_info.gender != gender.gender
      self.name = fb_info.name
      self.profile_url = fb_info.profile_url
      self.pic = pic
      self.gender.gender = fb_info.gender
      save!
    end
  end

end
