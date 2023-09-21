Feature: Portal Tests

@smoketest
Scenario: navigate
	Given I am on the landing page
#	Then  I see "This is a new service – your feedback will help us to improve it." on the page
#	And   I see "Welcome to DARTS" on the page
	And   I see "All content is available under the Open Government Licence v3.0, except where otherwise stated" on the page
#Any others to check?

@DMP-407
Scenario: Inbox - Verify text on screen rather than link?
	Given I am on the portal page
	When  I click on the "Inbox" link
	Then  I see "Inbox" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407
Scenario: My Audios - Verify text on screen rather than link?
	Given I am on the portal page
	When  I click on the "My Audios" link
	Then  I see "My Audios" on the page
	And   I do not see "Welcome to DARTS" on the page

@DMP-407
Scenario: My Transcriptions - Verify text on screen rather than link?
	Given I am on the portal page
	When  I click on the "My Transcriptions" link
	Then  I see "My Audios" on the page
	Then  I do not see "Welcome to DARTS" on the page

@DMP-407
Scenario: Logout
	Given I am on the portal page
	When  I click on the "Sign out" link
	Then  I see "Welcome to DARTS" on the page

@DMP-407
Scenario: DARTS Portal
	Given I am on the portal page
	When  I click on the "Inbox" link
	Then  I do not see "Welcome to DARTS" on the page
	When  I click on the "DARTS portal" link
	Then  I see "Welcome to DARTS" on the page


#Search case… has now been removed
#Scenario: search
#	Given I am on the portal page
#	When  I search for "12345"
#	 And  I press the "search" button
#	And   I dismiss the alert

