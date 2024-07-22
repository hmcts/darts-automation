Feature: Requester

  @end2end @end2end2 @DMP-2206
  @reads-system-properties
  Scenario Outline: Requester
    Given I add a daily lists
      | messageId       | type      | subType      | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime      | endDate   | timeStamp   | defendant    | urn           |
      | <DL_message_id> | <DL_type> | <DL_subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <DL_startTime> | <endDate> | <timeStamp> | <defendants> | <case_number> |
    When I process the daily list for courthouse <courthouse>
    Then I create an event
      | message_id | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text                    | date_time  | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 21200 | 11000    | <eventId> | <courthouse> | <courtroom> | <case_number> | Reporting Restriction {{seq}} | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |
    When I am logged on to DARTS as an REQUESTER user
    #Search
    And  I set "Case ID" to "<case_number>"
    And  I press the "Search" button
    Then I see "1 result" on the page
    And  I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | *IGNORE* | *IGNORE*     |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |
    # Hearings Tab and Reporting Restrictions
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    When I click on "<HearingDate>" in the same row as "<courtroom>"
    Then I see "There are restrictions against this hearing" on the page
    Then I see "This audio is not currently available in DARTS, please try again later." in the same row as "<startTime> - <endTime>"
    # Preview Audio
    Then I wait for text "<startTime> - <endTime>" on the same row as link "Play preview"
    Then I click on "Play preview" in the same row as "<startTime> - <endTime>"
    Then I wait for 1 minutes
    #Request Audio
    When I check the checkbox in the same row as "<startTime> - <endTime>" "Audio recording"
    And  I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see the Request ID
    #Duplicate audio request
    When I click on the "Return to hearing date" link
    And  I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    When I press the "Confirm" button
    Then I see "You cannot order this audio" on the page
    And  I see "You have already ordered this audio and the request is 'pending'." on the page
    When I click on the "HMCTS" link
    # Wait for Requested Audio
    When I click on the "Your audio" link
    Then I click on "Request ID" in the "Ready" table header
#   Then I wait for the requested audio file to be ready
#      | user      | courthouse   | case_number   | hearing_date |
#      | REQUESTER | <courthouse> | <case_number> | {{date+0/}}  |

    Then I wait for text "READY" on the same row as link "<case_number>"
    # Stream the Audio
    And  I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I press the "Download audio file" button

    # All Transcripts
    Then I click on the "Search" link
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on "<HearingDate>" in the same row as "<courtroom>"

    Then I click on the "Transcripts" link
    Then I press the "Request a new transcript" button
    Then I see "Request a new transcript" on the page
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    And I see "<case_number>" on the page
    And I set "Comments to the Transcriber (optional)" to "Please expedite my transcript request"
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    And I see "Transcript request submitted" on the page
    Then I click on the "Return to hearing" link
    Then I Sign out

    # Approver approves the request
    Then I see "Sign in to the DARTS Portal" on the page
    When I am logged on to DARTS as an APPROVER user
    Then I see "Search for a case" on the page
    Then I click on the "Your transcripts" link
    Then I see "Requests to approve or reject" on the page
    Then I click on "View" in the same row as "<case_number>"
    And I see "Do you approve this request?" on the page
    Then I select the "Yes" radio button
    Then I press the "Submit" button
    Then I Sign out
    # Transcriber uploads the document
    Then I see "Sign in to the DARTS Portal" on the page
    Given I am logged on to DARTS as an TRANSCRIBER user
    When I click on the "Transcript requests" link
    And I see "Transcript requests" on the page
    Then I click on "View" in the same row as "<case_number>"
    Then I select the "Assign to me" radio button
    Then I press the "Continue" button
    Then I click on "View" in the same row as "<case_number>"
    Then I upload the file "<filename>" at "Upload transcript file"
    Then I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page
    Then I Sign out

    # Requester View the Transcript
    Then I see "Sign in to the DARTS Portal" on the page
    When I am logged on to DARTS as an REQUESTER user
    Then I click on the "Your transcripts" link
    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I see "Complete" on the page
    Then I press the "Download transcript file" button

    #Case close
    Then I create an event
      | message_id | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text              | date_time  | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 30300 |          | <eventId> | <courthouse> | <courtroom> | <case_number> | Case S{{seq}}009 closed | <dateTime> | <caseRetention>             | <totalSentence>     |

     # 7 days Past Case Close Event
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    Then I click on the "Search" link
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page

    And I click on the "View or change" link
    Then I see "Default" on the page
    And I click on the "Change retention date" link
    And I click on the "Retain permanently (99 years)" link
    And I set "Why are you making this change?" to "<reason>"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "<case_number>" in the same row as "Case ID"
    And I see "<courthouse>" in the same row as "Courthouse"
    And I see "Change case retention date" on the page
    And I see "{{displaydate(date+99years)}} (Permanent)" in the same row as "Retain case until"
    And I see "<reason>" in the same row as "Reason for change"
    And I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate(date+99years)}}" in the same row as "Retain case until"

    Examples:
      | DL_message_id                 | DL_type | DL_subType | documentName          | courthouse      | courtroom   | case_number   | eventId     | defendants            | startDate  | DL_startTime | endDate     | timeStamp     | HearingDate     | transcription-type | urgency   | caseRetention | totalSentence | dateTime      | audioFile   | startTime | endTime  | filename            | reason                                            |
      | DARTS_E2E_{{date+0/}}_{{seq}} | DL      | DL         | Dailylist_{{date+0/}} | {{courthouse1}} | C{{seq}}-86 | S{{seq}}086-B | {{seq}}1001 | S{{seq}} defendant-86 | {{date+0}} | 10:00:00     | {{date+30}} | {{timestamp}} | {{displaydate}} | Sentencing remarks | Overnight |               |               | {{timestamp}} | sample1.mp2 | 08:03:00  | 08:04:00 | file-sample_1MB.doc | 99 Years Permanent Retention for case S{{seq}}009 |