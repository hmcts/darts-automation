Feature: User as a Requester and Approver

  Background:
    Given I am logged on to DARTS as an REQUESTERAPPROVER user

  @DMP-1146
  Scenario: Verify Your Transcript Screen
    When I click on the "Your Transcripts" link
    And I see "Your Transcripts" on the page
    And I click on the "Transcript requests" link
    And I see "There are no transcription requests in progress or ready" on the page
    And I click on the "Transcript requests to review" link
    And I see "Requests to review" on the page
    #Then I verify the HTML table contains the following values