Feature: Case File Screen

  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
      | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |

  Scenario: Case File Screen
    Given I click on "CASE1009" in the same row as "Swansea"
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 0                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 0                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 0                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |