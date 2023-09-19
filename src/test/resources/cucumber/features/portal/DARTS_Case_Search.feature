Feature: Case Search

@DMP-509 @DMP-507
Scenario: Simple case search and result verification

#Step def for logging in as x, requester, judge, transciber etc?
#Replace login steps with new non-MFA user after merge

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I press the "Continue" button
	Then I see "This sign in page is for users who do not work for HMCTS." on the page

	When I set "Enter your email" to "externaluser1@gmail.com"
	And I set "Enter your password" to "Password1!"
	And I pause the test with message "enter userid & password"
	And I press the "Continue" button
	Then I see "Multi-factor authentication" on the page
	And I see phone number "07769742371" on the page
	And I press the "Send Code" button

	When I see "Enter your verification code below, or" on the page
	And I see "send a new code" on the page
	And I enter the security code
	And I press the "Verify Code" button
	Then I see "Welcome to DARTS" on the page

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
		| DMP461_Case40 | LIVERPOOL_DMP461 | ROOM_B_DMP461_L    |       |            |
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