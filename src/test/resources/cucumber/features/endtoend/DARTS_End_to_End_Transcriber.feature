Feature: Transcriber

  @end2end @end2end4 @DMP-2055
  Scenario Outline: Transcriber - TranscriptionType - Sentencing Remarks - Audio requestType -Download
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I authenticate from the XHIBIT source system
    Given I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |

    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |
    Given I am logged on to DARTS as an REQUESTER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
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
    Then I check the "I confirm I have received authorisation from the judge." checkbox
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
    Then I select the "Assign to me and upload a transcript" radio button
    Then I press the "Continue" button
    Then I see "<case_number>" on the page
    Then I see "<courthouse>" on the page
    Then I press the "Get audio for this request" button

    When I select the "Audio preview and events" radio button
    And I set the time fields of "Start Time" to "<startTime>"
    And I set the time fields of "End Time" to "<endTime>"
    And I select the "<audioRequestType>" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    Then I press the "Confirm" button
    Then I see "Your order is complete" on the page

    Then I click on the "Return to hearing date" link
    Then I click on the "Your audio" link
    Then I wait for "2" minutes with "READY" to appear for "<case_number>"

    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I press the "Download audio file" button
    Then I verify the download file matches "<case_number>"
    Then I click on the "Delete audio file" link
    Then I press the "Yes - delete" button

    When I click on the "Your work" link
    Then I click on "View" in the same row as "<case_number>"
    Then I upload the file "<filename>" at "Upload transcript file"
    Then I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    Examples:
      | courthouse         | courtroom | case_number | judges         | defendants         | prosecutors         | defenders         | HearingDate        | transcription-type | urgency   | message_id | eventId     | type  | subType | caseRetention | totalSentence | dateTime      | keywords       | audioFile   | startTime | endTime  | filename            | audioRequestType |
      | Harrow Crown Court | {{seq}}   | S{{seq}}031 | S{{seq}} judge | S{{seq}} defendant | S{{seq}} prosecutor | S{{seq}} defender | {{todayDisplay()}} | Sentencing remarks | Overnight | {{seq}}031 | {{seq}}1031 | 21200 | 11000   |               |               | {{timestamp}} | SIT LOG{{seq}} | sample1.mp2 | 18:04:00  | 18:05:00 | file-sample_1MB.doc | Download         |

  @end2end @end2end4 @DMP-2055 @ts
  Scenario Outline: Transcriber TranscriptionType - Court Logs - Audio requestType -Playback
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I authenticate from the XHIBIT source system
    Given I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |
    Given I am logged on to DARTS as an REQUESTER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on "<HearingDate>" in the same row as "<courtroom>"

    Then I click on the "Transcripts" link
    Then I press the "Request a new transcript" button
    Then I see "Request a new transcript" on the page
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    When I set the time fields below "Start time" to "<startTime>"
    When I set the time fields below "End time" to "<endTime>"
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
    Then I select the "Assign to me and upload a transcript" radio button
    Then I press the "Continue" button
    Then I see "<case_number>" on the page
    Then I see "<courthouse>" on the page
    Then I press the "Get audio for this request" button

    When I select the "Audio preview and events" radio button
    And I set the time fields of "Start Time" to "<startTime>"
    And I set the time fields of "End Time" to "<endTime>"
    And I select the "<audioRequestType>" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    Then I press the "Confirm" button
    Then I see "Your order is complete" on the page

    Then I click on the "Return to hearing date" link
    Then I click on the "Your audio" link
    Then I wait for "2" minutes with "READY" to appear for "<case_number>"

    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I press the "Download audio file" button
    Then I verify the download file matches "<case_number>"
    Then I click on the "Delete audio file" link
    Then I press the "Yes - delete" button

    When I click on the "Your work" link
    Then I click on "View" in the same row as "<case_number>"
    Then I upload the file "<filename>" at "Upload transcript file"
    Then I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    Examples:
      | courthouse         | courtroom | case_number | judges         | defendants         | prosecutors         | defenders         | HearingDate        | transcription-type | urgency   | message_id | eventId     | type  | subType | caseRetention | totalSentence | dateTime      | keywords       | audioFile   | startTime | endTime  | filename            | audioRequestType |
      | Harrow Crown Court | {{seq}}   | S{{seq}}032 | S{{seq}} judge | S{{seq}} defendant | S{{seq}} prosecutor | S{{seq}} defender | {{todayDisplay()}} | Court Log          | Overnight | {{seq}}032 | {{seq}}1032 | 21200 | 11000   |               |               | {{timestamp}} | SIT LOG{{seq}} | sample1.mp2 | 18:03:00  | 18:04:00 | file-sample_1MB.doc | Playback Only    |


