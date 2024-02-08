Feature: Advance Search

  @end2end @end2end6 @DMP-1927
   #Created a case and event via Post courtlog
  Scenario Outline: Create a case
    #Given I authenticate from the DARMIDTIER source system
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |

    Given I add courtlogs
      | dateTime   | courthouse   | courtroom   | case_numbers  | text       |
      | <dateTime> | <courthouse> | <courtroom> | <case_number> | <keywords> |

    When I am logged on to DARTS as an APPROVER user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants>  |

    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "result" on the page

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

    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants>  |

    When I click on the "Clear search" link
    Then "Keywords" is ""
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "result" on the page

    When I click on the "Your audio" link
    Then I click on the "Search" link
    Then I see "result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on the breadcrumb link "Search"
    Then I see "Search for a case" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on the "Clear search" link
    Then I press the "Search" button
    Then I see "No search results" on the page
    Then I see "You need to enter some search terms and try again" on the page

    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    When I click on the "Clear search" link
    Then I select the "Specific date" radio button with label "Specific date"
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    When I click on the "Clear search" link
    Then I select the "Specific date" radio button with label "Specific date"
    Then I set "Enter a date" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date from" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date to" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page

    Examples:
      | courthouse         | case_number | defendants         | judges         | prosecutors         | defenders         | courtroom | keywords        | dateTime      | todaysDate  |
      | Harrow Crown Court | S{{seq}}001 | S{{seq}} defendant | S{{seq}} judge | S{{seq}} prosecutor | S{{seq}} defender | {{seq}}   | SIT_TEST{{seq}} | {{timestamp}} | {{date+0/}} |

  @end2end @end2end6 @DMP-1927
  #Created a case and event via Post event using SOAP
  Scenario Outline: Create a case and hearing via events
    Given I authenticate from the XHIBIT source system
    Given I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |
    #Given I authenticate from the DARMIDTIER source system
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |

    When I am logged on to DARTS as an <user> user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                 | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                           | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction There are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "result" on the page

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

    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                 | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                           | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction There are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
    When I click on the "Clear search" link
    Then "Keywords" is ""
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "result" on the page

    When I click on the "Your audio" link
    Then I click on the "Search" link
    Then I see "result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I see "Important" on the page
    Then I see "There are restrictions against this case" on the page
    Then I see "Show restrictions" on the page
    When I click on the "Show restrictions" link
    Then I see "Hide restrictions" on the page
    And I see "For full details, check the events for each hearing below." on the page

    Then I click on the breadcrumb link "Search"
    Then I see "Search for a case" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"

    When I click on the "Clear search" link
    Then I press the "Search" button
    Then I see "No search results" on the page
    Then I see "You need to enter some search terms and try again" on the page

    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "There are more than 500 results" on the page
    Then I see "Refine your search by:" on the page
    Then I see "adding more information to your search" on the page
    Then I see "using filters to restrict the number of results" on the page

    When I click on the "Clear search" link
    Then I select the "Specific date" radio button with label "Specific date"
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    When I click on the "Clear search" link
    Then I select the "Specific date" radio button with label "Specific date"
    Then I set "Enter a date" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date from" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
    Then I see an error message "You have not selected an end date. Select an end date to define your search"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date to" to "Invalid"
    Then I press the "Search" button
    Then I see an error message "You have not selected a start date. Select a start date to define your search"
    Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

    When I click on the "Clear search" link
    Then I select the "Date range" radio button with label "Date range"
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "result" on the page

    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page
    Then I press the "Search" button
    Then I see "result" on the page

    Examples:
      | user     | courthouse         | courtroom | case_number | dateTime      | message_id | eventId     | type  | subType | caseRetention | totalSentence | prosecutors         | defenders         | defendants         | judges         | keywords       | todaysDate  |
      | APPROVER | Harrow Crown Court | {{seq}}   | S{{seq}}001 | {{timestamp}} | {{seq}}001 | {{seq}}1001 | 21200 | 11000   |               |               | S{{seq}} prosecutor | S{{seq}} defender | S{{seq}} defendant | S{{seq}} judge | SIT LOG{{seq}} | {{date+0/}} |