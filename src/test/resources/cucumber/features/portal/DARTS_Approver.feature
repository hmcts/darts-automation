Feature: User as a Approver

  Background:
    Given I am logged on to DARTS as an APPROVER user

  @DMP-1059
  Scenario: Verify Your Transcript Screen
    When I click on the "Your Transcripts" link
    And I see "Your Transcripts" on the page
    And I see "Requests to approve or reject" on the page
    Then I verify the HTML table contains the following values
      | Case ID            | Court   | Hearing date | Type                              | Requested on      | Request ID | Urgency               |
      | Case1              | Swansea | 31 Aug 2023  | Antecedents                       | 17 Nov 2023 15:06 | 2893       | OVERNIGHT             |
      | CASE1009           | Swansea | 15 Aug 2023  | Mitigation                        | 17 Nov 2023 10:03 | 2857       | Up to 3 working days  |
      | CASE1009           | Swansea | 15 Aug 2023  | Court Log                         | 17 Nov 2023 10:02 | 2856       | Other                 |
      | CASE1009           | Swansea | 15 Aug 2023  | Argument and submission of ruling | 17 Nov 2023 10:02 | 2855       | OVERNIGHT             |
      | CASE1009           | Swansea | 15 Aug 2023  | Antecedents                       | 17 Nov 2023 10:01 | 2854       | Standard              |
      | CASE1009           | Swansea | 15 Aug 2023  | Summing up (including verdict)    | 17 Nov 2023 09:53 | 2853       | Standard              |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Prosecution opening of facts      | 17 Nov 2023 09:28 | 2833       | OVERNIGHT             |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Summing up (including verdict)    | 16 Nov 2023 16:44 | 2813       | Other                 |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Court Log                         | 16 Nov 2023 16:56 | 2800       | Standard              |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Argument and submission of ruling | 16 Nov 2023 16:55 | 2799       | Up to 12 working days |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Summing up (including verdict)    | 16 Nov 2023 16:53 | 2798       | Up to 3 working days  |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Sentencing remarks                | 16 Nov 2023 16:51 | 2797       | Other                 |
      | CASE5_Event_DMP461 | Swansea | 11 Aug 2023  | Sentencing remarks                | 16 Nov 2023 16:48 | 2796       | Other                 |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Mitigation                        | 16 Nov 2023 16:45 | 2795       | Other                 |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Sentencing remarks                | 16 Nov 2023 16:43 | 2793       | Other                 |
    And I click on the pagination link "2"
    And I see "Next" on the page
    And I see "Previous" on the page

    @DMP-1009
    Scenario Outline: Approve/Reject Transcript Request Screen
      When I click on the "Your Transcripts" link
      And I see "Your Transcripts" on the page
      And I see "Requests to approve or reject" on the page
      Then I click on "View" in the same row as "<CaseID>"
      And I see "<Restriction>" on the page
      And I see "Approve transcript request" on the page
      And I see "Case details" on the page
      And I see "<CaseID>" on the page
      And I see "<Courthouse>" on the page
      And I see "<Defendants>" on the page
      And I see "<Judge(s)>" on the page
      And I see "Hearing details" on the page
      And I see "<HearingDate>" on the page
      And I see "<RequestType>" on the page
      And I see "<urgency>" on the page
      And I see "<From>" on the page
      And I see "<Instructions>" on the page
      And I see "<JudgeApproval>" on the page
      And I see "Do you approve this request?" on the page
      Examples:
        | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType                       | urgency              | HearingDate | From      | Instructions | JudgeApproval |
        | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Argument and submission of ruling | Up to 3 working days | 14 Aug 2023 | Requester |              | Yes           |

    @DMP-1815-AC1
    Scenario Outline: transcript request approval process is cancelled
      When I click on the "Your transcripts" link
      And I see "Your transcripts" on the page
      And I see "Requests to approve or reject" on the page
      Then I click on "View" in the same row as "<CaseID>"
      And I see "<Restriction>" on the page
      And I see "Approve transcript request" on the page
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
      And I see "<JudgeApproval>" on the page
      And I see "Do you approve this request?" on the page
      And I press the "Submit" button
      Then I see an error message "Select if you approve this request or not"
      
          Examples:
            | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType | urgency              | HearingDate | From         | JudgeApproval  |
            | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Mitigation  | Up to 7 working days | 14 Aug 2023 | 	global_judge| Yes           |


    @DMP-1011-AC3
    Scenario Outline: transcript request approval process cancel link
      When I click on the "Your transcripts" link
      And I see "Your transcripts" on the page
      And I click on the "Transcript requests to review" link
      Then I click on "View" in the same row as "<CaseID>"
      And I see "<Restriction>" on the page
      And I see "Approve transcript request" on the page
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
      And I see "<JudgeApproval>" on the page
      And I see "Do you approve this request?" on the page
      Then I click on the "Cancel" link
      And I see "Your transcripts" on the page

      Examples:
        | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType                     | urgency              | HearingDate | From         | JudgeApproval |
        | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Summing up (including verdict)  | Up to 3 working days | 15 Aug 2023 | global_judge | Yes           |


  @DMP-1011-AC4
  Scenario Outline: Error - No reason
    When I click on the "Your transcripts" link
    And I see "Your transcripts" on the page
    And I click on the "Transcript requests to review" link
    Then I click on "View" in the same row as "<CaseID>"
    And I see "<Restriction>" on the page
    And I see "Approve transcript request" on the page
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
    And I see "<JudgeApproval>" on the page
    And I see "Do you approve this request?" on the page
    Then I select the "No" radio button
    And I press the "Submit" button
    Then I see an error message "You must explain why you cannot approve this request"


    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType                     | urgency              | HearingDate | From         | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Summing up (including verdict)  | Up to 3 working days | 15 Aug 2023 | global_judge | Yes           |


