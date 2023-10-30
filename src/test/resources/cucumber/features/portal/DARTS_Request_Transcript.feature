Feature: Request Transcript

  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |
      | CASE1009                                                              | Swansea    | Multiple  |          | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    Given I click on "CASE1009" in the same row as "Swansea"
    Then I verify the HTML table contains the following values
      | Hearing date | Judge | Courtroom       | No. of transcripts |
      | 15 Aug 2023  |       | ROOM_A          | 1                  |
      | 15 Aug 2023  |       | ROOM_A12434     | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZ        | 1                  |
      | 15 Aug 2023  |       | ROOM_XYZhhihihi | 0                  |
    #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page

  @DMP-862-AC1
  Scenario: View Transcript
    And I see the transcription-count is "1"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |      |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE | View |

  @DMP-862-AC2
  Scenario: Transcript - View link
    And I see the transcription-count is "1"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |      |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE | View |
    #And I see "View" in the same row as "system" "Sentencing remarks "
    And I click on "View" in the same row as "system"

  @DMP-862-AC2
  Scenario: Transcript - Request a new transcript
    And I see the transcription-count is "1"
    Then I click on the "Transcripts" link
    And I verify the HTML table contains the following values
      | Type               | Requested on         | Requested by | Status   |      |
      | Sentencing remarks | 19 Sep 2023 00:00:00 | system       | COMPLETE | View |
    And I press the "Request a new transcript" button