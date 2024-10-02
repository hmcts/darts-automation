Feature: End-to-end Approver

  @end2end @end2end3 @DMP-2201
  Scenario Outline: Approver - Approves the request
    Given I create a case
      | courthouse   | courtroom   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <courtroom> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text                    | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 21200 | 11000    | <eventId> | <courthouse> | <courtroom> | <case_number> | Reporting Restriction {{seq}} | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime | endTime  | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | 10:01:00  | 10:02:00 | <audioFile> |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | 10:03:00  | 10:04:00 | <audioFile> |

    #Requester requests the transcript
    Given I am logged on to DARTS as an REQUESTER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"
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

    #Approver approves the request

    Then I see "Sign in to the DARTS Portal" on the page
    When I am logged on to DARTS as an APPROVER user
    Then I see "Search for a case" on the page
    Then I click on the "Your transcripts" link
    Then I click on "Request ID" in the table header
    #And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    Then I click on "View" in the same row as "<case_number>"
    And I see "Do you approve this request?" on the page
    Then I select the "Yes" radio button
    Then I press the "Submit" button
    Then I Sign out

    Examples:
      | courthouse         | courtroom | case_number   | judges         | defendants          | prosecutors          | defenders          | HearingDate                 | transcription-type | urgency   | message_id | eventId    | caseRetention | totalSentence | dateTime      | audioFile   |
      | Harrow Crown Court | {{seq}}   | R{{seq}}051-B | S{{seq}} judge | S{{seq}} defendants | S{{seq}} prosecutors | S{{seq}} defenders | {{displayDate(17-01-2024)}} | Sentencing remarks | Overnight | {{seq}}001 | {{seq}}001 |               |               | {{timestamp}} | sample1.mp2 |

  @end2end @end2end3 @DMP-2201
  Scenario Outline: Approver - Rejects the request
    Given I create a case
      | courthouse   | courtroom   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <courtroom> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text                    | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 21200 | 11000    | <eventId> | <courthouse> | <courtroom> | <case_number> | Reporting Restriction {{seq}} | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |

    Given I am logged on to DARTS as an REQUESTER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"
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
    Then I click on "Request ID" in the table header
    #And I click on the "Transcript requests to review" link
    Then I see "Requests to approve or reject" on the page
    Then I click on "View" in the same row as "<case_number>"
    And I see "Do you approve this request?" on the page
    Then I select the "No" radio button
    Then I set " Why can you not approve this request? " to "<Reason>"
    Then I press the "Submit" button
    Then I Sign out
    Examples:
      | courthouse         | courtroom | case_number   | judges         | defendants          | prosecutors          | defenders          | HearingDate                 | transcription-type | urgency   | message_id | eventId    | caseRetention | totalSentence | dateTime      | audioFile   | startTime | endTime  | Reason             |
      | Harrow Crown Court | {{seq}}   | S{{seq}}052-B | S{{seq}} judge | S{{seq}} defendants | S{{seq}} prosecutors | S{{seq}} defenders | {{displayDate(17-01-2024)}} | Sentencing remarks | Overnight | {{seq}}001 | {{seq}}001 |               |               | {{timestamp}} | sample1.mp2 | 18:03:00  | 18:04:00 | Reject for testing |

  @end2end @end2end3 @DMP-2201
  Scenario Outline: Requester Approver
    Given I create a case
      | courthouse   | courtroom   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <courtroom> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text                    | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 21200 | 11000    | <eventId> | <courthouse> | <courtroom> | <case_number> | Reporting Restriction {{seq}} | <dateTime> | <caseRetention>             | <totalSentence>     |
    When I load an audio file
      | courthouse   | courtroom   | case_numbers  | date        | startTime   | endTime   | audioFile   |
      | <courthouse> | <courtroom> | <case_number> | {{date+0/}} | <startTime> | <endTime> | <audioFile> |
    Given I am logged on to DARTS as an REQUESTERAPPROVER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"
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
    Then I click on the "Return to hearing date" link

    Then I click on the "Your transcripts" link
    Then I click on the "Transcript requests" link
    Then I see "<case_number>" on the page
    Then I click on the "Transcript requests to review" link
    Then I do not see "<case_number>" on the page
    Examples:
      | courthouse      | courtroom  | case_number   | judges              | defendants               | prosecutors            | defenders            | HearingDate     | transcription-type | urgency   | message_id | eventId    | caseRetention | totalSentence | dateTime      | audioFile   | startTime | endTime  |
      | {{courthouse1}} | {{seq}}-87 | S{{seq}}053-B | S{{seq}} judge-B087 | S{{seq}} defendants-B087 | S{{seq}} prosecutors-B | S{{seq}} defenders-B | {{displaydate}} | Sentencing remarks | Overnight | {{seq}}001 | {{seq}}001 |               |               | {{timestamp}} | sample1.mp2 | 18:03:00  | 18:04:00 |
