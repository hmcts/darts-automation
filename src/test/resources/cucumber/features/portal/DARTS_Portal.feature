Feature: Portal Tests

@smoketest @obsolete
Scenario: External logon
	Given I am logged on to DARTS as an external user
	Then  I see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page

@smoketest @demo
Scenario: External logon
	Given I am logged on to DARTS as an external user
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page


@DMP-407 @smoketest @demo
Scenario: Search - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @DMP-860 @smoketest @demo
Scenario: Your Audio - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your audio" link
	Then  I see "Your audio" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @DMP-860 @smoketest @demo
Scenario: Your Transcripts - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your transcripts" link
	Then  I see "Your transcripts" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest @demo
Scenario: Logout
	Given I am logged on to DARTS as an external user
	When  I click on the "Sign out" link
	Then  I see "Sign in to the DARTS Portal" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest @demo
Scenario: HMCTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "HMCTS" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page
	And   I Sign out

@DMP-407 @smoketest @demo
Scenario: Sign out Internal user
	Given I am logged on to DARTS as a requester user
	Then  I see "Search for a case" on the page
	When  I Sign out
	Then  I see "Sign in to the DARTS Portal" on the page
	When  I am logged on to DARTS as an approver user
	Then  I see "Search for a case" on the page

@DMP-407 @smoketest @demo
Scenario: Sign out External user
	Given I am logged on to DARTS as an external user
	Then  I see "Search for a case" on the page
	When  I Sign out
	Then  I see "Sign in to the DARTS Portal" on the page
	When  I am logged on to DARTS as a transcriber user
	Then  I see "Search for a case" on the page

@DMP-407 @smoketest @demo
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
	| ADMIN             | Y     | Y         | N               | N                  | N        |
	


@Admin @smoketest @demo
Scenario: Admin User
	When  I am logged on to the admin portal as an ADMIN user
	Then  I see "Users" on the page
	And   I see links with text:
		| Users | Groups | Organisations | Courthouses | Events | Audio cache | Transcripts | File deletion | System configuration | Node registry | Transformed media | Transcript requests | Retention policies | Your audio |
		| Y     | Y      | N             | Y           | Y      | Y           | Y           | Y             | Y                    | N             | N                 | N                   | N                  | N          |
	And   I see link with text "HMCTS"
	And   I see link with text "DARTS"
	And   I see link with text "Sign out"
