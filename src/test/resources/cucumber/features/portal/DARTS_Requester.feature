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
        | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendant(s) |
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
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendant(s) |
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
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendant(s) |
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

  @DMP-1028-AC1
  Scenario Outline: View reject Transcription request

    When I click on the "Your transcripts" link
    Then I click on "View" in the same row as "<RequestType>"
    And I see "Your transcripts" on the page
    And I see "Your request was rejected" on the page
    And I see "DMP-851 test." on the page
    And I see "<Restriction>" on the page
    And I see "Transcript request" on the page
    And I see "<Status>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<urgency>" on the page
    And I see "<From>" on the page
    And I see "<Instructions>" on the page
    And I see "<JudgeApproval>" on the page

    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType | urgency              | Status   | HearingDate | From      | Instructions | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Mitigation  | Up to 3 working days | REJECTED | 14 Aug 2023 | system    | DMP-1025     | Yes           |

    @DMP-1028-AC2
    Scenario Outline: User wants to request again

      When I click on the "Your transcripts" link
      Then I click on "View" in the same row as "<RequestType>"
      And I see "Your transcripts" on the page
      And I see "Your request was rejected" on the page
      And I see "DMP-851 test." on the page
      And I see "<Restriction>" on the page
      And I see "Transcript request" on the page
      And I see "<Status>" on the page
      And I see "Case details" on the page
      And I see "<CaseID>" on the page
      And I see "<Courthouse>" on the page
      And I see "<Defendants>" on the page
      And I see "<Judge(s)>" on the page
      And I see "Request details" on the page
      And I see "<HearingDate>" on the page
      And I see "<RequestType>" on the page
      And I see "<urgency>" on the page
      And I see "<From>" on the page
      And I see "<Instructions>" on the page
      And I see "<JudgeApproval>" on the page
      Then I press the "Request again" button
      And I see "<CaseID>" on the page
      And I see "<Courthouse>" on the page
      And I see "<Defendants>" on the page


      Examples:
        | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType | urgency              | Status   | HearingDate | From      | Instructions | JudgeApproval |
        | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Mitigation  | Up to 3 working days | REJECTED | 14 Aug 2023 | system    | DMP-1025     | Yes           |

  @DMP-1028-AC3
  Scenario Outline: View rejected transcript - A user clicks on the cancel hyperlink

    When I click on the "Your transcripts" link
    And I click on "View" in the same row as "<RequestType>"
    And I see "Your transcripts" on the page
    And I see "Your request was rejected" on the page
    And I see "DMP-851 test." on the page
    And I see "<Restriction>" on the page
    And I see "Transcript request" on the page
    And I see "<Status>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<urgency>" on the page
    And I see "<From>" on the page
    And I see "<Instructions>" on the page
    And I see "<JudgeApproval>" on the page
    Then I click on the "Cancel" link
    And I see "Your transcripts" on the page
    And I verify the HTML table "Ready" contains the following values
      | *NO-CHECK* | Case ID  | Court   | Hearing date | Type                                     | Requested on      | Status   | Urgency              |
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | Argument and submission of ruling        | 27 Nov 2023 14:29 | COMPLETE | Up to 3 working days|
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | Prosecution opening of facts             | 21 Nov 2023 10:18 | COMPLETE | Up to 12 working days |
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | Mitigation                               | 17 Nov 2023 10:03 | REJECTED | Up to 3 working days |

  Examples:
  | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType | urgency              | Status   | HearingDate | From      | Instructions | JudgeApproval |
  | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Mitigation  | Up to 3 working days | REJECTED | 14 Aug 2023 | system    | DMP-1025     | Yes           |

  @DMP-1053
  Scenario: Delete single request from ready section of your transcripts
    When I click on the "Your transcripts" link
    And I check the checkbox in the same row as "CASE1009" "27 Nov 2023 14:29"
    And I press the "Remove transcript request" button
    Then I see "Are you sure you want to remove this transcript request?" on the page
    And I see "This action will remove this transcript request from your transcripts. You can still access it by searching at the hearing and case levels." on the page

    When I click on the "Cancel" link
    And I see "Your transcripts" on the page
    And I check the checkbox in the same row as "CASE1009" "27 Nov 2023 14:29"
    And I press the "Remove transcript request" button
    And I press the "Yes - remove" button
    Then I see "Your transcripts" on the page
    And I do not see "27 Nov 2023 14:29" on the page

  #Update will be needed to use clean data when available

  @DMP-1054
  Scenario: Delete multiple requests from ready section of your transcripts
    When I click on the "Your transcripts" link
    And I check the checkbox in the same row as "CASE1009" "21 Nov 2023 10:18"
    And I check the checkbox in the same row as "CASE1009" "17 Nov 2023 10:03"
    And I press the "Remove transcript request" button
    Then I see "Are you sure you want to remove these transcript requests?" on the page
    And I see "This action will remove these transcript requests from your transcripts. You can still access them by searching at the hearing and case levels." on the page

    When I click on the "Cancel" link
    And I see "Your transcripts" on the page
    And I check the checkbox in the same row as "CASE1009" "21 Nov 2023 10:18"
    And I check the checkbox in the same row as "CASE1009" "17 Nov 2023 10:03"
    And I press the "Remove transcript request" button
    And I press the "Yes - remove" button
    Then I see "Your transcripts" on the page
    And I do not see "21 Nov 2023 10:18" on the page
    And I do not see "17 Nov 2023 10:03" on the page

    #Update will be needed to use clean data when available

  @DMP-1740
  Scenario: Your audio - Expired screen
    When I click on the "Your audio" link
    And  I click on the "Expired" link
    Then I verify the HTML table contains the following values
      |*NO-CHECK* | Case ID    | Court     | Hearing date   | Start time| End time  | Request ID| Expiry date          | Status    |
      |*NO-CHECK* | CASE1009   | Swansea   | 15 Aug 2023    | 14:00:00  | 14:01:00  |  7713     | 09:20:02 13/12/2023  |  EXPIRED  |
      |*NO-CHECK* | CASE1009   | Swansea   | 15 Aug 2023    | 13:00:00  | 13:01:00  | 8385      | 16:30:00 19/12/2023  | EXPIRED   |

  @DMP-2123
  Scenario: Delete single transcripts request warning
    When I click on the "Your transcripts" link
    And I check the checkbox in the same row as "DMP-1908" "Swansea"
    And I press the "Remove transcript request" button
    And I see "Are you sure you want to remove this transcript request?" on the page
    And I see "This action will remove this transcript request from your transcripts. You can still access it by searching at the hearing and case levels." on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Courthouse | Hearing date | Type        | Requested on      | Status   | Urgency   |
      | DMP-1908 | Swansea    | 26 Jan 2024  | Antecedents | 26 Jan 2024 16:06 | Complete | OVERNIGHT |
    And I see the "Yes - delete" button
    And I see link with text "Cancel"

   #Update will be needed to use dynamic data when available.

  @DMP-2124
  Scenario: Delete multiple transcripts request warning
    When I click on the "Your transcripts" link
    And I check the checkbox in the same row as "DMP-1908" "Swansea"
    And I check the checkbox in the same row as "S859001" "Harrow Crown Court"
    And I press the "Remove transcript request" button
    And I see "Are you sure you want to remove these transcript requests?" on the page
    And I see "This action will remove these transcript requests from your transcripts. You can still access them by searching at the hearing and case levels." on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Courthouse         | Hearing date | Type               | Requested on      | Status   | Urgency   |
      | DMP-1908 | Swansea            | 26 Jan 2024  | Antecedents        | 26 Jan 2024 16:06 | Complete | OVERNIGHT |
      | S859001  | Harrow Crown Court | 17 Jan 2024  | Sentencing remarks | 26 Jan 2024 15:47 | Complete | OVERNIGHT |
    And I see the "Yes - delete" button
    And I see link with text "Cancel"

  #Update will be needed to use dynamic data when available

