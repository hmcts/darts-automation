Feature: User as a Requester and Approver

  Background:
    Given I am logged on to DARTS as an REQUESTERAPPROVER user
  @DMP-1146
  Scenario: Verify Your Transcript Screen logged in as RequesterApprover
    When I click on the "Your Transcripts" link
    And I see "Your Transcripts" on the page
    And I click on the "Transcript requests" link
    Then I verify the HTML table contains the following values
      | Case ID            | Court   | Hearing date | Type                         | Requested on      | Status                 | Urgency   |
      | CASE5_Event_DMP461 | Swansea | 11 Aug 2023  | Court Log                    | 21 Nov 2023 16:12 | AWAITING AUTHORISATION | OVERNIGHT |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Prosecution opening of facts | 21 Nov 2023 16:10 | AWAITING AUTHORISATION | OVERNIGHT |
    And I click on the "Transcript requests to review" link
    And I see "Requests to approve or reject" on the page
    Then I verify the HTML table contains the following values
      | Case ID            | Court   | Hearing date | Type                              | Requested on      | Request ID | Urgency               |
      | CASE5_Event_DMP461 | Swansea | 10 Aug 2023  | Antecedents                       | 21 Nov 2023 11:26 | 3033       | OVERNIGHT             |
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
    And I click on the pagination link "2"
    And I see "Next" on the page
    And I see "Previous" on the page