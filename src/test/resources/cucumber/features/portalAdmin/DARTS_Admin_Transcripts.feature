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

  @DMP-1265 @DMP-2525 @DMP-2538 @DMP-3133 @regression @MissingData
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

    When I set the time fields below "Start time" to "09:30:00"
    And I set the time fields below "End time" to "09:31:00"
    #When I check the checkbox in the same row as "10:30:00" "Hearing started"
    #And I check the checkbox in the same row as "10:31:00" "Hearing ended"
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

    When I set the time fields below "Start time" to "10:00:00"
    And I set the time fields below "End time" to "10:01:00"
    #When I check the checkbox in the same row as "11:00:00" "Hearing started"
    #And I check the checkbox in the same row as "11:01:00" "Hearing ended"
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

    When I set the time fields below "Start time" to "10:30:00"
    And I set the time fields below "End time" to "10:31:00"
    #When I check the checkbox in the same row as "11:30:00" "Hearing started"
    #And I check the checkbox in the same row as "11:31:00" "Hearing ended"
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

    When I set the time fields below "Start time" to "11:00:00"
    And I set the time fields below "End time" to "11:01:00"
    #When I check the checkbox in the same row as "12:00:00" "Hearing started"
    #And I check the checkbox in the same row as "12:01:00" "Hearing ended"
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

    When I set the time fields below "Start time" to "11:30:00"
    And I set the time fields below "End time" to "11:31:00"
    #When I check the checkbox in the same row as "12:30:00" "Hearing started"
    #And I check the checkbox in the same row as "12:31:00" "Hearing ended"
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
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to requested scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
    And I see "Requested by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to requested for case 1" on the page

    #Case 2: Awaiting authorisation -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}002"
    And I press the "Search" button
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to closed scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 2" on the page

    #Case 3: Approved -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}003"
    And I press the "Search" button
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for approved to closed scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 3" on the page

    #Case 4: With transcriber -> Approved

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}004"
    And I press the "Search" button
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for with transcriber to approved scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "With Transcriber by Transcriber (darts.transcriber@hmcts.net)" on the page
    And I see "Approved by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to approved for case 4" on the page

    #Case 5: With transcriber -> Closed

    When I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}005"
    And I press the "Search" button
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for with transcriber to closed scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
    And I see "Approved by Approver (darts.approver@hmcts.net)" on the page
    And I see "With Transcriber by Transcriber (darts.transcriber@hmcts.net)" on the page
    And I see "Closed by Darts Admin (darts.admin@hmcts.net)" on the page
    And I see "Changing status to closed for case 5" on the page

    #Case 1: Requested -> Closed (using case 1 again)

    And I click on the "Transcripts" link
    And I click on the "Advanced search" link
    And I set "Case ID" to "G{{seq}}001"
    And I press the "Search" button
    #TODO: This requires a way for auto to know the request ID
    #And I click on the "Request ID" link
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
    Then I see "Requested by Requester (darts.requester@hmcts.net)" on the page
    And I see "This transcript request is for awaiting authorisation to requested scenario" on the page
    And I see "Awaiting Authorisation by Requester (darts.requester@hmcts.net)" on the page
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