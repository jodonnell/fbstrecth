Given /^a user$/ do
  Fixtures.create_fixtures("spec/fixtures", "genders")

  visit home_path
  begin
    fill_in 'email', :with => 'mssshimmers@gmail.com'
    fill_in 'pass', :with => 'bambam12'
    click_on 'Log In'
  rescue Capybara::ElementNotFound
  end
end

When /^I visit the show matches page$/ do
  visit show_matches_path
end

Then /^I see "([^"]*)" as one of my options$/ do |name| #"
  page.should have_content(name)
end

When /^I visit the show matches page and change to view men$/ do
  visit show_matches_path
  select('male', :from => 'interested_in_id')
  click_on('Change orientation')
end

When /^I visit the show matches page and choose Sally$/ do
  visit show_matches_path
  find("#friend_#{Fixtures.identify(:sally)}").click
  click_on 'Create List'
  save_and_open_page
end

Then /^I have created a match list with Sally$/ do
  Match.count.should == 1
end
