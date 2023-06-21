Feature: External Login Portal

@DMP-455 @DMP-361 @DMP-435 @DMP-436 @DMP-439 @DMP-452
Scenario Outline: External user logs in first time

#Step def for landing on correct screen - confirm content on all screens even if not interacted with

	Given I am on the landing page
	When I see "Sign in the the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button
	And I see "I have an account for DARTS through my organisation." on the page
	And I press the "Continue" button
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page
	And   I see "There is a dedicated page for HMCTS employees to sign in to the DARTS portal." on the page
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
	Then I see "Homepage" on the page
	
	#Last step will be to determine login was successful and landed on Homepage

Examples:
|email						|password	|phoneNum		|
|externaluser1@gmail.com	|Password1!	|07911123456	|

@DMP-455 @DMP-361 @DMP-435 @DMP-436 @DMP-451 @DMP-452
Scenario Outline: External user logs in second time/subsequent logins

	Given I am on the landing page
	When I see "Sign in the the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button
	And I press the "Continue" button
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page

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
	And I see "Homepage" on the page

Examples:
|email						|password	|phoneNum		|
|externaluser1@gmail.com	|Password1!	|07911123456	|

@DMP-455 @DMP-361 @DMP-436
Scenario Outline: External user forgotten password, existing account

#Pre-existing user who has logged in before, consider new user too

	Given I am on the landing page
	When I see "Sign in the the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button
	And I press the "Continue" button
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page

	When I click on the "Forgotten your password?" link
	Then I see "Reset your password" on the page
	And I see "We will send you a code to reset your password. Enter the email address that you use with DARTS."
	
	When I set "Enter your email" to "<email>"
	And I press the "Send code" button
	Then I see "Reset your password" on the page
	And I see "A verification code has been emailed to you. Enter it below." on the page
	
	#Will need to find a way for auto to dig out the verification code and insert it into this field - Notify? New step def?
	
	When I enter the verification code
	And I press the "Verify" button
	Then I see "Create a new password" on the page
	
	#Assuming standard PW is Password1!, so changing to Password2!
	
	When I set "New password" to "<newPassword>"
	And I set "Confirm new password" to "<newPassword>"
	And I press the "Create new password" button
	
	#According to wireframes, takes you back to sign in page, no confirmation or message to confirm PW change was successful?
	
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page
	
	#Sign back in with new password - decide if test finishes on next screen or at the end (homepage)
	
	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<newPassword>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number." on the page

Examples:
|email						|password	|newPassword	|
|externaluser1@gmail.com	|Password1!	|Password2!		|

@DMP-455 @DMP-361 @DMP-436
Scenario Outline: External user forgotten password, new account

#New user who has NOT logged in before

	Given I am on the landing page
	When I see "Sign in the the DARTS Portal" on the page
	And I select the "I work with the HM Courts and Tribunals Service" radio button
	And I press the "Continue" button
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page

	When I click on the "Forgotten your password?" link
	Then I see "Reset your password" on the page
	And I see "We will send you a code to reset your password. Enter the email address that you use with DARTS."
	
	When I set "Enter your email" to "<email>"
	And I press the "Send code" button
	Then I see "Reset your password" on the page
	And I see "A verification code has been emailed to you. Enter it below." on the page
	
	#Will need to find a way for auto to dig out the verification code and insert it into this field - Notify? New step def?
	
	When I enter the verification code
	And I press the "Verify" button
	Then I see "Create a new password" on the page
	
	When I set "New password" to "<newPassword>"
	And I set "Confirm new password" to "<newPassword>"
	And I press the "Create new password" button
	
	#According to wireframes, takes you back to sign in page, no confirmation or message to confirm PW change was successful?
	
	Then  I see "Sign in the the DARTS Portal" on the page
	And   I see "This sign in page is for users who do not work for HMCTS." on the page
	
	#Sign back in with new password - decide if test finishes on next screen or at the end (homepage)
	
	When I set "Enter your email" to "<email>"
	And I set "Enter your password" to "<newPassword>"
	And I press the "Continue" button
	Then I see "Verify your identity" on the page
	And I see "We'll send a security code to this mobile number whenever you sign in to your account." on the page

Examples:
|email						|password	|newPassword	|
|externaluser1@gmail.com	|Password1!	|Password2!		|