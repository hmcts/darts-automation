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

  @DMO-2340
  Scenario: Admin portal data creation - User 2 - Deactivated user
  #Login admin portal
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

  @DMP-2340
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

  @DMP-2466
  Scenario: Retention Policies primary page
    Given I am logged on to DARTS as an ADMIN user
      #AC1 - View active polices
    And I click on the "Retention policies" navigation link
    And I see "Retention policies" on the page
    Then I verify the HTML table contains the following values
      | Name                         | Description | Fixed policy key | Duration | Policy start | Policy end | *SKIP* |
      | DARTS Permanent Retention v3 | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Standard Retention v3  | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Not Guilty Policy      | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Non Custodial Policy   | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Custodial Policy       | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Default Policy         | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Permanent Policy       | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Manual Policy          | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | DARTS Life Policy            | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |

      #AC 2 - View inactive polices
    And I click on the "Inactive" link
    Then I see "No data to display." on the page

  @DMP-2252
  Scenario: Edit a courthouse
    Given I am logged on to DARTS as an ADMIN user
      #AC1 - Editing a courthouse
    Then I click on the "Courthouses" navigation link
    And I set "Courthouse name" to "Swansea"
    And I press the "Search" button
    And I click on "Swansea" in the same row as "Wales"
    And I press the "Edit courthouse" button
    And I see "Courthouse details" on the page
    And I see "Courthouse name" on the page
    And I see "There is data associated with this courthouse name. It cannot be changed." on the page
    And I see "Display name" on the page
    And I see "Transcription companies" on the page
    Then I press the "Continue" button
    
  @DMP-2186 
  Scenario: Create a Courthouse Page - Check Details
    Given I am logged on to DARTS as an ADMIN user
    Then I click on the "Courthouses" navigation link
    And I press the "Create new courthouse" button
    Then I set "Courthouse name" to "Test Courthouse {{seq}}"
    And I set "Display name" to "Test Display Name {{seq}}"
    And I select the "Midlands" radio button
    And I select "Swansea_Transcribers" from the dropdown
    And I press the "Add company" button
    And I press the "Continue" button
    #AC1 - Review Courthouse Details
    Then I see "Create courthouse" on the page
    And I see "Back" on the page
    And I see "Check details" on the page
    And I see "Check the courthouse name carefully, as it must exactly match the name on XHIBIT or CPP." on the page
    And I see "Must be the same ID used on XHIBIT or CPP" on the page
    And I see "Display name" on the page
    And I see "Details" in the same row as "Change"
    And I see "Courthouse name" in the same row as "Test Courthouse {{seq}}"
    And I see "Display name" in the same row as "Test Display Name {{seq}}"
    And I see "Region" in the same row as "Midlands"
    And I see "Transcription companies" in the same row as "Swansea_Transcribers"
    And I see "Cancel" on the page
    And I see the "Create courthouse" button
    #AC2 - Change user details
    Then I click on the "Change" link
    Then I see "Test Courthouse {{seq}}" on the page
    And I see "Test Display Name {{seq}}" on the page
    And I see "Midlands" on the page
    And I see "Swansea_Transcribers" on the page
    #AC3 - Cancel Courthouse Creation
    And I press the "Continue" button
    Then I click on the "Cancel" link
    And I press the "Create new courthouse" button
    And I see "Create courthouse" on the page
    #AC4 - Creating a courthouse
    Then I set "Courthouse name" to "Test Courthouse {{seq}}"
    And I set "Display name" to "Test Display Name {{seq}}"
    And I select the "Midlands" radio button
    And I select "Swansea_Transcribers" from the dropdown
    And I press the "Add company" button
    And I press the "Continue" button
    And I press the "Create courthouse" button
    Then I see "Created Test Display Name {{seq}}" on the page
    And I see "© Crown copyright" on the page

  @DMP-1192
  Scenario: View Courthouse - Details Tab
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Courthouses" navigation link
    And I set "Courthouse name" to "Test Courthouse"
    And I press the "Search" button
    And I click on "Test Courthouse" in the same row as "Test Courthouse"
    #AC1
    Then I see "Courthouse record" on the page
    And I see "Test Courthouse" on the page
    And I see the "Edit courthouse" button
    And I see "Date created" on the page
    And I see "Tue 26 Mar 2024" on the page
    And I see "Last updated" on the page
    And I see "Tue 26 Mar 2024" on the page
    And I see "Details" on the page
    And I see "Users" on the page
    And I see "Details" on the page
    And I see "Database ID" in the same row as "26992"
    And I see "Courthouse name" in the same row as "Test Courthouse"
    And I see "Region" in the same row as "Midlands"
    And I see "Groups" in the same row as "TEST_COURTHOUSE_APPROVER"
    And I see "TEST_COURTHOUSE_REQUESTER" on the page
    And I see "LEEDS_DMP381_TRANSCRIBER" on the page
    And I see "Details" on the page
    And I see "© Crown copyright" on the page

@DMP-2299
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

  @DMP-2302
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
    And I see "There is an existing group with this name" on the page

  @DMP-2581
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

    @DMP-2269
    Scenario: Search Courthouse
      When I am logged on to the admin portal as an ADMIN user
     Then I click on the "Courthouses" navigation link
      And I set "Courthouse name" to "Bristol"
      Then I press the "Search" button
      And I see "3 result" on the page
      And I verify the HTML table contains the following values
      | Courthouse name       | Display name          | Region|
      | DMP-2163-Bristol-AAA  | DMP-2163-Bristol-AAA  |       |
      | Bristol               | Bristol               |       |
      | DMP-2163-Bristol-AAB  | DMP-2163-Bristol-AAB  |       |
      Then I click on "Courthouse name" in the table header
      And I verify the HTML table contains the following values
        | Courthouse name       | Display name          | Region|
        | DMP-2163-Bristol-AAB  | DMP-2163-Bristol-AAB  |       |
        | DMP-2163-Bristol-AAA  | DMP-2163-Bristol-AAA  |       |
        | Bristol               | Bristol               |       |

     When I click on the "Clear search" link
      Then I set "Display name" to "Bristol"
      Then I press the "Search" button
      And I see "3 result" on the page
      And I verify the HTML table contains the following values
        | Courthouse name       | Display name          | Region|
        | DMP-2163-Bristol-AAA  | DMP-2163-Bristol-AAA  |       |
        | Bristol               | Bristol               |       |
        | DMP-2163-Bristol-AAB  | DMP-2163-Bristol-AAB  |       |
      Then I click on "Display name" in the table header
      And I verify the HTML table contains the following values
        | Courthouse name       | Display name          | Region|
        | DMP-2163-Bristol-AAB  | DMP-2163-Bristol-AAB  |       |
        | DMP-2163-Bristol-AAA  | DMP-2163-Bristol-AAA  |       |
        | Bristol               | Bristol               |       |

      When I click on the "Clear search" link
      Then I set "Region" to "South East"
      Then I press the "Search" button
      And I see "2 result" on the page
      And I verify the HTML table contains the following values
        | Courthouse name            | Display name                | Region      |
        | Guildford Court            | GF Court                    | South East  |
        | DMP-2339-Update-Courthouse | DMP-2339-Update-DisplayName | South East  |
      Then I click on "Region" in the table header
      And I verify the HTML table contains the following values
        | Courthouse name       | Display name          | Region|
        | Guildford Court            | GF Court                    | South East  |
        | DMP-2339-Update-Courthouse | DMP-2339-Update-DisplayName | South East  |
      When I click on the "Clear search" link

      #AC2 Search Courthouse-No results
     When I set "Courthouse name" to "111"
      And I press the "Search" button
      Then I see "No search results" on the page
      And I see "No courthouses can be found with the search details provided. Review your search criteria and try again." on the page
      And I click on the "Clear search" link

      When I set "Display name" to "111"
      And I press the "Search" button
      Then I see "No search results" on the page
      And I see "No courthouses can be found with the search details provided. Review your search criteria and try again." on the page
      And I click on the "Clear search" link

      When I set "Region" to "111"
      And I press the "Search" button
      Then I see "No search results" on the page
      And I see "No courthouses can be found with the search details provided. Review your search criteria and try again." on the page
