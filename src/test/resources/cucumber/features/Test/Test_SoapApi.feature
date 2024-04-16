Feature: Portal Tests

@TS @SOAP @SOAP1
Scenario: test 1 getCourtlog
  When I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap body:
	"""
        <getCourtLog xmlns="http://com.synapps.mojdarts.service.com">
            <courthouse xmlns="">DMP-467-LIVERPOOL</courthouse>
            <caseNumber xmlns="">DMP-467-Case001</caseNumber>
            <startTime xmlns="">20230811160000</startTime>
            <endTime xmlns="">20230930170000</endTime>
        </getCourtLog>
	"""
	Then the API status code is 200
	And the API response contains:
	"""
        <court_log case_number="DMP-467-Case001" courthouse="DMP-467-LIVERPOOL">
          <entry D="11" H="17" M="8" MIN="49" S="3" Y="2023">DMP-467-Case001 some event text here</entry>
          <entry D="11" H="16" M="8" MIN="52" S="25" Y="2023">DMP-467-Case001 some event text here</entry>
          <entry D="11" H="18" M="8" MIN="10" S="27" Y="2023">DMP-467-Case001 some event text here</entry>
          <entry D="11" H="17" M="8" MIN="11" S="40" Y="2023">DMP-467-Case001 some event text here</entry>
          <entry D="11" H="17" M="8" MIN="22" S="8" Y="2023">DMP-467-Case001 some event text here</entry>
        </court_log>
	"""

@TS @SOAP @SOAP1B
Scenario: test 1B getCourtlog
  When I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap body:
	"""
        <getCourtLog xmlns="http://com.synapps.mojdarts.service.com">
            <courthouse xmlns="">{{courthouse1}}</courthouse>
            <caseNumber xmlns="">T1012002</caseNumber>
            <startTime xmlns="">20220311091900</startTime>
            <endTime xmlns="">20240311092000</endTime>
        </getCourtLog>
	"""
	Then the API status code is 200
	And the API response contains:
	"""
        <court_log case_number="T1012002" courthouse="Harrow Crown Court">
          <entry D="3" H="9" M="1" MIN="19" S="0" Y="2024">text 1012</entry>
        </court_log>
	"""
	
@TS @SOAP @SOAP1B
Scenario: test 1B getCourtlog
 When I get courtlogs
 | courthouse     | case_number | startDate  | startTime | endDateTime   |
 | {{courthouse1}} | T1012002    | 2022-03-11 | 09:19:00  | {{timestamp}} |

@TS @SOAP @SOAP2
Scenario: test 2 addCase
  When I authenticate from the VIQ source system
	When I call POST SOAP API using SOAPAction addCase and encoded body:
	"""
        <case type="" id="T20230000{{seq}}">
            <courthouse>DMP-723-LIVERPOOL</courthouse>
            <defendants>
                <defendant>DMP-723-AC1-D001</defendant>
                <defendant>DMP-723-AC1-D002</defendant>
            </defendants>
            <judges>
                <judge>DMP-723-AC1-J001</judge>
            </judges>
            <prosecutors>
                <prosecutor>DMP-723-AC1-P001</prosecutor>
            </prosecutors>
        </case>
	"""
	Then the API status code is 200
	And the API response contains:
	"""
	<message>OK</message>
	"""
	
@TS @SOAP @SOAP2A
Scenario: test 2A addCase
  When I authenticate from the VIQ source system
	When I call POST SOAP API using SOAPAction addCase and encoded body:
	"""
        <case type="1000" id="T20230002{{seq}}">
            <courthouse>Newcastle</courthouse>
            <defenders>
                <defender>DMP464-D003</defender> 
            </defenders>
        </case>
	"""	
	Then the API status code is 200
	And the API response contains:
	"""
	<message>OK</message>
	"""

@TS @SOAP @SOAP2B
Scenario: test 2B create a case 
  #When I authenticate from the VIQ source system
	When I create a case
	|courthouse|case_number|defendants|judges|prosecutors|defenders|
	|Swansea   | T20220002 | fred	| | | |

@TS @SOAP @SOAP4
Scenario: test 4 addLogEntry
  When I authenticate from the VIQ source system
	When I call POST SOAP API using SOAPAction addLogEntry and encoded body:
	"""
                <log_entry Y="2024" M="03" D="11" H="08" MIN="30" S="01">
                        <courthouse>DMP-467-LIVERPOOL</courthouse>
                        <courtroom>DMP-467-LIVERPOOL-ROOM_A</courtroom>
                        <case_numbers>
                            <case_number>DMP-467-Case011</case_number>
                        </case_numbers>
                        <text>abcdefgh1234567890abcdefgh1234567890abcdefgh1234567890abcdefgh12</text>
                </log_entry>
	"""
	Then the API status code is 201
	And the API response contains:
	"""
	<message>CREATED</message>
	"""

@TS @SOAP @SOAP4A
Scenario: test 4A addLogEntry
  #When I authenticate from the VIQ source system
  When I add courtlogs
  | courthouse | courtroom | case_numbers | text     | dateTime      |
  | Swansea    | 1         | T20220001    | log text | {{timestamp}} |

@TS @SOAP @SOAP5
Scenario: test 5 add event
 #Given I authenticate from the XHIBIT source system 
 When I create an event
 |message_id  | type  | sub_type | event_id    | courthouse      | courtroom    | case_numbers | event_text  | date_time              | case_retention_fixed_policy|case_total_sentence|
 | 18424      | 1000  | 1001     | 1           | Swansea         | 1            | T20220001    | my text     | 2024-03-12T09:00:01Z   |                            |                   |	
 | {{seq}}001 | 1000  | 1001     | {{seq}}1001 | {{courthouse1}} | Room {{seq}} | T{{seq}}001  | text {{seq}}| {{timestamp-10:00:00}} |                            |                 0 |	
 | {{seq}}002 | 20101 |          | {{seq}}1002 | {{courthouse1}} | Room {{seq}} | T{{seq}}002  | text {{seq}}| {{timestamp-10:00:10}} |                            |                 0 |
# | 18424    |40750|11504   | 45     |Swansea   |1        |T20220001   |my text   |2024-03-12T08:30:17Z    |4                          |26Y0M0D            |

	
@TS @SOAP @SOAP6
Scenario: test 6 addAudio
 * I load an audio file
 | courthouse      | courtroom | case_numbers | date       | startTime | endTime  | audioFile |
 | {{courthouse1}} | Room 1012 | T1012002     | 2022-03-11 | 08:30:00  | 08:31:00 | sample1   |
 
 	
