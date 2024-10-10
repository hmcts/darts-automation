Feature: Admin

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

  @DMP-2187 @regression @obsolete
  Scenario: Admin access and landing page
    Given I am logged on to the admin portal as an ADMIN user
    #DMP-2187-AC1 and AC2
    When I see "Search" on the page
    Then I see links with text:
      | Search | Users | Groups | Courthouses | Transformed media | Transcripts | File deletion | System configuration |
      | Y      | Y     | Y      | Y           | Y                 | Y           | Y             | Y                    |
    And I see link with text "HMCTS"
    And I see link with text "DARTS"
    And I see link with text "Sign out"

  @DMP-2187 @regression
  Scenario Outline: No ADMIN permissions

    #DMP-2187-AC3
    Given I am logged on to the admin portal as a <role> user
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

  @DMP-634 @regression
  Scenario: Search for Users in Portal Primary page
    Given I am logged on to the admin portal as an ADMIN user
    When I do not see "Search for user" on the page
    And I click on the "Users" link
    Then I see "Full name" on the page
    And I see "Email" on the page
    And I see "Active users" on the page
    And I see "Inactive users" on the page
    And I see "All" on the page

  @DMP-725 @regression
  Scenario: Search page for Courthouses
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Courthouses" link
    Then I see "Search for courthouse" on the page
    And I see "Courthouse name" on the page
    And I see "Display name" on the page
    And I see "Region" on the page

  @DMP-2178 @DMP-630-AC1-AC2 @regression
  Scenario Outline: New user account - Check user details

    #TODO: This needs fresh data each time or it will fail due to details not being unique

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
    And I set "Full name" to "Test User Change"
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
    Then I press the "Create user" button

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
    Then I see "There is a problem" on the page
    And I see an error message "<ErrorMessage>"
    And I see "<Field>" on the page
    And I see an error message "<ErrorMessage>"
    Examples:
      | Full name    | Email                 | Description | Field     | ErrorMessage                                                        |
      | global_judge | darts.judge@hmcts.net |             | email     | Enter a unique email address                                        |
      | global_judge | darts.judge           |             | email     | Enter an email address in the correct format, like name@example.com |
      |              | darts.judge@hmct.net  |             | Full name | Enter a full name                                                   |
      | Test         |                       |             | email     | Enter an email address                                              |
      | Test         | Test999@hmcts.net     | Test. Test. Test. Test. Test. Test. Test. Test. Test. Test. Test v. Test.   Test.   Test. Test.   Test. Test. v. Test. Test TestTestTestvvvvvvvTest Test Test Test TestTest Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test | Description | Enter a description shorter than 256 characters |

  @DMP-2931 @regression
  Scenario: Remove user role, single and multiple, test cancel link
    Given I am logged on to the admin portal as an ADMIN user
    #Add users roles for test
    Given I add user "Testuserfour" to group "Harrow Crown Court_REQUESTER"
    Given I add user "Testuserfive" to group "Harrow Crown Court_REQUESTER"
    Given I add user "Testusersix" to group "Harrow Crown Court_REQUESTER"
    
    When I click on the "Courthouses" link
    And I set "Courthouse name" to "Harrow"
    And I press the "Search" button
    And I click on the "{{upper-case-Harrow Crown Court}}" link
    And I click on the "Users" sub-menu link
    And I check the checkbox in the same row as "Testuserfour" "testuserfour@hmcts.net"
    And I press the "Remove user role" button
    Then I see "You are removing 1 user role from Harrow Crown Court" on the page

    When I click on the "Cancel" link
    Then I see "Courthouse record" on the page
    And I do not see "You are removing 1 user role from Harrow Crown Court" on the page

    When I check the checkbox in the same row as "Testuserfour" "testuserfour@hmcts.net"
    And I press the "Remove user role" button
    And I see "You are removing 1 user role from Harrow Crown Court" on the page
    And I see "Testuserfour" in the same row as "testuserfour@hmcts.net"
    And I press the "Confirm" button
    Then I see "1 user role removed from Harrow Crown Court" on the page
    And I do not see "Testuserfour" on the page

    When I check the checkbox in the same row as "Testuserfive" "testuserfive@hmcts.net"
    And I check the checkbox in the same row as "Testusersix" "testusersix@hmcts.net"
    And I press the "Remove user roles" button
    And I see "You are removing 2 user roles from Harrow Crown Court" on the page
    And I see "Testuserfive" in the same row as "testuserfive@hmcts.net"
    And I see "Testusersix" in the same row as "testusersix@hmcts.net"
    And I press the "Confirm" button
    Then I see "2 user roles removed from Harrow Crown Court" on the page
    And I do not see "Testuserfive" on the page
    And I do not see "Testusersix" on the page


  @DMP-2323 @DMP-2340 @regression
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

  @DMP-2678 @regression
  Scenario: Transformed media search

    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Transformed media" link
    And I press the "Search" button
    Then I see "results" on the page

    #DMP-2678-AC1 View search results

    When I click on the "Advanced search" link
    And I set "Courthouse" to "Harrow Crown Court"
    And I set "Hearing date" to "15/02/2024"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Media ID | Case ID  | Courthouse         | Hearing date | Owner       | Requested by | Date requested | Last accessed | File type | Size  | Filename                   |
      | 518      | B9160006 | Harrow Crown Court | 15 Feb 2024  | Transcriber | Transcriber  | 15 Feb 2024    |               | MP3       | 0.2MB | B9160006_15_Feb_2024_1.mp3 |
      | 519      | B9160006 | Harrow Crown Court | 15 Feb 2024  | Transcriber | Transcriber  | 15 Feb 2024    |               | ZIP       | 0.9MB | B9160006_15_Feb_2024_1.zip |
      | 557      | S1029021 | Harrow Crown Court | 15 Feb 2024  | Requestor   | Requestor    | 15 Feb 2024    |               | MP3       | 0.2MB | S1029021_15_Feb_2024_1.mp3 |
    And I see "Showing 1-3 of 3 results" on the page

    #DMP-2678-AC2 Single search result takes user directly to file details screen

    When I set "Request ID" to "17165"
    And I press the "Search" button
    Then I do not see "Showing" on the page
    And I see "Request details" on the page
    And I see "Requestor" in the same row as "Requested by"
    And I see "17165" in the same row as "Request ID"

  @DMP-2695 @DMP-2679 @DMP-3475
  Scenario: Transformed media-Change owner
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Transformed media" link
    And I see "Transformed media" on the page
    And I set "Request ID" to "8545"
    And I press the "Search" button
    And I click on the "Back" link
    And I see "Transformed media" on the page
    Then I click on the "101" link
    And I see "Transformed media" on the page
    And I see "101" on the page
    And I see "Request details" on the page
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to ""
    And I press the "Save change" button
    Then I see "Select a user" on the page
    And I click on the "Cancel" link
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to "Testuserone (testuserone@hmcts.net)" and click away
    And I press the "Save change" button
    Then I see "Changed media request owner to Testuserone " on the page
    And I see "Owner" in the same row as "Testuserone (testuserone@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to "Mehta Purvi (mehta.purvi@hmcts.net)" and click away
    And I press the "Save change" button

    #DMP-2679 Transformed media detail page
    Then I see "Transformed media" on the page
    And I see "101" on the page
    And I see "Request details" on the page
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I see "Requested by" in the same row as "Requestor"
    And I see "Request ID" in the same row as "8545"
    And I see "Date requested" in the same row as "20 December 2023"
    And I see "Hearing date" in the same row as "07 December 2023"
    And I see "Courtroom" in the same row as "Rayners room"
    And I see "Audio requested" in the same row as "Start time 2:00:00PM - End time 2:01:00PM"

    Then I see "Case details" on the page
    And I see "Case ID" in the same row as "T20230001"
    And I see "Courthouse" in the same row as "Harrow Crown Court"
    And I see "Judge(s)" in the same row as "{{upper-case-test judge}}"
    And I see "Defendant(s)" in the same row as "fred"

    Then I see "Media details" on the page
    And I see "Filename" in the same row as "T20230001_07_Dec_2023_1"
    And I see "File type" in the same row as ""
    And I see "File size" in the same row as "MB"

    Then I see "Associated audio" on the page
    Then I verify the HTML table contains the following values
      |Audio ID|Case ID    |Hearing date|Courthouse         |Start time|End time|Courtroom    |Channel number|
      |3833    |T20230001  |07 Dec 2023 |Harrow Crown Court |2:00PM    |2:01PM  |Rayners room |1             |

    @DMP-3139 @DMP-3469 @DMP-3406 @DMP-3564 @DMP-3565
    Scenario: Transcript advanced search
      When I am logged on to the admin portal as an ADMIN user
      And I click on the "Transcripts" link
      And I click on the "Completed transcripts" link
      Then I click on the "Advanced search" link
      #Search with Courthouse
      And I set "Courthouse" to "Leeds" and click away
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID            | Courthouse    | Hearing date | Request method | Is hidden |
        | 1             | 1393       | Case1_LEEDS_DMP381 | LEEDS_DMP381  | 03 Nov 2023  | Manual         | No        |
        | 21            | 1473       | Case1_LEEDS_DMP381 | LEEDS_DMP381  | 03 Nov 2023  | Manual         | No        |
        | 41            | 1613       | Case1_LEEDS_DMP381 | LEEDS_DMP381  | 06 Nov 2023  | Automatic      | No        |
        | 401           | 1593       | Case1_LEEDS_DMP381 | LEEDS_DMP381  | 03 Nov 2023  | Manual         | No        |
      And I clear the "Courthouse" field
      #Search with Hearing Date
      And I set "Hearing date" to "03/01/2024"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID        | Courthouse           | Hearing date | Request method | Is hidden |
        | 933           | 5485       | DMP-1071_case1 | DMP-1071_Courthouse  | 03 Jan 2024  | Manual         | Yes       |
        | 953           |5665        | DMP-1071_case1 | DMP-1071_Courthouse  | 03 Jan 2024  | Manual         | No        |
      And I clear the "Hearing date" field
      #Search with Owner
      And I set "Owner" to "Kyle"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID            | Courthouse | Hearing date | Request method | Is hidden |
        | 561           | 1633       | CASE5_Event_DMP461 | Swansea    | 10 Aug 2023  | Manual         | Yes       |
        | 801           | 3433       | CASE1009           | Swansea    | 15 Aug 2023  | Manual         | No        |
        | 821           | 2674       | CASE5_Event_DMP461 | Swansea    | 10 Aug 2023  | Manual         | No        |
        | 1593          | 16888      | CASE5_Event_DMP461 | Swansea    | 10 Aug 2023  | Manual         | No        |
      And I clear the "Owner" field
      #Search with Requested by
      And I set "Requested by" to "Kyle"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID            | Courthouse | Hearing date | Request method | Is hidden |
        | 561           | 1633       | CASE5_Event_DMP461 | Swansea    | 10 Aug 2023  | Manual         | Yes       |
        | 1593          | 16888      | CASE5_Event_DMP461 | Swansea    | 10 Aug 2023  | Manual         | No        |
      And I clear the "Requested by" field
      #Search with Specific date
      And I select the "Specific date" radio button
      And I set "Enter a date" to "01/07/2024"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID           | Courthouse        | Hearing date | Request method | Is hidden |
        | 7037          | 48029      | DMP-3338-Case-002 | DMP-3338-BATH-AAB | 01 Jul 2024  | Manual         | Yes       |
        | 7057          | 48049      | DMP-3184-Case-008 | DMP-3184-BATH     | 13 Jun 2024  | Manual         | No        |
      And I clear the "Enter a date" field
      # Search with Date range
      And I select the "Date range" radio button
      And I set "Date from" to "01/07/2024"
      And I set "Date to" to "08/07/2024"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID           | Courthouse        | Hearing date | Request method | Is hidden |
        | 7037          | 48029      | DMP-3338-Case-002 | DMP-3338-BATH-AAB | 01 Jul 2024  | Manual         | Yes       |
        | 7057          | 48049      | DMP-3184-Case-008 | DMP-3184-BATH     | 13 Jun 2024  | Manual         | No        |
        | 7077          | 49209      | DMP-2623-Case-008 | London            | 13 Jun 2024  | Manual         | No        |
      And I clear the "Date from" field
      And I clear the "Date to" field
      #Search with Request method
      And I select the "Automatic" radio button
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID            | Courthouse        | Hearing date | Request method    | Is hidden |
        | 441           | 3873      | DMP1600-case1      | London_DMP1600    | 01 Dec 2023  | Automatic         | Yes       |
        | 41            | 1613      | Case1_LEEDS_DMP381 | LEEDS_DMP381      | 06 Nov 2023  | Automatic         | No        |
      #Search with multiple fields
      And I select the "Manual" radio button
      And I set "Date from" to "01/07/2024"
      And I set "Date to" to "08/07/2024"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID | Case ID           | Courthouse        | Hearing date | Request method | Is hidden |
        | 7037          | 48029      | DMP-3338-Case-002 | DMP-3338-BATH-AAB | 01 Jul 2024  | Manual         | Yes       |
        | 7057          | 48049      | DMP-3184-Case-008 | DMP-3184-BATH     | 13 Jun 2024  | Manual         | No        |
        | 7077          | 49209      | DMP-2623-Case-008 | London            | 13 Jun 2024  | Manual         | No        |

      #Search wit Transcript ID
      And I click on the "Requests" link
      And I set "Request ID" to "17165"
      And I press the "Search" button
      Then I see "Transcript request" on the page
      And I see "Details" on the page
      And I see "Current status" on the page
      And I see "Status" in the same row as "Complete"
      And I see "Assigned to " in the same row as "Transcriber"

      And I see "Request details" on the page
      And I see "Hearing date" in the same row as "15 Feb 2024"
      And I see "Request type" in the same row as "Sentencing remarks"
      And I see "Request method" in the same row as "Manual"
      And I see "Request ID" in the same row as "17165"
      And I see "Urgency" in the same row as "Overnight"
      And I see "Requested by" in the same row as "Requestor"
      And I see "Received" in the same row as "19 Feb 2024 10:41:26"
      And I see "Judge approval" in the same row as "Yes"

      And I see "Case details" on the page
      And I see "Case ID" in the same row as "S1034021"
      And I see "Courthouse" in the same row as "Harrow Crown Court"
      And I see "Judge(s)" in the same row as "{{upper-case-S1034 judge}}"
      And I see "Defendant(s)" in the same row as "S1034 defendant"

      And I click on the "Back" link
      Then I see "Requests" on the page
      And I see "17165" on the page
      Then I verify the HTML table contains the following values
      | Request ID | Case ID  | Courthouse         | Hearing date| Requested on      | Status   | Request method|
      | 17165      | S1034021 | Harrow Crown Court | 15 Feb 2024 | 19 Feb 2024 10:41 | Complete | 	Manual      |

      #Search with Case ID
      Then I click on the "Completed transcripts" link
      And I set "Case ID" to "DMP-3104"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
      | Transcript ID | Request ID |Case ID   | Courthouse | Hearing date | Request method | Is hidden |
      | 6617          | 36329      | DMP-3104 | Swansea    | 07 Jun 2024  | Manual         | No        |
      | 6637          | 36349      | DMP-3104 | Swansea    | 07 Jun 2024  | Manual         | No        |
      And I click on the "6637" link
      And I see "Back" on the page
      And I click on the "Back" link
      And I see "Completed transcripts" on the page
      Then I verify the HTML table contains the following values
        | Transcript ID | Request ID |Case ID   | Courthouse | Hearing date | Request method | Is hidden |
        | 6617          | 36329      | DMP-3104 | Swansea    | 07 Jun 2024  | Manual         | No        |
        | 6637          | 36349      | DMP-3104 | Swansea    | 07 Jun 2024  | Manual         | No        |
      And I click on the "6637" link
      Then I see "Transcript file" on the page
      And I see "6637" on the page
      #Basic details
      And I see "Basic details" on the page
      And I see "Case ID" in the same row as "DMP-3104"
      And I see "Hearing date" in the same row as "07 Jun 2024"
      And I see "Courthouse" in the same row as "SWANSEA"
      And I see "Courtroom" in the same row as "DMP-3104-Courtroom"
      And I see "Defendant(s)" in the same row as ""
      And I see "Judge(s)" in the same row as ""

      And I see "Request details" on the page
      And I see "Request type" in the same row as "Sentencing remarks"
      And I see "Audio for transcript" in the same row as "Start time 02:00:00 - End time 02:02:00"
      And I see "Requested date" in the same row as "07 Jun 2024"
      And I see "Request method" in the same row as "Manual"
      And I see "Request ID" in the same row as "36349"
      And I see "Urgency" in the same row as "Overnight"
      And I see "Requested by" in the same row as "Requestor"
      And I see "Instructions" in the same row as "DMP-3104"
      And I see "Judge approval" in the same row as "Yes"
      And I see "Removed from user transcripts" in the same row as "No"
      #Advanced details
      Then I click on the "Advanced details" link
      And I see "Advanced details" on the page
      And I see "Transcription object ID" in the same row as ""
      And I see "Content object ID" in the same row as ""
      And I see "Clip ID" in the same row as ""
      And I see "Checksum" in the same row as "4b255620ba965043c3bcd000fc23558d"
      And I see "File size" in the same row as "0.01MB"
      And I see "File type" in the same row as "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      And I see "Filename" in the same row as "TestFile-Transcription.docx"
      And I see "Date uploaded" in the same row as "07 Jun 2024 at 3:36:31PM"
      And I see "Uploaded by" in the same row as "Transcriber"
      And I see "Last modified by" in the same row as "Transcriber"
      And I see "Date last modified" in the same row as "16 Jul 2024 at 4:25:50PM"
      And I see "Transcription hidden?" in the same row as "No"
      And I see "Hidden by" in the same row as ""
      And I see "Date hidden" in the same row as ""
      And I see "Retain until" in the same row as ""

    @DMP-3315
    Scenario: Hearings search results
      When I am logged on to the admin portal as an ADMIN user
      And I see "Search" on the page
      And I set "Filter by courthouse" to "Swansea"
      And I select the "Hearings" radio button
      And I press the "Search" button
      Then I see "Hearings" on the page
      And I click on the pagination link "2"
      And I see "Next" on the page
      And I see "Previous" on the page
      And I click on the pagination link "Previous"
      And I click on the pagination link "Next"

      And I select the "Date range" radio button
      And I set "Date from" to "20/06/2024"
      And I set "Date to" to "24/06/2024"
      And I press the "Search" button
      And I see "Showing 1-3 of 3" on the page
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |

      And I click on "Case ID" in the table header
      And "Case ID" has sort "descending" icon
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |

      And I click on "Hearing date" in the table header
      Then "Hearing date" has sort "descending" icon

      And I click on "Courthouse" in the table header
      Then "Courthouse" has sort "descending" icon

      And I click on "Courtroom" in the table header
      And "Courtroom" has sort "descending" icon
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |

  @DMP-2709 @DMP-3384
  Scenario: Audio file-Details page
    When I am logged on to the admin portal as a SUPERUSER user
    And I see "Search" on the page
    And I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
  #Back
    Then I click on the "Back" link
    And I see "Search" on the page
    And I click on the "52849" link
    And I see "Audio file" on the page
    And I see "52849" on the page
    And I see " Hide or delete " on the page
  #Basic details
    And I see "Basic details" on the page
    And I see "Courthouse" in the same row as "DMP-3438_Courthouse"
    And I see "Courtroom" in the same row as "Room1_DMP-3438"
    And I see "Start time" in the same row as "28 Jun 2024 at 1:00:00AM"
    And I see "End time" in the same row as "28 Jun 2024 at 11:59:59PM"
    And I see "Channel number" in the same row as "1"
    And I see "Total channels" in the same row as "4"
    And I see "Media type" in the same row as "A"
    And I see "File type" in the same row as "mp2"
    And I see "File size" in the same row as "0.94KB"
    And I see "Filename" in the same row as "DMP-3438-file1"
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Associated cases" on the page
    Then I verify the HTML table contains the following values
      | Case ID        | Hearing date| Defendants(s) | Judges(s) |
      | DMP-3438_case1 | 28 Jun 2024 |               |           |
    And I Sign out
  #Super Admin
    Then I am logged on to the admin portal as an ADMIN user
    And I see "Search" on the page
    And I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
  #Back
    Then I click on the "Back" link
    And I see "Search" on the page
    And I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
    And I see "Audio file" on the page
    And I see "52849" on the page
    And I see " Hide or delete " on the page
  #Basic details
    And I see "Basic details" on the page
    And I see "Courthouse" in the same row as "DMP-3438_Courthouse"
    And I see "Courtroom" in the same row as "Room1_DMP-3438"
    And I see "Start time" in the same row as "28 Jun 2024 at 1:00:00AM"
    And I see "End time" in the same row as "28 Jun 2024 at 11:59:59PM"
    And I see "Channel number" in the same row as "1"
    And I see "Total channels" in the same row as "4"
    And I see "Media type" in the same row as "A"
    And I see "File type" in the same row as "mp2"
    And I see "File size" in the same row as "0.94KB"
    And I see "Filename" in the same row as "DMP-3438-file1"
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Associated cases" on the page
    Then I verify the HTML table contains the following values
      | Case ID        | Hearing date| Defendants(s) | Judges(s) |
      | DMP-3438_case1 | 28 Jun 2024 |               |           |
  #Advanced details
    Then I click on the "Advanced details" link
    And I see "Advanced details" on the page
    And I see "Media object ID" in the same row as ""
    And I see "Content object ID" in the same row as ""
    And I see "Clip ID" in the same row as ""
    And I see "Checksum" in the same row as "d6df4486865e46f60d6bcebda3950760"
    And I see "Media status" in the same row as ""
    And I see "Audio hidden?" in the same row as "No"
    And I see "Audio deleted?" in the same row as "No"

    And I see "Version data" in the same row as "Show versions"
    And I see "Version" in the same row as ""
    And I see "Chronicle ID" in the same row as "52849"
    And I see "Antecedent ID" in the same row as ""
    And I see "Retain until" in the same row as ""
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Created by" in the same row as ""
    And I see "Date last modified" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Last modified by" in the same row as ""
  #Hide audio file
    Then I press the " Hide or delete " button
    And I select the "Other reason to hide only" radio button
    And I set "Enter ticket reference" to "DMP-2709"
    And I set "Comments" to "Testing DMP-2709 AC-3" and click away
    Then I see "You have 235 characters remaining" on the page
    And I press the "Hide or delete" button

    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    And I press the "Continue" button
    And I see "Important" on the page
    And I see "This file is hidden in DARTS" on the page
    And I see "DARTS users cannot view this file. You can unhide the file." on the page
    And I see "Hidden by - Darts Admin" on the page
    And I see "Reason - Other reason to hide only" on the page
    And I see "Testing DMP-2709 AC-3" on the page
    And I see "Unhide" on the page
  #Unhide audio file
    Then I click on the "unhide" link
    And I do not see "Important" on the page
    And I click on the "Advanced details" link
    And I see "Audio hidden?" in the same row as "No"
    And I see " Hide or delete " on the page

  @DMP-3317
  Scenario: Audio search results
    When I am logged on to the admin portal as an ADMIN user
    And I see "Search" on the page
    And I set "Filter by courthouse" to "Bristol"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I click on the pagination link "2"
    And I see "Next" on the page
    And I see "Previous" on the page
    And I click on the pagination link "Previous"
    And I click on the pagination link "Next"

    When I click on "Audio ID" in the table header
    Then "Audio ID" has sort "descending" icon

    And I click on "Courthouse" in the table header
    Then "Courthouse" has sort "descending" icon

    And I click on "Courtroom" in the table header
    Then "Courtroom" has sort "descending" icon

    And I click on "Start Time" in the table header
    Then "Start Time" has sort "descending" icon

    And I click on "End Time" in the table header
    Then "End Time" has sort "descending" icon

    And I click on "Channel" in the table header
    Then "Channel" has sort "descending" icon

    And I click on "Hidden" in the table header
    Then "Hidden" has sort "descending" icon

  @3309
  Scenario:Event_ID Screen
    When I am logged on to the admin portal as an ADMIN user
    And I see "Search" on the page
    And I select the "Specific date" radio button
    And I set "Enter a date" to "01/01/2024"
    And I select the "Events" radio button
    And I press the "Search" button
    Then I see "Events" on the page
    #Back Link
    And I click on "490225" in the same row as "22 Aug 2024 at 04:16:55"
    And I see link with text "Back"
    Then I click on the "Back" link
    And I see "Events" on the page
    #Basic details
    Then I click on "490225" in the same row as "22 Aug 2024 at 04:16:55"
    And I see "Event" on the page
    And I see "490225" on the page
    And I see "Basic details" on the page
    And I see "Name" in the same row as "Proceedings in chambers"
    And I see "Text" in the same row as "some text for the event"
    And I see "Courthouse" in the same row as "Harrow Crown Court"
    And I see "Courtroom" in the same row as "132311"
    And I see "Time stamp" in the same row as "22 Aug 2024 at 16:16:55"
    #Advanced details
    Then I click on the "Advanced details" link
    And I see "Documentum ID" in the same row as ""
    And I see "Source event ID" in the same row as "12345"
    And I see "Message ID" in the same row as "100"
    And I see "Type" in the same row as "1000"
    And I see "Subtype" in the same row as "1002"
    And I see "Event Handler" in the same row as "StandardEventHandler"
    And I see "Reporting restriction?" in the same row as "No"
    And I see "Log entry?" in the same row as "No"

    And I see "Version data" on the page
    And I see "Version" in the same row as ""
    And I see "Chronicle ID" in the same row as ""
    And I see "Antecedent ID" in the same row as ""
    And I see "Date created" in the same row as "22 Aug 2024 at 16:16:55"
    And I see "Created by" in the same row as "System"
    And I see "Date last modified" in the same row as "22 Aug 2024 at 16:16:55"
    And I see "Last modified by" in the same row as "System"

    @DMP-2471 @DMP-2475
    Scenario: Create and Edit new retention policy
      When I am logged on to the admin portal as an ADMIN user
      Then I click on the "System configuration" link
      And I click on the "Create policy" link
      And I see "Create new policy" on the page
      And I set "Display name" to "DMP-2471-AC1"
      And I set "Name" to "AC1-2471"
      And I set "Description" to ""
      And I set "Fixed policy key" to "99"
      And I set "Years" to "05"
      And I set "Months" to "04"
      And I set "Days" to "02"
      And I see "Policy start" on the page
      And I see "Start date" on the page
      And I set "Start date" to "04/10/2025"
      And I set "Hour" to "00"
      And I set "Minutes" to "59"
      And I click on the "Create" link
      Then I see "Retention policy created" on the page
      And I see "Retention policies" on the page
      And I see "Active" on the page
      And I see "Inactive" on the page
    #Cancel Policy.
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to "PMTest11"
      And I set "Name" to "PMTest11"
      And I set "Description" to ""
      And I set "Fixed policy key" to "TestPM11"
      And I set "Years" to "05"
      And I set "Months" to "05"
      And I set "Days" to "05"
      And I set "Start date" to "04/10/2025"
      And I set "Hour" to "05"
      And I set "Minutes" to "05"
      And I click on the "Cancel" link
      Then I see "Retention policies" on the page
      And I see "Active" on the page
      And I see "Inactive" on the page
   #Error
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to ""
      And I set "Name" to ""
      And I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A"
      And I set "Fixed policy key" to ""
      And I set "Years" to ""
      And I set "Months" to ""
      And I set "Days" to ""
      And I set "Start date" to ""
      And I set "Hour" to ""
      And I set "Minutes" to ""
      And I click on the "Create" link
      Then I see "There is a problem" on the page
      And I see "Enter a display name" on the page
      And I see "Enter a name" on the page
      And I see "Enter a description shorter than 256 characters" on the page
      And I see "Enter a fixed policy key" on the page
      And I see "Enter a duration of at least 1 day" on the page
      And I see "Enter a policy start date" on the page
      And I see "Enter a start time" on the page
    # All fields are already exist
      And I click on the "Cancel" link
      Then I see "Retention policies" on the page
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to "PM-Test"
      And I set "Name" to "PM-Test1"
      And I set "Description" to ""
      And I set "Fixed policy key" to "Test-PM"
      And I set "Years" to "00"
      And I set "Months" to "01"
      And I set "Days" to "02"
      And I set "Start date" to "01/01/2025"
      And I set "Hour" to "01"
      And I set "Minutes" to "00"
      And I click on the "Create" link
      Then I see "There is a problem" on the page
      And I see "Enter a unique display name" on the page
      And I see "Enter a unique name" on the page
      And I see "The fixed policy key entered already exists in the database. Fixed policy keys must be unique" on the page
      Then I click on the "Cancel" link
      #Edit policy @DMP-2475
    And I click on "Edit Policy" in the same row as "DMP-2471-AC1"
    And I set "Display name" to "DMP-2475-AC1-Edit"
    And I set "Name" to "AC1-2475-Edit"
    And I set "Description" to "Editing DMP-2471"
    And I set "Fixed policy key" to "92"
    And I set "Years" to "02"
    And I set "Months" to "12"
    And I set "Days" to "31"
    And I see "Policy start" on the page
    And I see "Start date" on the page
    And I set "Start date" to "29/04/2026"
    And I set "Hour" to "10"
    And I set "Minutes" to "30"
    And I click on the "Save" link
    Then I see "Retention policy updated" on the page
  #Cancel policy
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I click on the "Cancel" link
    Then I see "Retention policies" on the page
  #AC3
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I see "Retention policy" on the page
    And I clear the "Display name" field
    And I set "Display name" to ""
    And I clear the "Name" field
    And I set "Name" to ""
    And I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A"
    And I clear the "Fixed policy key" field
    And I set "Fixed policy key" to ""
    And I clear the "Years" field
    And I set "Years" to ""
    And I clear the "Months" field
    And I set "Months" to ""
    And I clear the "Days" field
    And I set "Days" to ""
    And I clear the "Start date" field
    And I set "Start date" to ""
    And I clear the "Hour" field
    And I set "Hour" to ""
    And I clear the "Minutes" field
    And I set "Minutes" to ""
    And I click on the "Save" link
    Then I see "There is a problem" on the page
    And I see "Enter a display name" on the page
    And I see "Enter a name" on the page
    And I see "Enter a description shorter than 256 characters" on the page
    And I see "Enter a fixed policy key" on the page
    And I see "Enter a duration of at least 1 day" on the page
    And I see "Enter a policy start date" on the page
    And I see "Enter a start time" on the page
  #fields are already exist
    And I click on the "Cancel" link
    Then I see "Retention policies" on the page
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I set "Display name" to "Custodial"
    And I set "Name" to "DMP-2532 AC3"
    And I set "Description" to ""
    And I clear the "Fixed policy key" field
    And I set "Fixed policy key" to ""
    And I set "Years" to "00"
    And I set "Months" to "12"
    And I set "Days" to "31"
    And I set "Start date" to "01/01/2024"
    And I set "Hour" to "11"
    And I set "Minutes" to "30"
    And I click on the "Save" link
    Then I see "There is a problem" on the page
    And I see "Enter a unique display name" on the page
    And I see "Enter a unique name" on the page
    And I see "Enter a fixed policy key" on the page
    And I see "Enter a policy start date in the future" on the page
    And I see "Enter a policy start time in the future" on the page

    @DMP-2731
    Scenario: Transcript files marked for deletion
      When I am logged on to the admin portal as an ADMIN user
      And I click on the "File deletion" link
      And I see "Audio files" in the same row as "Transcripts"
      Then I click on the "Transcripts" sub-menu link
      And I see "Transcripts" on the page
      Then I verify the HTML table contains the following values
      | Transcript ID| Case ID               | Hearing date| Courthouse| Courtroom         | Marked by  | Comments                             | *IGNORE* |
      | 8149         | DMP-3364-Disable-User | 24 Sep 2024 | Swansea   | OURTROOM-DMP-3364 | Darts Admin| Public interest immunity\nTest\nTest | Delete   |

      Then I press the "Delete" button
      And I see "You cannot delete this transcript file" on the page
      And I see "You cannot delete a transcript file that you marked for deletion." on the page
      And I see "Another administrator will need to check the file can be deleted and can complete this step." on the page
      And I see "Go back" on the page

      Then I click on the "Go back" link
      And I see "Transcripts" on the page
      And I verify the HTML table contains the following values
        | Transcript ID| Case ID               | Hearing date| Courthouse| Courtroom         | Marked by  | Comments                             | *IGNORE* |
        | 8149         | DMP-3364-Disable-User | 24 Sep 2024 | Swansea   | OURTROOM-DMP-3364 | Darts Admin| Public interest immunity\nTest\nTest | Delete   |
