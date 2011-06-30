class Match < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend

  def self.create_list user, friends, create_time
    user.active_list.each {|match| match.active = false; match.save!}
    friends.each do |friend|
      Match.create :user => user, :friend => friend, :create_time => create_time, :active => true, :emailed => false
    end
  end
end
