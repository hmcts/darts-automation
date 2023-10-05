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
    And I see "Restriction: Judge directed on reporting restrictions" on the page
        #Case Details
    When I click on "CASE1009" in the same row as "Swansea"
     #Hearing Details
    And I click on "15 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page

  @DMP-685 @DMP-651
  Scenario Outline: Request Audio with Request Type Playback Only
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
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
    And I see "When it is ready we will send an email to" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 14:07:33  | 14:07:33 | Restriction: Judge directed on reporting restrictions |

  Scenario Outline: Request Audio with Request Type Download
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
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
    And I see "When it is ready we will send an email to" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 14:07:33  | 14:07:33 | Restriction: Judge directed on reporting restrictions |

  Scenario: Request Audio Order Cancel link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I click on the "Cancel" link
    And I see link with text "CASE1009"

  Scenario: Request Audio Order Back link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I click on the "Back" link
    And I see "CASE1009" on the page

  @DMP-694
  Scenario: Request Audio Error Messages
    When I press the "Get Audio" button
    Then I see "You must include a start time for your audio recording" on the page
    And I see "You must include an end time for your audio recording" on the page
    And I see "You must select a request type" on the page

  Scenario: Request Audio request type error message
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "There is a problem" on the page
    And I see "You must select a request type" on the page

  Scenario: Order Confirmation Return to hearing date link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I click on the "Return to hearing date" link
    And I see "15 Aug 2023" on the page

  Scenario: Order Confirmation Back to search results link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I click on the "Back to search results" link
    And I see "Search for a case" on the page