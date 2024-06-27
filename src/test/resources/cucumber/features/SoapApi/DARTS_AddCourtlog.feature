Feature: Cases EndPoint using SOAP

@COURTLOG @SOAP_API @regression
Scenario Outline: SOAP courtLog where case exists
	Given I create a case
	| courthouse   | case_number  | defendants   | judges   | prosecutors   | defenders   |
	| <courthouse> | <caseNumber> | <defendants> | <judges> | <prosecutors> | <defenders> |
	 When I add courtlogs
	| courthouse   | courtroom   | case_numbers   | text                  | date       | time     |
	| <courthouse> | <courtroom> | <caseNumber>   | log details {{seq}}-1 | {{date-0}} | 10:00:01 |
	| <courthouse> | <courtroom> | <caseNumber>   | log details {{seq}}-2 | {{date-0}} | 11:00:01 |
   And I select column eve_id from table EVENT where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and event_ts = "{{date-yyyymmdd-0}} 09:00:01+00"
	Then I see table EVENT column event_text is "log details {{seq}}-1" where eve_id = "{{eve_id}}"
   And I see table EVENT column event_name is "LOG" where eve_id = "{{eve_id}}"
   And I see table EVENT column interpreter_used is "f" where eve_id = "{{eve_id}}"
   And I see table EVENT column handler is "StandardEventHandler" where eve_id = "{{eve_id}}"
   And I see table EVENT column active is "t" where eve_id = "{{eve_id}}"
   And I see table EVENT column case_closed_ts is "null" where eve_id = "{{eve_id}}"
  When I select column eve_id from table EVENT where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and event_ts = "{{date-yyyymmdd-0}} 10:00:01+00"
	Then I see table EVENT column event_text is "log details {{seq}}-2" where eve_id = "{{eve_id}}"
   And I see table EVENT column event_name is "LOG" where eve_id = "{{eve_id}}"
   And I see table EVENT column interpreter_used is "f" where eve_id = "{{eve_id}}"
   And I see table EVENT column handler is "StandardEventHandler" where eve_id = "{{eve_id}}"
   And I see table EVENT column active is "t" where eve_id = "{{eve_id}}"
   And I see table EVENT column case_closed_ts is "null" where eve_id = "{{eve_id}}"

Examples:
	| courthouse         | courtroom    | caseNumber  | defendants                        | judges     | prosecutors     | defenders     |
	| Harrow Crown Court | room {{seq}} | T{{seq}}121 | test defendent11~test defendent22 | test judge | test prosecutor | test defender |


@COURTLOG @SOAP_API @regression
Scenario Outline: SOAP courtLog where case dooes not exist and the courtlog creates the case
	 When I add courtlogs
	| courthouse   | courtroom   | case_numbers   | text                  | date       | time     |
	| <courthouse> | <courtroom> | <caseNumber>   | log details {{seq}}-1 | {{date-0}} | 10:00:01 |
	| <courthouse> | <courtroom> | <caseNumber>   | log details {{seq}}-2 | {{date-0}} | 11:00:01 |
   And I select column eve_id from table EVENT where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and event_ts = "{{date-yyyymmdd-0}} 09:00:01+00"
	Then I see table EVENT column event_text is "log details {{seq}}-1" where eve_id = "{{eve_id}}"
   And I see table EVENT column event_name is "LOG" where eve_id = "{{eve_id}}"
   And I see table EVENT column interpreter_used is "f" where eve_id = "{{eve_id}}"
   And I see table EVENT column handler is "StandardEventHandler" where eve_id = "{{eve_id}}"
   And I see table EVENT column active is "t" where eve_id = "{{eve_id}}"
   And I see table EVENT column case_closed_ts is "null" where eve_id = "{{eve_id}}"
  When I select column eve_id from table EVENT where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and event_ts = "{{date-yyyymmdd-0}} 10:00:01+00"
	Then I see table EVENT column event_text is "log details {{seq}}-2" where eve_id = "{{eve_id}}"
   And I see table EVENT column event_name is "LOG" where eve_id = "{{eve_id}}"
   And I see table EVENT column interpreter_used is "f" where eve_id = "{{eve_id}}"
   And I see table EVENT column handler is "StandardEventHandler" where eve_id = "{{eve_id}}"
   And I see table EVENT column active is "t" where eve_id = "{{eve_id}}"
   And I see table EVENT column case_closed_ts is "null" where eve_id = "{{eve_id}}"

Examples:
	| courthouse         | courtroom    | caseNumber  | defendants                        | judges     | prosecutors     | defenders     |
	| Harrow Crown Court | room {{seq}} | T{{seq}}122 | test defendent11~test defendent22 | test judge | test prosecutor | test defender |

@COURTLOG @SOAP_API @regression
Scenario: addLogEntry successful baseline
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addLogEntry and body:
	"""
<document xmlns="">
<![CDATA[<log_entry Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="11" MIN="00" S="03">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>room 9335</courtroom>
  <case_numbers>
    <case_number>T{{seq}}121</case_number>
  </case_numbers>
  <text>Log Entry {{seq}} text</text>
</log_entry>]]>
</document>
	"""
	Then the API status code is 200
	

@COURTLOG @SOAP_API @regression
Scenario: addLogEntry with invalid court fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addLogEntry and body:
	"""
<document xmlns="">
<![CDATA[<log_entry Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="11" MIN="00" S="03">
  <courthouse>No Crown Court</courthouse>
  <courtroom>room 9335</courtroom>
  <case_numbers>
    <case_number>T0000000</case_number>
  </case_numbers>
  <text>Log Entry {{seq}} text</text>
</log_entry>]]>
</document>
	"""
	Then the API status code is 404

@COURTLOG @SOAP_API @regression
Scenario: addLogEntry with authenticating from XHIBIT fails
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addLogEntry and body:
	"""
<document xmlns="">
<![CDATA[<log_entry Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="11" MIN="00" S="03">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>room 9335</courtroom>
  <case_numbers>
    <case_number>T0000000</case_number>
  </case_numbers>
  <text>Log Entry {{seq}} text</text>
</log_entry>]]>
</document>
	"""
	Then the API status code is 500
	