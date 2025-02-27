Feature: User as a Approver

  @DMP-1011 @DMP-1059 @DMP-1815 @regression
  Scenario: Approver data creation
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants      | judges            | prosecutors           | defenders           |
      | Harrow Crown Court | {{seq}}-15 | D{{seq}}001 | DefD {{seq}}-15 | JudgeD {{seq}}-15 | testprosecutorfifteen | testdefenderfifteen |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100 |          | {{seq}}022 | Harrow Crown Court | {{seq}}-15 | D{{seq}}001  | {{seq}}ABC-15 | {{timestamp-10:00:00}} |                             |                     |
      | {{seq}}001 | 1200 |          | {{seq}}023 | Harrow Crown Court | {{seq}}-15 | D{{seq}}001  | {{seq}}DEF-15 | {{timestamp-10:01:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
      | Harrow Crown Court | {{seq}}-15 | D{{seq}}001  | {{date+0/}} | 10:00:00  | 10:01:00 | sample1.mp2 |

  @DMP-1011 @DMP-1059 @DMP-1815 @regression @MissingData
  Scenario: Approver screen errors and cancel
    Given I am logged on to DARTS as an REQUESTER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "D{{seq}}001"
    And I press the "Search" button
    When I click on "D{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "D{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "DefD {{seq}}-15" on the page
    And I see "{{displaydate}}" on the page

    When I select "Court Log" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page

    When I set the time fields below "Start time" to "10:00:00"
    And I set the time fields below "End time" to "10:01:00"
    And I press the "Continue" button
    Then I see "Check and confirm your transcript request" on the page
    And I see "D{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "DefD {{seq}}-15" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"

    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Court Log for one minute of audio to test approver screen."
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Court Log" in the same row as "Awaiting Authorisation"

    When I click on the "Your transcripts" link
    Then I see "D{{seq}}001" in the same row as "Awaiting Authorisation"

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to DARTS as an APPROVER user
    And I click on the "Your transcripts" link
    And I click on "View" in the same row as "D{{seq}}001"
    Then I see "Approve transcript request" on the page
    And I see "D{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{upper-case-JudgeD {{seq}}-15}}" in the same row as "Judge(s)"
    And I see "DefD {{seq}}-15" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Court Log" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requesting transcript Court Log for one minute of audio to test approver screen." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"
    And I see "Do you approve this request?" on the page

    #DMP-1815 Press submit without selecting yes/no error

    When I press the "Submit" button
    Then I see an error message "Select if you approve this request or not"

    #DMP-1011-AC4 No reason given error

    When I select the "No" radio button
    And I press the "Submit" button
    Then I see an error message "You must explain why you cannot approve this request"

    #DMP-1011-AC3 Cancel link

    When I click on the "Cancel" link
    Then I see "Your transcripts" on the page
    And I see "Requests to approve or reject" on the page
    And I see "D{{seq}}001" on the page

  #DMP-1059 Pagination

    When I click on the pagination link "2"
    Then I see "Next" on the page
    And I see "Previous" on the page
