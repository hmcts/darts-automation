Feature: Language Shop User

  Background:
    Given I am logged on to DARTS as an LANGUAGESHOP user

  @DMP-770
  Scenario Outline: Verify download playback file
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Download audio file" button
    And I see "There is a problem" on the page
    And I see "You do not have permission to view this file" on the page
    And I see "Email crownITsupport@justice.gov.uk to request access" on the page

    Examples:
      | CaseID        | Courthouse    | Defendants | HearingDate | StartTime | EndTime  |
      | Case1_DMP1398 | LEEDS_DMP1398 |            | 2 Nov 2023  | 15:20:23  | 15:21:23 |

    @DMP-2137
    Scenario: User Permissions
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |
        #Advanced search
    When I click on the "Clear search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "DMP-1289-BATH"
    And I set "Courtroom" to "Courtroom SIT1"
      And I select the "Specific date" radio button
      And I set "Enter a date" to "15/01/2024"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And "Courthouse" is ""
    And "Courtroom" is ""
    And I set "Defendant's name" to "Def A{{seq}}-1"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And "Defendant's name" is ""
    And I set "Judge's name" to "Judge {{seq}}-1"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And "Judge's name" is ""
    And I set "Keywords" to "A{{seq}}ABC-1"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Your audio" link
    And I click on the "Search" link
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And "Keywords" is ""
    And I select the "Specific date" radio button
    And I set "Enter a date" to "{{date+0/}}"
    And I set "Case ID" to "A{{seq}}"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date+0/}}"
    And I set "Enter date to" to "{{date+0/}}"
    And I set "Case ID" to "A{{seq}}"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |

    When I click on the "Clear search" link
    And I set "Case ID" to "1" and click away
    And I press the "Search" button
    Then I see "There are more than 500 results" on the page
    And I see "Refine your search by:" on the page
    And I see "adding more information to your search" on the page
    And I see "using filters to restrict the number of results" on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "2"
    And I press the "Search" button
    Then I see an error message "You must also enter a courthouse"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "{{date+3/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date+7/}}"
    And I set "Enter date to" to "{{date-7/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date-10/}}"
    And I set "Enter date to" to "{{date+10/}}"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "{{date-7/}}"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "{{date-10/}}"
    And I press the "Search" button
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "Invalid"
    And I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "Invalid"
    And I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "Invalid"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    And I click on the "Clear search" link
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "A{{seq}}001"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s) | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   |          |              |