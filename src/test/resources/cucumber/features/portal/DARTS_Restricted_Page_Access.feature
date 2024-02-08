Feature: Restricted Page Access
@DMP-1486 @regression
  Scenario: Error for Restricted Page Access
    Given I am logged on to DARTS as an REQUESTER user
    And I navigate to the url "/work"
    Then I see "You do not have permission to access this page" on the page
    And I see "If you believe you should have permission, contact Crown IT Support" on the page
    And I click on the "contact Crown IT Support" link

  @DMP-1479 @regression
  Scenario: Error - 404 - Page not found
    Given I am logged on to DARTS as an external user
    And I navigate to the url "/case/1"
    Then I see "Page not found" on the page
    And I click on the "Go to search" link
    And I see "Search for a case" on the page