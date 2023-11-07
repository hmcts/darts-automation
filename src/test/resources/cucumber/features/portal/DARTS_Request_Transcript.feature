Feature: Request Transcript

  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
      | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |
    Given I click on "CASE1009" in the same row as "Swansea"
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 2                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |
    #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page

  @DMP-862-AC1
  Scenario: View Transcript
    And I see the transcription-count is "2"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE |

  @DMP-862-AC2
  Scenario: Transcript - View link
    And I see the transcription-count is "2"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE |
    And I click on "View" in the same row as "system"

  @DMP-862-AC3
  Scenario: Transcript - Request a new transcript button works
    And I see the transcription-count is "1"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE |
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page

  @DMP-892
  Scenario Outline: Transcript - Request a new transcript
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
    And I see "Check and confirm your transcript request" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | Restriction                                           | transcription-type | urgency  |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Sentencing remarks | Standard |

  @DMP-892-AC3
  Scenario Outline: Transcript - Request a new transcript - Cancel link
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
    And I click on the "Cancel" link
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | Restriction                                           | transcription-type | urgency  |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Sentencing remarks | Standard |

  @DMP-892-AC5
  Scenario: Transcript - Request a new transcript - Error
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    And I press the "Continue" button
    And I see "There is a problem" on the page
    And I see "Please select a transcription type" on the page
    And I see "Please select an urgency" on the page
    And I select "Summing up (including verdict)" from the "Request Type" dropdown
    And I press the "Continue" button
    And I see "There is a problem" on the page
    And I see "Please select an urgency" on the page

  @DMP-892-AC5
  Scenario: Transcript - Request a new transcript - Error1
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    And I select "Summing up (including verdict)" from the "Request Type" dropdown
    And I press the "Continue" button
    And I see "There is a problem" on the page
    And I see "Please select an urgency" on the page

  @DMP-892-AC5
  Scenario: Transcript - Request a new transcript - Error2
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    And I select "Overnight" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "There is a problem" on the page
    And I see "Please select a transcription type" on the page

  @DMP-892
  Scenario: Transcript - Request a new transcript - Urgency dropdown
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    Then the dropdown "Urgency" contains the options "Please select,Standard,Overnight,Other"

  @DMP-892
  Scenario: Transcript - Request a new transcript - Verify transcription-type dropdown
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    Then the dropdown "Request Type" contains the options
      | Please select                     |
      | Sentencing remarks                |
      | Summing up (including verdict)    |
      | Antecedents                       |
      | Argument and submission of ruling |
      | Court Log                         |
      | Mitigation                        |
      | Proceedings after verdict         |
      | Prosecution opening of facts      |
      | Specified Times                   |
      | Other                             |

  @DMP-917
  Scenario Outline: Request Transcript - Audio Times/Events using checkbox
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
    And I verify the HTML table contains the following values
      | Start Time | End Time | *IGNORE*        |
      | 10:00:00   | 11:14:05 | Audio Recording |
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | Restriction                                           | transcription-type | urgency  |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Specified Times    | Standard |

  @DMP-917
  Scenario Outline: Request Transcript - Audio Times/Events - manually entering time
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
    And I verify the HTML table contains the following values
      | Start Time | End Time | *IGNORE*        |
      | 10:00:00   | 11:14:05 | Audio Recording |
    And I set the time fields of "Start time" to "<StartTime>"
    And I set the time fields of "End time" to "<EndTime>"
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | Restriction                                           | transcription-type | urgency  | StartTime | EndTime  |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Restriction: Judge directed on reporting restrictions | Specified Times    | Standard | 13:07:33  | 13:07:33 |

  @DMP-917
  Scenario Outline: Request Transcript - Audio Times/Events - Cancel link
    Then I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I see "Request a new transcript" on the page
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "Events, audio and specific times requests" on the page
    And I click on the "Cancel" link
    Examples:
      | transcription-type | urgency  |
      | Sentencing remarks | Standard |

  @DMP-934
  Scenario Outline: Request Transcript - Check and confirm your transcript request
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
    And I see "Case Details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Request Details" on the page
    And I see "<HearingDate>" on the page
    And I see "<transcription-type>" on the page
    And I see "<urgency>" on the page
    And I see "Comments to the Transcriber (optional)" on the page
    And I see "Provide any further instructions or comments for the transcriber." on the page
    And I see "You have 2000 characters remaining" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button

    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | transcription-type | urgency  |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | Specified Times    | Standard |