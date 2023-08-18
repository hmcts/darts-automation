Feature: External Login Portal

@DMP-455 @DMP-361 @DMP-435 @DMP-436 @DMP-439 @DMP-452
Scenario Outline: External user logs in first time
#Step def for landing on correct screen - confirm content on all screens even if not interacted with

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I see "I have an account for DARTS through my organisation." on the page
	And I press the "Continue" button
	Then I see "Sign in to the DARTS portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page
	And I see "There is a dedicated page for HMCTS employees to sign into the portal." on the page
	And I see "Forgotten your password?" on the page
	And I see "Keep me signed in" on the page

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<password>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number whenever you sign in to your account." on the page

	When I set "Enter your mobile phone number (UK numbers only)" to "<phoneNum>"
	#Check extra info link
	And I click on the "Don't have a mobile phone?" link
	And I see "Find out what text is under this link and insert here." on the page
	And I press the "Send code" button
	Then I see "Check your phone" on the page
	And I see "Enter the x-digit security code sent to <phoneNum>" on the page

	#Will need to find a way for auto to dig out the security code and insert it into this field - Notify? New step def?
	#The mobile number is partly obscured on the code entering screen, will need to just use last x digits

	When I enter the security code
	And I press the "Continue" button
	Then I see "Welcome to DARTS" on the page
	And I see "Inbox" on the page
	And I see "My Audios" on the page
	And I see "My Transcriptions" on the page

	When I click on the "Sign out" link
	Then I see "Sign in to the DARTS Portal" on the page

	#Last step will be to determine login was successful and landed on Homepage

Examples:
|email					|password	|phoneNum	|
|externaluser1@gmail.com|Password1!	|07911123456|

@DMP-455 @DMP-361 @DMP-435 @DMP-436 @DMP-451 @DMP-452
Scenario Outline: External user logs in second time/subsequent logins

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I press the "Continue" button
	Then I see "Sign in to the DARTS portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<password>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number." on the page
	And I see "<phoneNum>" on the page

	When I click on the "I need to change this number" link
	And I see "To change your number email support@darts.gov.uk" on the page
	And I press the "Send code" button
	Then I see "Check your phone" on the page
	And I see "Enter the x-digit security code sent to <phoneNum>" on the page
	And I enter the security code
	And I press the "Continue" button
	Then I see "Welcome to DARTS" on the page

Examples:
|email					|password	|phoneNum	|
|externaluser1@gmail.com|Password1!	|07911123456|

@DMP-455 @DMP-361 @DMP-436 @DMP-493 @DMP-494 @DMP-495 @DMP-585
Scenario Outline: External user forgotten password, existing account

#Pre-existing user who has logged in before, consider new user too

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I press the "Continue" button
	Then I see "Sign in to the DARTS portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page

	When I click on the "Forgotten your password?" link
	Then I see "Reset your password" on the page
	And I see "Enter the email you use to sign in to DARTS Portal. We'll send you a code to reset your password." on the page

	When I set "Email address" to "<email>"
	And I press the "Send code" button
	Then I see "Reset your password" on the page
	And I see "Enter the verification code sent to your email to reset your password" on the page

	#Will need to find a way for auto to dig out the verification code and insert it into this field - Notify? New step def?

	When I enter the verification code
	And I press the "Verify" button
	Then I see "Code accepted" on the page
	And I see "You can continue to reset your password for account" on the page
	And I see "<email>" on the page

	When I press the "Continue" button
	Then I see "Create a new password" on the page

	#Assuming standard PW is Password1!, so changing to Password2!

	When I set "New password" to "<newPassword>"
	And I set "Confirm new password" to "<newPassword>"
	And I press the "Create new password" button

	#According to wireframes, takes you back to sign in page, no confirmation or message to confirm PW change was successful?

	Then I see "Sign in to the DARTS Portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page

	#Sign back in with new password - decide if test finishes on next screen or at the end (homepage)

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<newPassword>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number." on the page

Examples:
|email					|newPassword|
|externaluser1@gmail.com|Password2!	|

@DMP-455 @DMP-361 @DMP-436 @DMP-493 @DMP-494 @DMP-495 @DMP-585
Scenario Outline: External user forgotten password, new account

#New user who has NOT logged in before

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I press the "Continue" button
	Then I see "Sign in to the DARTS portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page

	When I click on the "Forgotten your password?" link
	Then I see "Reset your password" on the page
	And I see "Enter the email you use to sign in to DARTS Portal. We'll send you a code to reset your password." on the page

	When I set "Email address" to "<email>"
	And I press the "Send code" button
	Then I see "Reset your password" on the page
	And I see "Enter the verification code sent to your email to reset your password" on the page

	#Will need to find a way for auto to dig out the verification code and insert it into this field - Notify? New step def?

	When I enter the verification code
	And I press the "Verify" button
	Then I see "Code accepted" on the page
	And I see "You can continue to reset your password for account" on the page
	And I see "<email>" on the page

	When I press the "Continue" button
	Then I see "Create a new password" on the page

	When I set "New password" to "<newPassword>"
	And I set "Confirm new password" to "<newPassword>"
	And I press the "Create new password" button

	#According to wireframes, takes you back to sign in page, no confirmation or message to confirm PW change was successful?

	Then I see "Sign in to the DARTS Portal" on the page
	And I see "This sign in page is for users who do not work for HMCTS." on the page

	#Sign back in with new password - decide if test finishes on next screen or at the end (homepage)

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<newPassword>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number whenever you sign in to your account." on the page

Examples:
|email					|newPassword|
|externaluser1@gmail.com|Password2!	|

@DMP-436 @DMP-453 @DMP-552 @DMP-363 @DMP-681 @DMP-682
Scenario Outline: Existing External User error message verification

	Given I am on the landing page
	When I see "Sign in to the DARTS Portal" on the page
	And I press the "Continue" button
	Then I see an error message "Select whether you are an employee of HM Courts and Tribunals Service or you work with HM Courts and Tribunals Service."

	When I select the "I work with the HM Courts and Tribunals Service" radio button with label "I work with the HM Courts and Tribunals Service"
	And I press the "Continue" button
	Then I see "This sign in page is for users who do not work for HMCTS." on the page

	When I press the "Continue" button
	Then I see an error message "You must enter the email address you use to sign in to the DARTS Portal."
	And I see an error message "You must enter the password you use to sign in to the DARTS Portal."

	#Wireframes for error message for username/password mismatch?

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "WrongPassword"
	And I press the "Continue" button
	Then I see an error message "Enter the password you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "unknown@gmail.com"
	And I set "Enter your password" to "<password>"
	And I press the "Continue" button
	Then I see an error message "Enter the email address you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "unknown@gmail.com"
	And I set "Enter your password" to "WrongPassword"
	And I press the "Continue" button
	Then I see an error message "Enter the email address you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "invalid"
	And I set "Enter your password" to "<password>"
	And I press the "Continue" button
	Then I see an error message "Please enter a valid email address."

	#Testing DMP-682 with separate user, lockout mechanic

	When I set "Enter your email" to "<emailTwo>"
	And I set "Enter your Password" to "Wrongpassword"
	And I press the "Continue" button
	And I see an error message "Enter the password you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "<emailTwo>"
	And I set "Enter your Password" to "Wrongpassword"
	And I press the "Continue" button
	And I see an error message "Enter the password you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "<emailTwo>"
	And I set "Enter your Password" to "Wrongpassword"
	And I press the "Continue" button
	And I see an error message "Enter the password you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "<emailTwo>"
	And I set "Enter your Password" to "Wrongpassword"
	And I press the "Continue" button
	And I see an error message "Enter the password you use to sign in to the DARTS Portal."

	When I set "Enter your email" to "<emailTwo>"
	And I set "Enter your Password" to "Wrongpassword"
	And I press the "Continue" button
	And I see an error message "Your account is temporarily locked to prevent unauthorized use. Try again later."

	#Back to other tests

	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<password>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page

	When I press the "Sent code" button
	Then I see "Check your phone" on the page

	When I press the "Continue" button
	Then I see an error message "The security code you entered has not been recognised."
	And I see an error message "Review the 6-digit code to check you have entered it correctly."

	When I set "Enter security code" to "12345"
	And I press the "Continue" button
	Then I see an error message "The security code you entered has not been recognised."
	And I see an error message "Review the 6-digit code to check you have entered it correctly."

	When I click on the "Back" link
	And I click on the "Back" link
	And I click on the "Forgotten your password?" link
	And I see "Reset your password" on the page
	And I press the "Send code" button
	Then I see an error message "Enter an email address in the correct format, like name@example.com"

	When I set "Enter your email" to "invalid"
	And I press the "Send code" button
	Then I see an error message "Enter an email address in the correct format, like name@example.com"
	#What about an email that doesn't exist?

	When I set "Enter your email" to "<email>"
	And I press the "Send code" button
	And I press the "Verify" button
	Then I see an error message "You have not entered a verification code."
	And I see "Enter the verification code sent to <email>" on the page

	When I set "Enter verification code" to "12345"
	And I press the "Verify" button
	Then I see an error message "The verification code you have entered is not correct."
	And I see an error message "Review the 6-digit code to check you have entered it correctly."

	When I enter the verification code
	And I press the "Verify" button
	And I press the "Create new password" button
	Then I see an error message "Create a new password."
	And I see an error message "A password should be between 8 to 64 characters and have at least 3 lowercase letters, 3 uppercase letters, 3 digits, 3 symbols"

	When I set "New password" to "<newPassword>"
	And I set "Confirm new password" to "wrongpassword"
	And I press the "Create new password" button
	Then I see an error message "The passwords provided do not match. Enter and try again."

	#Criteria error message needs to be added?
	#Some of these error messages might be changed, will need to update if they do.

Examples:
|email					|password	|newPassword|emailTwo				|
|externaluser1@gmail.com|Password1!	|Password2!	|externaluser2@gmail.com|

 	#According to wireframes, there's an option to use email OR mobile, add email scenarios as well, especially if we can't auto texts
 	#Need to add/edit scenario for try again on "Check your phone" screen
	#DMP-490 Logout of FE Portal
	#Some errors might need changing