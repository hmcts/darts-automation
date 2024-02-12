Feature: Case Search

@DMP-509 @DMP-507 @DMP-508 @DMP-517 @DMP-515 @DMP-860 @DMP-702 @DMP-561 @DMP-963 @DMP-997 @regression
Scenario: Case Search data creation
	Given I create a case
		| courthouse         | case_number | defendants     | judges           | prosecutors         | defenders         |
		| Harrow Crown Court | A{{seq}}001 | Def {{seq}}-1  | Judge {{seq}}-1  | testprosecutor      | testdefender      |
		| Harrow Crown Court | A{{seq}}002 | Def {{seq}}-11 | Judge {{seq}}-11 | testprosecutortwo   | testdefendertwo   |
		| Harrow Crown Court | A{{seq}}003 | Def {{seq}}-2  | Judge {{seq}}-11 | testprosecutorthree | testdefenderthree |
		| Harrow Crown Court | A{{seq}}004 | Def {{seq}}-22 | Judge {{seq}}-2  | testprosecutorfour  | testdefenderfour  |
		| Harrow Crown Court | A{{seq}}005 | Def {{seq}}-11 | Judge {{seq}}-2  | testprosecutorfive  | testdefenderfive  |

	Given I create an event
		| message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
		| {{seq}}001 | 1100  |          | {{seq}}1001 | Harrow Crown Court | {{seq}}-1  | A{{seq}}001  | {{seq}}ABC-1  | {{timestamp-10:00:00}} |                             |                     |
		| {{seq}}001 | 1100  |          | {{seq}}1001 | Harrow Crown Court | {{seq}}-11 | A{{seq}}002  | {{seq}}ABC-2  | {{timestamp-10:00:00}} |                             |                     |
		| {{seq}}001 | 1100  |          | {{seq}}1001 | Harrow Crown Court | {{seq}}-2  | A{{seq}}003  | {{seq}}ABC-11 | {{timestamp-10:00:00}} |                             |                     |
		| {{seq}}001 | 1100  |          | {{seq}}1001 | Harrow Crown Court | {{seq}}-11 | A{{seq}}004  | {{seq}}ABC-2  | {{timestamp-10:00:00}} |                             |                     |
		| {{seq}}001 | 21200 | 11008    | {{seq}}1001 | Harrow Crown Court | {{seq}}-2  | A{{seq}}005  | {{seq}}ABC-11 | {{timestamp-10:00:00}} |                             |                     |

@DMP-509 @DMP-507 @DMP-508 @DMP-517 @DMP-515 @DMP-860 @DMP-702 @DMP-561 @regression
Scenario: Simple and Advanced Case Search

  #Simple search

	When I am logged on to DARTS as an APPROVER user
	And I click on the "Search" link
	And I see "Also known as a case reference or court reference. There should be no spaces." on the page
	And I set "Case ID" to "A{{seq}}"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*   | *IGNORE*         | *IGNORE*       |
		| A{{seq}}004                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

  #Advanced search

	When I click on the "Clear search" link
	And I click on the "Advanced search" link
	And I set "Courthouse" to "Harrow Crown Court"
	And I set "Courtroom" to "{{seq}}-1"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}004 | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}002 | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001 | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on the "Clear search" link
	And "Courthouse" is ""
	And "Courtroom" is ""
	And I set "Defendant's name" to "Def {{seq}}-2"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}004 | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003 | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |

	When I click on the "Clear search" link
	And "Defendant's name" is ""
	And I set "Judge's name" to "Judge {{seq}}-1"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}003 | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002 | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001 | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on the "Clear search" link
	And "Judge's name" is ""
	And I set "Keywords" to "{{seq}}ABC-1"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2 | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*  | *IGNORE*         | *IGNORE*       |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2 | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1 | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on the "Your audio" link
	And I click on the "Search" link
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2 | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*  | *IGNORE*         | *IGNORE*       |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2 | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1 | Judge {{seq}}-1  | Def {{seq}}-1  |

  #Change both specific and date range once Trevor's date/timestamp step is ready, some cases will be backdated

	When I click on the "Clear search" link
	And "Keywords" is ""
	And I select the "Specific date" radio button
	And I set "Enter a date" to "{{date+0/}}"
	And I set "Case ID" to "A{{seq}}"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*   | *IGNORE*         | *IGNORE*       |
		| A{{seq}}004                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on the "Clear search" link
	And I select the "Date range" radio button
	And I set "Enter date from" to "{{date+0/}}"
	And I set "Enter date to" to "{{date+0/}}"
	And I set "Case ID" to "A{{seq}}"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*   | *IGNORE*         | *IGNORE*       |
		| A{{seq}}004                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on the "Clear search" link
	And I set "Case ID" to "1" and click away
	And I press the "Search" button
	Then I see "There are more than 500 results" on the page
	And I see "Refine your search by:" on the page
	And I see "adding more information to your search" on the page
	And I see "using filters to restrict the number of results" on the page

@DMP-509 @DMP-507 @DMP-860 @regression
Scenario: Case details and Hearing details

	#Case Details

	Given I am logged on to DARTS as an APPROVER user
  	When I click on the "Search" link
  	And I see "Search for a case" on the page
	And I set "Case ID" to "A{{seq}}"
	And I press the "Search" button
	And I click on the "A{{seq}}001" link
	Then I see "A{{seq}}001" on the page
	And I see "Harrow Crown Court" on the page
	And I see "testprosecutor" on the page
	And I see "testdefender" on the page
	And I see "Def {{seq}}-1" on the page
	And I see "Hearings" on the page

	#Hearing Details - Set permission for this particular CH as per confluence, may change

	And I verify the HTML table contains the following values
		| Hearing date    | Judge | Courtroom | No. of transcripts |
		| {{displaydate}} |       | {{seq}}-1 | 0                  |

	When I click on the "{{displaydate}}" link
	Then I see "Events and audio recordings" on the page
	And I see "Select events or audio to set the recording start and end times. You can also manually adjust the times for a custom recording." on the page
	And I see "Select events to include in requests" on the page
	And I see "{{seq}}-1" on the page
	#And I see "Judge" on the page - Empty at the moment
	And I see "Hearing started" on the page
	And I see "{{seq}}ABC-1" on the page

@DMP-509 @DMP-1135 @DMP-508 @DMP-515 @DMP-691 @regression
Scenario: Case Search error message verification
	Given I am logged on to DARTS as an APPROVER user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I click on the "Advanced search" link
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

@DMP-963 @regression
Scenario: Last Search results are retrievable on clicking Search in the breadcrumb trail
	When I am logged on to DARTS as an APPROVER user
	And I click on the "Search" link
	And I set "Case ID" to "A{{seq}}"
	And I press the "Search" button
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*   | *IGNORE*         | *IGNORE*       |
		| A{{seq}}004                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

	When I click on "A{{seq}}003" in the same row as "Harrow Crown Court"
	And I see "Prosecutor(s)" on the page

	And I click on the breadcrumb link "Search"
	And I click on "Case ID" in the table header
	Then I verify the HTML table contains the following values
		| Case ID                                                 | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}005                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-2  | Def {{seq}}-11 |
		| !\nRestriction\nThere are restrictions against this case | *IGNORE*           | *IGNORE*   | *IGNORE*         | *IGNORE*       |
		| A{{seq}}004                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-2  | Def {{seq}}-22 |
		| A{{seq}}003                                             | Harrow Crown Court | {{seq}}-2  | Judge {{seq}}-11 | Def {{seq}}-2  |
		| A{{seq}}002                                             | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |
		| A{{seq}}001                                             | Harrow Crown Court | {{seq}}-1  | Judge {{seq}}-1  | Def {{seq}}-1  |

@DMP-997 @regression
Scenario: Case file breadcrumbs
	When I am logged on to DARTS as an APPROVER user
	And I click on the "Search" link
	And I set "Case ID" to "A{{seq}}002"
	And I press the "Search" button
	Then I verify the HTML table contains the following values
		| Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendants(s)  |
		| A{{seq}}002 | Harrow Crown Court | {{seq}}-11 | Judge {{seq}}-11 | Def {{seq}}-11 |

	When I click on "A{{seq}}002" in the same row as "Harrow Crown Court"
	And I see "testprosecutortwo" on the page
	And I see "testdefendertwo" on the page
	And I click on the "{{displaydate}}" link
	Then I see "Events and audio recordings" on the page

	When I click on the breadcrumb link "A{{seq}}002"
	Then I see "testprosecutortwo" on the page
	And I see "testdefendertwo" on the page

@DMP-1397-AC1
Scenario: Hide automatic transcript request - Case file screen
	Given I am logged on to DARTS as an external user
  	When I click on the "Search" link
  	And I see "Search for a case" on the page
	And I set "Case ID" to "DMP-1225_case1"
	And I press the "Search" button
	And I click on the "DMP-1225_case1" link
	And I click on the "All Transcripts" link
	Then I verify the HTML table contains the following values
		| Hearing date | Type             | Requested on | Requested by |Status        |
        | 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 22 Dec 2023  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 22 Dec 2023  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |
		| 05 Jan 2024  |*IGNORE*          |*IGNORE*      |*IGNORE*      |*IGNORE*      |

@DMP-1397-AC2
Scenario: Hide automatic transcript request - Heating details screen
	Given I am logged on to DARTS as an external user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "DMP-1225_case1"
	And I press the "Search" button
	And I click on the "DMP-1225_case1" link
	And I click on the "5 Jan 2023" link
	And I click on the "Transcripts" link
	Then I see "There are no transcripts for this hearing." on the page

@DMP-1798-AC1-AC3 @regression
Scenario: Restrictions banner on hearing details screen - All restriction events received during hearing displayed on hearing details screen - Open restriction list
	Given I am logged on to DARTS as an APPROVER user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "A{{seq}}005"
	And I press the "Search" button
	And I click on the "A{{seq}}005" link
	And I click on the "{{displaydate}}" link
	And I click on the "Show restrictions" link
	Then I see "Hide restrictions" on the page
	And I see "Restriction applied: An order made under s46 of the Youth Justice and Criminal Evidence Act 1999" on the page
	And I see "For full details, check the hearing events." on the page

@DMP-1798-AC2 @regression
Scenario: Restrictions banner on hearing details screen - Closed by default
	Given I am logged on to DARTS as an APPROVER user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "A{{seq}}005"
	And I press the "Search" button
	And I click on the "A{{seq}}005" link
	And I click on the "{{displaydate}}" link
	#Then I click on the "Show restrictions" link
	Then I do not see "Restriction applied: An order made under s46 of the Youth Justice and Criminal Evidence Act 1999" on the page

@DMP-1798-AC4 @regression
Scenario: Restrictions banner on hearing details screen - collapse restriction list
	Given I am logged on to DARTS as an APPROVER user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "A{{seq}}005"
	And I press the "Search" button
	And I click on the "A{{seq}}005" link
	And I click on the "{{displaydate}}" link
	And I click on the "Show restrictions" link
	Then I see "Restriction applied: An order made under s46 of the Youth Justice and Criminal Evidence Act 1999" on the page
	And I see "For full details, check the hearing events." on the page

	When I click on the "Hide restrictions" link
	Then I do not see "Restriction applied: An order made under s46 of the Youth Justice and Criminal Evidence Act 1999" on the page
	And I do not see "For full details, check the hearing events." on the page

@DMP-1798-AC5
Scenario: Restrictions banner on hearing details screen - no restrictions during hearing but others on case
	Given I am logged on to DARTS as an external user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "DMP-1225_case1"
	And I press the "Search" button
	And I click on the "DMP-1225_case1" link
	And I click on the "5 Jan 2024" link
	Then I see "There are restrictions against this case" on the page
	And I do not see "Show restrictions" on the page

@DMP-1798-AC6
Scenario: Restrictions banner on hearing details screen - No restrictions
	Given I am logged on to DARTS as an external user
	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "CASE5_Event_DMP461"
	And I press the "Search" button
	And I click on the "CASE5_Event_DMP461" link
	Then I do not see "There are restrictions against this case" on the page

	When I click on the "10 Aug 2023" link
	And I do not see "There are restrictions against this case" on the page
	And I press the "back" button on my browser
	And I click on the "11 Aug 2023" link
	Then I do not see "There are restrictions against this case" on the page
