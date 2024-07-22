Feature: Admin User

   #TODO: Need to find out what groups to reassign, currently user is with PlatOps
  @DMP-2974 @DMP-2975
  Scenario: User state active/inactive

    Given I am on the portal page
    When I select the "I work with the HM Courts and Tribunals Service" radio button
    And I press the "Continue" button
    And I set "Enter your email" to "darts.userstate.test@hmcts.net"
    And I set "Enter your password" to "Password@1"
    And I press the "Continue" button
    Then I see "Search for a case" on the page

      #Deactivate user on Admin and attempt to log back in

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to the admin portal as an ADMIN user
    And I click on the "Users" link
    And I set "Email" to "darts.userstate.test@hmcts.net"
    And I press the "Search" button
    And I click on the "View" link
    And I press the "Deactivate user" button
    And I press the "Deactivate user" button
    Then I see "User record deactivated" on the page
    And I see "Inactive" on the page

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I select the "I work with the HM Courts and Tribunals Service" radio button
    And I press the "Continue" button
    And I set "Enter your email" to "darts.userstate.test@hmcts.net"
    And I set "Enter your password" to "Password@1"
    And I press the "Continue" button
    Then I see "You do not have permission to access this page" on the page

      #Reactivate user for next run

    When I Sign out
    And I see "Sign in to the DARTS Portal" on the page
    And I am logged on to the admin portal as an ADMIN user
    And I click on the "Users" link
    And I set "Email" to "darts.userstate.test@hmcts.net"
    And I select the "Inactive users" radio button
    And I press the "Search" button
    And I click on the "View" link
    And I press the "Activate user" button
    And I press the "Reactivate user" button
    Then I see "User record activated" on the page
    And I see "Active user" on the page

    When I click on the "Groups" sub-menu link
    And I press the "Assign groups" button

