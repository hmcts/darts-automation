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
	When  I click on the "Your audio" link
	Then  I see "Your audio" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @DMP-860 @smoketest
Scenario: Your Transcripts - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your transcripts" link
	Then  I see "Your transcripts" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: Logout
	Given I am logged on to DARTS as an external user
	When  I click on the "Sign out" link
	Then  I see "Sign in to the DARTS Portal" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest @TS
Scenario: HMCTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "HMCTS" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page
	And   I Sign out

@DMP-407 @smoketest
Scenario: HMCTS Link
	Given I am logged on to DARTS as a judge user
	Then  I see "Search for a case" on the page
	When  I Sign out
	Then  I see "Sign in to the DARTS Portal" on the page

@DMP-407 @smoketest
Scenario: DARTS Link
	Given I am logged on to DARTS as an external user
	Then  I see "Search for a case" on the page
	When  I Sign out
	Then  I see "Sign in to the DARTS Portal" on the page

@DMP-407 @smoketest
Scenario Outline: All roles
	When  I am logged on to DARTS as a <role> user
	Then  I see "Search for a case" on the page
	And   I see links with text:
	| Search   | Your audio  | Your transcripts  | Transcript requests  | Your work   |
	| <search> | <yourAudio> | <yourTranscripts> | <transcriptRequests> | <yourWork> |
	And   I see link with text "HMCTS"
	And   I see link with text "DARTS"
	And   I see link with text "Sign out"

Examples:
	| role 	  	        |search | yourAudio | yourTranscripts | transcriptRequests | yourWork |
	| Judge             | Y     | Y         | Y               | N                  | N        |
	| REQUESTER         | Y     | Y         | Y               | N                  | N        |
	| APPROVER          | Y     | Y         | Y               | N                  | N        |
	| APPEALCOURT       | Y     | Y         | N               | N                  | N        |
	| TRANSCRIBER       | Y     | Y         | N               | Y                  | Y        |
	| LANGUAGESHOP      | Y     | Y         | N               | N                  | N        |
	| REQUESTERAPPROVER | Y     | Y         | Y               | N                  | N        |


