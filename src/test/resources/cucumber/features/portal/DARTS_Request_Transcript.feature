Feature: Request Transcript

  @DMP-696 @DMP-862 @DMP-868 @DMP-872 @DMP-892 @DMP-917 @DMP-925 @DMP-934 @DMP-1009 @DMP-1011 @DMP-1012 @DMP-1025 @DMP-1028 @DMP-1033 @DMP-1053 @DMP-1054 @DMP-1138 @DMP-1198 @DMP-1203 @DMP-1234 @DMP-1243 @DMP-1326 @DMP-2123 @DMP-2124 @regression
  Scenario: Request Transcription data creation
    Given I create a case using json
      | courthouse         | case_number | defendants      | judges            | prosecutors            | defenders            |
      | Harrow Crown Court | C{{seq}}001 | DefC {{seq}}-8  | JudgeC {{seq}}-8  | testprosecutoreight    | testdefendereight    |
      | Harrow Crown Court | C{{seq}}002 | DefC {{seq}}-9  | JudgeC {{seq}}-9  | testprosecutornine     | testdefendernine     |
      | Harrow Crown Court | C{{seq}}003 | DefC {{seq}}-10 | JudgeC {{seq}}-10 | testprosecutorten      | testdefenderten      |
      | Harrow Crown Court | C{{seq}}004 | DefC {{seq}}-11 | JudgeC {{seq}}-11 | testprosecutoreleven   | testdefendereleven   |
      | Harrow Crown Court | C{{seq}}005 | DefC {{seq}}-12 | JudgeC {{seq}}-12 | testprosecutortwelve   | testdefendertwelve   |
      | Harrow Crown Court | C{{seq}}006 | DefC {{seq}}-13 | JudgeC {{seq}}-13 | testprosecutorthirteen | testdefenderthirteen |
      | Harrow Crown Court | C{{seq}}007 | DefC {{seq}}-14 | JudgeC {{seq}}-14 | testprosecutorfourteen | testdefenderfourteen |

    Given I create an event using json
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100  |          | {{seq}}1008 | Harrow Crown Court | {{seq}}-8  | C{{seq}}001  | {{seq}}ABC-8  | {{timestamp-10:00:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1009 | Harrow Crown Court | {{seq}}-9  | C{{seq}}002  | {{seq}}ABC-9  | {{timestamp-10:30:00}} |                             |                     |
      | {{seq}}001 | 21200 | 11008    | {{seq}}1010 | Harrow Crown Court | {{seq}}-9  | C{{seq}}002  | {{seq}}DEF-9  | {{timestamp-10:30:30}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1011 | Harrow Crown Court | {{seq}}-9  | C{{seq}}002  | {{seq}}GHI-9  | {{timestamp-10:31:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1012 | Harrow Crown Court | {{seq}}-10 | C{{seq}}003  | {{seq}}ABC-10 | {{timestamp-11:00:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1013 | Harrow Crown Court | {{seq}}-10 | C{{seq}}003  | {{seq}}DEF-10 | {{timestamp-11:01:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1014 | Harrow Crown Court | {{seq}}-11 | C{{seq}}004  | {{seq}}ABC-11 | {{timestamp-11:30:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1015 | Harrow Crown Court | {{seq}}-11 | C{{seq}}004  | {{seq}}DEF-11 | {{timestamp-11:31:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1016 | Harrow Crown Court | {{seq}}-12 | C{{seq}}005  | {{seq}}ABC-12 | {{timestamp-12:00:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1017 | Harrow Crown Court | {{seq}}-12 | C{{seq}}005  | {{seq}}DEF-12 | {{timestamp-12:01:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1018 | Harrow Crown Court | {{seq}}-13 | C{{seq}}006  | {{seq}}ABC-13 | {{timestamp-12:30:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1019 | Harrow Crown Court | {{seq}}-13 | C{{seq}}006  | {{seq}}DEF-13 | {{timestamp-12:31:00}} |                             |                     |
      | {{seq}}001 | 1100  |          | {{seq}}1020 | Harrow Crown Court | {{seq}}-14 | C{{seq}}007  | {{seq}}ABC-14 | {{timestamp-13:00:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1021 | Harrow Crown Court | {{seq}}-14 | C{{seq}}007  | {{seq}}DEF-14 | {{timestamp-13:01:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile |
      | Harrow Crown Court | {{seq}}-9  | C{{seq}}002  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1   |
      | Harrow Crown Court | {{seq}}-10 | C{{seq}}003  | {{date+0/}} | 11:00:00  | 11:01:00 | sample1   |
      | Harrow Crown Court | {{seq}}-11 | C{{seq}}004  | {{date+0/}} | 11:30:00  | 11:31:00 | sample1   |
      | Harrow Crown Court | {{seq}}-12 | C{{seq}}005  | {{date+0/}} | 12:00:00  | 12:01:00 | sample1   |
      | Harrow Crown Court | {{seq}}-13 | C{{seq}}006  | {{date+0/}} | 12:30:00  | 12:31:00 | sample1   |
      | Harrow Crown Court | {{seq}}-14 | C{{seq}}007  | {{date+0/}} | 13:00:00  | 13:01:00 | sample1   |

  @DMP-862 @DMP-917 @DMP-925 @DMP-934 @DMP-1011 @DMP-1012 @DMP-1025 @DMP-1033 @DMP-1138 @DMP-1198 @DMP-1203 @DMP-1234 @DMP-1243 @regression
  Scenario: Request Transcription, Specified Times with Event Checkboxes

    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    When I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    #DMP-862-AC3 Request Transcript button works
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "There are restrictions against this hearing" on the page
    And I see "C{{seq}}002" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefC {{seq}}-9" on the page
    And I see "{{displaydate}}" on the page

   #@DMP-892-AC1 and @DMP-892-AC4 Specified Times option (Court Log different scenario) and Urgency populated
    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page
    And I see "Select events or specify start and end times to request a transcript." on the page
    And I see "Specific times requests cover all events and audio between the transcript start and end time." on the page

    #DMP-917-AC1 Setting specific time via checkboxes
    When I check the checkbox in the same row as "10:30:00" "Hearing started"
    And I check the checkbox in the same row as "10:31:00" "Hearing ended"
    And I press the "Continue" button
    #DMP-934 and DMP-917-AC2 Confirmation screen checks
    Then I see "Check and confirm your transcript request" on the page
    And I see "C{{seq}}002" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefC {{seq}}-9" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page
    And I see "You have 2000 characters remaining" on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Specified Times for one minute of audio selected via event checkboxes."
    And I see "You have 1908 characters remaining" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    #DMP-1012-AC1 and DMP-1138-AC1 Transcript submitted screen
    Then I see "Transcript request submitted" on the page
    And I see "What happens next?" on the page
    And I see "We’ll review it and notify you of our decision to approve or reject your request by email and through the DARTS portal." on the page

    #DMP-1138-AC2 Return to hearing date link
    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #DMP-1025-AC1 In progress on Your transcripts screen
    When I click on the "Your transcripts" link
    Then I see "C{{seq}}002" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}002"
    Then I see "Approve transcript request" on the page
    And I see "C{{seq}}002" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-9" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-9" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Specified Times" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    #DMP-1011-AC1 Approve request

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}002" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    #DMP-1198-AC1, AC3 and DMP-1203-AC4 Transcript request screen and column names/sortable columns to do
    And I see "Manual" in the same row as "C{{seq}}002"
    #DMP-1198-AC2 and DMP-1234 View transcript request order
    And I click on "View" in the same row as "C{{seq}}002"
    Then I see "Transcript Request" on the page
    And I see "C{{seq}}002" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-9" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-9" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Specified Times" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    #DMP-1243-AC2 Assign to myself

    When I select the "Assign to me" radio button
    And I press the "Continue" button
    Then I see "C{{seq}}002" on the page

    When I click on the "Completed today" link
    Then I do not see "C{{seq}}002" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}002" in the same row as "With Transcriber"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Your work" link
    #DMP-1243-AC1 Item moved to your work after assigning to transcriber
    And I click on "View" in the same row as "C{{seq}}002"
    And I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
    And I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Go to your work" link
    And I click on the "Completed today" link
    Then I see "C{{seq}}002" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    #DMP-1025-AC2 Ready on Your transcripts screen
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}002" in the same row as "Complete"

    #DMP-1033 View link from My Transcripts (shows additional fields not seen elsewhere)
    When I click on "View" in the same row as "C{{seq}}002"
    Then I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
    And I see "Complete" on the page

    When I click on the "Search" link
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    And I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    Then I see "Specified Times" in the same row as "Complete"

    #DMP-868 Check transcript after clicking View link - Case Details
    When I click on "View" in the same row as "Specified Times"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for transcript"

    When I click on the breadcrumb link "C{{seq}}002"
    #@DMP-862-AC1 See complete transcript in Hearing Details
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "Specified Times" in the same row as "Complete"

    #@DMP-862-AC2 Check transcript after clicking View link - Hearing Details
    When I click on "View" in the same row as "Specified Times"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for transcript"

    When I click on the "Search" link
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    And I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    And I check the checkbox in the same row as "10:30:00" "Hearing started"
    And I check the checkbox in the same row as "10:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    #DMP-925-AC1 Transcript already exists
    When I set "Comments to the Transcriber (optional)" to "Doing repeat request, shouldn't go through."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "This transcript was requested already" on the page
    And I see "If the request is complete, a transcript will be available below." on the page

    #DMP-925-AC2 Go to transcript link
    When I click on the "Go to transcript" link
    Then I see "file-sample_1MB.doc" on the page
    And I see "C{{seq}}002" on the page
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for transcript"

    When I click on the "Search" link
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    And I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    And I check the checkbox in the same row as "10:30:00" "Hearing started"
    And I check the checkbox in the same row as "10:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    When I set "Comments to the Transcriber (optional)" to "Doing repeat request, shouldn't go through."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "This transcript was requested already" on the page

    ##DMP-925-AC3 Return to hearing link
    When I click on the "Return to hearing" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Complete" in the same row as "Specified Times"

  @DMP-917 @DMP-862 @DMP-868 @DMP-934 @DMP-1011 @DMP-1012 @DMP-1138 @regression
  Scenario: Request Transcription, Court Log by Manually Entering Time
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}003"
    And I press the "Search" button
    When I click on "C{{seq}}003" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    #DMP-862-AC3 Request Transcript button works
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "C{{seq}}003" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefC {{seq}}-10" on the page
    And I see "{{displaydate}}" on the page

    #@DMP-892-AC1 and @DMP-892-AC4 Court Log option (Specified Times different scenario) and Urgency populated
    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page
    And I see "Select events or specify start and end times to request a transcript." on the page
    And I see "Specific times requests cover all events and audio between the transcript start and end time." on the page

    #DMP-917-AC1 Setting specific time via fields
    When I set the time fields below "Start time" to "11:00:00"
    And I set the time fields below "End time" to "11:01:00"
    And I press the "Continue" button
    #DMP-934 and DMP-917-AC2 Confirmation screen checks
    Then I see "Check and confirm your transcript request" on the page
    And I see "C{{seq}}003" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefC {{seq}}-10" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page
    And I see "You have 2000 characters remaining" on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio selected via manually entering time."
    And I see "You have 1908 characters remaining" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    #DMP-1012-AC1 and DMP-1138-AC1 Transcript submitted screen
    Then I see "Transcript request submitted" on the page
    And I see "What happens next?" on the page
    And I see "We’ll review it and notify you of our decision to approve or reject your request by email and through the DARTS portal." on the page

    #DMP-1138-AC2 Return to hearing date link
    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    When I click on the "Your transcripts" link
    Then I see "C{{seq}}003" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}003"
    Then I see "Approve transcript request" on the page
    And I see "C{{seq}}003" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-10" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-10" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio selected via manually entering time." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    #DMP-1011-AC1 Approve request

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}003" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "C{{seq}}003"
    And I click on "View" in the same row as "C{{seq}}003"
    Then I see "Transcript Request" on the page
    And I see "C{{seq}}003" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-10" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-10" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio selected via manually entering time." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    When I select the "Assign to me" radio button
    And I press the "Continue" button
    Then I see "C{{seq}}003" on the page

    When I click on the "Completed today" link
    Then I do not see "C{{seq}}003" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}003" in the same row as "With Transcriber"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Your work" link
    And I click on "View" in the same row as "C{{seq}}003"
    And I see "Requesting transcript Court Log for one minute of audio selected via manually entering time." in the same row as "Instructions"
    And I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Go to your work" link
    And I click on the "Completed today" link
    Then I see "C{{seq}}003" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}003" in the same row as "Complete"

    When I click on "View" in the same row as "C{{seq}}003"
    Then I see "Requesting transcript Court Log for one minute of audio selected via manually entering time." in the same row as "Instructions"
    And I see "Complete" on the page

    When I click on the "Search" link
    And I set "Case ID" to "C{{seq}}003"
    And I press the "Search" button
    And I click on "C{{seq}}003" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    #DMP-868 Check transcript after clicking View link - Case Details
    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 11:00:00 - End time 11:01:00" in the same row as "Audio for transcript"

    When I click on the breadcrumb link "C{{seq}}003"
    #@DMP-862-AC1 See complete transcript in Hearing Details
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    #@DMP-862-AC2 Check transcript after clicking View link - Hearing Details
    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 11:00:00 - End time 11:01:00" in the same row as "Audio for transcript"

  @DMP-696 @DMP-1053 @DMP-1203 @DMP-1243 @DMP-1326 @DMP-2123 @regression
  Scenario: Request Transcription, Court Log, Assign to me and get audio, complete and single delete
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}004"
    And I press the "Search" button
    When I click on "C{{seq}}004" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "C{{seq}}004" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefC {{seq}}-11" on the page
    And I see "{{displaydate}}" on the page

    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "11:30:00"
    And I set the time fields below "End time" to "11:31:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "C{{seq}}004" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefC {{seq}}-11" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio, please request audio if needed."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page
    And I see "What happens next?" on the page
    And I see "We’ll review it and notify you of our decision to approve or reject your request by email and through the DARTS portal." on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    When I click on the "Your transcripts" link
    Then I see "C{{seq}}004" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}004"
    Then I see "Approve transcript request" on the page
    And I see "C{{seq}}004" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-11" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-11" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio, please request audio if needed." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}004" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "C{{seq}}004"
    And I click on "View" in the same row as "C{{seq}}004"
    Then I see "Transcript Request" on the page
    And I see "C{{seq}}004" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-11" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-11" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio, please request audio if needed." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    #DMP-1243-AC3 Assign to myself and request audio

    When I select the "Assign to me and get audio" radio button
    And I press the "Continue" button
    Then I see "Events and audio recordings" on the page

    #DMP-696 and DMP-1326-AC1 Transcriber requests playback audio

    When I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "C{{seq}}004" on the page

    When I press the "Confirm" button
    Then I see "Your order is complete" on the page

    When I click on the "Return to hearing date" link
    Then I see "Events and audio recordings" on the page

    #DMP-1203-AC3 Your audio

    When I click on the "Your audio" link
    And I wait for text "READY" on the same row as the link "C{{seq}}004"
    And I click on "View" in the same row as "C{{seq}}004"
    Then I see "Play all audio" on the page
    And I see "mp3" on the page

    #DMP-1203-AC2 Your work

    When I click on the "Your work" link
    And I click on the "Completed today" link
    Then I do not see "C{{seq}}004" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}004" in the same row as "With Transcriber"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Your work" link
    And I click on "View" in the same row as "C{{seq}}004"
    And I see "Requesting transcript Court Log for one minute of audio, please request audio if needed." in the same row as "Instructions"
    #DMP-1326-AC2 and AC3 Upload transcript file and complete
    And I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Go to your work" link
    And I click on the "Completed today" link
    Then I see "C{{seq}}004" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}004" in the same row as "Complete"

    When I click on "View" in the same row as "C{{seq}}004"
    Then I see "Requesting transcript Court Log for one minute of audio, please request audio if needed." in the same row as "Instructions"
    And I see "Complete" on the page

    When I click on the "Search" link
    And I set "Case ID" to "C{{seq}}004"
    And I press the "Search" button
    And I click on "C{{seq}}004" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 11:30:00 - End time 11:31:00" in the same row as "Audio for transcript"

    When I click on the breadcrumb link "C{{seq}}004"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 11:30:00 - End time 11:31:00" in the same row as "Audio for transcript"

    #Delete single transcript

    When I click on the "Your transcripts" link
    When I check the checkbox in the same row as "C{{seq}}004" "Court Log"
    And I press the "Remove transcript request" button
    Then I see "Are you sure you want to remove this transcript request?" on the page
    And I see "This action will remove this transcript request from your transcripts. You can still access it by searching at the hearing and case levels." on the page

    When I click on the "Cancel" link
    And I see "Your transcripts" on the page
    And I check the checkbox in the same row as "C{{seq}}004" "Court Log"
    And I press the "Remove transcript request" button
    And I press the "Yes - delete" button
    Then I see "Your transcripts" on the page
    And I do not see "C{{seq}}004" on the page

  @DMP-1054 @DMP-1243 @DMP-2124 @regression
  Scenario: Request two transcriptions, assign to me and attach transcript, complete and multiple delete
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}006"
    And I press the "Search" button
    When I click on "C{{seq}}006" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    #Request first transcript

    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "12:30:00"
    And I set the time fields below "End time" to "12:31:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio, attach transcript directly."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}007"
    And I press the "Search" button
    When I click on "C{{seq}}007" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    #Request second transcript

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "13:00:00"
    And I set the time fields below "End time" to "13:01:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting second transcript Specified Times for one minute of audio, attach transcript directly."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    #Approve both transcript requests

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}006"
    Then I see "Approve transcript request" on the page
    And I see "Requesting transcript Court Log for one minute of audio, attach transcript directly." in the same row as "Instructions"

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}006" on the page

    When I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}007"
    Then I see "Approve transcript request" on the page
    And I see "Requesting second transcript Specified Times for one minute of audio, attach transcript directly." in the same row as "Instructions"

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}007" on the page

    #Attach transcripts to both requests directly

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I click on "View" in the same row as "C{{seq}}006"
    Then I see "Transcript Request" on the page

    #DMP-1243-AC4 Assign to myself and upload transcript

    When I select the "Assign to me and upload a transcript" radio button
    And I press the "Continue" button
    Then I see "Upload transcript file" on the page
    And I see "Requesting transcript Court Log for one minute of audio, attach transcript directly." in the same row as "Instructions"

    When I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Transcript requests" link
    And I click on "View" in the same row as "C{{seq}}007"
    Then I see "Transcript Request" on the page

    When I select the "Assign to me and upload a transcript" radio button
    And I press the "Continue" button
    Then I see "Upload transcript file" on the page
    And I see "Requesting second transcript Specified Times for one minute of audio, attach transcript directly." in the same row as "Instructions"

    When I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Go to your work" link
    And I click on the "Completed today" link
    Then I see "C{{seq}}006" on the page
    And I see "C{{seq}}007" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I click on the "Your transcripts" link
    Then I see "C{{seq}}006" in the same row as "Complete"
    And I see "C{{seq}}007" in the same row as "Complete"

    #Delete both transcripts

    When I check the checkbox in the same row as "C{{seq}}006" "Court Log"
    And I check the checkbox in the same row as "C{{seq}}007" "Specified Times"
    And I press the "Remove transcript request" button
    Then I see "Are you sure you want to remove these transcript requests?" on the page
    And I see "This action will remove these transcript requests from your transcripts. You can still access them by searching at the hearing and case levels." on the page

    When I click on the "Cancel" link
    And I see "Your transcripts" on the page
    And I check the checkbox in the same row as "C{{seq}}006" "Court Log"
    And I check the checkbox in the same row as "C{{seq}}007" "Specified Times"
    And I press the "Remove transcript request" button
    And I press the "Yes - delete" button
    Then I see "Your transcripts" on the page
    And I do not see "C{{seq}}006" on the page
    And I do not see "C{{seq}}007" on the page

  @DMP-1009 @DMP-1011 @DMP-1025 @DMP-1028 @regression
  Scenario: Request Transcription, Rejected by Approver
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}005"
    And I press the "Search" button
    When I click on "C{{seq}}005" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "C{{seq}}005" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefC {{seq}}-12" on the page
    And I see "{{displaydate}}" on the page

    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "12:00:00"
    And I set the time fields below "End time" to "12:01:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "C{{seq}}005" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefC {{seq}}-12" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Provide any further instructions or comments for the transcriber." on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio, this will test negative path."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page
    And I see "What happens next?" on the page
    And I see "We’ll review it and notify you of our decision to approve or reject your request by email and through the DARTS portal." on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    When I click on the "Your transcripts" link
    Then I see "C{{seq}}005" in the same row as "Awaiting Authorisation"

    #DMP-1009 Approver screen and rejection reason

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "C{{seq}}005"
    Then I see "Approve transcript request" on the page
    And I see "C{{seq}}005" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeC {{seq}}-12" in the same row as "Judge(s)"
    And I see "DefC {{seq}}-12" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio, this will test negative path." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    #DMP-1011-AC2 Reject request

    When I select the "No" radio button
    And I see "You have 2000 characters remaining" on the page
    And I set "Why can you not approve this request?" to "Rejecting this request, for specific reason"
    #And I see "You have 1956 characters remaining" on the page
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "C{{seq}}005" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an REQUESTER user
    And I set "Case ID" to "C{{seq}}005"
    And I press the "Search" button
    And I click on "C{{seq}}005" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    Then I see "Court Log" in the same row as "Rejected"

    When I click on the "Hearings" link
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "Court Log" in the same row as "Rejected"

    #DMP-1025-AC3 Rejected on Your transcripts screen
    When I click on the "Your transcripts" link
    And I see "C{{seq}}005" in the same row as "Rejected"
    #DMP-1028-AC1 View rejected transcript request
    And I click on "View" in the same row as "C{{seq}}005"
    Then I see "Your request was rejected" on the page
    And I see "Rejecting this request, for specific reason" on the page
    And I see "Requesting transcript Court Log for one minute of audio, this will test negative path." in the same row as "Instructions"

    #DMP-1028-AC3 Cancel link takes user back to Your Transcripts screen
    When I click on the "Cancel" link
    And I see "C{{seq}}005" in the same row as "Rejected"
    And I click on "View" in the same row as "C{{seq}}005"
    #DMP-1028-AC2 Request again functionality
    And I press the "Request again" button
    Then I see "Request a new transcript" on the page
    And I see "Audio list" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "12:00:00"
    And I set the time fields below "End time" to "12:01:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    When I set "Comments to the Transcriber (optional)" to "Requesting this again, as first request was rejected."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Rejected"
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

  @DMP-872 @DMP-862 @regression
  Scenario: No Audio Available for Transcript Request
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}001"
    And I press the "Search" button
    And I click on "C{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    #DMP-862-AC3 Request transcript from Hearing screen, in transcripts section
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    #DMP-872 No audio available
    Then I see "Audio list" on the page
    And I see "There is no audio for this hearing date." on the page

    When I click on the "Cancel and go back to case level" link
    Then I see "testprosecutoreight" on the page
    And I do not see "Also known as a case reference or court reference. There should be no spaces." on the page

    When I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "There is no audio for this hearing date." on the page

    When I click on the "Cancel and go back to the search results" link
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom | Judge(s)         | Defendant(s)   |
      | C{{seq}}001 | Harrow Crown Court | {{seq}}-8 | JudgeC {{seq}}-8 | DefC {{seq}}-8 |

  @DMP-892 @DMP-917 @DMP-1012 @regression
  Scenario: Transcript - Request a new transcript cancel links

    #TODO: Are cancel links working as intended? AC seems to indicate cancel takes you back to Hearing Details rather than back a screen. Check this.

    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    When I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    #@DMP-892-AC3 Cancel and return to previous screen
    When I select "Court Log" from the "Request Type" dropdown
    And I click on the "Cancel" link
    Then I see "Transcripts for this hearing" on the page

    When I press the "Request a new transcript" button
    And I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I click on the "Cancel" link
    Then I see "C{{seq}}002" on the page

    When I press the "Continue" button
    And I check the checkbox in the same row as "10:30:00" "Hearing started"
    And I check the checkbox in the same row as "10:31:00" "Hearing ended"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    #@DMP-1012-AC2
    When I click on the "Cancel" link
    Then I see "Events, audio and specific times requests" on the page

  @DMP-892 @DMP-1012 @regression
  Scenario: Request Transcription Errors
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    And I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    #DMP-892-AC5 Transcription type and/or urgency not populated
    When I press the "Continue" button
    Then I see an error message "Please select a transcription type"
    And I see an error message "Please select an urgency"

    When I select "Court Log" from the "Request Type" dropdown
    And I press the "Continue" button
    Then I see an error message "Please select an urgency"

    When I click on the "Cancel" link
    And I press the "Request a new transcript" button
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "There is a problem" on the page
    Then I see an error message "Please select a transcription type"

    When I select "Court Log" from the "Request Type" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I press the "Continue" button
    Then I see an error message "Select a start time"
    And I see an error message "Select an end time"

    When I set the time fields below "Start time" to "10:30:00"
    And I set the time fields below "End time" to "10:31:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page

    #@DMP-1012-AC3
    When I press the "Submit request" button
    Then I see an error message "You must confirm that you have authority to request a transcript"
    And I see "You must have authorisation from a judge to confirm this request." on the page

  @DMP-892 @regression
  Scenario: Request Transcript Dropdowns
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "C{{seq}}002"
    And I press the "Search" button
    And I click on "C{{seq}}002" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page

    #DMP-892 Dropdown checks
    And the dropdown "Urgency" contains the options
      | Please select         |
      | Overnight             |
      | Up to 2 working days  |
      | Up to 3 working days  |
      | Up to 7 working days  |
      | Up to 12 working days |
      | Other                 |

    And the dropdown "Request Type" contains the options
      | Please select                     |
      | Sentencing remarks                |
      | Summing up (including verdict)    |
      | Antecedents                       |
      | Argument and submission of ruling |
      | Court Log                         |
      | Mitigation                        |
      | Proceedings after verdict         |
      | Prosecution opening of facts      |
      | Specified Times                   |
      | Other                             |

  @DMP-917
  Scenario: Verify Audio list pagination

    #TODO: Will sort later, need a case with many audio files?

    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    Given I click on "CASE1009" in the same row as "Swansea"
    #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    #DMP-917-AC4 Audio pagination
    And I click on the pagination link "2"
    And I see "Next" on the page
    And I see "Previous" on the page