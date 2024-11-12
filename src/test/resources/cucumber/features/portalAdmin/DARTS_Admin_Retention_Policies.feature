@admin @admin_retention_policies
Feature: Admin Retention Policies



  @DMP-2466 @TODO
  Scenario: Retention Policies primary page
    Given I am logged on to the admin portal as an ADMIN user
      #AC1 - View active polices
    And I click on the "System configuration" navigation link
    And I click on the "Retention policies" link
    And I see "Retention policies" on the page
    Then I verify the HTML table contains the following values
#TODO needs an alternative method to verify these rows exist but its ok for others to exist too
      | Name          | Description | Fixed policy key | Duration | Policy start | Policy end | *SKIP* |
#      | DARTS Permanent Retention v3 | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
#      | DARTS Standard Retention v3  | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Not Guilty    | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Non Custodial | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Custodial     | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Default       | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Permanent     | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Manual        | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |
      | Life          | *IGNORE*    | *IGNORE*         | *IGNORE* | *IGNORE*     | *IGNORE*   | *SKIP* |

      #AC 2 - View inactive polices
    And I click on the "Inactive" link
    Then I see "No data to display." on the page