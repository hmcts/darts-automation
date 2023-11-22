Feature: Portal Tests

@TS @API_TESTx
Scenario: test events
	When I call POST events API using json body:
	"""
	{
	  "message_id": "18422",
	  "event_id": "1",
	  "type": "1000",
	  "sub_type": "1002",
	  "courthouse": "LEEDS",
	  "courtroom": "ROOM1_LEEDS461",
	  "case_numbers": [
	    "174"
	  ],
	  "date_time": "2023-06-18T08:37:30.945Z",
	  "event_text": "some event text"
	}
	"""

@TS @API_TEST
Scenario: test
	When I call GET case-hearings API with terms:
	| case_number  | courthouse  | courtroom  | judge_name | defendant_name | date_from | date_to | event_text_contains |
	| 						 | Swansea		 | 1						|            |                |           |         |                     |


@TS @API_TEST1
Scenario: test
	When I call GET case-hearings API with terms:
	| courthouse |
	| Leeds			 |

@TS @API_TEST1
Scenario: test event
  Given case "174" exists for courthouse "Leeds"
	When I call POST events API for id 18422 type 1000 1002 with "courthouse=Leeds,courtroom=ROOM1_LEEDS461,case_numbers=174,date_time=2023-06-18T08:37:30.945Z,event_text=some event text"
	

@TS @API_TESTx
Scenario: test GET courthouses
	When I call GET courthouses API
	
@TS @API_TESTx
Scenario: test POST courthouses
	When I call POST courthouses API using json body:
	"""
	{
	  "courthouse_name": "Trev Test",
	  "code": 1
	}
	"""
@case
Scenario: test create a case
	When I create a case
	|courthouse|case_number|defendants|judges|prosecutors|defenders|
	|Swansea   | T20220001 | fred	| | | |
	
@event
Scenario: test create an event
	When I create an event
 |message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|
 | |1100| ||Swansea|1|T20220001|my text|2023-08-11T14:30:17.974Z|||

