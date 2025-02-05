Feature: Admin portal

  @DMP-4442
  Scenario: Data creation for Audio file deletion
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors               | defenders               |
      | Harrow Crown Court | {{seq}}-47 | I{{seq}}001 | DefI {{seq}}-47 | JudgeI {{seq}}-47 | testprosecutorfourtyseven | testdefenderfourtyseven |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}075 | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{seq}}ABC-47 | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}076 | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{seq}}GHI-47 | {{timestamp-10:31:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
      | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1.mp2 |

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
    And I see "Requestor" in the same row as "Requested by"
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

  @DMP-2562 @regression
  Scenario: Request download audio for Admin user
    When I am logged on to DARTS as an Admin user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "B{{seq}}006"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)                        | Defendant(s)   |
      | B{{seq}}006 | Harrow Crown Court | B{{seq}}-6 | {{upper-case-Judge B{{seq}}-6}} | Def B{{seq}}-6 |

    When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:01:00"
    And I set the time fields of "End Time" to "10:02:00"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def B{{seq}}-6" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page

    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Darts Admin and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    Then I click on the "Back to search results" link

    When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
    And I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:01:00"
    And I set the time fields of "End Time" to "10:02:00"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def B{{seq}}-6" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page

  @DMP-4035 @regression
  Scenario Outline: Admin user can hide audio
    Given I am logged on to the admin portal as an Admin user
    And I select column hea_id from table CASE_HEARING where courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and case_number = "<caseId>"
    And I select column med_id from table CASE_AUDIO where hea_id = "{{hea_id}}"
    When I get audios for hearing "{{hea_id}}"
    Then I see "id" in the json response is "{{med_id}}"
    When I click on the "Search" link
    Then I see "You can search for cases, hearings, events and audio." on the page
    When I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I click on the "{{med_id}}" link
    And I press the "Hide or delete" button
    And I press the "Hide or delete" button
    Then I see "Select a reason for hiding and/or deleting the file" on the page

    When I select the "Other reason to hide only" radio button
    And I press the "Hide or delete" button
    Then I see "Enter a ticket reference" on the page

    When I set "Enter ticket reference" to "T{{seq}}006"
    And I press the "Hide or delete" button
    Then I see "Provide details relating to this action" on the page

    When I set "Comments" to "DMP-4035"
    Then I see "You have 248 characters remaining" on the page
    When I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    When I press the "Continue" button
    Then I see "Important" on the page
    And I see "This file is hidden in DARTS" on the page
    And I see "DARTS users cannot view this file. You can unhide the file." on the page
    And I see "Hidden by - Darts Admin" on the page
    And I see "Reason - Other reason to hide only" on the page
    And I see "T{{seq}}006 - DMP-4035" on the page

    When I get audios for hearing "{{hea_id}}"
    Then I see that the json response is empty
    And I see table CASE_AUDIO column is_hidden is "t" where med_id = "{{med_id}}"
    And I see table CASE_AUDIO column med.is_deleted is "f" where med_id = "{{med_id}}"

    When I click on the "Back" link
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to DARTS as an requester user
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "<caseId>" link
    And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I see "There is no audio for this hearing date" on the page

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to the admin portal as an Admin user
    And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
    And I click on the "Search" link
    And I see "You can search for cases, hearings, events and audio." on the page
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I click on the "{{med_id}}" link
    And I press the "Unhide" button
    And I click on the "Back" link
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to DARTS as an requester user
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "<caseId>" link
    And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I verify the HTML table contains the following values
      | *NO-CHECK* | Time                    | Event           | Text          |
      | *NO-CHECK* | <startTime> - <endTime> | *NO-CHECK*      | *NO-CHECK*    |
      | *NO-CHECK* | 10:00:00                | Hearing started | B{{seq}}ABC-6 |

    Examples:
      | courthouse         | courtroom  | caseId      | startTime | endTime  |
      | Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | 10:01:00  | 10:02:00 |

  @DMP-4035 @regression @review
  Scenario Outline: Admin user can delete audio
    Given I am logged on to the admin portal as an Admin user
    And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
    And I click on the "Search" link
    And I see "You can search for cases, hearings, events and audio." on the page
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I click on the "{{med_id}}" link
    And I press the "Hide or delete" button
    And I press the "Hide or delete" button
    Then I see "Select a reason for hiding and/or deleting the file" on the page

    When I select the "<reason>" radio button
    And I press the "Hide or delete" button
    Then I see "Enter a ticket reference" on the page

    When I set "Enter ticket reference" to "<ticketNo>"
    And I press the "Hide or delete" button
    Then I see "Provide details relating to this action" on the page

    When I set "Comments" to "DMP-4035"
    Then I see "You have 248 characters remaining" on the page
    When I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    When I press the "Continue" button
    Then I see "Important" on the page
    And I see "This file is hidden in DARTS and is marked for manual deletion" on the page
    And I see "DARTS user cannot view this file. You can unmark for deletion and it will no longer be hidden." on the page
    And I see "Marked for manual deletion by - Darts Admin" on the page
    And I see "Reason - <reason>" on the page
    And I see "<ticketNo> - DMP-4035" on the page

    When I click on the "Back" link
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to DARTS as an requester user
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "<caseId>" link
    And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I see "There is no audio for this hearing date" on the page

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to the admin portal as an Admin user
    And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
    And I click on the "Search" link
    And I see "You can search for cases, hearings, events and audio." on the page
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I select column hea_id from table CASE_HEARING where courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and case_number = "<caseId>"
    And I get audios for hearing "{{hea_id}}"
#		Then I see "" in the json response is ""

    When I click on the "{{med_id}}" link
    And I press the "Unmark for deletion and unhide" button
    And I click on the "Back" link
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I Sign out
    Then I see "Sign in to the DARTS Portal" on the page

    When I am logged on to DARTS as an requester user
    And I set "Case ID" to "<caseId>"
    And I press the "Search" button
    And I click on the "<caseId>" link
    And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I verify the HTML table contains the following values
      | *NO-CHECK* | Time                    | Event           | Text       |
      | *NO-CHECK* | 10:00:00                | Hearing started | <text>     |
      | *NO-CHECK* | <startTime> - <endTime> | *NO-CHECK*      | *NO-CHECK* |

    Examples:
      | courthouse         | courtroom  | caseId      | startTime | endTime  | reason                    | ticketNo    | text          |
      | Harrow Crown Court | B{{seq}}-7 | B{{seq}}007 | 10:01:00  | 10:02:00 | Public interest immunity  | T{{seq}}007 | B{{seq}}ABC-7 |
      | Harrow Crown Court | B{{seq}}-8 | B{{seq}}008 | 10:01:00  | 10:02:00 | Classified above official | T{{seq}}008 | B{{seq}}ABC-8 |
      | Harrow Crown Court | B{{seq}}-9 | B{{seq}}009 | 10:01:00  | 10:02:00 | Other reason to delete    | T{{seq}}009 | B{{seq}}ABC-9 |

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

  @DMP-4442
  Scenario: Data creation for Audio file deletion
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors               | defenders               |
      | Harrow Crown Court | {{seq}}-47 | I{{seq}}001 | DefI {{seq}}-47 | JudgeI {{seq}}-47 | testprosecutorfourtyseven | testdefenderfourtyseven |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}075 | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{seq}}ABC-47 | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}076 | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{seq}}GHI-47 | {{timestamp-10:31:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
      | Harrow Crown Court | {{seq}}-47 | I{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1.mp2 |

  @DMP-4442 @DMP-4573
  Scenario: Admin user can delete audio
    Given I am logged on to the admin portal as an ADMIN user
    And I set "Case ID" to "I{{seq}}001"
    And I select the "Audio" radio button
    And I press the "Search" button
    And I click on "1" in the same row as "Harrow Crown Court"
    And I press the "Hide or delete" button
    And I select the "Public interest immunity" radio button
    And I set "Enter ticket reference" to "A{{seq}}"
    And I set "Comments" to "Rejecting audio deletion request" and click away
    And I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page

    And I press the "Continue" button
    Then I see "This file is hidden in DARTS and is marked for manual deletion" on the page
    And I see "Marked for manual deletion by - Darts Admin" on the page
    And I see "Reason - Public interest immunity" on the page
    And I see "A{{seq}} - Rejecting audio deletion request" on the page
    And I Sign out
    And I see "Sign in to the DARTS Portal" on the page

    #Sign in as as Admin 2 to reject audio deletion request and DMP-4573 Cancel link
    When I am logged on to the admin portal as an ADMIN2 user
    And I click on the "File deletion" link
    And I press the "Delete" button in the same row as "Harrow Crown Court" "{{seq}}-47"
    And I see "Delete audio file" on the page
    And I see "Audio file deletion details" on the page
    And I click on the "Cancel" link
    And I see "Files marked for deletion" on the page
    And I press the "Delete" button in the same row as "Harrow Crown Court" "{{seq}}-47"
    And I see "Delete audio file" on the page
    And I see "Audio file deletion details" on the page
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{seq}}-47" in the same row as "Courtroom"
    And I see "{{displaydate}} 10:30:00" in the same row as "Start time"
    And I see "{{displaydate}} 10:31:00" in the same row as "End time"
    And I see "Darts Admin" in the same row as "Marked by"
    And I see "Public interest immunity" in the same row as "Deletion reason"
    And I see "A{{seq}}" in the same row as "Ticket reference"
    And I see "Rejecting audio deletion request" in the same row as "Comments"

    Then I verify the HTML table contains the following values
    | Audio ID   | Channel| Max channel| Is current?| No. of versions|
    | *NO-CHECK* | 1      | 1          | Yes        | 1              |

    And I see "By checking this box, you are confirming that you have reviewed all versions of the above audio" on the page
    And I see "file(s) marked to be deleted and understand that by deleting the audio file(s), all versions of the" on the page
    And I see "the file(s) will be deleted." on the page

    And I see "Approve or reject file deletion?" on the page
    And I see "Approve" on the page
    And I see "Reject and unhide" on the page
    And I press the "Confirm" button

    Then I see "You must confirm that you have reviewed all versions and understand that all versions of the listed audio file(s) will be deleted" on the page
    And I see "Select your decision" on the page

    Then I check the "By checking this box, you are confirming that you have reviewed all versions of the above audio" checkbox
    And I select the "Reject and unhide" radio button
    And I press the "Confirm" button

    Then I see "There are other audio files associated with the file" on the page
    And I see "you are unhiding/unmarking for deletion" on the page
    And I see "The files you are unhiding and/or unmarking for deletion" on the page
    Then I verify the HTML table contains the following values
    | *NO-CHECK* | Audio ID   | Courthouse          | Courtroom  | Start time           | End time             | Channel number  | Is current?|
    | *NO-CHECK* | *NO-CHECK* | Harrow Crown Court  | {{seq}}-47 | {{displaydate}} 10:30:00 | {{displaydate}} 10:31:00 | 1               | Yes        |

    And I press the "Continue" button
    Then I see "Audio file(s) unhidden / unmarked for deletion" on the page

    #Request deletion
    And I press the "Hide or delete" button
    And I select the "Public interest immunity" radio button
    And I set "Enter ticket reference" to "A{{seq}}"
    And I set "Comments" to "Approving audio deletion request" and click away
    And I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page

    And I press the "Continue" button
    Then I see "This file is hidden in DARTS and is marked for manual deletion" on the page
    And I see "Marked for manual deletion by - Darts Admin2" on the page
    And I see "Reason - Public interest immunity" on the page
    And I see "A{{seq}} - Approving audio deletion request" on the page
    And I Sign out

    #Sign in as an Admin to approve audio deletion request
    And I am logged on to the admin portal as an ADMIN user
    And I click on the "File deletion" link
    And I press the "Delete" button in the same row as "Harrow Crown Court" "{{seq}}-47"
    And I check the "By checking this box, you are confirming that you have reviewed all versions of the above audio" checkbox
    And I select the "Approve" radio button
    And I press the "Confirm" button

    Then I see "Audio file deleted" on the page
    And I do not see "{{seq}}-47" on the page

  @DMP-4442
  Scenario: Admin user can delete audio
    Given I am logged on to the admin portal as an ADMIN user
    And I set "Case ID" to "I{{seq}}001"
    And I select the "Audio" radio button
    And I press the "Search" button
    And I click on "1" in the same row as "Harrow Crown Court"
    And I press the "Hide or delete" button
    And I select the "Public interest immunity" radio button
    And I set "Enter ticket reference" to "A{{seq}}"
    And I set "Comments" to "Rejecting audio deletion request" and click away
    And I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page

    And I press the "Continue" button
    Then I see "This file is hidden in DARTS and is marked for manual deletion" on the page
    And I see "Marked for manual deletion by - Darts Admin" on the page
    And I see "Reason - Public interest immunity" on the page
    And I see "A{{seq}} - Rejecting audio deletion request" on the page
    And I Sign out

  #Sign in as as Admin 2 to reject audio deletion request
    And I am logged on to the admin portal as an ADMIN2 user
    And I click on the "File deletion" link
    And I press the "Delete" button in the same row as "Harrow Crown Court" "{{seq}}-47"
    And I see "Delete audio file" on the page
    And I see "Audio file deletion details" on the page
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{seq}}-47" in the same row as "Courtroom"
    And I see "{{displaydate}} 10:30:00" in the same row as "Start time"
    And I see "{{displaydate}} 10:31:00" in the same row as "End time"
    And I see "Darts Admin" in the same row as "Marked by"
    And I see "Public interest immunity" in the same row as "Deletion reason"
    And I see "A{{seq}}" in the same row as "Ticket reference"
    And I see "Rejecting audio deletion request" in the same row as "Comments"

    Then I verify the HTML table contains the following values
      | Audio ID   | Channel| Max channel| Is current?| No. of versions|
      | *NO-CHECK* | 1      | 1          | Yes        | 1              |

    And I see "By checking this box, you are confirming that you have reviewed all versions of the above audio" on the page
    And I see "file(s) marked to be deleted and understand that by deleting the audio file(s), all versions of the" on the page
    And I see "the file(s) will be deleted." on the page

    And I see "Approve or reject file deletion?" on the page
    And I see "Approve" on the page
    And I see "Reject and unhide" on the page
    And I press the "Confirm" button

    Then I see "You must confirm that you have reviewed all versions and understand that all versions of the listed audio file(s) will be deleted" on the page
    And I see "Select your decision" on the page

    Then I check the "By checking this box, you are confirming that you have reviewed all versions of the above audio" checkbox
    And I select the "Reject and unhide" radio button
    And I press the "Confirm" button

    Then I see "There are other audio files associated with the file" on the page
    And I see "you are unhiding/unmarking for deletion" on the page
    And I see "The files you are unhiding and/or unmarking for deletion" on the page
    Then I verify the HTML table contains the following values
      | *NO-CHECK* | Audio ID   | Courthouse          | Courtroom  | Start time           | End time             | Channel number  | Is current?|
      | *NO-CHECK* | *NO-CHECK* | Harrow Crown Court  | {{seq}}-47 | {{displaydate}} 10:30:00 | {{displaydate}} 10:31:00 | 1               | Yes        |

    And I press the "Continue" button
    Then I see "Audio file(s) unhidden / unmarked for deletion" on the page

  #Request deletion
    And I press the "Hide or delete" button
    And I select the "Public interest immunity" radio button
    And I set "Enter ticket reference" to "A{{seq}}"
    And I set "Comments" to "Approving audio deletion request" and click away
    And I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page

    And I press the "Continue" button
    Then I see "This file is hidden in DARTS and is marked for manual deletion" on the page
    And I see "Marked for manual deletion by - Darts Admin2" on the page
    And I see "Reason - Public interest immunity" on the page
    And I see "A{{seq}} - Approving audio deletion request" on the page
    And I Sign out

  #Sign in as an Admin to approve audio deletion request
    And I am logged on to the admin portal as an ADMIN user
    And I click on the "File deletion" link
    And I press the "Delete" button in the same row as "Harrow Crown Court" "{{seq}}-47"
    And I check the "By checking this box, you are confirming that you have reviewed all versions of the above audio" checkbox
    And I select the "Approve" radio button
    And I press the "Confirm" button

    Then I see "Audio file deleted" on the page
    And I do not see "{{seq}}-47" on the page
