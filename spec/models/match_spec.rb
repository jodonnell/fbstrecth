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

  it "cannot have duplicates" do
    Match.create_list users(:bob), [friends(:sally), friends(:sally)], Time.now
    users(:bob).active_list.length.should == 1
  end

  it "has a limit" do
    Match.send(:max_list_size=, 1)
    expect {
      Match.create_list users(:bob), [friends(:sally), friends(:fred)], Time.now
    }.to raise_error(ListTooBigError)
  end

end
