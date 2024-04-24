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

    @DMP-2137-AC1
      #Global Access = True Interpreter = True
    Scenario: Translation QA User Permissions
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |
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
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
      And I set "Courthouse" to "DMP-1289-BATH"
    And I set "Defendant's name" to "Joe Bloggs"
      And I set "Judge's name" to "Jane Bloggs"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2024"
    And I set "Enter date to" to "20/01/2024"
    And I set "Case ID" to "DMP-2137"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I set "Case ID" to "1" and click away
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    And I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "2"
    And I press the "Search" button
    Then I see an error message "You must also enter a courthouse"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "15/01/2026"
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
      And I set "Enter date from" to "07/01/2026"
      And I set "Enter date to" to "20/01/2026"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "20/01/2024"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2024"
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
    And I set "Case ID" to "DMP-2137"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

      And I click on the "Search" link
      And I see "Search for a case" on the page
      And I set "Case ID" to "DMP-2137"
      And I press the "Search" button
      Then I verify the HTML table contains the following values
        | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
        | DMP-2137    | DMP-1289-BATH      | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |
      When I click on "DMP-2137" in the same row as "DMP-1289-BATH"
      And I click on "15 Jan 2024" in the same row as "Courtroom SIT1"
      Then I see "Events and audio recordings" on the page
      And I set the time fields of "Start Time" to "16:00:00"
      And I set the time fields of "End Time" to "16:02:00"
      And I select the "Playback Only" radio button
      And I press the "Get Audio" button
      Then I see "Confirm your Order" on the page
      And I see "Case details" on the page
      And I see "DMP-2137" on the page
      And I see "DMP-1289-BATH" on the page
      And I see "Joe Bloggs" on the page
      And I see "Audio details" on the page
      And I see "15 Jan 2024" on the page
      And I see "16:00:00" on the page
      And I see "16:02:00" on the page
      When I press the "Confirm" button
      Then I see "Your order is complete" on the page
      And I see "DMP-2137" on the page
      And I see "DMP-1289-BATH" on the page
      And I see "Joe Bloggs" on the page
      And I see "15 Jan 2024" on the page
      And I see "16:00:00" on the page
      And I see "16:02:00" on the page
      And I see "We are preparing your audio." on the page
      And I see "When it is ready we will send an email to Language Shop and notify you in the DARTS application." on the page
      And I see "Return to hearing date" on the page
      And I see "Back to search results" on the page
      And I click on the "Back to search results" link
      When I click on the "Your audio" link
      And I see "Current" on the page
      And I see "Expired" on the page

  @DMP-2137-AC2
      #Global Access = False Interpreter = True
  Scenario: Translation QA User Permissions
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137-2"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

        #Advanced search
    When I click on the "Clear search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "LEEDS_DMP381"
    And I set "Courtroom" to "Courtroom SIT1"
    And I select the "Specific date" radio button
    And I set "Enter a date" to "23/04/2024"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I set "Courthouse" to "LEEDS_DMP381"
    And I set "Defendant's name" to "Joe Bloggs"
    And I set "Judge's name" to "Jane Bloggs"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/04/2024"
    And I set "Enter date to" to "23/04/2024"
    And I set "Case ID" to "DMP-2137-2"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I set "Case ID" to "1" and click away
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    And I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "2"
    And I press the "Search" button
    Then I see an error message "You must also enter a courthouse"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "23/04/2026"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2026"
    And I set "Enter date to" to "20/01/2026"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "20/01/2024"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2024"
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
    And I set "Case ID" to "DMP-2137-2"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137-2"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-2  | LEEDS_DMP381       | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |
    When I click on "DMP-2137-2" in the same row as "LEEDS_DMP381"
    And I click on "23 Apr 2024" in the same row as "Courtroom SIT1"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "12:30:17"
    And I set the time fields of "End Time" to "12:35:30"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "DMP-2137-2" on the page
    And I see "LEEDS_DMP381" on the page
    And I see "Joe Bloggs" on the page
    And I see "Audio details" on the page
    And I see "23 Apr 2024" on the page
    And I see "12:30:17" on the page
    And I see "12:35:30" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "DMP-2137-2" on the page
    And I see "LEEDS_DMP381" on the page
    And I see "Joe Bloggs" on the page
    And I see "23 Apr 2024" on the page
    And I see "12:30:17" on the page
    And I see "12:35:30" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Language Shop and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    And I click on the "Back to search results" link
    When I click on the "Your audio" link
    And I see "Current" on the page
    And I see "Expired" on the page

  @DMP-2137-AC3
      #Global Access = True Interpreter = False
  Scenario: Translation QA User Permissions
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137-3"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

        #Advanced search
    When I click on the "Clear search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "Swansea"
    And I set "Courtroom" to "Courtroom SIT1"
    And I select the "Specific date" radio button
    And I set "Enter a date" to "23/04/2024"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I set "Courthouse" to "Swansea"
    And I set "Defendant's name" to "Joe Bloggs"
    And I set "Judge's name" to "Jane Bloggs"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/04/2024"
    And I set "Enter date to" to "23/04/2024"
    And I set "Case ID" to "DMP-2137-3"
    And I press the "Search" button
    And I click on "Case ID" in the table header
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    When I click on the "Clear search" link
    And I set "Case ID" to "1" and click away
    And I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    And I see "Refine your search by adding more information and try again." on the page

    When I click on the "Clear search" link
    And I set "Courtroom" to "2"
    And I press the "Search" button
    Then I see an error message "You must also enter a courthouse"

    When I click on the "Clear search" link
    And I select the "Specific date" radio button
    And I set "Enter a date" to "23/04/2026"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2026"
    And I set "Enter date to" to "20/01/2026"
    And I press the "Search" button
    Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date to" to "20/01/2024"
    And I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"

    When I click on the "Clear search" link
    And I select the "Date range" radio button
    And I set "Enter date from" to "07/01/2024"
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
    And I set "Case ID" to "DMP-2137-3"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |

    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "DMP-2137-3"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom        | Judge(s)     | Defendant(s) |
      | DMP-2137-3  | Swansea            | Courtroom SIT1   | Jane Bloggs  | Joe Bloggs   |
    When I click on "DMP-2137-3" in the same row as "Swansea"
    And I click on "23 Apr 2024" in the same row as "Courtroom SIT1"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "12:30:17"
    And I set the time fields of "End Time" to "12:35:30"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "DMP-2137-3" on the page
    And I see "Swansea" on the page
    And I see "Joe Bloggs" on the page
    And I see "Audio details" on the page
    And I see "23 Apr 2024" on the page
    And I see "12:30:17" on the page
    And I see "12:35:30" on the page
    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "DMP-2137-3" on the page
    And I see "Swansea" on the page
    And I see "Joe Bloggs" on the page
    And I see "23 Apr 2024" on the page
    And I see "12:30:17" on the page
    And I see "12:35:30" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Language Shop and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    And I click on the "Back to search results" link
    When I click on the "Your audio" link
    And I see "Current" on the page
    And I see "Expired" on the page

  @DMP-2137-AC4
      #Global Access = False Interpreter = False
  Scenario: Translation QA User Permissions
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "Case_DMP174"
    And I press the "Search" button
    Then I see "No search results" on the page
    And I see "Review the case ID, case reference or court reference you entered and try again." on the page
