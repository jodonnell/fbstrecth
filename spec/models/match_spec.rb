require 'spec_helper'

describe Match do
  fixtures :genders
  fixtures :potentials
  fixtures :users

  it "needs to be able to create list" do
    Match.create_list users(:bob), [potentials(:fred), potentials(:sally)], Time.now
    users(:bob).active_list.length.should == 2
  end

  it "creates a list and unactivates the old one" do
    Match.create_list users(:bob), [potentials(:fred), potentials(:sally)], Time.now
    Match.create_list users(:bob), [potentials(:fred)], Time.now
    users(:bob).active_list.length.should == 1
  end

  it "can find matches" do
    Match.create_list users(:bob), [potentials(:sally)], Time.now
    Match.create_list users(:sally), [potentials(:bob)], Time.now
    Match.matches(users(:bob)).should include(users(:sally))
  end

  it "cannot have duplicates" do
    Match.create_list users(:bob), [potentials(:sally), potentials(:sally)], Time.now
    users(:bob).active_list.length.should == 1
  end

  it "has a limit" do
    Match.send(:max_list_size=, 1)
    expect {
      Match.create_list users(:bob), [potentials(:sally), potentials(:fred)], Time.now
    }.to raise_error(ListTooBigError)
  end

end
