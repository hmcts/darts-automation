Feature: User as a Requester

  Background:
    Given I am logged on to DARTS as an REQUESTER user

  @DMP-1025
  Scenario: Verify Your Transcript Screen - "In Progress" or "Ready"
    When I click on the "Your Transcripts" link
    And I see "Your Transcripts" on the page
    And I click on the "Transcript requests" link
    Then I verify the HTML table "In Progress" contains the following values
      | Case ID  | Court   | Hearing date | Type      | Requested on      | Status                 | Urgency              |
      | CASE1009 | Swansea | 15 Aug 2023  | Court Log | 15 Nov 2023 10:07 | AWAITING AUTHORISATION | Up to 3 working days |
    And I see "Select to apply actions" on the page
    Then I verify the HTML table "Ready" contains the following values
      | *NO-CHECK* | Case ID  | Court   | Hearing date | Type               | Requested on      | Status   | Urgency              |
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | Mitigation         | 15 Nov 2023 13:48 | REJECTED | Up to 7 working days |
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | Sentencing remarks | 15 Nov 2023 09:55 | COMPLETE | OVERNIGHT            |
    Then I click on "Status" in the table header
    Then "Status" has sort "descending" icon

    @DMP-925-AC1
    Scenario Outline: Transcript already exists
      When I click on the "Search" link
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
      And I see "<Restriction>" on the page
      And I see "<CaseID>" on the page
      And I see "<Courthouse>" on the page
      And I see "<Defendants>" on the page
      And I see "<HearingDate>" on the page
      And I select "<transcription-type>" from the "Request Type" dropdown
      And I select "<urgency>" from the "Urgency" dropdown
      And I press the "Continue" button
      And I see "Events, audio and specific times requests" on the page
      And I see "Select events or specify start and end times to request a transcript." on the page
      And I see "Specific times requests cover all events and audio between the transcript start and end time." on the page
      And I see "Audio list" on the page
      And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
      And I press the "Continue" button
      And I see "Check and confirm your transcript request" on the page
      And I check the "I confirm I have received authorisation from the judge." checkbox
      And I press the "Submit request" button
      And I see "This transcript already exists" on the page
      Examples:
        | CaseID   | Courthouse | Defendants | HearingDate | Restriction                                           | transcription-type | urgency   |
        | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Specified Times    | Overnight |
        | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Court Log          | Overnight |

  @DMP-925-AC2
  Scenario Outline: Go to this Transcript Link
    When I click on the "Search" link
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
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "Events, audio and specific times requests" on the page
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    And I see "This transcript already exists" on the page
    And I click on the "Go to this transcript" link
    And I see "Transcript file" on the page
    And I see "<Restriction>" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Request Details" on the page
    And I see "<transcription-type>" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | Restriction                                           | transcription-type | urgency   |
      | CASE1009 | Swansea    | Jow Bloggs | Restriction: Judge directed on reporting restrictions | Specified Times    | Overnight |
      | CASE1009 | Swansea    | Jow Bloggs | Restriction: Judge directed on reporting restrictions | Court Log          | Overnight |

  @DMP-925-AC3
  Scenario Outline: Return to hearing Link
    When I click on the "Search" link
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
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "Events, audio and specific times requests" on the page
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    And I see "This transcript already exists" on the page
    And I click on the "Return to hearing" link
    And I see "Hearing" on the page
    And I see "<Restriction>" on the page
    Examples:
      | Restriction                                           | transcription-type | urgency   |
      | Restriction: Judge directed on reporting restrictions | Specified Times    | Overnight |
      | Restriction: Judge directed on reporting restrictions | Court Log          | Overnight |

  @DMP-1033
  Scenario Outline: View Transcript - Via Your Transcriptions screen
    When I click on the "Your Transcripts" link
    And I see "Your Transcripts" on the page
    And I see "Select to apply actions" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Transcript file" on the page
    And I see "<Status>" on the page
    And I see "Case Details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request Details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<urgency>" on the page
    And I see "<From>" on the page
    And I see "<Instructions>" on the page
    And I see "<JudgeApproval>" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType               | urgency              | Status   | HearingDate | From      | Instructions | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Proceedings after verdict | Up to 7 working days | COMPLETE | 14 Aug 2023 | Requester | DMP-1025     | Yes           |
