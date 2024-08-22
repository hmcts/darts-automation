Feature: Admin portal

  @DMP-724 @DMP-2222 @DMP-2225 @DMP-2224 @regression
  Scenario: Admin portal data creation - User 1
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
  #Create new user
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}001"
    And I set "Email" to "KH{{seq}}001@test.net"
    And I press the "Continue" button
    Then I see "Check user details" on the page
    When I press the "Create user" button
    Then I see "KH{{seq}}001" in the same row as "Full name"
    And I see "KH{{seq}}001@test.net" in the same row as "Email"


  @DMP-2340 @regression
  Scenario: Admin portal data creation - User 2 - Deactivated user
  #Login admin portal
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
  #Create new user
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}002"
    And I set "Email" to "KH{{seq}}002@test.net"
    And I press the "Continue" button
    Then I see "Check user details" on the page
    When I press the "Create user" button
    When I press the "Deactivate user" button
  #Deactivate user in database
#    Then I select column usr_id from table darts.user_account where user_email_address = "KH{{seq}}002@test.net"
#    Then I set table darts.user_account  column is_active to "false" where usr_id = "{{usr_id}}"

  @DMP-724 @regression
  Scenario: Update user personal detail
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
  #AC1 - Edit user screen
    When I click on the "Users" navigation link
    And I set "Full name" to "KH{{seq}}001"
    And I press the "Search" button
    And I click on "View" in the same row as "KH{{seq}}001"
    And I press the "Edit user" button
  #AC2 - Editing a user name
    And I set "Full name" to "automation_KH{{seq}}001"
  #AC3 - Editing a user email address
    And I set "Email" to "automation@KH{{seq}}001.net"
  #AC4 - Save changes
    And I press the "Save changes" button
    Then I see "Are you sure you want to change this user’s email address?" on the page
    When I press the "Yes - continue" button
    Then I see "User updated" on the page

  @DMP-2222 @regresion
  Scenario: Viewing a users groups
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
  #AC1 - Viewing user groups
    When I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    And I click on the "User Groups" link
  #AC3 - Removing user groups
    Then I see "Assign groups" on the page

  @DMP-2225 @regression
  Scenario: Assigning user groups
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
  #Viewing user groups
    When I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    And I click on the "User Groups" link
  #AC1 - Assigning user groups
    And I press the "Assign groups" button
    And I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
  #AC2 - Viewing groups that have been selected
    Then I see "1 groups selected" on the page
  #AC3 - Filter
    When I set "Filter by group name" to "Swansea"
    And I press the "Assign groups (1)" button

  @DMP-2224 @regression
  Scenario: Removing a group confirmation screen
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
  #Viewing user groups
    And I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    Then I click on the "User Groups" link
  #AC1 - Remove a group confirmation screen
    Then I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
    And I press the "Remove groups" button
    Then I see "Are you sure you want to remove automation_KH{{seq}}001 from this group?" on the page
  #AC2 - Removing a group
    Then I press the "Yes - continue" button
    Then I see "This user is not a member of any groups." on the page

  @DMP-635 @regression
  Scenario: Create a Courthouse Page
    Given I am logged on to the admin portal as an ADMIN user
      #AC1 - Creating a courthouse
    When I click on the "Courthouses" navigation link
    And I press the "Create new courthouse" button
    Then I see "Create courthouse" on the page
    And I see "Courthouse details" on the page
    And I see "Courthouse name" on the page
    And I see "Must be the same ID used on XHIBIT or CPP" on the page
    And I see "Display name" on the page
      #AC2 - Enter Courthouse Details
    Then I set "Courthouse name" to "Test Courthouse 635"
    And I set "Display name" to "Test Display Name 635"
    And I select the "Midlands" radio button
      #AC3 Add Transcription Company
    Then I see "Transcription companies" on the page
    And I see "Select transcription companies" on the page
    And I see "You can select and add multiple companies" on the page
    And I select "Swansea_Transcribers" from the dropdown
    And I press the "Add company" button
    Then I see "Swansea_Transcribers" in the same row as "Remove"
    And I click on the "Remove" link
    And I click on the "Cancel" link
      #AC4 - Error Handling
    And I press the "Create new courthouse" button
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see "Enter a courthouse code" on the page
    And I see "Enter a display name" on the page
    And I see "Select a region" on the page

  @DMP-2466 @TODO
  Scenario: Retention Policies primary page
    Given I am logged on to the admin portal as an ADMIN user
      #AC1 - View active polices
    And I click on the "System configuration" navigation link
    And I click on the "Retention policies" link
    And I see "Retention policies" on the page
    Then I verify the HTML table contains the following values
#TODO needs an alternative method to verify these rows exist but its ok for others to exist too
      | Name            | Description | Fixed policy key | Duration | Policy start | Policy end | *SKIP* |
#      | DARTS Permanent Retention v3 | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
#      | DARTS Standard Retention v3  | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Not Guilty      | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Non Custodial   | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Custodial       | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Default         | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Permanent       | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Manual          | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Life            | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |

      #AC 2 - View inactive polices
    And I click on the "Inactive" link
    Then I see "No data to display." on the page

  @DMP-2252 @regression
  Scenario: Edit a courthouse
    Given I am logged on to the admin portal as an ADMIN user
      #AC1 - Editing a courthouse
    Then I click on the "Courthouses" navigation link
    And I set "Courthouse name" to "Swansea"
    And I press the "Search" button
    And I click on "SWANSEA" in the same row as "Wales"
    And I press the "Edit courthouse" button
    And I see "Courthouse details" on the page
    And I see "Courthouse name" on the page
    And I see "There is data associated with this courthouse name. It cannot be changed." on the page
    And I see "Display name" on the page
    And I see "Transcription companies" on the page
    Then I press the "Continue" button

  @DMP-2263 @regression
  Scenario: Create a Courthouse Page - Check Details
    Given I am logged on to the admin portal as an ADMIN user
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

    #Delete courthouse for next run (can this be done? Don't see delete button for courthouses) - use seq instead

    #When I click on the "Courthouses" link
    #And I set "Courthouse name" to "Test Courthouse {{seq}}"
    #And I press the "Search" button
    #And I click on the "Test Courthouse {{seq}}" link
    #And I press the "Edit courthouse" button

  @DMP-1192 @regression
  Scenario: View Courthouse - Details Tab
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Courthouses" navigation link
    And I set "Courthouse name" to "Test Courthouse 1192"
    And I press the "Search" button
    And I click on "TEST COURTHOUSE 1192" in the same row as "Test Courthouse 1192"
    #AC1
    Then I see "Courthouse record" on the page
    And I see "Test Courthouse 1192" on the page
    And I see the "Edit courthouse" button
    And I see "Date created" on the page
    And I see "Tue 26 Mar 2024" on the page
    And I see "Last updated" on the page
    And I see "Thu 1 Aug 2024" on the page
    And I see "Details" on the page
    And I see link with text "Users"
    And I see "Details" on the page
    And I see "Database ID" in the same row as "1232"
    And I see "Courthouse name" in the same row as "Test Courthouse 1192"
    And I see "Region" in the same row as "Midlands"
    And I see "Groups" in the same row as "TEST_COURTHOUSE_APPROVER"
    And I see "Groups" in the same row as "TEST_COURTHOUSE_REQUESTER"
    And I see "Groups" in the same row as "LEEDS_DMP381_TRANSCRIBER"
    And I see "Details" on the page
    And I see "© Crown copyright" on the page

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

  @DMP-2263 @regression
  Scenario: Editing a courthouse - Check details
    When I am logged on to the admin portal as an ADMIN user
  #AC1- Review courthouse details
    And I click on the "Courthouses" link
    And I set "Courthouse name" to "Swansea"
    And I press the "Search" button
    And I click on "SWANSEA" in the same row as "Wales"
    And I press the "Edit courthouse" button
    And I press the "Continue" button
    Then I see "Check details" on the page
    Then I see "Check the courthouse name carefully, as it must exactly match the name on XHIBIT or CPP." on the page
  #AC2- Change courthouse details
    And I click on "Change" in the same row as "Display name"
    And I see "Courthouse details" on the page
    And I press the "Continue" button
    And I click on "Change" in the same row as "Region"
    And I see "Courthouse details" on the page
    And I press the "Continue" button
    And I click on "Change" in the same row as "Transcription companies"
    And I see "Courthouse details" on the page
    And I press the "Continue" button
  #AC3- Cancel courthouse edit
    Then I click on the "Cancel" link
  #AC4- Save changes
    And I press the "Edit courthouse" button
    And I press the "Continue" button
    Then I see "Update courthouse" on the page

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

  @DMP-2269 @regression
  Scenario: Search Courthouse
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "Courthouses" navigation link
    And I set "Courthouse name" to "Bristol"
    Then I press the "Search" button
    And I see "3 result" on the page
    And I verify the HTML table contains the following values
      | Courthouse name      | Display name         | Region     |
      | BRISTOL              | Bristol              | South West |
      | DMP-2163-BRISTOL-AAA | DMP-2163-Bristol-AAA |            |
      | DMP-2163-BRISTOL-AAB | DMP-2163-Bristol-AAB |            |
    Then I click on "Courthouse name" in the table header
    And I verify the HTML table contains the following values
      | Courthouse name      | Display name         | Region     |
      | DMP-2163-BRISTOL-AAB | DMP-2163-Bristol-AAB |            |
      | DMP-2163-BRISTOL-AAA | DMP-2163-Bristol-AAA |            |
      | BRISTOL              | Bristol              | South West |

    When I click on the "Clear search" link
    Then I set "Display name" to "Bristol"
    Then I press the "Search" button
    And I see "3 results" on the page
    And I verify the HTML table contains the following values
      | Courthouse name      | Display name         | Region     |
      | BRISTOL              | Bristol              | South West |
      | DMP-2163-BRISTOL-AAA | DMP-2163-Bristol-AAA |            |
      | DMP-2163-BRISTOL-AAB | DMP-2163-Bristol-AAB |            |
    Then I click on "Display name" in the table header
    And I verify the HTML table contains the following values
      | Courthouse name      | Display name         | Region     |
      | DMP-2163-BRISTOL-AAB | DMP-2163-Bristol-AAB |            |
      | DMP-2163-BRISTOL-AAA | DMP-2163-Bristol-AAA |            |
      | BRISTOL              | Bristol              | South West |

    When I click on the "Clear search" link
    Then I set "Region" to "London"
    Then I press the "Search" button
    And I see "31 results" on the page
    And I set "Courthouse name" to "guil"
    Then I press the "Search" button
    And I see "2 results" on the page
    And I verify the HTML table contains the following values
      | Courthouse name              | Display name                 | Region     |
      | GUILDFORD                    | GF Court                     | London     |
      | GUILDFORD CROWN COURT SITE B | Guildford Crown Court Site B | London     |
    When I click on the "Clear search" link
    Then I set "Region" to "London"
    And I set "Courthouse name" to "guil"
    Then I press the "Search" button
    And I see "4 results" on the page
    And I verify the HTML table contains the following values
      | Courthouse name               | Display name                 | Region |
      | GUILDFORD                     | GF Court                     | London |
      | GUILDFORD CROWN COURT SITE B  | Guildford Crown Court Site B | London |
      | THE CRIMINAL COURT, GUILDHALL | Swansea sitting at Guildhall | Wales  |
      | GUILDFORD COURT               | GF Court                     |        |
    Then I click on "Region" in the table header
    And I verify the HTML table contains the following values
      | Courthouse name               | Display name                 | Region |
      | GUILDFORD COURT               | GF Court                     |        |
      | GUILDFORD                     | GF Court                     | London |
      | GUILDFORD CROWN COURT SITE B  | Guildford Crown Court Site B | London |
      | THE CRIMINAL COURT, GUILDHALL | Swansea sitting at Guildhall | Wales  |
    Then I click on "Region" in the table header
    And I verify the HTML table contains the following values
      | Courthouse name               | Display name                 | Region |
      | THE CRIMINAL COURT, GUILDHALL | Swansea sitting at Guildhall | Wales  |
      | GUILDFORD CROWN COURT SITE B  | Guildford Crown Court Site B | London |
      | GUILDFORD                     | GF Court                     | London |
      | GUILDFORD COURT               | GF Court                     |        |
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

  @DMP-2714 @obsolete
  Scenario: Update admin portal navigation
    When I am logged on to the admin portal as an ADMIN user
  #AC1 - Updated nav
    And I see "Users" on the page
    And I see "Groups" on the page
    And I see "Courthouses" on the page
    And I see "Events" on the page
    And I see "Audio cache" on the page
    And I see "Transcripts" on the page
    And I see "File deletion" on the page
    And I see "System configuration" on the page
  #AC2 - File deletion tabs
    And I click on the "File deletion" navigation link
    And I see "File deletion" on the page
    And I see "Audio files" on the page
    And I see "Transcripts" on the page
  #AC3 - System configuration tabs
    And I click on the "System configuration" navigation link
    And I see "System configuration" on the page
    And I see "Retention policies" on the page
    And I see "Event mapping" on the page
    And I see "Automated tasks" on the page

    @DMP-2959 @review
    Scenario: Add error messaging to Search Transcripts screen
      Given I am logged on to the admin portal as an ADMIN user
      When I click on the "System configuration" link
      Then I see "Retention policies" on the page
      Then I click on "Create new version" in the same row as "DMP-2474-4 retention policy type."
      And I clear the "Display name" field
      And I set "Display name" to "DMP-2471-Display name-1" and click away
      Then I see "Enter a unique display name" on the page

      And  I clear the "Display name" field
      When I set "Display name" to "" and click away
      Then I see "Enter a display name" on the page

      And I clear the "Name" field
      When I set "Name" to "Test" and click away
      Then I see "Enter a unique name" on the page

      And I clear the "Name" field
      When I set "Name" to "" and click away
      Then I see "Enter a name" on the page

      And I clear the "Description" field
      When I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A" and click away
      Then I see "Enter a description shorter than 256 characters" on the page

      And I clear the "Description" field
      When I set "Years" to "00" and click away
      Then I see "Enter a duration of at least 1 day" on the page
      And I set "Months" to "01"
      When I set "Start date" to "{{date-10/}}"
      And I set "Hour" to "14"
      And I set "Minutes" to "20" and click away

      And I click on the "Create" link
      Then I see "Enter a policy start date in the future" on the page
      And I see "Enter a policy start time in the future" on the page

     Then I set "Display name" to "DMP-2474-Automation-1"
     And I set "Name" to "DMP-2474-Automation-1"
     And I set "Start date" to "{{date+0/}}"
     And I click on the "Create" link
     Then I see "Retention policy version created" on the page

    @DMP-2669 @DMP2668
    Scenario: Automated tasks- primary & details page
      #DMP-2668-AC1-AC2
      When I am logged on to the admin portal as an ADMIN user
      Then I click on the "System configuration" link
      And I click on the "Automated tasks" link
      And I see "Automated tasks" on the page
      And I see "ID" on the page
      And I see "Name" on the page
      And I see "Description" on the page
      And I see "Cron expression" on the page
      And I see "Status" on the page
      And I see "Run task" on the page
      And I press the "Run task" button in the same row as "ApplyRetention" "11"
      And I see "Task start request sent" on the page
      #DMP2669 AC1  View Automated tasks
      Then I click on the "1" link
      And I see "Automated task" on the page
      And I see "ProcessDailyList" on the page
      And I see "ID" on the page
      And I see "Name" on the page
      And I see "Description" on the page
      And I see "Cron expression" on the page
      And I see "Cron editable" on the page
      And I see "Date created" on the page
      And I see "Created by" on the page
      And I see "Date modified" on the page
      And I see "Modified by" on the page
      And I see "Run task" on the page
      And I see "Make inactive" on the page
      And I see "Active" on the page
      #AC2 Run task
      Then I press the "Run task" button
      And I see "Task start request sent" on the page
      #AC3 Disable task
      Then I press the "Make inactive" button
      And I see "Task 1 is inactive" on the page
      And I click on the "System configuration" link
      And I click on the "Automated tasks" link
      And I see "Inactive" in the same row as "ProcessDailyList" "1"
      #AC4 Reenable task
      And I click on the "1" link
      Then I press the "Make active" button
      And I see "Task 1 is active" on the page
      And I click on the "System configuration" link
      And I click on the "Automated tasks" link
      And I see "Active" in the same row as "ProcessDailyList" "1"
 
    Then I click on the "Transcripts" navigation link
    And I click on the "Advanced search" link
    Then I set "Hearing date" to "{{date+7/}}"
    And I set "Courthouse" to "Test"
    Then I see "You have selected a date in the future. Hearing date must be in the past" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "{{date+7/}}"
    And I set "Courthouse" to "Placeholder"
    Then I see "You have selected a date in the future. Requested date must be in the past" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "{{date+7/}}"
    And I set "Date to" to "{{date+7/}}"
    And I set "Courthouse" to "Test"
    Then I see "You have selected a date in the future. Requested start date must be in the past" on the page
    And I see "You have selected a date in the future. Requested end date must be in the past" on the page
    Then I set "Hearing date" to "ddd"
    And I set "Courthouse" to "Placeholder"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "ddd"
    And I set "Hearing date" to ""
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "ddd"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I set "Date to" to "ddd"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I set "Hearing date" to "30/02/2024"
    And I set "Courthouse" to "Test"
    Then I see "Enter a real date" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "30/02/2024"
    And I set "Hearing date" to ""
    Then I see "Enter a real date" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "30/02/2024"
    Then I see "Enter a real date" on the page
    Then I set "Date to" to "30/02/2024"
    Then I see "Enter a real date" on the page
    Then I set "Date from" to "30/03/2029"
    And I set "Date to" to "30/01/2029"
    Then I see "The start date must be before the end date" on the page
    And I see "The end date must be after the start date" on the page

  @DMP-2746 @DMP-2674 @regression
  Scenario: Add event mapping
    Given I am logged on to the admin portal as an ADMIN user
    And I see "You can search for cases, hearings, events and audio." on the page
    When I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    #DMP-2746-AC1 Create event mapping
    And I press the "Add event mapping" button
    And I set "Type" to "DMP-2746-Automation-Type {{seq}}"
    And I set "Event name" to "DMP-2746-Automation-Event-Name {{seq}}"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I check the "Tick if this event mapping has reporting restrictions" checkbox
    And I press the "Add mapping" button
    Then I see "Event mapping added" on the page

    #Cancel

    When I press the "Add event mapping" button
    And I set "Type" to "DMP-2746-Automation-Type-1"
    And I set "Event name" to "DMP-2746-Automation-Event-Name-1"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I click on the "Tick if this event mapping has reporting restrictions" link
    And I click on the "Cancel" link
    Then I see "Filter by type, subtype, or name" on the page
    And I see "Event mappings" on the page

    #DMP-2646-AC2 Error handling

    When I press the "Add event mapping" button
    And I set "Type" to "" and click away
    Then I see an error message "Enter the event type"

    When I set "Event name" to "" and click away
    Then I see an error message "Enter the event name"

    When I click on the "Tick if this event mapping has reporting restrictions" link
    And I press the "Add mapping" button
    Then I see an error message "Select an event handler to map to"

    #DMP-2674-AC1 Delete created event mapping for next run

    When I click on the "Cancel" link
    When I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type {{seq}}"
    And I click on "Change" in the same row as "DMP-2746-Automation-Type {{seq}}"
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I see "DMP-2746-Automation-Type {{seq}}" in the same row as "DMP-2746-Automation-Event-Name {{seq}}"

    When I press the "Yes - delete" button
    Then I see "Event mapping deleted" on the page

    When I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type {{seq}}"
    Then I see "There are no matching results." on the page

  @DMP-754 @regression
  Scenario: View event mapping
    Given I am logged on to the admin portal as an ADMIN user
    When I see "You can search for cases, hearings, events and audio." on the page
    And I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    And I see "Event mappings" on the page
    And I see "Add event mapping" on the page
    And I see "Filter by type, subtype, or name" on the page
    And I see "Filter by event handler" on the page
    And I select "Stop And Close Handler" from the "Filter by event handler" dropdown
    Then I see "Active only" on the page
    And I see "Active and inactive" on the page
    And I see "With restrictions" on the page
    And I see "Without restrictions" on the page
    And I verify the HTML table contains the following values
      | Type                   | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | 3000                   |          | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 30300                  |          | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 1000                   | 999      | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-2764-Accessibility | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When  I select the "Active and inactive" radio button
    And I click on the "With restrictions" link
    Then I verify the HTML table contains the following values
      | Type                   | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | 3000                   | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 30300                  | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-2764-Accessibility | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When I click on the "With restrictions" link
    And I click on the "Without restrictions" link
    Then I verify the HTML table contains the following values
      | Type | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | 1000 | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When I select "All" from the "Filter by event handler" dropdown
    And I click on the "Without restrictions" link
    And I see "Next" on the page
    And I click on the pagination link "Next"
    And I click on the pagination link "3"
    And I see "Next" on the page
    And I see "Previous" on the page
    And I click on the pagination link "Previous"
    And I click on the pagination link "1"
    And I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type2"
    And I select "Stop And Close Handler" from the "Filter by event handler" dropdown
    Then I see "There are no matching results." on the page

  @DMP-3028 @regression
  Scenario: Testing attempt to add identical event mapping
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    And I press the "Add event mapping" button
    And I click on the "Cancel" link
    Then I see "Filter by type, subtype, or name" on the page

    #DMP-3028-AC1 Type and subtype already in use (using already existing from DMP-2746 testing)

    When I press the "Add event mapping" button
    And I set "Type" to "DMP-2746_Type"
    And I set "Subtype (optional)" to "DMP-2746_Subtype"
    And I set "Event name" to "DMP3028TEST"
    And I select "Standard Event Handler" from the dropdown
    And I press the "Add mapping" button
    Then I see "Type and subtype already in use" on the page
    And I see "The combination of type and subtype you entered are already in use." on the page
    And I see "Choose a different combination or make changes to the existing mapping." on the page

    #DMP-3028-AC2 Go back link

    When I click on the "Go back" link
    Then I see "Tick if this event mapping has reporting restrictions" on the page

  @DMP-2763
  Scenario: Edit event mapping
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    #Error handling
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    Then I see "Event mapping" on the page
    And I see "AC2-DMP-2764-Deletion-Test-2" on the page
    And I see "AC2-DMP-2764-Deletion-Test-2" on the page
    And I see "AC1-DMP-2763" on the page
    And I clear the "Event name" field
    And I see "Map to event handler" on the page
    And I select "Dar Stop Handler" from the "Map to event handler" dropdown
    Then I see "Event name" on the page
    And I click on the "Cancel" link
    #Cancel
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    And I clear the "Event name" field
    And I set "Event name" to "AC1-DMP-2763"
    And I see "Map to event handler" on the page
    And I see "Dar Start Handler" on the page
    And I see "Yes" on the page
    And I see "07 Jun 2024" on the page
    And I see "Save as new version" on the page
    And I see "Cancel" on the page
    And I click on the "Cancel" link
    Then I see "System configuration" on the page
    #Create new version
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    And I set "Event name" to "AC1-DMP-2763"
    And I see "Dar Start Handler" on the page
    And I select "Dar Stop Handler" from the dropdown
    And I see "Yes" on the page
    And I see "07 Jun 2024" on the page
    And I press the "Save as new version" button
    Then I see "Saved new version of event mapping" on the page
    And I see "System configuration" on the page

  @DMP-2764
  Scenario: Delete event mapping
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "System configuration" link
    Then I click on the "Event mappings" navigation link
    And I click on the "Add event mapping" link
    Then I set "Type" to "DMP-2764-Automation-Type-3"
    And I set "Event name" to "DMP-2764-Automation-Event-Name"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I click on the "Tick if this event mapping has reporting restrictions" link
    And I click on the "Add mapping" link
    Then I see "Event mapping added " on the page
    And I set "Filter by type, subtype, or name" to "DMP-2764-Automation-Type-3"
    And I click on the "Change" link
    Then I see "Event mapping" on the page
    And I see "DMP-2764-Automation-Event-Name" on the page
    And I see "DMP-2764-Automation-Type-3" on the page
    And I see "DMP-2764-Automation-Event-Name" on the page
    And I see "Dar Start Handler" on the page
    And I see "Yes" on the page
    And I see "06 Jun 2024" on the page
    And I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I click on the "No - cancel" link
    Then I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I press the "Yes - delete" button
    Then I see "Event mapping deleted" on the page
    And I see "System configuration" on the page
    #AC2
    And I set "Filter by type, subtype, or name" to "Offences put to defendant"
    And I click on the "Change" link
    And I see "Offences put to defendant" on the page
    And I see "1000" on the page
    And I see "1001" on the page
    And I see "Offences put to defendant" on the page
    And I see "Standard Event Handler" on the page
    And I see "No" on the page
    And I see "02 Nov 2023" on the page
    And I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "You cannot delete this event mapping" on the page
    And I see "This event mapping has been used and can no longer be deleted." on the page
    And I see "You can make changes and create a new version, or you can select the event handler 'No mapping'." on the page
    And I see "Go back" on the page
    And I click on the "Go back" link
    Then I see "Offences put to defendant" on the page

    @DMP-1662 @review
    Scenario: Deletion Reasons
      When I am logged on to the admin portal as an ADMIN user
      And I click on the "Transcripts" link
      Then I click on the "Completed transcripts" link
      And I set "Case ID" to "DMP1600-case1"
      And I press the "Search" button
      Then I click on "761" in the same row as "Manual"
      And I see " Hide or delete " on the page
      And I press the " Hide or delete " button
      Then I press the "Hide or delete" button
      #Error Message
      And I see "Select a reason for hiding and/or deleting the file" on the page
      And I see "Enter a ticket reference" on the page
      And I see "Provide details relating to this action" on the page
      #Cancel
      And I see "Select a reason" on the page
      And I see " Other reason to hide only " on the page
      And I see " File will be hidden only " on the page
      And I check the " Other reason to hide only " checkbox
      And I set "Enter ticket reference" to "DMP1600"
      And I set "Comments" to "Test"
      And I click on the "Cancel" link
      #Hide file
      And I press the " Hide or delete " button
      And I see "Select a reason" on the page
      And I see " Other reason to hide only " on the page
      And I see " File will be hidden only " on the page
      And I select the "Other reason to hide only" radio button
      And I set "Enter ticket reference" to "DMP1600"
      And I set "Comments" to "Test" and click away
      Then I see "You have 252 characters remaining" on the page
      And I press the "Hide or delete" button
      Then I see " File(s) successfully hidden or marked for deletion " on the page
      And I see "Check for associated files" on the page
      And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
      Then I press the "Continue" button
      And I see "Important" on the page
      And I see "This file is hidden in DARTS" on the page

      @DMP-3247 @DMP-3382 @review
      Scenario: Transcription File Details Page
        When I am logged on to the admin portal as an ADMIN user
        And I click on the "Transcripts" link
        Then I click on the "Completed transcripts" link
        And I set "Case ID" to "C1216002"
        And I press the "Search" button
        #Basic details
        Then I click on the "Back" link
        And I see "Transcripts" on the page
        And I click on the "Completed transcripts" link
        And I set "Case ID" to "C1216002"
        And I press the "Search" button

        Then I see "Transcript file" on the page
        And I see "Basic details" on the page
        And I see "C1216002" in the same row as "Case ID"
        And I see "02 Apr 2024" in the same row as "Hearing date"
        And I see "Harrow Crown Court" in the same row as "Courthouse"
        And I see "1216-9" in the same row as "Courtroom"
        And I see "DefC 1216-9" in the same row as "Defendant(s)"
        And I see "Defendant(s)" in the same row as "Judge(s)"

        And I see "Request details" on the page
        And I see "Specified Times" in the same row as "Request type"
        And I see "23345" in the same row as "Request ID"
        And I see "Overnight" in the same row as "Urgency"
        And I see "Requester" in the same row as "Requested by"
        And I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
        And I see "Yes" in the same row as "Judge approval"
        #Advanced details
        Then I click on the "Advanced details" link
        And I see "Advanced details" on the page
        And I see "Transcription object ID" on the page
        And I see "Content object ID" on the page
        And I see "Clip ID" on the page
        And I see "cDc5hZaR35EMEvnA3XJDyQ==" in the same row as "Checksum"
        And I see "0.98MB" in the same row as "File size"
        And I see "application/msword" in the same row as "File type"
        And I see "file-sample_1MB.doc" in the same row as "Filename"
        And I see "02 Apr 2024 at 9:49:55AM" in the same row as "Date uploaded"
        And I see "Transcriber" in the same row as "Uploaded by"
        And I see "Transcriber" in the same row as "Last modified by"
        And I see "No" in the same row as "Transcription hidden?"
        And I see "" in the same row as "Hidden by"
        And I see "" in the same row as "Date hidden"
        And I see "" in the same row as "Retain until"
        And I see " Hide or delete " on the page
        And I press the " Hide or delete " button
        Then I press the "Hide or delete" button
      #Error Message
        And I see "Select a reason for hiding and/or deleting the file" on the page
        And I see "Enter a ticket reference" on the page
        And I see "Provide details relating to this action" on the page
      #Cancel
        And I see "Select a reason" on the page
        And I see " Other reason to hide only " on the page
        And I see " File will be hidden only " on the page
        And I check the " Other reason to hide only " checkbox
        And I set "Enter ticket reference" to "DMP1600"
        And I set "Comments" to "Test"
        And I click on the "Cancel" link
        #Hide file
        Then I press the " Hide or delete " button
        And I select the "Other reason to hide only" radio button
        And I set "Enter ticket reference" to "DMP1600"
        And I set "Comments" to "Test" and click away
        Then I see "You have 252 characters remaining" on the page
        And I press the "Hide or delete" button

        Then I see " File(s) successfully hidden or marked for deletion " on the page
        And I see "Check for associated files" on the page
        And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
        And I press the "Continue" button
        And I see "Important" on the page
        And I see "This file is hidden in DARTS" on the page
        And I see "DARTS users cannot view this file. You can unhide the file" on the page
        And I see "Hidden by - Darts Admin" on the page
        And I see "Reason - Other reason to hide only" on the page
        And I see "Test" on the page
        And I click on the "Advanced details" link
        And I see "Yes" in the same row as "Transcription hidden?"
        And I see "Unhide" on the page
        #Unhide file
        Then I press the "Unhide" button
        And I do not see "Important" on the page
        And I click on the "Advanced details" link
        And I see "No" in the same row as "Transcription hidden?"
        And I see " Hide or delete " on the page

    @DMP-3234
    Scenario: Add a link to "user portal" link to each admin portal screen
      When I am logged on to the admin portal as an ADMIN user
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "Users" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "Groups" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "Courthouses" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "Transformed media" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "Transcripts" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "File deletion" link
      Then I click on the "User portal" link
      And I press the "back" button on my browser
      And I click on the "System configuration" link
      Then I click on the "User portal" link

    @DMP-3235
    Scenario: Add a link to "Admin portal" to each DARTS portal screen
      When I am logged on to the admin portal as an ADMIN user
      Then I click on the "User portal" link
      Then I click on the "Admin portal" link
      Then I click on the "User portal" link
      Then I click on the "Your audio" link
      Then I click on the "Admin portal" link
      Then I click on the "User portal" link
      Then I click on the "Your transcripts" link
      Then I click on the "Admin portal" link

    @DMP-3129
    Scenario: Search Results - Cases
      When I am logged on to the admin portal as an ADMIN user
      #Filter by courthouse
      Then I set "Filter by courthouse" to "Swansea"
      Then I press the "Search" button
      Then I click on the "Hearings" link
      Then I click on the "Cases" link
      Then I refresh the page
      #Case ID
      Then I set "Case ID" to "CASE1009"
      Then I press the "Search" button
      Then I click on the "Hearings" link
      Then I click on the "Cases" link
      Then I refresh the page
      #Courtroom
      Then I set "Courtroom" to "ROOM_A"
      Then I press the "Search" button
      Then I click on the "Hearings" link
      Then I click on the "Cases" link
      Then I refresh the page
      #Hearing Date-Specific Date
      Then I select the "Specific date" radio button
      Then I set "Enter a date" to "03/07/2024"
      Then I press the "Search" button
      Then I click on the "Hearings" link
      Then I click on the "Cases" link
      Then I refresh the page
      #Hearing Date-Date Range
      Then I refresh the page
      Then I select the "Date range" radio button
      Then I set "Date from" to "02/07/2024"
      Then I set "Date to" to "03/07/2024"
      Then I press the "Search" button
      Then I click on the "Hearings" link
      Then I click on the "Cases" link

  @DMP-2728
  Scenario: Associated Audio files for deletion/hidden
    When I am logged on to the admin portal as an ADMIN user
    When I set "Case ID" to "CASE1009"
    Then I press the "Search" button
    Then I click on the "Audio" link
    Then I click on "Audio ID" in the table header
    Then I click on the "1313" link
    Then I press the "Hide or delete" button
    Then I select the "Other reason to hide only" radio button
    Then I set "Enter ticket reference" to "Test"
    Then I set "Comments" to "Test"
    Then I press the "Hide or delete" button
    Then I see "There are other audio files associated with the file you are hiding and/or deleting" on the page
    Then I press the "Continue" button
    Then I see "There is a problem" on the page