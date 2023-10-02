@DMP-1048-RequestAudio
Feature: Request Audio
  Background:
    Given I am logged on to DARTS as an external user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
       Then I can see search results table
         | CaseID   | Courthouse | Courtroom | Judges   | Defendants |
         | CASE1009 | Swansea    | Multiple  | Mr Judge | Jow Bloggs |

  Scenario: Request Audio
        #Case Details
    When I click on "CASE1009" in the same row as "Swansea"
        #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page
    Then I set "Hour" in "Start Time" to "14"
    And I set "Minutes" in "Start Time" to "07"
    And I set "Seconds" in "Start Time" to "33"
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "CASE1009" on the page
    And I see "Swansea" on the page
    And I see "Jow Bloggs" on the page
    And I see "2023-08-15" on the page
    And I see "14:07:33" on the page
    And I press the "Confirm" button