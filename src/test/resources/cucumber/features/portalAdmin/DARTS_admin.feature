Feature: Admin

  @DMP-2323
  Scenario: Admin change transcription status data creation
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors             | defenders             |
      | Harrow Crown Court | {{seq}}-46 | H{{seq}}001 | DefH {{seq}}-46 | JudgeH {{seq}}-46 | testprosecutorfourtysix | testdefenderfourtysix |

    Given I create an event
      | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}1052 | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{seq}}ABC-46 | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}1053 | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{seq}}GHI-46 | {{timestamp-10:31:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
      | Harrow Crown Court | {{seq}}-46 | H{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1.mp2 |

  @DMP-2187-AC1,AC-2
  Scenario: Admin access and landing page
    When  I am logged on to the admin portal as an ADMIN user
    Then  I see "Users" on the page
    And   I see links with text:
      | Users | Groups | Organisations | Courthouses | Events | Node registry | Transformed media | Transcript requests |
      | Y     | Y      | Y             | Y           | Y      | Y             | Y                 | Y                   |
    And   I see link with text "HMCTS"
    And   I see link with text "DARTS"
    And   I see link with text "Sign out"

  @DMP-2187-AC3
  Scenario Outline: No ADMIN permissions
    When  I am logged on to the admin portal as a <role> user
    Then I see "Page not found" on the page

    Examples:
      | role              | 
      | judge             |
      | transcriber       |
      | languageshop      |
      | requester         |
      | approver          |
			| APPEALCOURT       |
			| TRANSCRIBER       |
			| LANGUAGESHOP      |
			| REQUESTERAPPROVER |

  @DMP-634
  Scenario: Search for Users in Portal Primary page
    When I am logged on to the admin portal as an ADMIN user
    And I see "Users" on the page
    Then I see "Full name" on the page
    And I see "Email" on the page
    And I see "Active users" on the page
    And I see "Inactive users" on the page
    And I see "All" on the page

  @DMP-725
  Scenario: Search page for Courthouses
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Courthouses" link
    Then I see "Search for courthouse" on the page
    And I see "Courthouse name" on the page
    And I see "Display name" on the page
    And I see "Region" on the page

  @DMP-2178 @DMP-630-AC1-AC2
  Scenario Outline: New user account - Check user details
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I see the "Create new user" button
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
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
    Then I click on the "Change" link
    Then I set "Full name" to "Test User Change"
    And I set "Email" to "testchange@test.com"
    And I set "Description (optional)" to "Test Change"
    And I press the "Continue" button
    #AC3 Cancel User Creation
    Then I click on the "Cancel" link
    And I press the "Create new user" button
    #AC4 Create a User
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    And I press the "Create user" button

    Examples:
      | Full name  | Email                 | Description |
      | Joe Bloggs | darts.test4@hmcts.net | Test        |

  @DMP-630-AC3-1
  Scenario Outline: Create a new user account with existing email address
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I see the "Create new user" button
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter a unique email address"
    Then I see "email" on the page
    And I see an error message "Enter a unique email address"
    Examples:
      | Full name    | Email                 | Description |
      | global_judge | darts.judge@hmcts.net |             |

  @DMP-630-AC3-2
  Scenario Outline: Create a new user account with invalid email format
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter an email address in the correct format, like name@example.com"
    Then I see "email" on the page
    And I see an error message "Enter an email address in the correct format, like name@example.com"
    Examples:
      | Full name    | Email       | Description |
      | global_judge | darts.judge |             |

  @DMP-630-AC3-3
  Scenario Outline: Create a new user account without full name
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter a full name"
    Then I see "Full name" on the page
    And I see an error message "Enter a full name"
    Examples:
      | Full name | Email                | Description |
      |           | darts.judge@hmct.net |             |

  @DMP-630-AC3-4
  Scenario Outline: Create a new user account without Email address
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter an email address"
    Then I see "email" on the page
    And I see an error message "Enter an email address"
    Examples:
      | Full name | Email | Description |
      | Test      |       |             |

  @DMP-630-AC3-5
  Scenario Outline: Create a new user account with more than 256 characters
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I press the "Create new user" button
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "Description (optional)" on the page
    And I see "Enter a description shorter than 256 characters" on the page
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter a description shorter than 256 characters"
    Examples:
      | Full name | Email             | Description                                                                                                                                                                                                                                                           |
      | Test      | Test999@hmcts.net | Test. Test. Test. Test. Test. Test. Test. Test. Test. Test. Test v. Test.   Test.   Test. Test.   Test. Test. v. Test. Test TestTestTestvvvvvvvTest Test Test Test TestTest Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test |

  @DMP-2323 @regression
  Scenario: Deactivate user and last user in group
    Given I am logged on to the admin portal as an ADMIN user

    #DMP-2323-AC1 Deactivate user

    When I click on the "Users" link
    And I set "Full name" to "Testuserone"
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserone"
    And I see "Active user" on the page
    And I press the "Deactivate user" button
    Then I see "Deactivating this user will remove their access to DARTS." on the page
    And I see "Testuserone" on the page

    When I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see "Inactive" on the page

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

    #Reactivate users and assign group for next run

    When I press the "Activate user" button
    Then I see "Reactivating this user will give them access to DARTS. They will not be able to see any data until they are added to at least one group." on the page
    And I see "Testusertwo" on the page

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

    When I click on the sub-menu link "Groups"
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Testgroupone"
    When I check the checkbox in the same row as "Testgroupone" "Transcriber"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page

    When I click on the "Users" link
    And I set "Full name" to "Testusertwo"
    And I press the "Search" button
    And I click on "View" in the same row as "Testusertwo"
    Then I see "Active user" on the page

    When I click on the sub-menu link "Groups"
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
    And I click on the "Transcript requests to review" link
    And I click on "View" in the same row as "H{{seq}}001"
    And I see "This transcript request is for user to be deactivated" in the same row as "Instructions"
    And I select the "Yes" radio button
    And I press the "Submit" button
    And I click on the "Transcript requests to review" link
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