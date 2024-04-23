Feature: Internal Login Portal

  @DMP-621 @DMP-625 @regression @demo
  Scenario Outline: Internal sign in from link on external page
    Given I am on the landing page
    When I see "Sign in to the DARTS Portal" on the page
    And I select the "I work with the HM Courts and Tribunals Service" radio button
    And I see "I have an account for DARTS through my organisation." on the page
    And I press the "Continue" button
    Then I see "Sign in to the DARTS portal" on the page
    And I see "There is a dedicated page for HMCTS employees to sign into the portal." on the page
    And I click on the "There is a dedicated page for HMCTS employees to sign into the portal." link
    And I see "Sign in" on the page
    When  I am logged on to DARTS as a <role> user
    Then  I see "Search for a case" on the page
    And   I see links with text:
      | Search   | Your audio  | Your transcripts  | Transcript requests  | Your work   |
      | <search> | <yourAudio> | <yourTranscripts> | <transcriptRequests> | <yourWork> |
    And   I see link with text "HMCTS"
    And   I see link with text "DARTS"
    And   I see link with text "Sign out"
    Examples:
      | role              | search | yourAudio | yourTranscripts | transcriptRequests | yourWork |
      | Judge             | Y      | Y         | Y               | N                  | N        |
      | REQUESTER         | Y      | Y         | Y               | N                  | N        |
      | APPROVER          | Y      | Y         | Y               | N                  | N        |
      | APPEALCOURT       | Y      | Y         | N               | N                  | N        |
      | REQUESTERAPPROVER | Y      | Y         | Y               | N                  | N        |