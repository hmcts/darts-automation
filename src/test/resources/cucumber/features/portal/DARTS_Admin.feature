Feature: Admin portal

  @DMP-724 @DMP-2222 @DMP-2225 @DMP-2224
  Scenario: Admin portal data creation - User 1
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Create new user
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}001"
    Then I set "Email" to "KH{{seq}}001@test.net"
    And I press the "Continue" button
    And I see "Check user details" on the page
    Then I press the "Create user" button

  @2340 @KH
  Scenario: Admin portal data creation - User 2 - Deactivated user
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Create new user
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}002"
    Then I set "Email" to "KH{{seq}}002@test.net"
    And I press the "Continue" button
    And I see "Check user details" on the page
    Then I press the "Create user" button
  #Deactivate user in database
    Then I select column usr_id from table darts.user_account where user_email_address = "KH{{seq}}002@test.net"
    Then I set table darts.user_account  column is_active to "false" where usr_id = "{{usr_id}}"

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
    Then I set "Full name" to "automation_KH{{seq}}001"
  #AC3 - Editing a user email address
    Then I set "Email" to "automation@KH{{seq}}001.net"
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
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    Then I click on the "User Groups" link
  #AC3 - Removing user groups
    Then I see "Assign groups" on the page

  @DMP-2225
  Scenario: Assigning user groups
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Viewing user groups
    And I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    Then I click on the "User Groups" link
  #AC1 - Assigning user groups
    And I press the "Assign groups" button
    Then I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
  #AC2 - Viewing groups that have been selected
    Then I see "1 groups selected" on the page
  #AC3 - Filter
    And I set "Filter by group name" to "Swansea"
    Then I press the "Assign groups (1)" button

  @DMP-2224
  Scenario: Removing a group confirmation screen
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Viewing user groups
    And I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    Then I click on the "User Groups" link
  #AC1 - Remove a group confirmation screen
    Then I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
    And I press the "Remove groups" button
    Then I see "Are you sure you want to remove automation_KH{{seq}}001 from these groups?" on the page
  #AC2 - Removing a group
    Then I press the "Yes - continue" button
    Then I see "This user is not a member of any groups." on the page

  @DMP-2340 @KH
  Scenario: Reactivate a user
  #Login admin
    Given I am logged on to DARTS as an ADMIN user
  #Viewing user groups
    And I click on the "Users" navigation link
    And I set "Email" to "KH{{seq}}002@test.net"
    And I select the "Inactive users" radio button
    And I press the "Search" button
    And I click on "View" in the same row as "KH{{seq}}002@test.net"
    Then I press the "Activate user" button
    Then I see "Reactivating this user will give them access to DARTS. They will not be able to see any data until they are added to at least one group." on the page
    Then I press the "Reactivate user" button
    Then I see "User record activated" on the page













