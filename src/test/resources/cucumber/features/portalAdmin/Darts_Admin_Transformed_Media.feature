@admin @admin_transformed_media
Feature: Admin-Transformed Media


  @DMP-2678 @regression
  Scenario: Transformed media search

    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "Transformed media" link
    And I press the "Search" button
    Then I see "results" on the page

    #DMP-2678-AC1 View search results

    When I click on the "Advanced search" link
    And I set "Courthouse" to "Harrow Crown Court"
    And I set "Hearing date" to "15/02/2024"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Media ID | Case ID  | Courthouse         | Hearing date | Owner       | Requested by | Date requested | Last accessed | File type | Size  | Filename                   |
      | 518      | B9160006 | Harrow Crown Court | 15 Feb 2024  | Transcriber | Transcriber  | 15 Feb 2024    |               | MP3       | 0.2MB | B9160006_15_Feb_2024_1.mp3 |
      | 519      | B9160006 | Harrow Crown Court | 15 Feb 2024  | Transcriber | Transcriber  | 15 Feb 2024    |               | ZIP       | 0.9MB | B9160006_15_Feb_2024_1.zip |
      | 557      | S1029021 | Harrow Crown Court | 15 Feb 2024  | Requestor   | Requestor    | 15 Feb 2024    |               | MP3       | 0.2MB | S1029021_15_Feb_2024_1.mp3 |
    And I see "Showing 1-3 of 3" on the page
    And I see "results" on the page

    #DMP-2678-AC2 Single search result takes user directly to file details screen

    When I set "Request ID" to "17165"
    And I press the "Search" button
    Then I do not see "Showing" on the page
    And I see "Request details" on the page
    And I see "Requestor" in the same row as "Requested by"
    And I see "17165" in the same row as "Request ID"

  @DMP-2695 @DMP-2679 @DMP-3475
  Scenario: Transformed media-Change owner
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Transformed media" link
    And I see "Transformed media" on the page
    And I set "Request ID" to "8545"
    And I press the "Search" button
    And I click on the "Back" link
    And I see "Transformed media" on the page
    Then I click on the "101" link
    And I see "Transformed media" on the page
    And I see "101" on the page
    And I see "Request details" on the page
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to ""
    And I press the "Save change" button
    Then I see "Select a user" on the page
    And I click on the "Cancel" link
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to "Testuserone (testuserone@hmcts.net)" and click away
    And I press the "Save change" button
    Then I see "Changed media request owner to Testuserone " on the page
    And I see "Owner" in the same row as "Testuserone (testuserone@hmcts.net)"
    And I click on the "Change" link
    Then I see "Change owner" on the page
    And I set "Search for a user" to "Mehta Purvi (mehta.purvi@hmcts.net)" and click away
    And I press the "Save change" button

    #DMP-2679 Transformed media detail page
    Then I see "Transformed media" on the page
    And I see "101" on the page
    And I see "Request details" on the page
    And I see "Owner" in the same row as "Mehta Purvi (mehta.purvi@hmcts.net)"
    And I see "Requested by" in the same row as "Requestor"
    And I see "Request ID" in the same row as "8545"
    And I see "Date requested" in the same row as "20 December 2023"
    And I see "Hearing date" in the same row as "07 December 2023"
    And I see "Courtroom" in the same row as "Rayners room"
    And I see "Audio requested" in the same row as "Start time 2:00:00PM - End time 2:01:00PM"

    Then I see "Case details" on the page
    And I see "Case ID" in the same row as "T20230001"
    And I see "Courthouse" in the same row as "Harrow Crown Court"
    And I see "Judge(s)" in the same row as "{{upper-case-test judge}}"
    And I see "Defendant(s)" in the same row as "fred"

    Then I see "Media details" on the page
    And I see "Filename" in the same row as "T20230001_07_Dec_2023_1"
    And I see "File type" in the same row as ""
    And I see "File size" in the same row as "MB"

    Then I see "Associated audio" on the page
    Then I verify the HTML table contains the following values
      |Audio ID|Case ID    |Hearing date|Courthouse         |Start time|End time|Courtroom    |Channel number|
      |3833    |T20230001  |07 Dec 2023 |Harrow Crown Court |2:00PM    |2:01PM  |Rayners room |1             |

