Feature: Admin portal

  @DMP-724
  Scenario: Update user personal detail
    #Login admin
    Given I am logged on to DARTS as an ADMIN user
    #Create new user
    Given I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}001"
    Then I set "Email" to "KH{{seq}}001@test.net"
    And I press the "Continue" button
    And I see "Check user details" on the page
    Then I press the "Create user" button
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






