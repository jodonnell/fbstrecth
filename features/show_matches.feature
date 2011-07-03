Feature: Show Matches Feature

  So that I can find ladies to love
  As a dude looking to love
  I want to see woman to kiss

  Scenario: I see some women to select
  Given a user
  When I visit the show matches page
  Then I see "Jacob O'Donnell" as one of my options

  Scenario: I see some women to select but I want dudes
  Given a user
  When I visit the show matches page and change to view men
  Then I see "Fred" as one of my options

  Scenario: I see a special lady and want to save her
  Given a user
  When I visit the show matches page and choose Sally
  Then I have created a match list with Sally