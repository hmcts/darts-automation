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
  Scenario Outline: No ADMIN permissions
    When I navigate to the url "/admin"
    # And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
    And I click on the "I work with the HM Courts and Tribunals Service" link
    And I see "I have an account for DARTS through my organisation." on the page
    And I press the "Continue" button
    When I set "Enter your email" to "<Email>"
    And I set "Enter your password" to "<Password>"
    And I press the "Continue" button
    Then I see "Page not found" on the page

    Examples:
      | Email                        | Password   |
      | darts.transcriber@hmcts.net  | Password@1 |
      | darts.languageshop@hmcts.net | Password@1 |

  @DMP-2178
  Scenario Outline: New user account - Check user details
    When I am logged on to DARTS as an ADMIN user
    Then I see "Users" on the page
    And I see the "Create new user" button
    And I press the "Create new user" button
    And I see "Create user" on the page
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    #AC1 Review User Details
    Then I see "Check user details" on the page
    And I see "Details" on the page
    And I see "Full name" in the same row as "<Full name>"
    And I see "Email" in the same row as "<Email>"
    And I see "Description (optional)" in the same row as "<Description>"
    #AC2 Change User Details
    Then I click on the "Change" link
    Then I set "Full name" to "Test User Change"
    And I set "Email" to "testchange@test.com"
    And I set "Description (optional)" to "Test Change"
    And I press the "Continue" button
    #AC3 Cancel User Creation
    Then I click on the "Cancel" link
    And I press the "Create new user" button
    #AC4 Create a User
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    And I press the "Create user" button

    Examples:
      |Full name  | Email                  | Description  |
      |Joe Bloggs | darts.test4@hmcts.net  | Test         |
