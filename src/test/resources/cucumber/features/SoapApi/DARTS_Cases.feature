Feature: Cases EndPoint using SOAP

@DMP-1706 @SOAP_API
Scenario: POST /addCase
	When I create a case
	|courthouse         |case_number |defendants                         |judges     |prosecutors     |defenders     |
	|Harrow Crown Court |T{{seq}}001 | test defendent11~test defendent22 |test judge |test prosecutor |test defender |
	Then the API status code is 200
