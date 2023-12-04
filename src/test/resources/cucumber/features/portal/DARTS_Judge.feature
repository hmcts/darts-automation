Feature: User as a Judge

  Background:
    Given I am logged on to DARTS as an Judge user

  @DMP-1033
  Scenario Outline: View Transcript - Via Your Transcriptions screen
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
    And I see "<RequestType>" on the page
    And I see "<urgency>" on the page
    And I see "<From>" on the page
    And I see "<Instructions>" on the page
    And I see "<JudgeApproval>" on the page
    And I see "Do you approve this request?" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | Judge(s) | Restriction                                           | RequestType                  | urgency              | From      | Instructions | JudgeApproval |
      | CASE1009 | Swansea    | Jow Bloggs | Mr Judge | Restriction: Judge directed on reporting restrictions | Prosecution opening of facts | Up to 2 working days | Requester |              | Yes           |