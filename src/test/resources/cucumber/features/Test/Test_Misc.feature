Feature: Misc Tests

@TS001
Scenario Outline: xx
  Given courthouse "<courthouse>" exists
	And I create a case
	|courthouse|case_number     |defendants|judges|prosecutors|defenders|
	|Swansea   | <case_number> | fred	    | | | |
	And  I create an event
  |message_id| type    |sub_type|event_id |courthouse  |courtroom| case_numbers  | event_text | date_time                |
  |          | 1100    |        | missing |<courthouse>| room1   | <case_number> | my text    |  |

  Examples: 
    | courthouse     | case_number |
#    | TS001{{seq}} | |
		| Swansea        | T0005{{seq}} |
