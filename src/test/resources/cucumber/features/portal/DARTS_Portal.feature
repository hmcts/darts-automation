Feature: Portal Tests

@smoketest @obsolete
Scenario: External logon
	Given I am logged on to DARTS as an external user
	Then  I see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page

@smoketest
Scenario: External logon
	Given I am logged on to DARTS as an external user
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page


@DMP-407 @smoketest
Scenario: Search - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @DMP-860 @smoketest
Scenario: Your Audio - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your Audio" link
	Then  I see "Your Audio" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @DMP-860 @smoketest @broken
Scenario: Your Transcripts - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your Transcripts" link
	Then  I see "Your Transcripts" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: Logout
	Given I am logged on to DARTS as an external user
	When  I click on the "Sign out" link
	Then  I see "Sign in to the DARTS Portal" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: HMCTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "HMCTS" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page
	And   I click on the "Sign out" link

@DMP-407 @smoketest
Scenario: DARTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I see "Search for a case" on the page
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "DARTS" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario Outline: All roles
	When  I am logged on to DARTS as a <Type> user
	Then  I see "Search for a case" on the page
	And   I see link with text "Search"
	And   I see links with text:
	| Your Audio   | Your Transcripts   | Transcript Requests   | Your Work   |
	| <Your Audio> | <Your Transcripts> | <Transcript Requests> | <Your Work> |
	And   I see link with text "HMCTS"
	And   I see link with text "DARTS"
	And   I see link with text "Sign out"
	
Examples:
	| Type 			   | Your Audio | Your Transcripts | Transcript Requests | Your Work |
	| Judge        | Y          | N                | N                   | N         |
	| REQUESTER    | Y          | Y                | N                   | N         |
	| APPROVER     | Y          | Y                | N                   | N         |
	| APPEALCOURT  | Y          | Y                | N                   | N         |
	| TRANSCRIBER  | Y          | N                | N                   | N         |
	| LANGUAGESHOP | Y          | Y                | N                   | N         |


