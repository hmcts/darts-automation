Feature: Advance Search

  @end2end @end2end6 @DMP-1927 @demo
  Scenario Outline: Advance Search for a case details created using Case and Courtlogs
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I add courtlogs
      | dateTime   | courthouse   | courtroom   | case_numbers  | text       |
      | <dateTime> | <courthouse> | <courtroom> | <case_number> | <keywords> |
    When I am logged on to DARTS as an <user> user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link

    #Courthouse
    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    #Courthouse + Courtroom
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "result" on the page

    #Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    #Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    # Error for Invalid date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date to" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    #Defendant's name
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Keywords
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Judge
    When I click on the "Clear search" link
    Then "Keywords" is ""
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Case Number
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Only Courtroom
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then "Defendant's name" is ""
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "result" on the page

    #Last Search results
    When I click on the "Your audio" link
    Then I click on the "Search" link
    Then I see "result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on the breadcrumb link "Search"
    Then I see "Search for a case" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    #No Search Criteria
    When I click on the "Clear search" link
    Then I press the "Search" button
    Then I see "No search results" on the page
    Then I see "You need to enter some search terms and try again" on the page

    #Press Search button multiple times
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page

    #500 Search results
    Then I click on the "Clear search" link
    Then I set "Case ID" to "S"
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    Examples:
      | user      | courthouse         | case_number   | defendants           | judges           | prosecutors           | defenders           | courtroom | keywords             | dateTime      | todaysDate  |
      | REQUESTER | {{courthouse1}} | S{{seq}}041-A | S{{seq}} defendant-A | S{{seq}} judge-A | S{{seq}} prosecutor-A | S{{seq}} defender-A | C{{seq}}  | SIT LOG-41-{{seq}}-A | {{timestamp}} | {{date+0/}} |
      | JUDGE     | {{courthouse1}} | S{{seq}}041-A | S{{seq}} defendant-A | S{{seq}} judge-A | S{{seq}} prosecutor-A | S{{seq}} defender-A | C{{seq}}  | SIT LOG-41-{{seq}}-A | {{timestamp}} | {{date+0/}} |

  @end2end @end2end6 @DMP-1927 @demo
  Scenario Outline: Advance Search for a case details created using events
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I authenticate from the XHIBIT source system
    Given I create an event using json
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |

    When I am logged on to DARTS as an <user> user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link

    #Courthouse
    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    #Courthouse + Courtroom
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "result" on the page

    #Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    #Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    # Error for Invalid date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date to" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    #Defendant's name
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Keywords
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Judge
    When I click on the "Clear search" link
    Then "Keywords" is ""
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Case Number
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Only Courtroom
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then "Defendant's name" is ""
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "result" on the page

    #Last Search results
    When I click on the "Your audio" link
    Then I click on the "Search" link
    Then I see "result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on the breadcrumb link "Search"
    Then I see "Search for a case" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    #No Search Criteria
    When I click on the "Clear search" link
    Then I press the "Search" button
    Then I see "No search results" on the page
    Then I see "You need to enter some search terms and try again" on the page

    #Press Search button multiple times
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page

    #500 Search results
    Then I click on the "Clear search" link
    Then I set "Case ID" to "S"
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    Examples:
      | user      | courthouse         | courtroom | case_number   | dateTime      | message_id   | eventId       | type  | subType | caseRetention | totalSentence | prosecutors           | defenders           | defendants           | judges           | keywords             | todaysDate  |
      | REQUESTER | {{courthouse1}} | C{{seq}}  | S{{seq}}042-B | {{timestamp}} | {{seq}}042-B | {{seq}}1042-B | 21200 | 11000   |               |               | S{{seq}} prosecutor-B | S{{seq}} defender-B | S{{seq}} defendant-B | S{{seq}} judge-B | SIT LOG-42-{{seq}}-B | {{date+0/}} |
      | JUDGE     | {{courthouse1}} | C{{seq}}  | S{{seq}}042-B | {{timestamp}} | {{seq}}042-B | {{seq}}1042-B | 21200 | 11000   |               |               | S{{seq}} prosecutor-B | S{{seq}} defender-B | S{{seq}} defendant-B | S{{seq}} judge-B | SIT LOG-42-{{seq}}-B | {{date+0/}} |