Feature: try out

@logon_judge
Scenario: logon-judge
	Given I am logged on to DARTS as a judge user
	When I want to display a dialog "????"
	Then I want to try something

@logon_admin
Scenario: logon-admin
	Given I am logged on to DARTS as an admin user
	When I want to display a dialog "????"
	Then I want to try something

@logon_transcriber
Scenario: logon-transcriber
	Given I am logged on to DARTS as a transcriber user
	When I want to display a dialog "????"
	Then I want to try something

@logon_requester
Scenario: logon-requester
	Given I am logged on to DARTS as a requester user
	When I want to display a dialog "****"
	Then I want to try something

@logon_approver
Scenario: logon-approver
	Given I am logged on to DARTS as an approver user
	When I want to display a dialog "****"
	Then I want to try something

@try_time
Scenario: try_time
	Given I am logged on to DARTS as a requester user
	And   I want to display a dialog "navigate to correct page"
	When I set the time fields below "Start time" to "10:01:02"
	And  I set the time fields below "End time" to "11:03:04"
	Then I want to display a dialog "verify entries are correct"
	
@try2
Scenario Outline: Create a case
  When I create a case
    | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
    | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
  Then the API status code is 201
  And I am logged on to DARTS as an external user
  When I click on the "Search" 
	 And I click on the "Advanced search" link
   And I set "Courthouse" to "<courthouse>"
   And I set "Case ID" to "<case_number>"
   And I press the "Search" button
   And I click on the "case_number" link
  Then I see "<case_number>" on the page
  #And I see "" on the page

Examples:
    | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     |
    | Harrow Crown Court | T{{yyyy-}}{{seq}}   | fred       | test judge | test prosecutor | test defender |

@try3
Scenario: POST /addCase
 When I call POST SOAP API using SOAPAction addCase and encoded body:
 """
 <case type="1" id="SOAP20230001{{seq}}">
 <courthouse>Harrow Crown Court</courthouse>
 <courtroom>Rayners room</courtroom>
 <defendants>
 <defendant>test defendent11</defendant>
 <defendant>test defendent22</defendant>
 </defendants>
 <judges>
 <judge>test judge</judge>
 </judges>
 <prosecutors>
 <prosecutor>test prosecutor</prosecutor>
 </prosecutors>
 </case>
 """

@try4
Scenario: Allow audio seeking - handle "Range" header - Preview
  Given I authenticate as a transcriber user
  When I call GET audio/preview/3833 API with header "range=0-100" and query params ""
  Then the API status code is 200

@try-date
Scenario: try date
  When I pause the test with message "{{dd-{{date+0}}}}"
  
@try-audio
Scenario: try audio
  When I load an audio file
  | courthouse         | courtroom | case_numbers | date        | startTime | endTime  | audioFile |
  | Harrow Crown Court | 855       | S855001      | {{date+0/}} | 10:00:00  | 10:05:00 | sample1   | 
  
@try_dailylist
Scenario: daily list
Given I add a daily lists
  | messageId | type | subType | documentName            | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp  | defendant    |
  | {{seq}}01 | DL   | DL      | DL {{date+0/}} FINAL v1 | Harrow Crown Court | {{seq}}   | S{{seq}}001 | {{date-2}} | 10:00:00  | {{date+30}} | {{timestamp}} | S{{seq}} defendants |
  

	
@try5
Scenario Outline: courthouse
  Given I am logged on to DARTS as an external user
	 When I click on the "Advanced search" link
   And I set "Courthouse" to "{{courthouse1}}"
   And I press the "Search" button
	Then I want to display a dialog "verify courthouse is correct"

Examples:
    | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     |
    | Harrow Crown Court | T{{yyyy-}}{{seq}}   | fred       | test judge | test prosecutor | test defender |