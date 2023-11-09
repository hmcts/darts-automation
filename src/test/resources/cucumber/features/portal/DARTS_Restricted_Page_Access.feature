Feature: Restricted Page Access
@DMP-1486
  Scenario: Error for Restricted Page Access
    Given I am logged on to DARTS as an external user
    And I navigate to the url "https://darts-portal.staging.platform.hmcts.net/case/1235"
    Then I see "You do not have permission to access this page" on the page
    And I see "If you believe you should have permission, contact Crown IT Support" on the page
    And I click on the "contact Crown IT Support" link