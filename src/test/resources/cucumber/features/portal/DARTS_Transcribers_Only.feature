Feature: Request Audio for transcribers

  Background:
    Given I am logged on to DARTS as an TRANSCRIBER user

  @DMP-696
  Scenario Outline: Request Audio for transcribers-Playback Only
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    And I see "Restriction: Judge directed on reporting restrictions" on the page
        #Case Details
    When I click on "CASE1009" in the same row as "Swansea"
     #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    #Confirm your Order
    Then I see "Confirm your Order" on the page
    And I see "<Restriction>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Audio details" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Confirm" button
    #Order Confirmation
    Then I see "Your order is complete" on the page
    And I see "<Restriction>" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-696
  Scenario Outline: Request Audio for Transcribers - Download
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    And I see "Restriction: Judge directed on reporting restrictions" on the page
        #Case Details
    When I click on "CASE1009" in the same row as "Swansea"
     #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
     #Confirm your Order
    Then I see "Confirm your Order" on the page
    And I see "<Restriction>" on the page
    Then I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Audio details" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Confirm" button
    #Order Confirmation
    Then I see "Your order is complete" on the page
    And I see "<Restriction>" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-1326
  Scenario Outline: Manual Transcription Request - Upload Transcript
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Transcript Request" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<HearingDate>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Judge(s)>" on the page
    And I see "<Defendant(s)>" on the page
    And I see "Hearing details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<Urgency>" on the page
    And I see "<From>" on the page
    And I see "<Instructions>" on the page
    And I see "<JudgeApproval>" on the page
    Examples:
      | CaseID   | Restriction                                           | Courthouse | Judge(s) | Defendant(s) | HearingDate | RequestType | RequestMethod | Urgency | From       | Instructions | JudgeApproval |
      | CASE1009 | Restriction: Judge directed on reporting restrictions | Swansea    | Mr Judge | Jow Bloggs   | 14 Aug 2023 | Court Log   | Manual        | Other   | RCJ Appeal | DMP-1025     | Yes           |

  @DMP-1326-AC1
  Scenario Outline: Manual Transcription Request - Get Audio
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<HearingDate>"
    And I see "Transcript request" on the page
    And I see "<CaseID>" on the page
    And I press the "Get audio for this request" button
    And I see "Events and audio recordings" on the page
    Examples:
      | HearingDate | CaseID   |
      | 15 Aug 2023 | CASE1009 |

  @DMP-1326-AC2
  Scenario Outline: Manual Transcription Request - Select file
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "Transcript request" on the page
    And I see "<CaseID>" on the page
    And I see "Upload transcript file" on the page
    And I see "This must be in a doc or docx format. Maximum file size 10MB." on the page
    #Add line to click upload file. New  step def may be required.
    Examples:
      | CaseID   |
      | CASE1009 |

  @DMP-1326-AC4
  Scenario Outline: Manual Transcription Request - Cancel Upload
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "Transcript request" on the page
    And I see "<CaseID>" on the page
    Then I click on the "Cancel" link
    And I see "Your work" on the page
    And I see "<CaseID>" on the page
    Examples:
      | CaseID   |
      | CASE1009 |

  @DMP-1234-AC1
  Scenario Outline: Assign transcript order screen - View order details
    When I click on the "Transcript requests" link
    And I see "Transcript requests" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Transcript Request" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Judge(s)>" on the page
    And I see "<Defendant(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<Urgency>" on the page
    And I see "<From>" on the page
    And I see "<JudgeApproval>" on the page
    Examples:
      | CaseID   | Restriction                                           | Courthouse | Judge(s) | Defendant(s) | HearingDate | RequestType                       | RequestMethod | Urgency              | From      | JudgeApproval |
      | CASE1009 | Restriction: Judge directed on reporting restrictions | Swansea    | Mr Judge | Jow Bloggs   | 14 Aug 2023 | Argument and submission of ruling | Manual        | Up to 3 working days | Requester | Yes           |

  @DMP-1198-AC2
  Scenario Outline: Transcript Requests - Transcribers
    When I click on the "Transcript requests" link
    And I see "Transcript requests" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<urgency>" on the page
    And I see "<JudgeApproval>" on the page
    And I see "Choose an action" on the page
    And I see "Assign to me" on the page
    And I see "Assign to me and get audio" on the page
    And I see "Assign to me and upload a transcript" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType                       | urgency              | HearingDate | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Argument and submission of ruling | Up to 3 working days | 14 Aug 2023 | Yes           |

  @DMP-1198-AC3
  Scenario: Transcript Requests - Sortable Column descending
    When I click on the "Transcript requests" link
    And I see "Transcript requests" on the page
    When I click on "Case ID" in the table header
    Then "Case ID" has sort "descending" icon
    When I click on "Court" in the table header
    Then "Court" has sort "descending" icon
    When I click on "Hearing date" in the table header
    Then "Hearing date" has sort "descending" icon
    When I click on "Type" in the table header
    Then "Type" has sort "descending" icon
    When I click on "Requested on" in the table header
    Then "Requested on" has sort "descending" icon
    When I click on "Method" in the table header
    Then "Method" has sort "descending" icon
    When I click on "Urgency" in the table header
    Then "Urgency" has sort "descending" icon
    When I click on "Urgency" in the table header
    Then "Urgency" has sort "ascending" icon

@DMP-1203
  Scenario: Transcriber navigation bar

    When I click on the "Your work" link
    And I see "To do" on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Court    | Hearing date | Type               | Requested on      | Urgency  |
      | CASE1009 | Swansea  | 05 Dec 2023  | Other              | 05 Dec 2023 16:34 | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |

    When I click on the "Completed today" link
    Then I verify the HTML table contains the following values
      | Case ID  | Court    | Hearing date | Type     | Requested on      | Urgency  |
      | CASE1009 | Swansea  | 05 Dec 2023  | Other    | 05 Dec 2023 16:40 | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE* | *IGNORE*          | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*     | *IGNORE* | *IGNORE*          | *IGNORE* |
    #Then I see "There are no transcript requests completed today" on the page - Save for negative test

    When I click on the "Your audio" link
    Then I see "Current" on the page
    And I see "In Progress" on the page
    And I see "Ready" on the page
    And I see "Expired" on the page

    When I click on the "Transcript requests" link
    Then I verify the HTML table contains the following values
      | Case ID       | Court          | Hearing date | Type                           | Requested on      | Method    | Urgency  |
      | DMP1600-case1 | London_DMP1600 | 11 Oct 2023  | Summing up (including verdict) | 05 Dec 2023 10:44 | Automated | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
      | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |

 @DMP-1243-AC5
    Scenario Outline: Assign transcript order screen - Cancel Assign

      When I click on the "Transcript requests" link
      And I see "Transcript requests" on the page
      Then I click on "View" in the same row as "<CaseID>"
      And I see "Transcript request" on the page
      And I see "Case details" on the page
      When I click on the "Cancel" link
      And I see "Transcript requests" on the page
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type  | Requested on      | Method    | Urgency  |
        | DMP1600-case1 | London_DMP1600 | 12 Oct 2023  | Other | 05 Dec 2023 10:16 | Automated | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
        | *IGNORE* | *IGNORE* | *IGNORE*  | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |

      Examples:
        | CaseID   |
        | CASE1009 |

    @DMP-1243-AC6
    Scenario Outline: Assign transcript order screen - Error no selection made

      When I click on the "Transcript requests" link
      And I see "Transcript requests" on the page
      Then I click on "View" in the same row as "<CaseID>"
      And I see "Transcript request" on the page
      And I see "Case details" on the page
      Then I press the "Continue" button
      And I see an error message "Select an action to progress this request."

      Examples:
        | CaseID   |
        | CASE1009 
        
 @DMP-1331
  Scenario Outline: Automated Transcription Request - Upload Transcript
  
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<RequestID>" on the page
    And I see "<urgency>" on the page
    And I see "<JudgeApproval>" on the page

    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType       | urgency   | RequestMethod | RequestID    |HearingDate | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions |Sentencing remarks | Overnight | Manual        | 3773         |14 Aug 2023 | Yes           |

    And I see "Transcript request" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<HearingDate>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Judge(s)>" on the page
    And I see "<Defendant(s)>" on the page
    #And I see "Hearing details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<Urgency>" on the page
    And I see "<From>" on the page
    And I see "<JudgeApproval>" on the page
    Examples:
      | CaseID   | Restriction                                           | Courthouse | Judge(s) | Defendant(s) | HearingDate | RequestType | RequestMethod | Urgency   | From                   | JudgeApproval |
      | CASE1009 | Restriction: Judge directed on reporting restrictions | Swansea    | Mr Judge | Jow Bloggs   | 05 Dec 2023 | Other       | Automated     | Overnight | darts_global_test_user | Yes           |

  @DMP-1331-AC1
  Scenario Outline: Automated Transcription Request - Get Audio
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<HearingDate>"
    And I see "Transcript request" on the page
    And I see "<CaseID>" on the page
    And I press the "Get audio for this request" button
    And I see "Events and audio recordings" on the page
    Examples:
      | HearingDate | CaseID   |
      | 05 Dec 2023 | CASE1009 |

  @DMP-1331-AC3
  Scenario Outline: Automated Transcription Request - Cancel Upload
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<HearingDate>"
    And I see "Transcript request" on the page
    And I see "<CaseID>" on the page
    Then I click on the "Cancel" link
    And I see "Your work" on the page
    And I see "<CaseID>" on the page
    Examples:
      | CaseID   | HearingDate |
      | CASE1009 | 05 Dec 2023 |

  @DMP-1351-AC2
  Scenario: Your work - completed today tab - Sortable column
    When I click on the "Your work" link
    And I see "Your work" on the page
    And I click on the "Completed today" link
    When I click on "Case ID" in the table header
    Then "Case ID" has sort "descending" icon
    When I click on "Court" in the table header
    Then "Court" has sort "descending" icon
    When I click on "Hearing date" in the table header
    Then "Hearing date" has sort "descending" icon
    When I click on "Type" in the table header
    Then "Type" has sort "descending" icon
    When I click on "Requested on" in the table header
    Then "Requested on" has sort "descending" icon
    When I click on "Urgency" in the table header
    Then "Urgency" has sort "descending" icon

    @DMP-1351-AC1-AC3
    Scenario Outline: Your work - completed today tab - View link
      When I click on the "Your work" link
      And I see "Your work" on the page
      And I click on the "Completed today" link
      And I see "Completed today" on the page
      Then I click on "View" in the same row as "<CaseID>"
      And I see "Transcript request" on the page
    Examples:
      | CaseID   |
      | CASE1009 |

@DMP-1255-AC1
    Scenario: Transcriber's Your Work - List all to do items

      When I click on the "Your work" link
      And I see "Your work" on the page
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type        | Requested on      | Urgency  |
        | DMP1600-case1 | London_DMP1600 | 01 Dec 2023  | Antecedents | 06 Dec 2023 14:48 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |

    @DMP-1255-AC2
    Scenario: Transcriber's Your Work - Sortable columns

      When I click on the "Your work" link
      And I see "Your work" on the page
      #checks first table header descending order
      And I click on "Case ID" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court            | Hearing date | Type        | Requested on      | Urgency  |
        | long audio    | PerfCourtHouse01 | 23 Nov 2023  | Antecedents | 01 Dec 2023 08:50 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
      #checks first table header ascending order
      And I click on "Case ID" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type               | Requested on      | Urgency  |
        | CASE1009      | Swansea        | 15 Aug 2023  | Sentencing remarks | 04 Dec 2023 10:36 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
      #checks second table header descending order
      And I click on "Court" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type               | Requested on      | Urgency  |
        | CASE1009      | Swansea        | 15 Aug 2023  | Sentencing remarks | 04 Dec 2023 10:36 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
       #checks second table header ascending order
      And I click on "Court" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type        | Requested on      | Urgency  |
        | DMP1600-case1 | London_DMP1600 | 01 Dec 2023  | Antecedents | 06 Dec 2023 14:48 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
       #checks third table header descending order
      And I click on "Hearing date" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type        | Requested on      | Urgency  |
        | DMP1600-case1 | London_DMP1600 | 01 Dec 2023  | Antecedents | 06 Dec 2023 14:48 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
       #checks third table header ascending order
      And I click on "Hearing date" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type               | Requested on      | Urgency  |
        | CASE1009      | Swansea        | 15 Aug 2023  | Sentencing remarks | 04 Dec 2023 10:36 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*           | *IGNORE*          | *IGNORE* |
        #checks fourth table header descending order
      And I click on "Type" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type                           | Requested on      | Urgency  |
        | CASE1009      | Swansea        | 15 Aug 2023  | Summing up (including verdict) | 01 Dec 2023 17:19 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
       #checks fourth table header ascending order
      And I click on "Type" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court            | Hearing date | Type        | Requested on      | Urgency  |
        | long audio    | PerfCourtHouse01 | 23 Nov 2023  | Antecedents | 01 Dec 2023 08:50 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
      #checks fourth table header descending order
      And I click on "Requested on" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type        | Requested on      | Urgency  |
        | DMP1600-case1 | London_DMP1600 | 01 Dec 2023  | Antecedents | 06 Dec 2023 14:48 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*    | *IGNORE*          | *IGNORE* |
      #checks fourth table header ascending order
      And I click on "Requested on" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court            | Hearing date | Type        | Requested on      | Urgency  |
        | long audio    | PerfCourtHouse01 | 23 Nov 2023  | Antecedents | 01 Dec 2023 08:50 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
       #checks fifth table header descending order
      And I click on "Urgency" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court          | Hearing date | Type                           | Requested on      | Urgency  |
        | CASE1009      | Swansea        | 15 Aug 2023  | Summing up (including verdict) | 01 Dec 2023 17:19 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*                       | *IGNORE*          | *IGNORE* |
      #checks fifth table header ascending order
      And I click on "Urgency" in the table header
      Then I verify the HTML table contains the following values
        | Case ID       | Court            | Hearing date | Type        | Requested on      | Urgency  |
        | long audio    | PerfCourtHouse01 | 23 Nov 2023  | Antecedents | 01 Dec 2023 08:50 | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |
        | *IGNORE*      | *IGNORE*       | *IGNORE*     | *IGNORE*      | *IGNORE*          | *IGNORE* |

  @DMP-1255-AC3
  Scenario Outline: Transcriber's Your Work -  View Link on manual requests takes to Manual Transcript request
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<Judge(s)>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<RequestID>" on the page
    And I see "<urgency>" on the page
    And I see "<JudgeApproval>" on the page

    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType       | urgency   | RequestMethod | RequestID    |HearingDate | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions |Sentencing remarks | Overnight | Manual        | 3773         |14 Aug 2023 | Yes           |

  @DMP-1255-AC4
  Scenario Outline: Transcriber's Your Work -  View Link on automatic requests takes to Manual Transcript request
    When I click on the "Your work" link
    And I see "Your work" on the page
    Then I click on "View" in the same row as "<RequestedOn>"
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "Request details" on the page
    And I see "<HearingDate>" on the page
    And I see "<RequestType>" on the page
    And I see "<RequestMethod>" on the page
    And I see "<RequestID>" on the page
    And I see "<urgency>" on the page
    And I see "<JudgeApproval>" on the page

    Examples:
      | CaseID        |Courthouse       |RequestType                    | urgency               | RequestMethod | RequestID    |HearingDate | JudgeApproval | RequestedOn |
      | DMP1600-case1 |London_DMP1600   |Summing up (including verdict) | Up to 12 working days | Automated     | 	4013      |11 Oct 2023 | Yes           | 05 Dec 2023 10:44 |

