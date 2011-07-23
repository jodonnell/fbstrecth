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

When /^I visit the show crushes page$/ do
  visit show_matches_path
end

Then /^I see "([^"]*)" as one of my options$/ do |name| #"
  page.should have_content(name)
end

When /^I visit the show crushes page and change to view "([^"]*)"$/ do |sex| #"
  visit show_matches_path
  select(sex, :from => 'interested_in_id')
  click_on('Change orientation')
end

When /^I visit the show crushes page and choose "([^"]*)"$/ do |name| "#"
  visit show_matches_path
  find("#potential_#{send(string_to_identifier(name)).id}").click
  click_on 'Create List'
end

When /^I logout and login as "([^"]*)"$/ do |arg1| #"
  pending # express the regexp above with the code you wish you had
end

When /^"([^"]*)" selects me$/ do |arg1| #"
  pending # express the regexp above with the code you wish you had
end

Then /^I have created a crush list with "([^"]*)"$/ do |arg1| #"
  Crush.count.should == 1
end

