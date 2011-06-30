class Match < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend

  def self.create_list user, friends, create_time
    user.matches.where(:active => true).each {|match| match.active = false; match.save!}
    friends.each do |friend|
      Match.create :user => user, :friend => friend, :create_time => create_time, :active => true, :emailed => false
    end
  end

  def self.matches user
    users = []
    user.active_list.each do |friend|
      potential_match_user = User.find_by_myself_friend_id friend
      users << potential_match_user if potential_match_user and potential_match_user.active_list.include? user.myself_friend
    end
    users
  end
end
