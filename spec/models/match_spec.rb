require 'spec_helper'

describe Match do
  fixtures :genders
  fixtures :friends
  fixtures :users

  it "needs to be able to create list" do
    Match.create_list users(:bob), [friends(:fred), friends(:sally)], Time.now
    users(:bob).active_list.length.should == 2
  end

  it "creates a list and unactivates the old one" do
    Match.create_list users(:bob), [friends(:fred), friends(:sally)], Time.now
    Match.create_list users(:bob), [friends(:fred)], Time.now
    users(:bob).active_list.length.should == 1
  end

  it "can find matches" do
    Match.create_list users(:bob), [friends(:sally)], Time.now
    Match.create_list users(:sally), [friends(:bob)], Time.now
    Match.matches(users(:bob)).should include(users(:sally))
  end
end
