Feature: Case File Screen

  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I can see search results table
      | CaseID   | Courthouse | Courtroom | Judges   | Defendants |
      | CASE1009 | Swansea    | Multiple  | Mr Judge | Jow Bloggs |
    And I see "Restriction: Judge directed on reporting restrictions" on the page

  Scenario: Case File Screen
    Given I click on "CASE1009" in the same row as "Swansea"
    Then I verify the HTML table contains the following values
      | 15 Aug 2023 |  | ROOM_A          |  |
      | 15 Aug 2023 |  | ROOM_A12434     |  |
      | 15 Aug 2023 |  | ROOM_XYZ        |  |
      | 15 Aug 2023 |  | ROOM_XYZhhihihi |  |