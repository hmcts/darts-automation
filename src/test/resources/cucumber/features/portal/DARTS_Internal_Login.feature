Feature: Internal Login Portal

  @DMP-621 @regression
  Scenario: Internal sign in from link on external page
    Given I am on the landing page
    When I see "Sign in to the DARTS Portal" on the page
    And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
    And I see "I have an account for DARTS through my organisation." on the page
    And I press the "Continue" button
    Then I see "Sign in to the DARTS portal" on the page
    And I see "There is a dedicated page for HMCTS employees to sign into the portal." on the page
    And I click on the "There is a dedicated page for HMCTS employees to sign into the portal." link
    And I see "Sign in" on the page