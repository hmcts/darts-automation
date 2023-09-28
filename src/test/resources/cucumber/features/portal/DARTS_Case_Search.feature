Feature: Case Search

@DMP-509 @DMP-507
Scenario: Simple case search and result verification

#Step def for logging in as x, requester, judge, transciber etc?

	Given I am logged on to DARTS as an external user

	When I click on the "Search" link
	And I see "Search for a case" on the page
	And I set "Case ID" to "Case50"
	And I see "Also known as a case reference or court reference. There should be no spaces." on the page
	And I press the "Search" button
	Then Search results should contain "CaseID" containing "Case50"

	When I set "Case ID" to "Case40"
	And I press the "Search" button
	Then I can see search results table
		| CaseID     	 | Courthouse     	| Courtroom   		 |Judges | Defendants |
		| DMP461_Case40  | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case400 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case402 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case404 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case406 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case408 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case401 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case403 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case405 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case407 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
		| DMP461_Case409 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |


@DMP-509 @DMP-508 @DMP-860 @DMP-702
Scenario: Advanced case search and result verification

	Given I am logged on to DARTS as an external user

	When I click on the "Search" link
	And I see "Search for a case" on the page

	When I click on the "Advanced search" link
	And I set "Courthouse" to "DMP-948-1"
	And I set "Courtroom" to "DMP-948-01 Courtroom"
	And I press the "Search" button
	Then I can see search results table
		| CaseID       | Courthouse   | Courtroom   		   | Judges 			   | Defendants 		   |
		| DMP-948-01   | DMP-948-1	  | DMP-948-01 Courtroom   | DMP-948-01 Judge 948  | DMP-948-01 Defendant  |

	And I see "Restriction: Judge directed on reporting restrictions" on the page

	When I click on the "Clear search" link
	And "Courthouse" is ""
	And "Courtroom" is ""
	And I set "Defendant's name" to "DMP-370-01 Defendant"
	And I press the "Search" button
	Then I can see search results table
		| CaseID       | Courthouse   | Courtroom   		 	| Judges 			 | Defendants 			  |
		| DMP-370-01   | DMP-370-1	  | DMP-370-01 Courtroom    | DMP-370-01 Judge   | DMP-370-01 Defendant   |

	And I do not see "Restriction:" on the page

	When I click on the "Clear search" link
	And "Defendant's name" is ""
	And I set "Judge's name" to "DMP-517-AC2 Judge Dredd"
	And I press the "Search" button
	Then I can see search results table
		| CaseID     	 | Courthouse    | Courtroom   		 	   | Judges 				   | Defendants 			|
		| DMP-517-AC2  	 | DMP-517-AC2	 | DMP-517-AC2 Courtroom   | DMP-517-AC2 Judge Dredd   | DMP-517-AC2 Defendant  |

	And I see "Restriction: Section 4(2) of the Contempt of Court Act 1981" on the page

	When I click on the "Clear search" link
	And "Judge's name" is ""
	And I set "Keywords" to "Case"
	And I press the "Search" button
	Then I can see search results table
		| CaseID     	 	| Courthouse    	 | Courtroom    				| Judges 				| Defendants 			|
		| DMP-467-Case001  	| DMP-467-LIVERPOOL  | 'DMP-467-LIVERPOOL-ROOM_B   	| DMP-467-Case001-J001  | DMP-467-Case001-D001  |
		| DMP-751-Case001  	| DMP-751-LIVERPOOL	 | Multiple     				| DMP-751-Case001-J001  | DMP-751-Case001-D001  |
		| 23-DMP-0661-0	 	| Harrow Crown Court | Grimsdyke room   			| 					    | 					    |

	When I click on the "Clear search" link
	Then "Keywords" is ""

 #Specific and date range might have an issue, what is the field name for the date fields to input?

@DMP-509 @DMP-507 @DMP-860
Scenario: Case details and Hearing details

	Given I am logged on to DARTS as an external user

	When I click on the "Search" link
	And I see "Search for a case" on the page

	And I set "Case ID" to "DMP-695-01"
	And I press the "Search" button
	Then I can see search results table
		| CaseID      | Courthouse	| Courtroom   			|Judges 			| Defendants 			|
		| DMP-695-01  | DMP-695-1	| DMP-695-01 Courtroom  | DMP-695-01 Judge  | DMP-695-01 Defendant  |

	And I see "Restriction: Judge directed on reporting restrictions" on the page

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

	When I click on the "18 Sep 2023" link
	Then I see "Events and audio recordings" on the page
	And I see "Select events or audio to set the recording start and end times. You can also manually adjust the times for a custom recording." on the page
	And I see "Select events to include in requests" on the page
	And I see "DMP-695-1" on the page
	And I see "DMP-695-01 Courtroom" on the page
	And I see "DMP-695-01 Judge" on the page