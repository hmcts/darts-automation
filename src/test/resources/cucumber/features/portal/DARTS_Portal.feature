Feature: Portal Tests

@smoketest
Scenario: External logon
	Given I am logged on to DARTS as an external user
	Then  I see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page


@DMP-407 @smoketest
Scenario: Search - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I see "Search for a case" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: Your Audios - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your Audios" link
	Then  I see "Your Audios" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: Your Transcriptions - Verify link
	Given I am logged on to DARTS as an external user
	When  I click on the "Your Transcriptions" link
	Then  I see "Your Transcriptions" on the page
	And  I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: Logout
	Given I am logged on to DARTS as an external user
	When  I click on the "Sign out" link
	Then  I see "Sign in to the DARTS Portal" on the page
	And  I do not see "Welcome to DARTS" on the page

@DMP-407 @smoketest
Scenario: HMCTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "HMCTS" link
	Then  I see "Welcome to DARTS" on the page
	And   I click on the "Sign out" link

@DMP-407 @smoketest
Scenario: DARTS Link
	Given I am logged on to DARTS as an external user
	When  I click on the "Search" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "DARTS" link
	Then  I see "Welcome to DARTS" on the page



