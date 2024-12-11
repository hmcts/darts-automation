Feature: Portal Tests

@smoketest @demo
Scenario: Accept cookies
	Given I am on the landing page
	 Then I see link with text "View cookies"
	 When I press the "Accept additional cookies" button
	 Then I see "You have accepted additional cookies. You can change your cookie settings at any time." on the page
	  And I do not see link with text "View cookies"
	 When I press the "Hide cookie message" button
	 Then I do not see "You have accepted additional cookies. You can change your cookie settings at any time." on the page
	  And Cookie "cookie_policy" "appInsightsCookiesEnabled" value is "true"

@smoketest @demo
Scenario: Reject cookies
	Given I am on the landing page
	 Then I see link with text "View cookies"
	 When I press the "Reject additional cookies" button
	 Then I see "You have rejected additional cookies. You can change your cookie settings at any time." on the page
	  And I do not see link with text "View cookies"
	 When I press the "Hide cookie message" button
	 Then I do not see "You have rejected additional cookies. You can change your cookie settings at any time." on the page
	  And Cookie "cookie_policy" "appInsightsCookiesEnabled" value is "false"

@DMP-407 @smoketest @demo
Scenario: Logout
	Given I am logged on to DARTS as an external user
	When I click on the "Sign out" link
	Then I see "Sign in to the DARTS Portal" on the page
	And I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest @demo
Scenario: Sign out Internal user
	Given I am logged on to DARTS as a requester user
	Then I see "Search for a case" on the page
	When I Sign out
	Then I see "Sign in to the DARTS Portal" on the page
	When I am logged on to DARTS as an approver user
	Then I see "Search for a case" on the page

@DMP-407 @smoketest @demo
Scenario: Sign out External user
	Given I am logged on to DARTS as an external user
	Then I see "Search for a case" on the page
	When I Sign out
	Then I see "Sign in to the DARTS Portal" on the page
	When I am logged on to DARTS as a transcriber user
	Then I see "Search for a case" on the page

@DMP-407 @smoketest @demo
Scenario Outline: All roles
	Given I am logged on to DARTS as a <role> user
	 Then I see "Search for a case" on the page
	  And I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page
	 When I verify links with text:
		| Your audio  | Your transcripts  | Search   | Transcript requests  | Your work  |
		| <yourAudio> | <yourTranscripts> | <search> | <transcriptRequests> | <yourWork> |
	  And I click on the "Your audio" link
  	And I click on the "HMCTS" link
	 Then I see "Search for a case" on the page
	 When I click on the "Your audio" link
  	And I click on the "DARTS" link
	 Then I see "Search for a case" on the page
	  And I see link with text "Sign out"

Examples:
	| role 	  	        | search            | yourAudio | yourTranscripts | transcriptRequests | yourWork |
	| Judge             | Search for a case | Y         | Y               | N                  | N        |
	| REQUESTER         | Search for a case | Y         | Y               | N                  | N        |
	| APPROVER          | Search for a case | Y         | Y               | N                  | N        |
	| APPEALCOURT       | Search for a case | Y         | N               | N                  | N        |
	| TRANSCRIBER       | Search for a case | Y         | N               | Y                  | Y        |
	| LANGUAGESHOP      | Search for a case | Y         | N               | N                  | N        |
	| ADMIN             | Search for a case | Y         | Y               | N                  | N        |
	| SUPERUSER         | Search for a case | Y         | Y               | N                  | N        |

@DMP-407 @smoketest @demo
Scenario Outline: Requester-Approver links
	When I am logged on to DARTS as a <role> user
	Then I see "Search for a case" on the page
	 And I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page
	 And I verify links with text:
		| Your audio  | Your transcripts  | Search   | Transcript requests  | Your work  |
		| <yourAudio> | <yourTranscripts> | <search> | <transcriptRequests> | <yourWork> |
	 And I verify sub-menu links for "Your transcripts":
		| Transcript requests | Transcript requests to review |
		| In Progress         | Requests to approve or reject |
	 And I see link with text "HMCTS"
	 And I see link with text "DARTS"
	 And I see link with text "Sign out"

Examples:
	| role 	  	        | search            | yourAudio | yourTranscripts | transcriptRequests | yourWork |
	| REQUESTERAPPROVER | Search for a case | Y         | Y               | N                  | N        |

@Admin @smoketest @demo
Scenario: Admin User
	When  I am logged on to the admin portal as an ADMIN user
	Then  I see "Users" on the page
	 And  I verify links with text:
		| Groups | Organisations | Courthouses | Transformed media | Transcripts | File deletion             | System configuration | Search | Users | Node registry | Transcript requests | Retention policies | Your audio | Events |
		| Y      | N             | Y           | Y                 | Y           | Files marked for deletion | Y                    | Y      | Y     | N             |  N                  | N                  | N          | N      |
	 And I verify sub-menu links for "File deletion":
		| Transcripts | Audio files |
		| Y           | Y           |
	 And I verify sub-menu links for "Transcripts":
		| Completed transcripts | Transcript requests |
		| Y                     | Y                   |
	 And I verify sub-menu links for "System configuration":
		| Event mappings | Automated tasks | Retention policies |
		| Y              | Y               | Y                  |
	When I click on the "Retention policies" sub-menu link
	 And I click on the "Inactive" sub-menu link
	 And I click on the "Active" sub-menu link
	Then I see link with text "HMCTS"
	 And I see link with text "DARTS"
	 And I see link with text "Sign out"
	When I click on the "User portal" link
	Then I see link with text "Your audio"
	When I click on the "Admin portal" link
	Then I see "You can search for cases, hearings, events and audio." on the page
