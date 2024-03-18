Feature: Admin portal

  @DMP-724 @DMP-2222
  Scenario: Create user admin portal
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Create new user
    Given I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}001"
    Then I set "Email" to "KH{{seq}}001@test.net"
    And I press the "Continue" button
    And I see "Check user details" on the page
    Then I press the "Create user" button

  @DMP-724
  Scenario: Update user personal detail
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #AC1 - Edit user screen
    And I click on the "Users" navigation link
    And I set "Full name" to "KH{{seq}}001"
    And I press the "Search" button
    And I click on "View" in the same row as "KH{{seq}}001"
    Then I press the "Edit user" button
  #AC2 - Editing a user name
    Then I set "Full name" to "DMP_724_KH{{seq}}001"
  #AC3 - Editing a user email address
    Then I set "Email" to "DMP724Automation@KH{{seq}}001.net"
  #AC4 - Save changes
    Then I press the "Save changes" button
    And I see "Are you sure you want to change this user’s email address?" on the page
    And I press the "Yes - continue" button
    And I see "User updated" on the page

  @DMP-2222
  Scenario: Viewing a users groups
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #AC1 - Viewing user groups
    And I click on the "Users" navigation link
    And I set "Full name" to "DMP_724_KH{{seq}}00"
    And I press the "Search" button
    And I click on "View" in the same row as "DMP724Automation@KH{{seq}}001.net"
    Then I click on the "User Groups" link
  #AC2 - Assigning user groups
    Then I see "Remove groups" on the page
  #AC3 - Removing user groups
    Then I see "Assign groups" on the page

  @DMP-635
  Scenario: Create a Courthouse Page
    Given I am logged on to DARTS as an ADMIN user
      #AC1 - Creating a courthouse
    Then I click on the "Courthouses" navigation link
    And I press the "Create new courthouse" button
    Then I see "Create courthouse" on the page
    And I see "Courthouse details" on the page
    And I see "Courthouse name" on the page
    And I see "Must be the same ID used on XHIBIT or CPP" on the page
    And I see "Display name" on the page
      #AC2 - Enter Courthouse Details
    Then I set "Courthouse name" to "Test Courthouse"
    And I set "Display name" to "Test Display Name"
    And I select the "Midlands" radio button
      #AC3 Add Transcription Company
    Then I see "Transcription companies" on the page
    And I see "Select transcription companies" on the page
    And I see "You can select and add multiple companies" on the page
    And I select "DMP-626-LEEDS_JUDGE" from the dropdown
    And I press the "Add company" button
    Then I see "DMP-626-LEEDS_JUDGE" in the same row as "Remove"
    And I click on the "Remove" link
    And I click on the "Cancel" link
      #AC4 - Error Handling
    And I press the "Create new courthouse" button
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see "Enter a courthouse code" on the page
    And I see "Enter a display name" on the page
    And I see "Select a region" on the page
