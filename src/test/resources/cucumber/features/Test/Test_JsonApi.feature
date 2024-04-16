Feature: Portal Tests

@TS @JSON @JSON1
Scenario: test POST events
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

@TS @JSON @JSON2
Scenario: test GET cases/search
	When I authenticate as a judge user
	When I call GET cases/search API with query params:
	| case_number  | courthouse  | courtroom  | judge_name | defendant_name | date_from | date_to | event_text_contains |
	| 						 | Swansea		 | 1					|            |                |           |         |                     |
	Then the API status code is 200
	And the API response contains:
	"""
        "case_id": 141,
        "case_number": "CASE1009",
        "courthouse": "Swansea",
        "defendants": [
            "Jow Bloggs"
        ],
	"""

@TS @JSON @JSON3
Scenario: test GET cases/search
	When I call GET cases/search API with query params:
	| courthouse |
	| Leeds			 |
	Then the API status code is 400
	And the API response contains:
	"""	
	"""	


@TS @JSON @JSON4
Scenario: test POST events
  Given case "174" exists for courthouse "Leeds"
	When I call POST events API for id 18422 type 1000 1002 with "courthouse=Leeds,courtroom=ROOM1_LEEDS461,case_numbers=174,date_time=2023-06-18T08:37:30.945Z,event_text=some event text"
	

@TS @JSON @JSON5
Scenario: test GET courthouses
	When I call GET courthouses API
	Then the API status code is 200
	
@TS @JSON @JSON6
Scenario: test POST courthouses
	When I call POST courthouses API using json body:
	"""
	{
	  "courthouse_name": "Trev Test{{seq}}",
	  "code": 12{{seq}},
	  "display_name": "Trev Test display"
	}
	"""
	Then the API status code is 201
	And I find case_id in the json response at "id"

@TS @JSON @JSON6A @test
Scenario: test create a courthouse
	When I create a courthouse
	|courthouse  | code          | display_name |
	|TS{{seq}} | 1200{{seq}} | DIS{{seq}} |
	Then the API status code is 201
	And I find case_id in the json response at "id"
# following lines will fail as the value found is from the courthouse justt created	
#	When I authenticate as a judge user
#	And I call GET cases/{{case_id}} API
#	Then the API status code is 200

@TS @JSON @JSON7 @json_case
Scenario: test create a case
	When I create a case
	|courthouse|courtroom|case_number|defendants|judges|prosecutors|defenders|
	|Swansea   | 1       |T20220001 | fred	| | | |
	Then the API status code is 201
	
@TS @JSON @JSON8 @json_event
Scenario: test create an event
	When I create an event
 |message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|
 | |1100| ||Swansea|1|T{{seq}}0001|my text|2023-11-11T14:30:17.974Z|||

@TS @JSON @JSON9
Scenario: test GET cases
	When I select column cas.cas_id from table COURTCASE where case_number = "T20220001" and courthouse_name = "Swansea"
	And  I authenticate as a requester user
	And  I call GET cases/{{cas.cas_id}}/hearings API
	Then the API status code is 200

@TS @JSON @JSON10	
Scenario: POST courthouse
  Given I call POST courthouses API using json body:
  """
    {
    "courthouse_name": "automation{{seq}}",
    "code": {{seq}},
    "display_name": "Automation {{seq}}"
    }
  """

@TS @JSON @JSON11
Scenario: test GET transcriptions/transcriber-view
  Given I call GET transcriptions/transcriber-view API with header "user_id=-34" and query params "assigned=true"
	Then the API status code is 200
	And the API response contains:
	"""
    {
        "transcription_id": 4293,
        "case_id": 11217,
        "case_number": "DMP1600-case1",
        "courthouse_name": "London_DMP1600",
        "hearing_date": "2023-12-01",
        "transcription_type": "Antecedents",
        "status": "With Transcriber",
        "urgency": "Overnight",
        "requested_ts": "2023-12-06T14:48:09.311402Z",
        "state_change_ts": "2023-12-06T14:48:32.054637Z",
        "is_manual": true
    }
	"""
  
