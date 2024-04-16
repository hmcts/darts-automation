Feature: User as a Judge

  @DMP-1033 @DMP-1618 @regression
  Scenario: Judge data creation
    Given I create a case using json
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors           | defenders           |
      | Harrow Crown Court | {{seq}}-16 | E{{seq}}001 | DefE {{seq}}-16 | JudgeE {{seq}}-16 | testprosecutorsixteen | testdefendersixteen |

    Given I create an event using json
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100  |          | {{seq}}1024 | Harrow Crown Court | {{seq}}-16 | E{{seq}}001  | {{seq}}ABC-16 | {{timestamp-10:00:00}} |                             |                     |
      | {{seq}}001 | 1200  |          | {{seq}}1025 | Harrow Crown Court | {{seq}}-16 | E{{seq}}001  | {{seq}}DEF-16 | {{timestamp-10:01:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile |
      | Harrow Crown Court | {{seq}}-16 | E{{seq}}001  | {{date+0/}} | 10:00:00  | 10:01:00 | sample1   |

  @DMP-1033 @DMP-1618 @regression
  Scenario: Judge requesting and viewing transcripts
    Given I am logged on to DARTS as an JUDGE user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "E{{seq}}001"
    And I press the "Search" button
    When I click on "E{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    #DMP-1618-AC2 Judge able to request transcript
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "E{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefE {{seq}}-16" on the page
    And I see "{{displaydate}}" on the page

    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "10:00:00"
    And I set the time fields below "End time" to "10:01:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "E{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefE {{seq}}-16" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio to test judge transcript request."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    #DMP-1033 and DMP-1618-AC1 Judge view transcript screen and view request that was just made (in progress)

    When I click on the "Your transcripts" link
    Then I see "E{{seq}}001" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "E{{seq}}001"
    Then I see "Approve transcript request" on the page
    And I see "E{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeE {{seq}}-16" in the same row as "Judge(s)"
    And I see "DefE {{seq}}-16" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio to test judge transcript request." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    When I select the "Yes" radio button
    And I press the "Submit" button
    Then I see "Requests to approve or reject" on the page
    And I do not see "E{{seq}}001" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Transcript requests" link
    And I see "Manual" in the same row as "E{{seq}}001"
    And I click on "View" in the same row as "E{{seq}}001"
    Then I see "Transcript Request" on the page
    And I see "E{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "JudgeE {{seq}}-16" in the same row as "Judge(s)"
    And I see "DefE {{seq}}-16" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing Date"
    And I see "Court Log" in the same row as "Request Type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio to test judge transcript request." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"

    When I select the "Assign to me" radio button
    And I press the "Continue" button
    Then I see "E{{seq}}001" on the page

    When I click on the "Completed today" link
    Then I do not see "E{{seq}}001" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an JUDGE user
    And I click on the "Your transcripts" link
    Then I see "E{{seq}}001" in the same row as "With Transcriber"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as a TRANSCRIBER user
    And I click on the "Your work" link
    And I click on "View" in the same row as "E{{seq}}001"
    And I see "Requesting transcript Court Log for one minute of audio to test judge transcript request." in the same row as "Instructions"
    And I upload the file "file-sample_1MB.doc" at "Upload transcript file"
    And I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    When I click on the "Go to your work" link
    And I click on the "Completed today" link
    Then I see "E{{seq}}001" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an JUDGE user
    #DMP-1618-AC1 Judge view transcript screen and view request that was completed (complete)
    And I click on the "Your transcripts" link
    Then I see "E{{seq}}001" in the same row as "Complete"

    #DMP-1033 View link from My Transcripts (shows additional fields not seen elsewhere)
    When I click on "View" in the same row as "E{{seq}}001"
    Then I see "E{{seq}}001" in the same row as "Case ID"
    And I see "JudgeE {{seq}}-16" in the same row as "Judge(s)"
    And I see "DefE {{seq}}-16" in the same row as "Defendant(s)"
    And I see "Requested" on the page
    And I see "Received" on the page
    And I see "Judge approval" on the page
    And I see "Requesting transcript Court Log for one minute of audio to test judge transcript request." in the same row as "Instructions"
    And I see "Complete" on the page

    When I click on the "Search" link
    And I set "Case ID" to "E{{seq}}001"
    And I press the "Search" button
    And I click on "E{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "All Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 10:00:00 - End time 10:01:00" in the same row as "Audio for transcript"

    When I click on the breadcrumb link "E{{seq}}001"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    Then I see "Court Log" in the same row as "Complete"

    When I click on "View" in the same row as "Court Log"
    Then I see "file-sample_1MB.doc" on the page
    And I see "Start time 10:00:00 - End time 10:01:00" in the same row as "Audio for transcript"
