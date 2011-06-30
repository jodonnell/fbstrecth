require 'spec_helper'

describe Match do
  fixtures :genders
  fixtures :friends
  fixtures :users

  it "needs to be able to create list" do
    Match.create_list users(:bob), [friends(:fred), friends(:sally)], Time.now
    users(:bob).active_list.length.should == 2
  end
end
