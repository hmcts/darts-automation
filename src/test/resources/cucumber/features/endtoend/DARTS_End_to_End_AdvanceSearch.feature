Feature: Advance Search

  @end2end @end2end6 @DMP-1927 @demo
  Scenario Outline: Advance Search for a case details created using Case and Courtlogs
    Given I create a case
      | courthouse   | courtroom   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <courtroom> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I add courtlogs
      | dateTime   | courthouse   | courtroom   | case_numbers  | text       |
      | <dateTime> | <courthouse> | <courtroom> | <case_number> | <keywords> |
    When I am logged on to DARTS as an <user> user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link

    #Courthouse
    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Defendant
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Judge
    When I click on the "Clear search" link
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Keywords
    When I click on the "Clear search" link
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Courthouse + Courtroom + Judge
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "result" on the page
    Then I see "<judges>" in the same row as "<courthouse>"


    #Courthouse + Defendant + Courtroom
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "result" on the page
    Then I see "<defendants>" in the same row as "<courthouse>"

    #Courthouse + Courtroom + Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Courtroom + Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Keyword + Courtroom
    When I click on the "Clear search" link
    Then I set "Keywords" to "<keywords>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

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

    #Courtroom + Judge + Defendant
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Judge's name" to "<judges>"
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Judge + Specific Date
    When I click on the "Clear search" link
    Then I set "Judge's name" to "<judges>"
    Then I set "Courtroom" to "<courtroom>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Defendant + Specific Date
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Courtroom" to "<courtroom>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Defendant + Keywords
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courthouse + Judge + Defendant
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Judge + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Judge + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Judge + Keyword
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Defendant + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Defendant + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Keywords + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Keywords" to "<keywords>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Keywords + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Keywords" to "<keywords>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Courthouse + Defendant + Keyword
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

    #Case Number
    When I click on the "Clear search" link
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
    Then I set "Case ID" to "{{seq}}"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants> |

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
#    Then I click on the "Clear search" link
#    Then I set "Case ID" to "S"
#    Then I press the "Search" button
#    Then I see "There are more than 500 results" on the page
#    Then I see "Refine your search by:" on the page
#    Then I see "adding more information to your search" on the page
#    Then I see "using filters to restrict the number of results" on the page

    Examples:
      | user        | courthouse      | case_number   | defendants           | judges           | prosecutors           | defenders           | courtroom | keywords             | dateTime      | todaysDate  |
      | REQUESTER   | {{courthouse1}} | S{{seq}}081-B | S{{seq}} defendant-B | S{{seq}} judge-B | S{{seq}} prosecutor-B | S{{seq}} defender-B | C{{seq}}  | SIT LOG-81-{{seq}}-B | {{timestamp}} | {{date+0/}} |
      | JUDGE       | {{courthouse1}} | S{{seq}}081-B | S{{seq}} defendant-B | S{{seq}} judge-B | S{{seq}} prosecutor-B | S{{seq}} defender-B | C{{seq}}  | SIT LOG-81-{{seq}}-B | {{timestamp}} | {{date+0/}} |
      | TRANSCRIBER | {{courthouse1}} | S{{seq}}081-B | S{{seq}} defendant-B | S{{seq}} judge-B | S{{seq}} prosecutor-B | S{{seq}} defender-B | C{{seq}}  | SIT LOG-81-{{seq}}-B | {{timestamp}} | {{date+0/}} |


  @end2end @end2end6 @DMP-1927 @demo
  Scenario Outline: Advance Search for a case details created using events
    Given I create a case
      | courthouse   | courtroom   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <courtroom> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence | start_time    | end_time      | is_mid_tier |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     | {{timestamp}} | {{timestamp}} | true        |

    When I am logged on to DARTS as an <user> user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link

    #Courthouse
    When I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Defendant
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Judge
    When I click on the "Clear search" link
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Keywords
    When I click on the "Clear search" link
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

     #Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page

    #Courthouse + Courtroom + Judge
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Case ID" is ""
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I see "result" on the page
    Then I see "<judges>" in the same row as "<courthouse>"

      #Courthouse + Defendant + Courtroom
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I see "<defendants >" in the same row as "<courthouse>"

    #Courthouse + Courtroom + Hearing Date - Specific date
    When I click on the "Clear search" link
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Courtroom + Hearing Date - Date Range
    When I click on the "Clear search" link
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Keyword + Courtroom
    When I click on the "Clear search" link
    Then I set "Keywords" to "<keywords>"
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I press the "Search" button
    Then I see "We need more information to search for a case" on the page
    Then I see "Refine your search by adding more information and try again." on the page
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

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

    #Courtroom + Judge + Defendant
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Judge's name" to "<judges>"
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Judge + Specific Date
    When I click on the "Clear search" link
    Then I set "Judge's name" to "<judges>"
    Then I set "Courtroom" to "<courtroom>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Defendant + Specific Date
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Courtroom" to "<courtroom>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courtroom + Defendant + Keywords
    When I click on the "Clear search" link
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Courtroom" to "<courtroom>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    #Courthouse + Judge + Defendant
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Judge's name" to "<judges>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Judge + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Judge + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Judge + Keyword
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Judge's name" to "<judges>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Defendant + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Defendant + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Keywords + Specific Date
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Keywords" to "<keywords>"
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Keywords + Date Range
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Keywords" to "<keywords>"
    Then I select the "Date range" radio button
    Then I set "Enter date from" to "<todaysDate>"
    Then I set "Enter date to" to "<todaysDate>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Courthouse + Defendant + Keyword
    When I click on the "Clear search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Defendant's name" to "<defendants>"
    Then I set "Keywords" to "<keywords>"
    Then I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Case Number
    When I click on the "Clear search" link
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

    #Only Courtroom
    When I click on the "Clear search" link
    Then "Courthouse" is ""
    Then "Courtroom" is ""
    Then "Defendant's name" is ""
    Then I set "Courtroom" to "<courtroom>"
    Then I press the "Search" button
    Then I see "You must also enter a courthouse" on the page

    When I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "{{seq}}"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendant(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants> |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*     |

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
#    Then I click on the "Clear search" link
#    Then I set "Case ID" to "S"
#    Then I press the "Search" button
#    Then I see "There are more than 500 results" on the page
#    Then I see "Refine your search by:" on the page
#    Then I see "adding more information to your search" on the page
#    Then I see "using filters to restrict the number of results" on the page

    Examples:
      | user        | courthouse      | courtroom | case_number   | dateTime      | message_id | eventId     | type  | subType | caseRetention | totalSentence | prosecutors           | defenders           | defendants           | judges           | keywords             | todaysDate  |
      | REQUESTER   | {{courthouse1}} | C{{seq}}  | S{{seq}}082-B | {{timestamp}} | {{seq}}082 | {{seq}}1042 | 21200 | 11000   |               |               | S{{seq}} prosecutor-B | S{{seq}} defender-B | S{{seq}} defendant-B | S{{seq}} judge-B | SIT LOG-82-{{seq}}-B | {{date+0/}} |
      | JUDGE       | {{courthouse1}} | C{{seq}}  | S{{seq}}082-B | {{timestamp}} | {{seq}}082 | {{seq}}1042 | 21200 | 11000   |               |               | S{{seq}} prosecutor-B | S{{seq}} defender-B | S{{seq}} defendant-B | S{{seq}} judge-B | SIT LOG-82-{{seq}}-B | {{date+0/}} |
      | TRANSCRIBER | {{courthouse1}} | C{{seq}}  | S{{seq}}082-B | {{timestamp}} | {{seq}}082 | {{seq}}1042 | 21200 | 11000   |               |               | S{{seq}} prosecutor-B | S{{seq}} defender-B | S{{seq}} defendant-B | S{{seq}} judge-B | SIT LOG-82-{{seq}}-B | {{date+0/}} |