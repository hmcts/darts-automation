Feature: Language Shop User

  @end2end @end2end7 @DMP-2201
  Scenario Outline: Language Shop User
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
#    Given I add a daily lists
#      | messageId       | type      | subType      | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp   | defendant    | urn           |
#      | <DL_message_id> | <DL_type> | <DL_subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <startTime> | <endDate> | <timeStamp> | <defendants> | <case_number> |
    When I process the daily list for courthouse <courthouse>

    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text             | date_time   | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 10100 |          | <eventId> | <courthouse> | <courtroom> | <case_number> | Case called on {{seq}} | <timeStamp> | <caseRetention>             | <totalSentence>     |
    Given I add courtlogs
      | dateTime    | courthouse   | courtroom   | case_numbers  | text         |
      | <timeStamp> | <courthouse> | <courtroom> | <case_number> | text {{seq}} |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |

    Given I am logged on to DARTS as an LANGUAGESHOP user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "No search results" on the page
    And I see "Review the case ID, case reference or court reference you entered and try again." on the page

    # Set Interpreter Flag on
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.court_case column interpreter_used to "true" where cas_id = "{{cas_id}}"
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |
    When I click on "<case_number>" in the same row as "<courthouse>"
    And I do not see "Transcripts" on the page
    Then I see "<case_number>" on the page
    Then I click on "<HearingDate>" in the same row as "<courtroom>"
    And I do not see "Transcripts" on the page
    # Audio Request
    When I select the "Audio preview and events" radio button
    And I set the time fields of "Start Time" to "<startTime>"
    And I set the time fields of "End Time" to "<endTime>"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    Then I press the "Confirm" button
    Then I see "Your order is complete" on the page

    Then I click on the "Return to hearing date" link
    Then I click on the "Your audio" link

    #Wait for Requested Audio
    When I click on the "Your audio" link
    Then I wait for the requested audio file to be ready
      | user      | courthouse   | case_number   | hearing_date |
      | REQUESTER | <courthouse> | <case_number> | {{date+0/}}  |
    Then I click on "Request ID" in the "Ready" table header
    Then I wait for text "READY" on the same row as link "<case_number>"
    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I press the "Download audio file" button
    Then I verify the download file matches "<case_number>"
    Then I click on the "Delete audio file" link
    Then I press the "Yes - delete" button

    Examples:
      | DL_message_id                 | DL_type | DL_subType | documentName          | courthouse         | courtroom | HearingDate        | case_number | startDate  | endDate     | timeStamp     | judges         | defendants         | prosecutors         | defenders         | message_id | eventId     | caseRetention | totalSentence | audioFile | startTime | endTime  |
      | DARTS_E2E_{{date+0/}}_{{seq}} | DL      | DL         | Dailylist_{{date+0/}} | Harrow Crown Court | {{seq}}   | {{todayDisplay()}} | S{{seq}}001 | {{date+0}} | {{date+30}} | {{timestamp}} | S{{seq}} judge | S{{seq}} defendant | S{{seq}} prosecutor | S{{seq}} defender | {{seq}}001 | {{seq}}1001 |               |               | sample1   | 08:04:00  | 08:05:00 |

