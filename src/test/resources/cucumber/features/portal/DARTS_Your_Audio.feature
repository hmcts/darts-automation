Feature: Your Audio Screen

  Background:
    Given I am logged on to DARTS as an external user

  @DMP-697  @DMP-836 @DMP-837 @DMP-859
  Scenario: Verify Your Audio Screen - Current Tab "in Progress" or "Ready"
    #Then I see the notification-count is "1"
    When I click on the "Your Audio" link
    And I see "Your Audio" on the page
    Then I verify the HTML table "In Progress" contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status     |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 4653       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 2901       |             | *IGNORE*   |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 3941       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 4673       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 3083       |             | *IGNORE*   |
      | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2221       |             | PROCESSING |
      | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2342       |             | PROCESSING |
      | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2661       |             | *IGNORE*   |
    And I see "Select to apply actions" on the page
    Then I verify the HTML table "Ready" contains the following values
      | *NO-CHECK* |  | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status |
      | *NO-CHECK* |  | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 3861       |             | READY  |
      | *NO-CHECK* |  | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2541       |             | READY  |


  Scenario: Verify the sorting of the "Your Audio" table
    When I click on the "Your Audio" link
    And I see "Your Audio" on the page
    When I click on "Request ID" in the table header
    Then "Request ID" has sort "descending" icon
    Then I verify the HTML table "In Progress" contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status     |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 4673       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 4653       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 3941       |             | OPEN       |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 3083       |             | *IGNORE*   |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 2901       |             | *IGNORE*   |
      | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2661       |             | *IGNORE*   |
      | CASE1009 | Swansea | 15 Aug 2023  | 13:07:33   | 13:07:33 | 2342       |             | PROCESSING |
      | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2221       |             | PROCESSING |

  Scenario Outline: Verify Clear link for the In Progress Audios
    When I click on the "Your Audio" link
    When I click on "Clear" in the same row as "<Request ID>"
    And I see "Are you sure you want to delete this item?" on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 2901       |             | FAILED |
    And I click on the "Cancel" link
    And I see "Your Audio" on the page
    Examples:
      | Request ID |
      | 2901       |

  Scenario Outline: Verify View link for the Ready Audios
    # TODO: And I see a new audio blob - Need visibility of icon to check ID and implement
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "<Restriction>" on the page
    And I see "Play all audio" on the page
    And I see "Skip to event" on the page
    And I see "Jump to a specific audio events within the audio file" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  #Verify audio player for playback?
  Scenario Outline: Verify breadcrumbs link for Your Audio
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "<Restriction>" on the page
    When I click on the breadcrumb link "Your Audio"
    Then I see "Your Audio" on the page
    #Then I see "<CaseID>" under ready
    #And I do not see a new audio blob
    #And I do not see a new case audio blob
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-839-AC1
  Scenario: Verify Delete audio link in View Audio page -Confirm Delete
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "<Restriction>" on the page
    Then I click on the "Delete audio file" link
    And I see "Are you sure you want to delete this item?" on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 3861       |             | READY  |
    #And I press the "Yes - delete" button
    #Then I do not see "<CaseID>" on the page
    #Examples:
    #  | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
    #  | CASE1009 | Swansea | Jow Bloggs   | 15 Aug 2023 | 13:07:33 | 13:07:33   | Restriction: Judge directed on reporting restrictions |
  @DMP-839-AC2
  Scenario Outline: Verify Delete audio link in View Audio page - Cancel Delete
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "<Restriction>" on the page
    Then I click on the "Delete audio file" link
    And I see "Are you sure you want to delete this item?" on the page
    Then I verify the HTML table contains the following values
      | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status |
      | CASE1009 | Swansea | 15 Aug 2023  | 01:07:33   | 01:07:33 | 3861       |             | READY  |
    And I click on the "Cancel" link
    And I see "Your Audio" on the page
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

  @DMP-836
  #Now delete the requested audio
  Scenario: Delete Audio - Cancel Link
    When I click on the "Your Audio" link
    When I check the checkbox in the same row as "Swansea" "3861"
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I click on the "Cancel" link
    And I see "Your Audio" on the page

  @DMP-836
  Scenario: Delete Audio -Confirm
    When I click on the "Your Audio" link
    When I check the checkbox in the same row as "Swansea" "3861"
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
#    And I press the "Yes - delete" button
#    Then I do not see "<CaseID>" on the page
#    Examples:
#      | CaseID   |
#      | CASE1009 |

  @DMP-730
  Scenario: Verify Your Audio Screen - Expired Tab
    When I click on the "Your Audio" link
    And I click on the "Expired" link
    Then I verify the HTML table contains the following values
      | *NO-CHECK* | Case ID  | Court   | Hearing date | Start time | End time | Request ID | Expiry date | Status  |
      | *NO-CHECK* | CASE1009 | Swansea | 15 Aug 2023  | 14:07:33   | 14:07:33 | 2601       |             | EXPIRED |

  @DMP-837
  Scenario: Verify Your Audio Screen - Expired Tab Delete
    When I click on the "Your Audio" link
    And I click on the "Expired" link
    When I check the checkbox in the same row as "Swansea" "2601"
    And I press the "Delete" button
    And I see "Are you sure you want to delete this item?" on the page
    And I click on the "Cancel" link
    And I see "Your Audio" on the page

  @DMP-837
  Scenario: Verify Your Audio Screen - Expired Tab Delete Confirm
    When I click on the "Your Audio" link
    And I click on the "Expired" link
    When I check the checkbox in the same row as "Swansea" "2601"
#    And I press the "Delete" button
#    And I see "Are you sure you want to delete this item?" on the page

  @DMP-840
  Scenario Outline: Verify download playback file
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I see "<Restriction>" on the page
    And I see "Play all audio" on the page
    And I see "Skip to event" on the page
    And I see "Jump to a specific audio events within the audio file" on the page
    And I press the "Download audio file" button
    # Need to verify Download of the file
    Examples:
      | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
      | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |



