@admin @admin_users
Feature: Admin-Users

  @DMP-2323 @regression
  Scenario: Admin change transcription status data creation
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors             | defenders             |
      | Harrow Crown Court | {{seq}}-46 | H{{seq}}001 | DefH {{seq}}-46 | JudgeH {{seq}}-46 | testprosecutorfourtysix | testdefenderfourtysix |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}052 | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{seq}}ABC-46 | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}053 | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{seq}}GHI-46 | {{timestamp-10:31:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
      | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1.mp2 |


  @DMP-634 @regression
  Scenario: Verify screen contents - Search for Users
    Given I am logged on to the admin portal as an ADMIN user
    Then I do not see "Search for user" on the page
    When I click on the "Users" link
    Then I see "Search for user" on the page
    Then I see "Full name" on the page
    And I see "Email" on the page
    And I see "Active users" on the page
    And I see "Inactive users" on the page
    And I see "All" on the page

  @DMP-2178 @DMP-630-AC1-AC2 @regression
  Scenario Outline: New user account - Check user details
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
    Then I see "Search for user" on the page
    When I press the "Create new user" button
    Then I see "Create user" on the page
    And I see "Enter user details" on the page
    When I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    #AC1 Review User Details
    Then I see "Check user details" on the page
    And I see "Details" on the page
    And I see "Full name" in the same row as "<Full name>"
    And I see "Email" in the same row as "<Email>"
    And I see "Description (optional)" in the same row as "<Description>"

    #AC2 Change User Details
    When I click on the "Change" link
    Then "Full name" is "<Full name>"
    And "Email" is "<Email>"
    And "Description (optional)" is "<Description>"
    When I set "Full name" to "Test User Change"
    And I set "Email" to "testchange@test.com"
    And I set "Description (optional)" to "Test Change"
    And I press the "Continue" button
    #AC3 Cancel User Creation
    And I click on the "Cancel" link
    And I press the "Create new user" button
    #AC4 Create a User
    And I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    And I press the "Create user" button
    Then I see "User record has been created for <Full name>" on the page

		Then I see table darts.user_account column user_name is "<Full name>" where user_email_address = "<Email>"
		Then I see table darts.user_account column description is "<Description>" where user_email_address = "<Email>"
		Then I see table darts.user_account column user_name is "<Full name>" where user_email_address = "<Email>"
		Then I see table darts.user_account column is_active is "t" where user_email_address = "<Email>"

    Examples:
      | Full name  | Email                       | Description |
      | Joe Bloggs | darts.test{{seq}}@hmcts.net | Test        |

  @DMP-630 @regression
  Scenario Outline: Create a new user account with existing email address
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
    Then I see "Search for user" on the page
    When I press the "Create new user" button
    Then I see "Create user" on the page
    And I see "Enter user details" on the page
    And I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    And I see an error message "<ErrorMessage>"
#    And I see "<Field>" on the page
#    And I see an error message "<ErrorMessage>"
    Examples:
      | Full name    | Email                 | Description | ErrorMessage                                                        |
      | global_judge | darts.judge@hmcts.net |             | Enter a unique email address                                        |
      | global_judge | darts.judge           |             | Enter an email address in the correct format, like name@example.com |
      |              | darts.judge@hmct.net  |             | Enter a full name                                                   |
      | Test         |                       |             | Enter an email address                                              |
      | Test         | Test999@hmcts.net     | Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis,.| Enter a description shorter than 256 characters |

  @DMP-724 @DMP-2222 @DMP-2225 @DMP-2224 @regression
  Scenario: Create Users
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
  #Create new user 1
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}001"
    And I set "Email" to "KH{{seq}}001@test.net"
    And I press the "Continue" button
    Then I see "Check user details" on the page
    When I press the "Create user" button
    Then I see "KH{{seq}}001" in the same row as "Full name"
    And I see "KH{{seq}}001@test.net" in the same row as "Email"
    When I click on the "Users" link
  #Create new user 2
    And I press the "Create new user" button
    And I set "Full name" to "KH{{seq}}002"
    And I set "Email" to "KH{{seq}}002@test.net"
    And I press the "Continue" button
    Then I see "Check user details" on the page
    When I press the "Create user" button
    Then I see table darts.user_account column user_name is "KH{{seq}}002" where user_email_address = "KH{{seq}}002@test.net"
    And I see table darts.user_account column user_full_name is "KH{{seq}}002" where user_email_address = "KH{{seq}}002@test.net"
    And I see table darts.user_account column is_active is "t" where user_email_address = "KH{{seq}}002@test.net"
  #Deactivate user 2
    When I press the "Deactivate user" button
    Then I see "Deactivating this user will remove their access to DARTS." on the page
    When I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see table darts.user_account column is_active is "f" where user_email_address = "KH{{seq}}002@test.net"

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
    And I click on the "Groups" link
  #AC3 - Removing user groups
    Then I see "Assign groups" on the page

  @DMP-2225 @regression @review
  Scenario: Assigning user groups
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
  #Viewing user groups
    When I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    And I click on the "Groups" link
  #AC1 - Assigning user groups
    And I press the "Assign groups" button
    And I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
  #AC2 - Viewing groups that have been selected
    Then I see "1 groups selected" on the page
  #AC3 - Filter
    When I set "Filter by group name" to "Swansea"
    And I press the "Assign groups (1)" button
    Then I see "Assigned 1 group" on the page
    And I see "Approver" in the same row as "Swansea_APPROVER"

  @DMP-2224 @regression @review
  Scenario: Removing a group confirmation screen
  #Login admin
    Given I am logged on to the admin portal as an ADMIN user
  #Viewing user groups
    And I click on the "Users" navigation link
    And I set "Email" to "automation@KH{{seq}}001.net"
    And I press the "Search" button
    And I click on "View" in the same row as "automation@KH{{seq}}001.net"
    Then I click on the "Groups" link
  #AC1 - Remove a group confirmation screen
    Then I check the checkbox in the same row as "Swansea_APPROVER" "Approver"
    And I press the "Remove groups" button
    Then I see "Are you sure you want to remove automation_KH{{seq}}001 from this group?" on the page
  #AC2 - Removing a group
    Then I press the "Yes - continue" button
    Then I see "This user is not a member of any groups." on the page

  @DMP-2323 @DMP-2340 @regression
  Scenario: Deactivate user and last user in group
    Given I am logged on to the admin portal as an ADMIN user
    Given I reactivate user "Testuserone"
    Given I reactivate user "Testusertwo"
    Given I reactivate user "Testuserthree"
    Given I add user "Testuserone" to group "Testgroupone"
    Given I add user "Testusertwo" to group "Testgroupone"

    #DMP-2323-AC1 Deactivate user

    When I click on the "Users" link
    And I set "Full name" to "Testuserone"
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserone"
    Then I see "Active user" on the page
    When I press the "Deactivate user" button
    Then I see "Deactivating this user will remove their access to DARTS." on the page
    And I see "Testuserone" on the page

    When I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see "Inactive" on the page
		And I see table darts.user_account column is_active is "f" where user_name = "Testuserone"
		And I see table USER_GROUP column group_name is "null" where user_name = "Testuserone"

    #DMP-2323-AC2 Deactivate last user in group

    When I click on the "Users" link
    And I set "Full name" to "Testusertwo"
    And I press the "Search" button
    And I click on "View" in the same row as "Testusertwo"
    And I see "Active user" on the page
    And I press the "Deactivate user" button
    Then I see "Deactivating this user will remove their access to DARTS." on the page
    And I see "This is the only active user in this group. Deactivating this user will result in no active users in this group." on the page
    And I see "Testusertwo" on the page

    When I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see "Inactive" on the page
		And I see table darts.user_account column is_active is "f" where user_name = "Testusertwo"
		And I see table USER_GROUP column group_name is "null" where user_name = "Testusertwo"

    #Reactivate users and assign group for next run
    #DMP-2340-AC1 and AC2 Activate user button and reactivate user confirmation

    When I press the "Activate user" button
    Then I see "Reactivating this user will give them access to DARTS. They will not be able to see any data until they are added to at least one group." on the page
    And I see "Testusertwo" on the page

    #DMP-2340-AC3 User reactivated

    When I press the "Reactivate user" button
    Then I see "User record activated" on the page
    And I see "Active user" on the page

    When I click on the "Users" link
    And I set "Full name" to "Testuserone"
    And I select the "Inactive users" radio button
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserone"
    Then I see "Inactive" on the page

    When I press the "Activate user" button
    Then I see "Reactivating this user will give them access to DARTS. They will not be able to see any data until they are added to at least one group." on the page
    And I see "Testuserone" on the page

    When I press the "Reactivate user" button
    Then I see "User record activated" on the page
    And I see "Active user" on the page

    When I click on the "Groups" sub-menu link
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Testgroupone"
    When I check the checkbox in the same row as "Testgroupone" "Transcriber"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page

    When I click on the "Users" link
    And I set "Full name" to "Testusertwo"
    And I select the "Active users" radio button
    And I press the "Search" button
    And I click on "View" in the same row as "Testusertwo"
    Then I see "Active user" on the page

    When I click on the "Groups" sub-menu link
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Testgroupone"
    When I check the checkbox in the same row as "Testgroupone" "Transcriber"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page


  @DMP-2323
  Scenario: Deactivate user with transcript

    #Create transcript request and assign to user

    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I set "Case ID" to "H{{seq}}001"
    And I press the "Search" button
    And I click on "H{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "10:30:00"
    And I set the time fields below "End time" to "10:31:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "H{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefH {{seq}}-46" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for user to be deactivated"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
#    And I click on the "Transcript requests to review" link
    And I click on "View" in the same row as "H{{seq}}001"
    And I see "This transcript request is for user to be deactivated" in the same row as "Instructions"
    And I select the "Yes" radio button
    And I press the "Submit" button
#    And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    And I do not see "H{{seq}}001" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    #And I am logged on to DARTS as TESTUSERTHREE user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "H{{seq}}001"
    And I click on "View" in the same row as "H{{seq}}001"
    And I select the "Assign to me" radio button
    And I press the "Continue" button
    Then I see "H{{seq}}001" on the page

    When I click on the "Completed today" link
    Then I do not see "H{{seq}}001" on the page

    #DMP-2323-AC4 Deactivate user with transcript

    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Users" link
    And I set "Full name" to "Testuserthree"
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserthree"
    And I see "Active user" on the page
    And I press the "Deactivate user" button
    Then I see "Deactivating this user will remove their access to DARTS." on the page
    And I see "This is the only active user in this group. Deactivating this user will result in no active users in this group." on the page
    And I see "Testuserthree" on the page

    When I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see "Inactive" on the page

    #Check transcript is unassigned after deactivation

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "H{{seq}}001"

    @DMP-4209
    Scenario: Back link
      Given I am logged on to the admin portal as an ADMIN user
      When I click on the "Users" link
      Then I see "Full name" on the page
      And I see "Email" on the page
      And I see "Active users" on the page
      And I see "Inactive users" on the page
      And I see "All" on the page

      Then I set "Full name" to "judge"
      And I select the "All" radio button
      And I press the "Search" button
      Then I verify the HTML table contains the following values
      | Full name    | Email                  | Status | View |
      | Local Judge  | darts.judge1@hmcts.net | Active | View |
      | global_judge | darts.judge@hmcts.net  | Active | View |

      And I click on "View" in the same row as "Local Judge"
      And I see link with text "Back"
      Then I click on the "Back" link
      And I verify the HTML table contains the following values
      | Full name    | Email                  | Status | View |
      | Local Judge  | darts.judge1@hmcts.net | Active | View |
      | global_judge | darts.judge@hmcts.net  | Active | View |
