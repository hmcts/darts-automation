Feature: Events Endpoints

  @end2end @end2end6
   #Created a case and event via Post courtlog
  Scenario Outline: Create a case
    Given I authenticate from the DARMIDTIER source system
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
      | courthouse         | case_number | defendants         | judges         | prosecutors         | defenders         | courtroom | keywords       | dateTime      | todaysDate  |
      | Harrow Crown Court | S{{seq}}001 | S{{seq}} defendant | S{{seq}} judge | S{{seq}} prosecutor | S{{seq}} defender | {{seq}}   | SIT LOG{{seq}} | {{timestamp}} | {{date+0/}} |

  @end2end @end2end6
  #Created a case and event via Post event using SOAP
  Scenario Outline: Create a case and hearing via events
    Given I authenticate from the DARMIDTIER source system
    Given I create an event
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |
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
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
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
      | Case ID                                                  | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number>                                            | <courthouse> | <courtroom> | <judges> | <defendants>  |
      | !\nRestriction\nThere are restrictions against this case | *IGNORE*     | *IGNORE*    | *IGNORE* | *IGNORE*      |
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
      | user     | courthouse         | courtroom      | case_number | dateTime      | message_id | eventId     | type | subType | caseRetention | totalSentence | prosecutors     | defenders     | defendants     | judges     | keywords       | todaysDate  |
      | APPROVER | Harrow Crown Court | Courtroom SIT1 | S{{seq}}001 | {{timestamp}} | {{seq}}001 | {{seq}}1001 | 1100 |         |               |               | prosecutor SIT1 | defender SIT1 | defendant SIT1 | judge SIT1 | SIT LOG{{seq}} | {{date+0/}} |



  @end2end @end2end4
  Scenario Outline: Transcriber
    Given I authenticate from the DARMIDTIER source system
    Given I create an event using json
      | message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <dateTime> | <caseRetention>             | <totalSentence>     |
    Given I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |

    Given I am logged on to DARTS as an REQUESTER user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    #Then I verify the HTML table contains the following values
      # | Case ID                                                 | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
     # | <case_number>                                           | <courthouse> | <courtroom> | <judges> | <defendants> |
     # | !\nRestriction There are restrictions against this case | *IGNORE* | *IGNORE* | *IGNORE* | *IGNORE* |
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on "<HearingDate>" in the same row as "<courtroom>"

    Then I click on the "Transcripts" link
    Then I press the "Request a new transcript" button
    Then I see "Request a new transcript" on the page
    And I select "<transcription-type>" from the "Request Type" dropdown
    And I select "<urgency>" from the "Urgency" dropdown
    And I press the "Continue" button
    And I see "Check and confirm your transcript request" on the page
    And I see "<case_number>" on the page
    And I check the "I confirm I have received authorisation from the judge." checkbox
    And I press the "Submit request" button
    And I see "Transcript request submitted" on the page
    Then I Sign out
    Then I see "Sign in to the DARTS Portal" on the page
    When I am logged on to DARTS as an APPROVER user
    Then I see "Search for a case" on the page
    Then I click on the "Your transcripts" link
    Then I see "Requests to approve or reject" on the page
    Then I click on "View" in the same row as "<case_number>"
    And I see "Do you approve this request?" on the page
    Then I select the "Yes" radio button
    Then I press the "Submit" button

    Then I Sign out
    Then I see "Sign in to the DARTS Portal" on the page
    Given I am logged on to DARTS as an TRANSCRIBER user
    When I click on the "Transcript requests" link
    And I see "Transcript requests" on the page
    Then I click on "View" in the same row as "<case_number>"
    Then I select the "Assign to me and upload a transcript" radio button
    Then I press the "Continue" button
    Then I see "<case_number>" on the page
    Then I see "<courthouse>" on the page
    Then I see "<requestMethod>" on the page
    Then I press the "Get audio for this request" button

    When I select the "Audio preview and events" radio button
    And I set the time fields of "Start Time" to "<startTime>"
    And I set the time fields of "End Time" to "<endTime>"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    Then I press the "Confirm" button
    Then I see "Your order is complete" on the page

    Then I click on the "Return to hearing date" link
    Then I click on the "Your audio" link
    Then I click on "View" in the same row as "<case_number>"
    Then I see "<case_number>" on the page
    Then I play the audio player
    Then I press the "Download audio file" button
    Then I verify the download file matches "<audioFile>"

    When I click on the "Your work" link
    Then I click on "View" in the same row as "<case_number>"
    Then I upload the file "<filename>" at "Upload transcript file"
    Then I press the "Attach file and complete" button
    Then I see "Transcript request complete" on the page

    Examples:
      | case_number | courthouse         | courtroom | judges     | defendants     | HearingDate                 | transcription-type | urgency   | message_id | eventId     | type  | subType | caseRetention | totalSentence | dateTime      | keywords       | prosecutors         | defenders         | requestMethod | audioFile                 | startTime | endTime  | filename            |
      | S855001     | Harrow Crown Court | 855       | S855 judge | S855 defendant | {{displayDate(17-01-2024)}} | Sentencing remarks | Overnight | {{seq}}001 | {{seq}}1001 | 21200 | 11000   |               |               | {{timestamp}} | SIT LOG{{seq}} | S{{seq}} prosecutor | S{{seq}} defender | Manual        | S855001_17_Jan_2024_1.mp3 | 16:00:00  | 16:02:00 | file-sample_1MB.doc |

