Feature: Admin

  @DMP-2187-AC1,AC-2
  Scenario: Admin access and landing page
    When  I am logged on to DARTS as an ADMIN user
    Then  I see "Users" on the page
    And   I see links with text:
      | Users   | Groups  | Organisations | Courthouses | Events | Node registry | Transformed media | Transcript requests |
      | Y       | Y       | Y             | Y           | Y      | Y             | Y                 | Y                   |
    And   I see link with text "HMCTS"
    And   I see link with text "DARTS"
    And   I see link with text "Sign out"

  @DMP-2187-AC3
  Scenario: No ADMIN permissions
    When  I am logged on to DARTS as an TRANSCRIBER user
    Then I see "Page not found" on the page


    When I navigate to the url "/work"
    And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
    And I see "I have an account for DARTS through my organisation." on the page
    And I press the "Continue" button
    When I set "Enter your email" to "<email>"
    And I set "Enter your password" to "<password>"
    And I press the "Continue" button
    Then I see "Page not found" on the page
