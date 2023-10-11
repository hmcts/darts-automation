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
    And I click on "14 Aug 2023" in the same row as "ROOM_A"
    And I see "Swansea" on the page
    And I see "ROOM_A" on the page

  @DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686
  Scenario Outline: Request Audio with Request Type Playback Only
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
    And I see "When it is ready we will send an email to" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686
  Scenario Outline: Request Audio with Request Type Download
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
    And I see "When it is ready we will send an email to dartsautomationuser@HMCTS.net and notify you in the DARTS application." on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-685
  Scenario: Request Audio Confirm your Order Cancel link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I click on the "Cancel" link
    And I see link with text "CASE1009"

  @DMP-685
  Scenario: Request Audio Confirm Order Back link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
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

  @DMP-694
  Scenario: Request Audio request type error message
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "There is a problem" on the page
    And I see "You must select a request type" on the page

  @DMP-686
  Scenario: Order Confirmation - Return to hearing date link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I click on the "Return to hearing date" link
    And I see "14 Aug 2023" on the page

  @DMP-686
  Scenario: Order Confirmation - Back to search results link
    When I select the "Audio preview and events" radio button
    And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I click on the "Back to search results" link
    And I see "Search for a case" on the page

  @DMP-695  #Manually enter in Start Time and End Time
  Scenario Outline: Request Audio by setting Start Time and End Time
    When I select the "Audio preview and events" radio button
    And I set the time fields of "Start Time" to "<StartTime>"
    And I set the time fields of "End Time" to "<EndTime>"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
  #Confirm your Order
    Then I see "Confirm your Order" on the page
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
    And I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 13:07:33  | 13:07:33 |

  @DMP-658
  Scenario Outline: Request Audio Events only available for hearing
    When I select the "Events only" radio button
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
    And I see "When it is ready we will send an email to" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 2023-08-15  | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |


  @DMP-692
  Scenario Outline: Preview Audio Player Loading
    When I select the "Audio preview and events" radio button
    And I press the "Preview Audio" button in the same row as "<StartTime>" "<EndTime>"
    Then I see "<Text>" in the same row as "<StartTime>" "<EndTime>"
   Examples:
     | StartTime            | EndTime            | Text                                 | 
     | Start time: 10:00:00 | End time: 11:14:05 | Loading Audio Preview... Please Wait |  