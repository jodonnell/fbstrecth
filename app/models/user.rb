class User < ActiveRecord::Base
  belongs_to :gender
  belongs_to :interested_in, :class_name => "Gender"
  has_and_belongs_to_many :potentials
  belongs_to :interested_in_local, :class_name => "Gender"
  belongs_to :myself_potential, :class_name => "Potential"
  has_many :families
  has_many :matches

  validates_presence_of :gender_id
  
  def self.create_from_api fb_info, token
    potential = Potential.find_by_fbid(fb_info.id)
    potential = Potential.create(:fbid => fb_info.id, :name => fb_info.name, :gender => Gender.find_by_gender_or_get_none(fb_info.gender)) if !potential
    create(:fbid => fb_info.id, :email => fb_info.email, :username => fb_info.username, :gender => Gender.find_by_gender_or_get_none(fb_info.gender), :access_token => token, :myself_potential => potential)
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

  def interested_in_local_id
    return 0 if interested_in_local.nil?
    interested_in_local.id
  end

  def get_potential_matches
    match_gender = interested_in_local || interested_in || opposite_sex
    return potentials if match_gender == Gender.bisexual
    potentials.find_all_by_gender_id(match_gender.id)
  end

  def active_list
    active_matches = matches.where :active => true
    active_matches.collect {|match| match.potential}
  end

  def make_matches
    matches = Match.matches self
    matches.each do |match|
      message = MatchMailer.match self, match
      message.deliver
      message = MatchMailer.match match, self
      message.deliver
    end
  end

  def create_list potentials
    Match.create_list self, potentials, Time.now
  end
  
  private
  def opposite_sex
    return Gender.find_by_gender('female') if gender.gender == 'male'
    return Gender.find_by_gender('male')
  end
end
