Given I am on the Admin Login Page
Then I see “Welcome to DARTS” on the page
And I see “This is a new service – your feedback will help us to improve it.” on the page
And I see “All content is available under the Open Government License v3.0, except where otherwise stated”
#Any others to check?

#Inbox - Verify text on screen rather than link?
When I click on the “Inbox” link
Then I do not see “Welcome to DARTS” on the page

#My Audios - Verify text on screen rather than link?
When I click on the “My Audios” link
Then I do not see “Welcome to DARTS” on the page

#My Transcriptions - Verify text on screen rather than link?
When I click on the “My Transcriptions” link
Then I do not see “Welcome to DARTS” on the page

#Logout
When I click on the “Logout” link
Then I see “Welcome to DARTS” on the page

#DARTS Portal
When I click on the “Inbox” link
Then I do not see “Welcome to DARTS” on the page
When I click on the “DARTS portal” link
Then I see “Welcome to DARTS” on the page

#Search case… (double check how to interact with field)
When I set “Search case…” to “12345”
#Click on search icon, as discussed, need to find how it’s clicked
And I dismiss the alert