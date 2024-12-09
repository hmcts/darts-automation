@admin @admin_transcripts
Feature: Admin portal transcripts

  @DMP-1265 @DMP-2525 @DMP-2538 @DMP-3133 @regression
  Scenario: Admin change transcription status data creation
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors               | defenders               |
      | Harrow Crown Court | {{seq}}-40 | G{{seq}}001 | DefG {{seq}}-40 | JudgeG {{seq}}-40 | testprosecutorfourty      | testdefenderfourty      |
      | Harrow Crown Court | {{seq}}-41 | G{{seq}}002 | DefG {{seq}}-41 | JudgeG {{seq}}-41 | testprosecutorfourtyone   | testdefenderfourtyone   |
      | Harrow Crown Court | {{seq}}-42 | G{{seq}}003 | DefG {{seq}}-42 | JudgeG {{seq}}-42 | testprosecutorfourtytwo   | testdefenderfourtytwo   |
      | Harrow Crown Court | {{seq}}-43 | G{{seq}}004 | DefG {{seq}}-43 | JudgeG {{seq}}-43 | testprosecutorfourtythree | testdefenderfourtythree |
      | Harrow Crown Court | {{seq}}-44 | G{{seq}}005 | DefG {{seq}}-44 | JudgeG {{seq}}-44 | testprosecutorfourtyfour  | testdefenderfourtyfour  |
      | Harrow Crown Court | {{seq}}-45 | G{{seq}}006 | DefG {{seq}}-45 | JudgeG {{seq}}-45 | testprosecutorfourtyfive  | testdefenderfourtyfive  |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}040 | Harrow Crown Court | {{seq}}-40 | G{{seq}}001  | {{seq}}ABC-40 | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}041 | Harrow Crown Court | {{seq}}-40 | G{{seq}}001  | {{seq}}GHI-40 | {{timestamp-10:31:00}} |                             |                     |
      | {{seq}}001 | 1100 |          | {{seq}}042 | Harrow Crown Court | {{seq}}-41 | G{{seq}}002  | {{seq}}ABC-41 | {{timestamp-11:00:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}043 | Harrow Crown Court | {{seq}}-41 | G{{seq}}002  | {{seq}}GHI-41 | {{timestamp-11:01:00}} |                             |                     |
      | {{seq}}001 | 1100 |          | {{seq}}044 | Harrow Crown Court | {{seq}}-42 | G{{seq}}003  | {{seq}}ABC-42 | {{timestamp-11:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}045 | Harrow Crown Court | {{seq}}-42 | G{{seq}}003  | {{seq}}DEF-42 | {{timestamp-11:31:00}} |                             |                     |
      | {{seq}}001 | 1100 |          | {{seq}}046 | Harrow Crown Court | {{seq}}-43 | G{{seq}}004  | {{seq}}ABC-43 | {{timestamp-12:00:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}047 | Harrow Crown Court | {{seq}}-43 | G{{seq}}004  | {{seq}}DEF-43 | {{timestamp-12:01:00}} |                             |                     |
      | {{seq}}001 | 1100 |          | {{seq}}048 | Harrow Crown Court | {{seq}}-44 | G{{seq}}005  | {{seq}}ABC-44 | {{timestamp-12:30:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}049 | Harrow Crown Court | {{seq}}-44 | G{{seq}}005  | {{seq}}DEF-44 | {{timestamp-12:31:00}} |                             |                     |
      | {{seq}}001 | 1100 |          | {{seq}}050 | Harrow Crown Court | {{seq}}-45 | G{{seq}}006  | {{seq}}ABC-45 | {{timestamp-13:00:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}051 | Harrow Crown Court | {{seq}}-45 | G{{seq}}006  | {{seq}}DEF-45 | {{timestamp-13:01:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile |
      | Harrow Crown Court | {{seq}}-40 | G{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1.mp2   |
      | Harrow Crown Court | {{seq}}-41 | G{{seq}}002  | {{date+0/}} | 11:00:00  | 11:01:00 | sample1.mp2   |
      | Harrow Crown Court | {{seq}}-42 | G{{seq}}003  | {{date+0/}} | 11:30:00  | 11:31:00 | sample1.mp2   |
      | Harrow Crown Court | {{seq}}-43 | G{{seq}}004  | {{date+0/}} | 12:00:00  | 12:01:00 | sample1.mp2   |
      | Harrow Crown Court | {{seq}}-44 | G{{seq}}005  | {{date+0/}} | 12:30:00  | 12:31:00 | sample1.mp2   |
      | Harrow Crown Court | {{seq}}-45 | G{{seq}}006  | {{date+0/}} | 13:00:00  | 13:01:00 | sample1.mp2   |

  @DMP-1265 @DMP-2525 @DMP-2538 @DMP-3133 @regression @review
  Scenario: Change manual transcription status

    Given I am logged on to DARTS as an REQUESTER user

    #Awaiting authorisation -> Requested

    And I click on the "Search" link
    And I set "Case ID" to "G{{seq}}001"
    And I press the "Search" button
    And I click on "G{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

#    When I set the time fields below "Start time" to "09:30:00"
#    And I set the time fields below "End time" to "09:31:00"
    When I check the checkbox in the same row as "10:30:00" "Hearing started"
    And I check the checkbox in the same row as "10:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "G{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefG {{seq}}-40" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for awaiting authorisation to requested scenario"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #Awaiting authorisation -> Closed

    And I click on the "Search" link
    And I set "Case ID" to "G{{seq}}002"
    And I press the "Search" button
    And I click on "G{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

#    When I set the time fields below "Start time" to "10:00:00"
#    And I set the time fields below "End time" to "10:01:00"
    When I check the checkbox in the same row as "11:00:00" "Hearing started"
    And I check the checkbox in the same row as "11:01:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "G{{seq}}002" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefG {{seq}}-41" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for awaiting authorisation to closed scenario"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #Approved -> Closed

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    And I click on "G{{seq}}003" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

#    When I set the time fields below "Start time" to "10:30:00"
#    And I set the time fields below "End time" to "10:31:00"
    When I check the checkbox in the same row as "11:30:00" "Hearing started"
    And I check the checkbox in the same row as "11:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "G{{seq}}003" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefG {{seq}}-42" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for approved to closed scenario"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #With transcriber -> Approved

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}004"
    And I press the "Search" button
    And I click on "G{{seq}}004" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

#    When I set the time fields below "Start time" to "11:00:00"
#    And I set the time fields below "End time" to "11:01:00"
    When I check the checkbox in the same row as "12:00:00" "Hearing started"
    And I check the checkbox in the same row as "12:01:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "G{{seq}}004" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefG {{seq}}-43" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for with transcriber to approved scenario"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #With transcriber -> Closed

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}005"
    And I press the "Search" button
    And I click on "G{{seq}}005" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

#    When I set the time fields below "Start time" to "11:30:00"
#    And I set the time fields below "End time" to "11:31:00"
    When I check the checkbox in the same row as "12:30:00" "Hearing started"
    And I check the checkbox in the same row as "12:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "G{{seq}}005" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefG {{seq}}-44" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "This transcript request is for with transcriber to closed scenario"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #Approve requests for cases 3, 4 and 5

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
#    And I click on the "Transcript requests to review" link
    And I click on "View" in the same row as "G{{seq}}003"
    And I see "This transcript request is for approved to closed scenario" in the same row as "Instructions"
    And I select the "Yes" radio button
    And I press the "Submit" button
#    And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    And I do not see "G{{seq}}003" on the page

    When I click on "View" in the same row as "G{{seq}}004"
    And I see "This transcript request is for with transcriber to approved scenario" in the same row as "Instructions"
    And I select the "Yes" radio button
    And I press the "Submit" button
#    And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    And I do not see "G{{seq}}004" on the page

    When I click on "View" in the same row as "G{{seq}}005"
    And I see "This transcript request is for with transcriber to closed scenario" in the same row as "Instructions"
    And I select the "Yes" radio button
    And I press the "Submit" button
#    And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    And I do not see "G{{seq}}005" on the page

    #DMP-3133-AC1 Check status is "With Transcriber" instead of "Approved"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    And I click on the "G{{seq}}003" link
    And I click on the "All Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    #Checking Requester as well

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    And I click on the "G{{seq}}003" link
    And I click on the "All Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    #Assign to transcriber for cases 4 and 5

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "G{{seq}}004"
    And I click on "View" in the same row as "G{{seq}}004"
    And I select the "Assign to me" radio button
    And I press the "Continue" button
    Then I see "G{{seq}}004" on the page

    When I click on the "Completed today" link
    Then I do not see "G{{seq}}004" on the page

    When I click on the "Transcript requests" link
    And I see "Manual" in the same row as "G{{seq}}005"
    And I click on "View" in the same row as "G{{seq}}005"
    And I select the "Assign to me" radio button
    And I press the "Continue" button
    And I click on the "To do" link
    Then I see "G{{seq}}005" on the page

    When I click on the "Completed today" link
    Then I do not see "G{{seq}}005" on the page

    #DMP-3133-AC2 Check status is still "With Transcriber"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}005"
    And I press the "Search" button
    And I click on the "G{{seq}}005" link
    And I click on the "All Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "With Transcriber" in the same row as "Specified Times"

    #Case 1: Awaiting authorisation -> Requested

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to the admin portal as an ADMIN user
    And I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}001"
    And I press the "Search" button
    #DMP-2525-AC1 and AC2 Transcript request details and stages
    Then I see "Current status" on the page
    And I see "Awaiting Authorisation" in the same row as "Status"
    And I see "Assigned to" on the page
    And I do not see "Associated groups" on the page
    And I see "Request details" on the page
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Manual" in the same row as "Request method"
    And I see "Request ID" on the page
    And I see "Overnight" in the same row as "Urgency"
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for transcript"
    And I see "Requested by" on the page
    And I see "Received" on the page
    And I see "This transcript request is for awaiting authorisation to requested scenario" in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"
    And I see "Case details" on the page
    And I see "G{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-40}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-40" in the same row as "Defendant(s)"

    #DMP-2525-AC3 and DMP-1265 Change status link and process
    When I click on the "Change status" link
    And I select "Requested" from the "Select status" dropdown
    And I see "You have 256 characters remaining" on the page
    And I set "Comment (optional)" to "Changing status to requested for case 1"
    And I see "You have 217 characters remaining" on the page
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Requested" in the same row as "Status"
    And I do not see "Associated groups" on the page

    #DMP-2538 Transcript request history
    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to requested scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Requested by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to requested for case 1" on the page

    #Case 2: Awaiting authorisation -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}002"
    And I press the "Search" button
    Then I see "Awaiting Authorisation" in the same row as "Status"
    And I do not see "Associated groups" on the page
    And I see "Start time 11:00:00 - End time 11:01:00" in the same row as "Audio for transcript"
    And I see "This transcript request is for awaiting authorisation to closed scenario" in the same row as "Instructions"
    And I see "G{{seq}}002" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-41}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-41" in the same row as "Defendant(s)"

    When I click on the "Change status" link
    And I select "Closed" from the "Select status" dropdown
    And I see "You have 256 characters remaining" on the page
    And I set "Comment (optional)" to "Changing status to closed for case 2"
    And I see "You have 220 characters remaining" on the page
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Closed" in the same row as "Status"

    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to closed scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 2" on the page

    #Case 3: Approved -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    #DMP-3133-AC1 Check status is "Approved" and not "With Transcriber"
    Then I see "Approved" in the same row as "Status"
    And I see "Associated groups" on the page
    And I see "Start time 11:30:00 - End time 11:31:00" in the same row as "Audio for transcript"
    And I see "This transcript request is for approved to closed scenario" in the same row as "Instructions"
    And I see "G{{seq}}003" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-42}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-42" in the same row as "Defendant(s)"

    When I click on the "Change status" link
    And I select "Closed" from the "Select status" dropdown
    And I see "You have 256 characters remaining" on the page
    And I set "Comment (optional)" to "Changing status to closed for case 3"
    And I see "You have 220 characters remaining" on the page
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Closed" in the same row as "Status"

    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for approved to closed scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 3" on the page

    #Case 4: With transcriber -> Approved

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}004"
    And I press the "Search" button
    Then I see "With Transcriber" in the same row as "Status"
    And I see "Associated groups" on the page
    And I see "Start time 12:00:00 - End time 12:01:00" in the same row as "Audio for transcript"
    And I see "This transcript request is for with transcriber to approved scenario" in the same row as "Instructions"
    And I see "G{{seq}}004" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-43}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-43" in the same row as "Defendant(s)"

    When I click on the "Change status" link
    And I select "Approved" from the "Select status" dropdown
    And I see "You have 256 characters remaining" on the page
    And I set "Comment (optional)" to "Changing status to approved for case 4"
    And I see "You have 218 characters remaining" on the page
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Approved" in the same row as "Status"

    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for with transcriber to approved scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "With Transcriber by Transcriber (darts.transcriber@hmcts.net)" on the page
    And I see "Approved by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to approved for case 4" on the page

    #Case 5: With transcriber -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}005"
    And I press the "Search" button
    #DMP-3133-AC2 Check status is still "With Transcriber"
    Then I see "With Transcriber" in the same row as "Status"
    And I see "Associated groups" on the page
    And I see "Start time 12:30:00 - End time 12:31:00" in the same row as "Audio for transcript"
    And I see "This transcript request is for with transcriber to closed scenario" in the same row as "Instructions"
    And I see "G{{seq}}005" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-44}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-44" in the same row as "Defendant(s)"

    When I click on the "Change status" link
    And I select "Closed" from the "Select status" dropdown
    And I see "You have 256 characters remaining" on the page
    And I set "Comment (optional)" to "Changing status to closed for case 5"
    And I see "You have 220 characters remaining" on the page
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Closed" in the same row as "Status"

    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for with transcriber to closed scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "With Transcriber by Transcriber (darts.transcriber@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 5" on the page

    #Case 1: Requested -> Closed (using case 1 again)

    And I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}001"
    And I press the "Search" button
    Then I see "Current status" on the page
    And I see "Requested" in the same row as "Status"
    And I do not see "Associated groups" on the page
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for transcript"
    And I see "This transcript request is for awaiting authorisation to requested scenario" in the same row as "Instructions"
    And I see "G{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeG {{seq}}-40}}" in the same row as "Judge(s)"
    And I see "DefG {{seq}}-40" in the same row as "Defendant(s)"

    When I click on the "Change status" link
    And I select "Closed" from the "Select status" dropdown
    And I set "Comment (optional)" to "Changing status to closed for case 1"
    And I press the "Save changes" button
    Then I see "Status updated" on the page
    And I see "Closed" in the same row as "Status"

    When I click on the "History" link
    Then I see "Requested by Requestor (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to requested scenario" on the page
    And I see "Awaiting Authorisation by Requestor (darts.requester@hmcts.net)" on the page
    And I see "Requested by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to requested for case 1" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 1" on the page

    #Check back on requester to confirm correct statuses

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a REQUESTER user
    And I click on the "Search" link
    And I set "Case ID" to "G{{seq}}001"
    And I press the "Search" button
    And I click on "G{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}002"
    And I press the "Search" button
    And I click on "G{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    And I click on "G{{seq}}003" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}004"
    And I press the "Search" button
    And I click on "G{{seq}}004" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    And I see "With Transcriber" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I see "With Transcriber" in the same row as "Specified Times"

    When I click on the "Search" link
    And I set "Case ID" to "G{{seq}}005"
    And I press the "Search" button
    And I click on "G{{seq}}005" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I see "Closed" in the same row as "Specified Times"

    #Check transcriber

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    Then I see "Manual" in the same row as "G{{seq}}004"

    #Case 1: Awaiting authorisation -> Requested then Requested -> Closed

    #Case 2: Awaiting authorisation -> Closed

    #Case 3: Approved -> Closed

    #Case 4: With transcriber -> Approved

    #Case 5: With transcriber -> Closed
	

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

