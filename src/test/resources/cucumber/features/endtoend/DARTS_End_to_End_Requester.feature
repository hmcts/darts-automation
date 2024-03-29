Feature: Requester

  @end2end @end2end2 @DMP-2206
  Scenario Outline: Requester
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I authenticate from the XHIBIT source system
    And   I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |
    When I am logged on to DARTS as an REQUESTER user
    And  I set "Case ID" to "<case_number>"
    And  I press the "Search" button
    Then I see "1 result" on the page
    And  I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    When I click on "<HearingDate>" in the same row as "<courtroom>"
    Then I see "There are restrictions against this hearing" on the page
    Then I wait for text "<startTime> - <endTime>" on the same row as link "Play preview"
#    Then I wait for the audio file to be ready
#      | courthouse   | courtroom   | case_number   | hearing_date |
#      | <courthouse> | <courtroom> | <case_number> | {{date+0/}}  |
#    When I refresh the page
    #Then I play the audio player
    When I check the checkbox in the same row as "<startTime> - <endTime>" "Audio recording"
    And  I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page

    When I click on the "Return to hearing date" link
    And  I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    When I press the "Confirm" button
    Then I see "You cannot order this audio" on the page
    And  I see "You have already ordered this audio and the request is 'pending'." on the page
    When I click on the "HMCTS" link

    Then I wait for the requested audio file to be ready
      | user      | courthouse   | case_number   | hearing_date |
      | REQUESTER | <courthouse> | <case_number> | {{date+0/}}  |
      
    When I click on the "Your audio" link
    Then I wait for text "READY" on the same row as link "<case_number>"
    And  I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    #Then I play the audio player
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
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    And I see "Transcript request submitted" on the page
    Then I Sign out

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

    Then I see "Sign in to the DARTS Portal" on the page
    When I am logged on to DARTS as an REQUESTER user
    Then I click on the "Your transcripts" link
    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I see "Complete" on the page

    Examples:
      | courthouse         | courtroom | case_number | judges         | defendants         | prosecutors         | defenders         | HearingDate        | transcription-type | urgency   | message_id | eventId     | type  | subType | caseRetention | totalSentence | dateTime      | keywords       | audioFile   | startTime | endTime  | filename            |
      | Harrow Crown Court | {{seq}}   | S{{seq}}021 | S{{seq}} judge | S{{seq}} defendant | S{{seq}} prosecutor | S{{seq}} defender | {{todayDisplay()}} | Sentencing remarks | Overnight | {{seq}}001 | {{seq}}1001 | 21200 | 11000   |               |               | {{timestamp}} | SIT LOG{{seq}} | sample1.mp2 | 08:03:00  | 08:04:00 | file-sample_1MB.doc |