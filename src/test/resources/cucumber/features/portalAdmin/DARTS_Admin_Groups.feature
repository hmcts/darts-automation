@admin @admin_groups
Feature: Admin Groups



  @DMP-2299 @regression @TODO
  Scenario: Viewing Group Details
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Groups" navigation link
    Then I select "XHIBIT" from the dropdown
    And I click on the "Xhibit Group" link
    And I see "Xhibit Group" on the page
    And I see "-" on the page
    And I see "XHIBIT" on the page
    And I click on the "Remove" link
    Then I select "Swansea" from the dropdown
    And I press the "Add courthouse" button

  @DMP-2302 @regression @TODO
  Scenario: Edit a Group
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Groups" navigation link
    Then I select "XHIBIT" from the dropdown
    And I click on the "Group name" link
    And I press the "Edit group details" button
    #AC1 - Edit group details
    Then I see "Edit group" on the page
    And I see "Group details" on the page
    And I see "Group name" on the page
    And I see "Description" on the page
    And I see "Role" on the page
    And I see "Cannot be changed." on the page
    And I see "XHIBIT" on the page
    And I see the "Save changes" button
    #AC2 - Error Handling
    And I set "Group name" to "Xhibit Group"
    And I press the "Save changes" button
    And I see "There is a problem" on the page
    And I see "There is an existing group with this name" on the page

  @DMP-2305 @regression
  Scenario: Removing users from a group confirmation screen
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Groups" navigation link
    And I set "Filter by name" to "swansea"
    And I click on the "Swansea_ADMIN" link
    And I click on the "Users" sub-menu link
    And I check the checkbox in the same row as "darts.superuser@hmcts.net" "Active"
    And I press the "Remove users" button
    And I see "Are you sure you want to remove 1 user from this group?" on the page
    Then I press the "No - cancel" button

  @DMP-2303 @regression
  Scenario: Viewing group details - Users
    When I am logged on to the admin portal as an ADMIN user
    #AC1 - View users
    And I see "You can search for cases, hearings, events and audio." on the page
    And I click on the "Groups" navigation link
    And I set "Filter by name" to "swansea"
    And I click on the "Swansea_ADMIN" link
    And I click on the "Group users" link
    Then I do not see "darts.admin@hmcts.net" on the page

    #AC1 - Remove users
    When I set "Search for a user" to "Darts Admin (darts.admin@hmcts.net)"
    And I press the "Add user" button
    And I see "Darts Admin" in the same row as "darts.admin@hmcts.net"
    And I check the checkbox in the same row as "Darts Admin" "darts.admin@hmcts.net"
    And I press the "Remove users" button
    Then I see "Are you sure you want to remove 1 user from this group?" on the page

    When I press the "Yes - continue" button
    Then I see "1 user removed" on the page
    And I do not see "darts.admin@hmcts.net" on the page

  @DMP-2581 @regression @TODO
  Scenario: Viewing groups - Adding a user
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Groups" navigation link
    Then I select "XHIBIT" from the dropdown
    And I click on the "Xhibit Group" link
    And I see "Xhibit Group" on the page
    And I click on the "Xhibit Group" link
    Then I click on the "Group users" link
    And I see "Search for a user" on the page
    And I set "Search for a user" to "Darts Admin (darts.admin@hmcts.net)"
    And I click on the "Add user" link
    Then I see "Darts Admin" in the same row as "darts.admin@hmcts.net"

  @DMP-2317 @regression
  Scenario: Create a new group (Translation or Transcriber)
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Groups" navigation link
    And I press the "Create group" button
    #AC1 - Group Details
    And I see "Create group" on the page
    And I see "Group details" on the page
    And I see "Group name" on the page
    And I see "Description" on the page
    And I see "Role" on the page
    And I see "Transcriber" on the page
    And I see "Translation QA" on the page
    And I see the "Create group" button
    And I see "Cancel" on the page
    Then I press the "Create group" button
    #AC2 - Error Handling
    And I see "There is a problem" on the page
    And I see "Enter a group name" on the page
    And I see "Select a role" on the page
    And I see "Enter a group name" on the page
    And I see "Select a role" on the page
    Then I set "Group name" to "Cpp Group"
    And I set "Description" to "ttttttrfiehjuehnskrgvskgrhgsrilugrnsjurgilvsjrgnsjnurislrnhsierekrnhvsurivrugvsoigjrusrigri;hoireierguerihgurhgegueihgogeogirejrfjeofieofjerijfofergiejgoierjgierojgfigjieorjgioerjhgierhgiohgioerhgiohgigheohgierhgoehgieergrnbsgsgrlsgr.jslgs.ga.kenfkdjrgtnks"
    Then I press the "Create group" button
    And I see "There is an existing group with this name" on the page
    And I see "Description must be less than 256 characters" on the page

