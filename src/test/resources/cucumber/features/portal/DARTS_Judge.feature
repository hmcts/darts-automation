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

  @DMP-1618
  Scenario: Judge able to view and request transcripts

    When I click on the "Your transcripts" link
    Then I see "In Progress" on the page
    And I see "Ready" on the page

    When I click on the "Search" link
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    And I click on "CASE1009" in the same row as "Swansea"
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I click on the "Transcripts" link
    And I press the "Request a new transcript" button
    And I select "Mitigation" from the "Request Type" dropdown
    And I select "Up to 7 working days" from the "Urgency" dropdown
    And I press the "Continue" button
    And I set "Comments to the Transcriber (optional)" to "Testing judge's ability to request transcript"
    And I see "Check and confirm your transcript request" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    Then I see "Transcript request submitted" on the page

    When I click on the "Return to hearing date" link
    And I click on the "Your transcripts" link
    Then I see "CASE1009" in the same row as "Mitigation"

