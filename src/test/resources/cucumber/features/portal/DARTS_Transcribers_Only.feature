Feature: Request Audio for transcribers
  Background:
    Given I am logged on to DARTS as an TRANSCRIBER user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case1009"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
      | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
      | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
      | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |
    And I see "Restriction: Judge directed on reporting restrictions" on the page
        #Case Details
    When I click on "CASE1009" in the same row as "Swansea"
     #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page

  @DMP-696
  Scenario Outline: Request Audio for transcribers-Playback Only
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    #Confirm your Order
    Then I see "Confirm your Order" on the page
    And I see "<Restriction>" on the page
    And I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Audio details" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Confirm" button
    #Order Confirmation
    Then I see "Your order is complete" on the page
    And I see "<Restriction>" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-696
  Scenario Outline: Request Audio for Transcribers - Download
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
     #Confirm your Order
    Then I see "Confirm your Order" on the page
    And I see "<Restriction>" on the page
    Then I see "Case details" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "Audio details" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Confirm" button
    #Order Confirmation
    Then I see "Your order is complete" on the page
    And I see "<Restriction>" on the page
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |