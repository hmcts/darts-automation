Feature: Case Search

	Background:
		Given I am logged on to DARTS as an external user
		When I click on the "Search" link
		And I see "Search for a case" on the page

	@DMP-509 @DMP-507 @DMP-517
	Scenario: Simple case search and result verification
		Then I set "Case ID" to "Case50"
		And I see "Also known as a case reference or court reference. There should be no spaces." on the page
		And I press the "Search" button
		Then Search results should contain "CaseID" containing "Case50"

		When I set "Case ID" to "Case40"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID        | Courthouse       | Courtroom       | Judge(s) | Defendants(s) |
			| DMP461_Case40  | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case400 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case402 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case404 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case406 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case408 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case401 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case403 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case405 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case407 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |
			| DMP461_Case409 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L |          |               |

	@DMP-509 @DMP-508 @DMP-515 @DMP-860 @DMP-702 @DMP-517 @DMP-561
	Scenario: Advanced case search and result verification
		When I click on the "Advanced search" link
		And I set "Courthouse" to "DMP-1151-1"
		And I set "Courtroom" to "DMP-1151-01 Courtroom"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID     | Courthouse | Courtroom             | Judge(s) | Defendants(s)         |
			| DMP-1151-01 | DMP-1151-1 | DMP-1151-01 Courtroom |          | DMP-1151-01 Defendant |

		When I click on the "Clear search" link
		And "Courthouse" is ""
		And "Courtroom" is ""
		And I set "Defendant's name" to "DMP-695-01 Defendant"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
          | Case ID | Courthouse | Courtroom | Judge(s)          | Defendants(s)         |
		  | DMP-695-01                                                            | DMP-695-1  | DMP-695-01 Courtroom |          | DMP-695-01 Defendant |
		  | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*             | *IGNORE* | *IGNORE*             |

		When I click on the "Clear search" link
		And "Defendant's name" is ""
		And I set "Judge's name" to "Mrs S10 Judge"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID   | Courthouse | Courtroom | Judge(s)      | Defendants(s)    |
			| S10_DEMO1 | Swansea    | Multiple  | Mrs S10 Judge | Mr S10 Defendant |

		When I click on the "Clear search" link
		And "Judge's name" is ""
		And I set "Keywords" to "Judge"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID                                                               | Courthouse | Courtroom            | Judge(s) | Defendants(s)        |
			| DMP-695-01                                                            | DMP-695-1  | DMP-695-01 Courtroom |          | DMP-695-01 Defendant |
			| !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*             | *IGNORE* | *IGNORE*             |
			| CASE1_DMP651                                                          | London     | Multiple             |          | Multiple             |
			| !\nRestriction\nRestriction: Prosecution witness adsent: police       | *IGNORE*   | *IGNORE*             | *IGNORE* | *IGNORE*             |

		When I click on the "Clear search" link
		And "Keywords" is ""
		And I select the "Specific date" radio button with label "Specific date"
		And I set "Enter a date" to "09/10/2023"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID       | Courthouse | Courtroom | Judge(s) | Defendants(s) |
			| DMP1128-case1 | London     | Multiple  | *IGNORE* | *IGNORE*      |

		When I click on the "Clear search" link
		And I select the "Date range" radio button with label "Date range"
		And I set "Enter date from" to "01/11/2023"
		And I set "Enter date to" to "03/11/2023"
		And I press the "Search" button
		Then I verify the HTML table contains the following values
			| Case ID                                                                     | Courthouse | Courtroom    | Judge(s) | Defendants(s) |
			| A2023XXX                                                                    | Liverpool  | 1            |          |               |
			| !\nRestriction\nRestriction: Section 4(2) of the Contempt of Court Act 1981 | *IGNORE*   | *IGNORE*     | *IGNORE* | *IGNORE*      |
			| A2023XXX                                                                    | Leeds      | Multiple     |          |               |
			| Case1_DMP938                                                                | London     | Multiple     |          |               |
			| Case2_DMP938                                                                | London     | Room1_London |          |               |

		When I click on the "Clear search" link
		And I set "Courthouse" to "Courthouse" and click away
		And I press the "Search" button
		Then I see "There are more than 500 results" on the page
		And I see "Refine your search by:" on the page
		And I see "adding more information to your search" on the page
		And I see "using filters to restrict the number of results" on the page

		When I click on the "Clear search" link
		And I set "Case ID" to "case"
		And I press the "Search" button
		Then I see "15 results" on the page

		When I set "Courthouse" to "Swansea" and click away
		And I press the "Search" button
		Then I see "8 results" on the page

@DMP-509 @DMP-507 @DMP-860
Scenario: Case details and Hearing details
	Then I set "Case ID" to "DMP-695-01"
	And I press the "Search" button
	Then I verify the HTML table contains the following values
		| Case ID                                                               | Courthouse | Courtroom            | Judge(s) | Defendants(s)        |
		| DMP-695-01                                                            | DMP-695-1  | DMP-695-01 Courtroom |          | DMP-695-01 Defendant |
		| !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*             | *IGNORE* | *IGNORE*             |

	#Case Details
	When I click on the "DMP-695-01" link
	Then I see "DMP-695-01" on the page
	And I see "DMP-695-1" on the page
	And I see "DMP-695-AC1 Prosecutor" on the page
	And I see "DMP-695-01 Defence" on the page
	And I see "DMP-695-01 Defendant" on the page
	And I see "Hearings" on the page
	And I see "Restriction: Judge directed on reporting restrictions" on the page

	#Hearing Details - Set permission for this particular CH as per confluence, may change
	Then I verify the HTML table contains the following values
		| Hearing date | Judge            | Courtroom            | No. of transcripts |
		| 18 Sep 2023  | DMP-695-01 Judge | DMP-695-01 Courtroom | 0                  |

	When I click on the "18 Sep 2023" link
	Then I see "Events and audio recordings" on the page
	And I see "Select events or audio to set the recording start and end times. You can also manually adjust the times for a custom recording." on the page
	And I see "Select events to include in requests" on the page
	And I see "DMP-695-1" on the page
	And I see "DMP-695-01 Courtroom" on the page
	And I see "DMP-695-01 Judge" on the page

@DMP-509 @DMP-1135 @DMP-508 @DMP-515 @DMP-691
Scenario: Case Search error message verification
	When I click on the "Advanced search" link
	And I set "Courtroom" to "2"
	And I press the "Search" button
	Then I see an error message "You must also enter a courthouse"

	#Will use hard-coded dates until we have ability to use date+/- x days
	When I click on the "Clear search" link
	And I select the "Specific date" radio button with label "Specific date"
	And I set "Enter a date" to "06/10/2024"
	And I press the "Search" button
	Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date from" to "06/10/2024"
	And I set "Enter date to" to "05/10/2023"
	And I press the "Search" button
	Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date from" to "05/10/2023"
	And I set "Enter date to" to "06/10/2024"
	And I press the "Search" button
	Then I see an error message "You have selected a date in the future. The hearing date must be in the past"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date to" to "05/10/2023"
	And I press the "Search" button
	Then I see an error message "You have not selected a start date. Select a start date to define your search"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date from" to "05/10/2023"
	And I press the "Search" button
	Then I see an error message "You have not selected an end date. Select an end date to define your search"

	When I click on the "Clear search" link
	And I select the "Specific date" radio button with label "Specific date"
	And I set "Enter a date" to "Invalid"
	And I press the "Search" button
	Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date from" to "Invalid"
	And I press the "Search" button
	Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"
	Then I see an error message "You have not selected an end date. Select an end date to define your search"

	When I click on the "Clear search" link
	And I select the "Date range" radio button with label "Date range"
	And I set "Enter date to" to "Invalid"
	And I press the "Search" button
	Then I see an error message "You have not selected a start date. Select a start date to define your search"
	Then I see an error message "You have not entered a recognised date in the correct format (for example 31/01/2023)"

@DMP-963
Scenario: Last Search results are retrievable on clicking Search in the breadcrumb trail
	When I set "Case ID" to "Case1009"
	And I press the "Search" button
	Then I verify the HTML table contains the following values
		| Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
		| CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
		| !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
		| CASE1009                                                              | Liverpool  | ROOM_A    |          |               |
    #Case Details
	When I click on "CASE1009" in the same row as "Swansea"
	Then I click on the breadcrumb link "Search"
	Then I verify the HTML table contains the following values
		| Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
		| CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
		| !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
		| CASE1009                                                              | Liverpool  | ROOM_A    |          |               |

@DMP-997
Scenario: Case file breadcrumbs
	When I set "Case ID" to "Case1009"
	And I press the "Search" button
	Then I verify the HTML table contains the following values
		| Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
		| CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
		| !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
		| CASE1009                                                              | Liverpool  | ROOM_A    |          |               |
    #Case Details
	When I click on "CASE1009" in the same row as "Swansea"
	And I see "Case ID" on the page
	And I see "CASE1009" on the page
	Then I click on the breadcrumb link "CASE1009"
	Then I see "Case ID" on the page
	And I see "CASE1009" on the page