@regression
Feature: GetCases using SOAP

@SOAP_API @GET_CASES
Scenario Outline: SOAP getCases
	* I call SOAP getCases
	| courthouse   | courtroom   | date   |
	| <courthouse> | <courtroom> | <date> |

Examples:
	| courthouse         | courtroom  | date         |
	| Harrow Crown Court | 1          | {{yyyymmdd}} |
	| Harrow Crown Court |            | {{yyyymmdd}} |
	| Harrow Crown Court | 1          | 2024-13-25   |
	



@SOAP_API @GET_CASES
Scenario: getCases successful baseline
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap body:
	"""
    <com:getCases xmlns:com="http://com.synapps.mojdarts.service.com">
      <courthouse>Harrow Crown Court</courthouse>
      <courtroom>1</courtroom>
      <date>{{yyyymmdd}}</date>
    </com:getCases>
	"""
	Then the API status code is 200
	

@SOAP_API @GET_CASES
Scenario: getCases invalid court name fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap body:
	"""
    <com:getCases xmlns:com="http://com.synapps.mojdarts.service.com">
      <courthouse>No Crown Court</courthouse>
      <courtroom>1</courtroom>
      <date>{{yyyymmdd}}</date>
    </com:getCases>
	"""
	Then the API status code is 404
	

@SOAP_API @GET_CASES
Scenario: getCases authentication from XHIBIT fails 
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap body:
	"""
    <com:getCases xmlns:com="http://com.synapps.mojdarts.service.com">
      <courthouse>Harrow Crown Court</courthouse>
      <courtroom>1</courtroom>
      <date>{{yyyymmdd}}</date>
    </com:getCases>
	"""
	Then the API status code is 500
	


@SOAP_API @GET_CASES
Scenario Outline: SOAP getCases verifying result
	Given I use caseNumber <caseNumber>
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>1"
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>2"
	  And I create a case
	| courthouse   | case_number   | defendants       | judges      | prosecutors       | defenders       |
	| <courthouse> | <caseNumber>1 | <defendantName>1 | <judgeName> | <prosecutorName>1 | <defenderName>1 |
	| <courthouse> | <caseNumber>2 | <defendantName>2 | <judgeName> | <prosecutorName>2 | <defenderName>2 |
    And I create events
  | courthouse   | courtroom   | case_numbers  | date_time              | message_id | event_id    | type   | sub_type | event_text    | case_retention_fixed_policy | case_total_sentence | text                                                                                                                                   | notes |
  | <courthouse> | <courtroom> | <caseNumber>1 | {{timestamp-12:04:00}} | {{seq}}368 | {{seq}}1368 | 10100  |          | text1 {{seq}} |               |               | Case called on  |       |
  | <courthouse> | <courtroom> | <caseNumber>2 | {{timestamp-12:05:00}} | {{seq}}369 | {{seq}}1369 | 10100  |          | text2 {{seq}} |               |               | Case called on  |       |
	When I call SOAP getCases
	| courthouse   | courtroom   | date   |
	| <courthouse> | <courtroom> | {{yyyymmdd}} |
	Then the SOAP response contains:
	"""
        <cases>
          <case>
            <case_number>{{caseNumber}}1</case_number>
            <scheduled_start>12:04</scheduled_start>
            <defendants>
              <defendant>test defendent1</defendant>
            </defendants>
            <judges>
              <judge>TEST JUDGE</judge>
            </judges>
            <prosecutors>
              <prosecutor>test prosecutor1</prosecutor>
            </prosecutors>
            <defenders>
              <defender>test defender1</defender>
            </defenders>
          </case>
          <case>
            <case_number>{{caseNumber}}2</case_number>
            <scheduled_start>12:05</scheduled_start>
            <defendants>
              <defendant>test defendent2</defendant>
            </defendants>
            <judges>
              <judge>TEST JUDGE</judge>
            </judges>
            <prosecutors>
              <prosecutor>test prosecutor2</prosecutor>
            </prosecutors>
            <defenders>
              <defender>test defender2</defender>
            </defenders>
          </case>
        </cases>
	"""

Examples:
	| courthouse         | courtroom  | caseNumber | defendantName  | judgeName  | prosecutorName  | defenderName  |
	| Harrow Crown Court | get{{seq}} | T{{seq}}62 | test defendent | test judge | test prosecutor | test defender |
	