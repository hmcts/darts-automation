@admin @admin_retention_policies
Feature: Admin Retention Policies

@DMP-2466 @regression
  Scenario: Retention Policies primary page
    Given I am logged on to the admin portal as an ADMIN user
      #AC1 - View active polices
    And I click on the "System configuration" navigation link
    And I click on the "Retention policies" link
    And I see "Retention policies" on the page
    Then I verify the HTML table includes the following values
      | Display name  | Name                       | Description | Fixed policy key | Duration  | Policy start | Policy end | *SKIP* |
      | Not Guilty    | DARTS Not Guilty Policy    | *NO-CHECK*  | 1                | 1y 0m 0d  | *NO-CHECK*   | -          | *SKIP* |
      | Non Custodial | DARTS Non Custodial Policy | *NO-CHECK*  | 2                | 7y 0m 0d  | *NO-CHECK*   | -          | *SKIP* |
      | Custodial     | DARTS Custodial Policy     | *NO-CHECK*  | 3                | 7y 0m 0d  | *NO-CHECK*   | -          | *SKIP* |
      | Default       | DARTS Default Policy       | *NO-CHECK*  | 0                | 7y 0m 0d  | *NO-CHECK*   | -          | *SKIP* |
      | Permanent     | DARTS Permanent Policy     | *NO-CHECK*  | PERM             | 99y 0m 0d | *NO-CHECK*   | -          | *SKIP* |
      | Manual        | DARTS Manual Policy        | *NO-CHECK*  | MANUAL           | 0y 0m 0d  | *NO-CHECK*   | -          | *SKIP* |
      | Life          | DARTS Life Policy          | *NO-CHECK*  | 4                | 99y 0m 0d | *NO-CHECK*   | -          | *SKIP* |

      #AC 2 - View inactive polices
    And I click on the "Inactive" link
    Then I do not see "No data to display." on the page