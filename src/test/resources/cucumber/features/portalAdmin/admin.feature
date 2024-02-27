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

    @DMP-634
    Scenario: Search for Users in Portal Primary page
      When I am logged on to DARTS as an ADMIN user
      And I see "Users" on the page
      Then I see "Full name" on the page
      And I see "Email" on the page
      And I see "Active users" on the page
      And I see "Inactive users" on the page
      And I see "All" on the page


      





