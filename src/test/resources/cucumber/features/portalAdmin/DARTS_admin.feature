Feature: Admin

  @DMP-2187-AC1,AC-2
  Scenario: Admin access and landing page
    When  I am logged on to the admin portal as an ADMIN user
    Then  I see "Users" on the page
    And   I see links with text:
      | Users | Groups | Organisations | Courthouses | Events | Node registry | Transformed media | Transcript requests |
      | Y     | Y      | Y             | Y           | Y      | Y             | Y                 | Y                   |
    And   I see link with text "HMCTS"
    And   I see link with text "DARTS"
    And   I see link with text "Sign out"

  @DMP-2187-AC3
  Scenario Outline: No ADMIN permissions
    When  I am logged on to the admin portal as a <role> user
    Then I see "Page not found" on the page

    Examples:
      | role              | 
      | judge             |
      | transcriber       |
      | languageshop      |
      | requester         |
      | approver          |
			| APPEALCOURT       |
			| TRANSCRIBER       |
			| LANGUAGESHOP      |
			| REQUESTERAPPROVER |

  @DMP-634
  Scenario: Search for Users in Portal Primary page
    When I am logged on to the admin portal as an ADMIN user
    And I see "Users" on the page
    Then I see "Full name" on the page
    And I see "Email" on the page
    And I see "Active users" on the page
    And I see "Inactive users" on the page
    And I see "All" on the page

  @DMP-725
  Scenario: Search page for Courthouses
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Courthouses" link
    Then I see "Search for courthouse" on the page
    And I see "Courthouse name" on the page
    And I see "Display name" on the page
    And I see "Region" on the page

  @DMP-2178 @DMP-630-AC1-AC2
  Scenario Outline: New user account - Check user details
    When I am logged on to the admin portal as an ADMIN user
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
      | Full name  | Email                 | Description |
      | Joe Bloggs | darts.test4@hmcts.net | Test        |

  @DMP-630-AC3-1
  Scenario Outline: Create a new user account with existing email address
    When I am logged on to the admin portal as an ADMIN user
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
    Then I see "There is a problem" on the page
    And I see an error message "Enter a unique email address"
    Then I see "email" on the page
    And I see an error message "Enter a unique email address"
    Examples:
      | Full name    | Email                 | Description |
      | global_judge | darts.judge@hmcts.net |             |

  @DMP-630-AC3-2
  Scenario Outline: Create a new user account with invalid email format
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
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
    Then I see "There is a problem" on the page
    And I see an error message "Enter an email address in the correct format, like name@example.com"
    Then I see "email" on the page
    And I see an error message "Enter an email address in the correct format, like name@example.com"
    Examples:
      | Full name    | Email       | Description |
      | global_judge | darts.judge |             |

  @DMP-630-AC3-3
  Scenario Outline: Create a new user account without full name
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
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
    Then I see "There is a problem" on the page
    And I see an error message "Enter a full name"
    Then I see "Full name" on the page
    And I see an error message "Enter a full name"
    Examples:
      | Full name | Email                | Description |
      |           | darts.judge@hmct.net |             |

  @DMP-630-AC3-4
  Scenario Outline: Create a new user account without Email address
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
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
    Then I see "There is a problem" on the page
    And I see an error message "Enter an email address"
    Then I see "email" on the page
    And I see an error message "Enter an email address"
    Examples:
      | Full name | Email | Description |
      | Test      |       |             |

  @DMP-630-AC3-5
  Scenario Outline: Create a new user account with more than 256 characters
    When I am logged on to the admin portal as an ADMIN user
    Then I see "Users" on the page
    And I press the "Create new user" button
    And I see "Enter user details" on the page
    And I see "Full name" on the page
    And I see "Email" on the page
    And I see "Description (optional)" on the page
    Then I set "Full name" to "<Full name>"
    And I set "Email" to "<Email>"
    And I set "Description (optional)" to "<Description>"
    And I press the "Continue" button
    Then I see "Description (optional)" on the page
    And I see "Enter a description shorter than 256 characters" on the page
    And I press the "Continue" button
    Then I see "There is a problem" on the page
    And I see an error message "Enter a description shorter than 256 characters"
    Examples:
      | Full name | Email             | Description                                                                                                                                                                                                                                                           |
      | Test      | Test999@hmcts.net | Test. Test. Test. Test. Test. Test. Test. Test. Test. Test. Test v. Test.   Test.   Test. Test.   Test. Test. v. Test. Test TestTestTestvvvvvvvTest Test Test Test TestTest Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test |

  @DMP-2931 @regression
  Scenario: Remove user role, single and multiple, test cancel link
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Courthouses" link
    And I set "Courthouse name" to "Harrow"
    And I press the "Search" button
    And I click on the "Harrow Crown Court" link
    And I click on the "Users" sub-menu link
    And I check the checkbox in the same row as "Testuserfour" "testuserfour@hmcts.net"
    And I press the "Remove user role" button
    Then I see "You are removing 1 user role from Harrow Crown Court" on the page

    When I click on the "Cancel" link
    Then I see "Courthouse record" on the page
    And I do not see "You are removing 1 user role from Harrow Crown Court" on the page

    When I check the checkbox in the same row as "Testuserfour" "testuserfour@hmcts.net"
    And I press the "Remove user role" button
    And I see "You are removing 1 user role from Harrow Crown Court" on the page
    And I see "Testuserfour" in the same row as "testuserfour@hmcts.net"
    And I press the "Confirm" button
    Then I see "1 user role removed from Harrow Crown Court" on the page
    And I do not see "Testuserfour" on the page

    When I check the checkbox in the same row as "Testuserfive" "testuserfive@hmcts.net"
    And I check the checkbox in the same row as "Testusersix" "testusersix@hmcts.net"
    And I press the "Remove user roles" button
    And I see "You are removing 2 user roles from Harrow Crown Court" on the page
    And I see "Testuserfive" in the same row as "testuserfive@hmcts.net"
    And I see "Testusersix" in the same row as "testusersix@hmcts.net"
    And I press the "Confirm" button
    Then I see "2 user roles removed from Harrow Crown Court" on the page
    And I do not see "Testuserfive" on the page
    And I do not see "Testusersix" on the page

    #Add users back to roles for next run

    When I click on the "Users" link
    And I set "Full name" to "Testuserfour"
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserfour"
    And I see "First user for 2931" on the page
    And I click on the "Groups" sub-menu link
    And I see "This user is not a member of any groups." on the page
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Harrow"
    And I check the checkbox in the same row as "Harrow Crown Court_REQUESTER" "Requestor"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page
    And I do not see "This user is not a member of any groups." on the page

    When I click on the "Users" link
    And I set "Full name" to "Testuserfive"
    And I press the "Search" button
    And I click on "View" in the same row as "Testuserfive"
    And I see "Second user for 2931" on the page
    And I click on the "Groups" sub-menu link
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Harrow"
    And I check the checkbox in the same row as "Harrow Crown Court_REQUESTER" "Requestor"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page

    When I click on the "Users" link
    And I set "Full name" to "Testusersix"
    And I press the "Search" button
    And I click on "View" in the same row as "Testusersix"
    And I see "Third user for 2931" on the page
    And I click on the "Groups" sub-menu link
    And I press the "Assign groups" button
    And I set "Filter by group name" to "Harrow"
    And I check the checkbox in the same row as "Harrow Crown Court_REQUESTER" "Requestor"
    And I press the "Assign groups" button
    Then I see "Assigned 1 group" on the page