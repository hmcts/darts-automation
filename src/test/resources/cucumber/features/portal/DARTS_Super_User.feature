Feature: Super User Permission
  @DMP2404
  Scenario: Case Search data creation

    Given I create a case using json
      | courthouse         | courtroom  | case_number | defendants      | judges           | prosecutors         | defenders         |
      | Harrow Crown Court | A{{seq}}-1 | A{{seq}}001 | Def A{{seq}}-1  | Judge {{seq}}-1  | testprosecutor      | testdefender      |

    Given I create an event using json
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom   | case_numbers | event_text     | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 1100  |          | {{seq}}1001 | Harrow Crown Court | A{{seq}}-1  | A{{seq}}001  | A{{seq}}ABC-1  | {{timestamp-10:00:00}} |                             |                     |

    When I load an audio file
      | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile |
      | Harrow Crown Court | A{{seq}}-1  | A{{seq}}001  | {{date+0/}} | 10:30:00  | 10:31:00 | sample1   |

  @DMP-2404-CaseSearch
  Scenario: Case search
    When I am logged on to DARTS as a SUPERUSER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
      | A{{seq}}001 | Harrow Crown Court | A{{seq}}-1  | Judge {{seq}}-1 | Def A{{seq}}-1 |
        #Advanced search
    When I click on the "Clear search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "Harrow Crown Court"
    And I set "Courtroom" to "A{{seq}}-1"
    And I set "Defendant's name" to "Def A{{seq}}-1"
    And I press the "Search" button
    Then I see "A{{seq}}001" in the same row as "A{{seq}}-1"

    When I click on the "Clear search" link
    And I set "Courthouse" to "Harrow Crown Court"
    And I set "Courtroom" to "A{{seq}}-1"
    And I set "Keywords" to "A{{seq}}ABC-1"
    And I press the "Search" button
    Then I see "A{{seq}}001" in the same row as "A{{seq}}-1"

    #Error Message
    When I click on the "Clear search" link
    Then I set "Case ID" to "1" and click away
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    Then I set "Courthouse" to "Harrow Crown Court" and click away
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    Then I set "Defendant's name" to "Def A{{seq}}-1"
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    Then I set "Judge's name" to "Judge {{seq}}-1"
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    Then I set "Keywords" to "A{{seq}}ABC-1"
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "Harrow Crown Court" and click away
    Then I set "Courtroom" to "A{{seq}}-1"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Case ID" to "Testing"
    And I set "Courthouse" to "Test"
    And I set "Courtroom" to "Test1234"
    Then I press the "Search" button
    Then I see "No search results" on the page
    And I see "Review the case ID, case reference or court reference you entered and try again." on the page

    When I click on the "Clear search" link
    Then I set "Defendant's name" to "Def A{{seq}}-1"
    Then I set "Judge's name" to "Judge {{seq}}-1"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Courthouse" to "Harrow Crown Court"
    Then I set "Judge's name" to "Judge {{seq}}-1"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "2"
    And I press the "Search" button
    Then I see an error message "You must also enter a courthouse"

    When I click on the "Clear search" link
    And I set "Courtroom" to "A{{seq}}-1"
    And I set "Defendant's name" to "Def A{{seq}}-1"
    And I set "Judge's name" to "Judge {{seq}}-1"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "A{{seq}}-1"
    And I set "Judge's name" to "Judge {{seq}}-1"
    Then I select the "Specific date" radio button
    And I set "Enter a date" to "{{date+0/}}"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I click on the "Clear search" link
    Then I set "Courtroom" to "A{{seq}}-1"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "{{date+0/}}"
    Then I set "Defendant's name" to "Def A{{seq}}-1"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "A{{seq}}-1"
    Then I set "Defendant's name" to "Def A{{seq}}-1"
    Then I set "Keywords" to "A{{seq}}ABC-1"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "{{date+3/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date+7/}}"
    And I set "Enter date to" to "{{date-7/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date-10/}}"
    And I set "Enter date to" to "{{date+10/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "{{date-7/}}"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date-10/}}"
    And I press the "Search" button
    And I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "Invalid"
    And I press the "Search" button
    And I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "Invalid"
    And I press the "Search" button
    And I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    And I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "Invalid"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

  @DMP-2404-Audio
  Scenario: Audio
    Given I am logged on to DARTS as a SUPERUSER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
      | A{{seq}}001 | Harrow Crown Court | A{{seq}}-1  | Judge {{seq}}-1 | Def A{{seq}}-1 |
    When I click on "A{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "A{{seq}}-1"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:30:00"
    And I set the time fields of "End Time" to "10:31:00"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to DartsSuperUser and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    And I click on the "Back to search results" link
    When I click on the "Your audio" link
    And I see "Current" on the page
    And I see "Expired" on the page

  @DMP-2404-Transcription
  Scenario: Transcription
    Given I am logged on to DARTS as a SUPERUSER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
      | A{{seq}}001 | Harrow Crown Court | A{{seq}}-1  | Judge {{seq}}-1 | Def A{{seq}}-1 |

    When I click on "A{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on the "{{displaydate}}" link
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    Then I see "Audio list" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "{{displaydate}}" on the page

    When I select "Specified Times" from the "Request Type" dropdown
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    Then I see "Events, audio and specific times requests" on the page
    And I see "Select events or specify start and end times to request a transcript." on the page
    And I see "Specific times requests cover all events and audio between the transcript start and end time." on the page
    And I set the time fields of "Start time" to "10:30:00"
    And I set the time fields of "End time" to "10:31:00"
    And I press the "Continue" button

    Then I see "Check and confirm your transcript request" on the page
    And I see "A{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def A{{seq}}-1" in the same row as "Defendant(s)"
    And I see "{{displaydate}}" in the same row as "Hearing date"
    And I see "Specified Times" in the same row as "Request type"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Start time 10:30:00 - End time 10:31:00" in the same row as "Audio for Transcript"
    And I see "Provide any further instructions or comments for the transcriber." on the page
    And I see "You have 2000 characters remaining" on the page
    When I set "Comments to the Transcriber (optional)" to "Requesting transcript Specified Times for one minute of audio selected via event checkboxes."
    And I see "You have 1908 characters remaining" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page
    And I see "What happens next?" on the page
    And I see "We’ll review it and notify you of our decision to approve or reject your request by email and through the DARTS portal." on the page

    When I click on the "Return to hearing date" link
    Then I see "Transcripts for this hearing" on the page
    And I see "Specified Times" in the same row as "Awaiting Authorisation"

    When I click on the "Your transcripts" link
    Then I see "A{{seq}}001" in the same row as "Awaiting Authorisation"
    And I Sign out

  @DMP-2404-Retention
  Scenario Outline: Retention
    When I am logged on to DARTS as a SUPERUSER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
      | A{{seq}}001 | Harrow Crown Court | A{{seq}}-1  | Judge {{seq}}-1 | Def A{{seq}}-1 |
    When I click on "A{{seq}}001" in the same row as "Harrow Crown Court"
    And I see "Retained until" on the page
    And I see "No date applied" on the page
    And I click on the "View or change" link
    And I see "This case is still open or was recently closed." on the page
    And I see "The retention date for this case cannot be changed while the case is open or while a retention policy is currently pending." on the page
    And I see "Case retention date" on the page
    And I see "Case details" on the page
    And I see "A{{seq}}001" on the page
    And I see "Current retention details" on the page
    And I see "A retention policy has yet to be applied to this case." on the page
    And I see "Retention audit history" on the page
    And I see "No history to show" on the page

  # Close the case
    Given I create an event using json
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers  | event_text | date_time              |
      | {{seq}}001 | 30300 |          | {{seq}}1167 | Harrow Crown Court | {{seq}}-28 | A{{seq}}001 | {{seq}}KH1 | {{timestamp-10:00:00}} |

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link

    And I see "Retained until" on the page
    And I see "No date applied" on the page
    And I click on the "View or change" link
    And I see "This case is still open or was recently closed." on the page
    And I see "The retention date for this case cannot be changed while the case is open or while a retention policy is currently pending." on the page
    And I see "Case retention date" on the page
    And I see "Case details" on the page
    And I see "A{{seq}}001" on the page
    And I see "Current retention details" on the page
    And I see "A retention policy has yet to be applied to this case." on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status  |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Default          |          | PENDING |

    # 7 days Past Case Close Event
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    And I see "Change retention date" on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Default          |          | COMPLETE |

    When I press the "Change retention date" button
    And I select the "Retain until a specific date" radio button
    And I see "Use dd/mm/yyyy format. For example, 31/01/2023." on the page
    And I set "Enter a date to retain the case until" to "{{date+3285/}}"
    When I see "You have 200 characters remaining" on the page
    And I set "Why are you making this change?" to "This is my reason for increasing the retention date"
    And I see "You have 149 characters remaining" on the page
    And I press the "Continue" button
    Then I see "Check retention date change" on the page
    And I see "A{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def A{{seq}}-1" in the same row as "Defendant(s)"
    And I see "This is my reason for increasing the retention date" in the same row as "Reason for change"
    When I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate}}" in the same row as "Date applied"
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Default          |                                                     | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | DartsSuperUser | Manual           | This is my reason for increasing the retention date | COMPLETE |
     #Reduce retention period
    When I press the "Change retention date" button
    And I select the "Retain until a specific date" radio button
    And I set "Enter a date to retain the case until" to "{{date+2920/}}"

    And I set "Why are you making this change?" to "Reason for reducing retention date by one year"
    And I see "You have 154 characters remaining" on the page
    And I press the "Continue" button
    Then I see "Check retention date change" on the page
    And I see "A{{seq}}001" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def A{{seq}}-1" in the same row as "Defendant(s)"
    And I see "Reason for reducing retention date by one year" in the same row as "Reason for change"

    When I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate}}" in the same row as "Date applied"
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Default          |                                                     | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | DartsSuperUser | Manual           | This is my reason for increasing the retention date | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | DartsSuperUser | Manual           | Reason for reducing retention date by one year      | COMPLETE |

    Examples:
      | case_number |
      | A{{seq}}001|

  @DMP-2562
  Scenario: Request download audio for Super Admin
    When I am logged on to DARTS as an Admin user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
      | A{{seq}}001 | Harrow Crown Court | A{{seq}}-1  | Judge {{seq}}-1 | Def A{{seq}}-1 |

    When I click on "A{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "A{{seq}}-1"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:30:00"
    And I set the time fields of "End Time" to "10:31:00"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Darts Admin and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    And I click on the "Back to search results" link

    When I click on "A{{seq}}001" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "A{{seq}}-1"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:30:00"
    And I set the time fields of "End Time" to "10:31:00"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "A{{seq}}001" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def A{{seq}}-1" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:30:00" on the page
    And I see "10:31:00" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Darts Admin and notify you in the DARTS application." on the page

