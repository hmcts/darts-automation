Feature: Request Audio and then View in Your Audio
  Background:
    Given I am logged on to DARTS as an external user

  Scenario Outline: Your Audio Screen
    When I click on the "Your Audio" link
    Then I see "In Progress" on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status     |       |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 3083       |             | FAILED     | Clear |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 2901       |             | FAILED     | Clear |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 3941       |             | OPEN       |       |
      | CASE1009 | Swansea | 15 Aug 2023  | 02:07:33   | 02:07:33 | 2541       |             | PROCESSING |       |
      | CASE1009 | Swansea | 15 Aug 2023  | 02:07:33   | 02:07:33 | 2342       |             | PROCESSING |       |
      | CASE1009 | Swansea | 15 Aug 2023  | 02:07:33   | 02:07:33 | 2661       |             | FAILED     | Clear |
      | CASE1009 | Swansea | 15 Aug 2023  | 02:07:33   | 02:07:33 | 2221       |             | PROCESSING |       |

  #TODO: And I see a new audio blob - Need visibility of icon to check ID and implement


    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page

  #Verify audio player for playback?

    When I click on the breadcrumb link "Your audio"
    #Then I see "<CaseID>" under ready
    #And I do not see a new audio blob
    #And I do not see a new case audio blob

  #Now delete the requested audio

    When I check the "<CaseID>" checkbox
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I click on the "Cancel" link
    #Then I see "<CaseID>" under ready

    When I check the "<CaseID>" checkbox
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I press the "Yes - delete" button
    Then I do not see "<CaseID>" on the page

    #TODO: At start of test, set up expired audio/cases available for next part, using Preksha's table for verify

    When I click on the "Expired" link
    Then I verify the HTML table contains the following values
      | Case ID         | Court    | Hearing date | Start time | End time | Request ID | Expiry date | Status  |
      | EXPIRED_CASE_ID | *IGNORE* | *IGNORE*     | *IGNORE*   | *IGNORE* | *IGNORE*   | *IGNORE*    | EXPIRED |

    When I check the "<EXPIRED_CASE_ID>" checkbox
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I click on the "Cancel" link
    Then I verify the HTML table contains the following values
      | Case ID         | Court    | Hearing date | Start time | End time | Request ID | Expiry date | Status  |
      | EXPIRED_CASE_ID | *IGNORE* | *IGNORE*     | *IGNORE*   | *IGNORE* | *IGNORE*   | *IGNORE*    | EXPIRED |

    When I check the "<EXPIRED_CASE_ID>" checkbox
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I press the "Yes - delete" button
    Then I do not see "<EXPIRED_CASE_ID>" on the page

    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction      |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @DMP-697 @DMP-859
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

    #Extending the above to complete E2E flow - There might be issues with auto running faster than processing time

    When I click on the "Return to search results" link
    And I click on the "Your audio" link
	#Then I see "<CaseID>" under in progress - New step def needed for under in progress/ready?

    When I am logged on to DARTS as an external user
    And I click on the "Your audio" link
	#Then I see "<CaseID>" under ready - New step def needed for under in progress/ready?

    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page

#Anything after pressing download button?

    When I press the "Download audio file" button

    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |
