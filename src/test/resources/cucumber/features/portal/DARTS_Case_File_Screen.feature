Feature: Case File Screen

  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  |Mr Judge  | Jow Bloggs    |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
      | CASE1009                                                              | TS0002     | ROOM_A    |          |               |

    Given I click on "CASE1009" in the same row as "Swansea"

  @DMP-965
  Scenario: Case File Screen Sort with Hearing Table
    When I click on "Hearing date" in the table header
    Then "Hearing date" has sort "descending" icon
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |

  @DMP-965
  Scenario: Case File Screen Sort with Courtroom
    When I click on "Courtroom" in the table header
    Then "Courtroom" has sort "descending" icon
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 1                  |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |

  @DMP-965
  Scenario: Case File Screen Sort with No. of transcripts
    When I click on "No. of transcripts" in the table header
    Then "No. of transcripts" has sort "descending" icon
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |

  @DMP-965
  Scenario: Case File Screen Sort with Judge
    When I click on "Judge" in the table header
    Then "Judge" has sort "descending" icon
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |

  @DMP-769
  Scenario: All transcripts tab
    Then I click on the "All Transcripts" link
    And I see "All transcripts for this case" on the page
    And I see the transcription-count is "3"
    And I verify the HTML table contains the following values
      | Hearing date | Type               | Requested on         | Requested by | Status   |      |
      | 14 Aug 2023  | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | CLOSED   |      |
      | 14 Aug 2023  | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | CLOSED   |      |
      | 14 Aug 2023  | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE | View |

  @DMP-1606
  Scenario: Case File Screen with Restrictions on case
    Given I see "There are restrictions against this case" on the page
    And I see "Important" on the page
    And I see "Show restrictions" on the page
    When I click on the "Show restrictions" link
    Then I see "Hide restrictions" on the page
    And I see "Restriction applied: Judge directed on reporting restrictions" on the page
    And I see "For full details, check the events for each hearing below." on the page
    When I click on the "Hide restrictions" link
    Then I click on the "Search" link
    And I set "Case ID" to "DMP-1025"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | DMP-1025                                                              | Swansea    | DMP-1025 Courtroom  |DMP-1025 Judge  | DMP-1025 Defendant|
    Given I click on "DMP-1025" in the same row as "Swansea"
    And I do not see "There are restrictions against this case" on the page

