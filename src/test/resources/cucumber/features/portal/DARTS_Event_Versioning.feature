@DMP-4034 @DMP-4036 @regression @review
Feature: Event Versioning

Scenario Outline: Event Versioning - 3 identical events
    Identical messages may be sent by XHIBIT / CPP if a successful response is not received.
    They should all be loaded into DARTS but only the latest should be displayed in the event details screens

  Given I create a case
    | courthouse   | courtroom   | case_number  | defendants   | judges         | prosecutors         | defenders         |
    | <courthouse> | <courtroom> | <caseNumber> | Def A{{seq}} | Judge A{{seq}} | Prosecutor A{{seq}} | Defender A{{seq}} |

  Given I authenticate from the <source> source system
    And I create an event
		| message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text   | date_time            |
		| <messageId> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber>  | <eventText>  | {{timestamp-<time>}} |
		| <messageId> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber>  | <eventText>A | {{timestamp-<time>}} |
		| <messageId> | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber>  | <eventText>B | {{timestamp-<time>}} |
    And I see table EVENT column count(eve_id) is "3" where cas.case_number = "<caseNumber>" and event_id = "<eventId>" and message_id = "<messageId>"

  Given I am logged on to DARTS as a requester user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "<caseNumber>"
  And I press the "Search" button
  And I click on the "<caseNumber>" link
  And I click on the "{{displaydate}}" link
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time    | Event   | Text         |
    | *NO-CHECK* | <time>  | <event> | <eventText>B |

Examples:
		| source | messageId  | type | subType | eventId   | courthouse         | courtroom   | caseNumber  | eventText       | time     | event           |
		| XHIBIT | {{seq}}10  | 1100 |         | {{seq}}10 | Harrow Crown Court | B{{seq}}-21 | B{{seq}}021 | B{{seq}}ABC-21  | 10:11:00 | Hearing started |
		| CPP    | {{seq}}10  | 1100 |         | {{seq}}10 | Harrow Crown Court | B{{seq}}-31 | B{{seq}}031 | B{{seq}}ABC-31  | 10:21:00 | Hearing started |


Scenario Outline: Event Versioning - identical event id on 2 events
    Versioned event messages may be received from XHIBIT / CPP with the same event_id. 
    They should all be loaded into DARTS but only the latest should be displayed in the event details screens

  Given I create a case
    | courthouse   | courtroom   | case_number  | defendants   | judges         | prosecutors         | defenders         |
    | <courthouse> | <courtroom> | <caseNumber> | Def B{{seq}} | Judge B{{seq}} | Prosecutor B{{seq}} | Defender B{{seq}} |

  Given I authenticate from the <source> source system
    And I create an event
		| message_id   | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text   | date_time            |
		| <messageId>1 | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber>  | <eventText>  | {{timestamp-<time>}} |
		| <messageId>2 | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber>  | <eventText>A | {{timestamp-<time>}} |
    And I see table EVENT column count(eve_id) is "1" where cas.case_number = "<caseNumber>" and event_id = "<eventId>" and message_id = "<messageId>1"
    And I see table EVENT column count(eve_id) is "1" where cas.case_number = "<caseNumber>" and event_id = "<eventId>" and message_id = "<messageId>2"

  Given I am logged on to DARTS as a requester user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "<caseNumber>"
  And I press the "Search" button
  And I click on the "<caseNumber>" link
  And I click on the "{{displaydate}}" link
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time    | Event   | Text         |
    | *NO-CHECK* | <time>  | <event> | <eventText>A |

Examples:
		| source | messageId  | type | subType | eventId   | courthouse         | courtroom   | caseNumber  | eventText       | time     | event           |
		| XHIBIT | {{seq}}2   | 1100 |         | {{seq}}21 | Harrow Crown Court | B{{seq}}-22 | B{{seq}}022 | B{{seq}}ABC-22  | 10:12:00 | Hearing started |
		| CPP    | {{seq}}2   | 1100 |         | {{seq}}21 | Harrow Crown Court | B{{seq}}-32 | B{{seq}}032 | B{{seq}}ABC-32  | 10:22:00 | Hearing started |

Scenario Outline: Event NON-Versioning - identical MESSAGE id on 2 events
    Multiple event messages with the same message_id but different event_id will all be loaded and treated as different events

  Given I create a case
    | courthouse   | courtroom   | case_number  | defendants   | judges         | prosecutors         | defenders         |
    | <courthouse> | <courtroom> | <caseNumber> | Def B{{seq}} | Judge B{{seq}} | Prosecutor B{{seq}} | Defender B{{seq}} |

  Given I authenticate from the <source> source system
    And I create an event
		| message_id  | type   | sub_type  | event_id   | courthouse   | courtroom   | case_numbers  | event_text  | date_time            |
		| <messageId> | <type> | <subType> | <eventId>1 | <courthouse> | <courtroom> | <caseNumber>  | <eventText> | {{timestamp-<time>}} |
		| <messageId> | <type> | <subType> | <eventId>2 | <courthouse> | <courtroom> | <caseNumber>  | <eventText> | {{timestamp-<time>}} |
    And I see table EVENT column count(eve_id) is "1" where cas.case_number = "<caseNumber>" and event_id = "<eventId>1" and message_id = "<messageId>"
    And I see table EVENT column count(eve_id) is "1" where cas.case_number = "<caseNumber>" and event_id = "<eventId>2" and message_id = "<messageId>"

  Given I am logged on to DARTS as a requester user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "<caseNumber>"
  And I press the "Search" button
  And I click on the "<caseNumber>" link
  And I click on the "{{displaydate}}" link
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time    | Event   | Text        |
    | *NO-CHECK* | <time>  | <event> | <eventText> |
    | *NO-CHECK* | <time>  | <event> | <eventText> |

Examples:
		| source | messageId  | type | subType | eventId   | courthouse         | courtroom   | caseNumber  | eventText       | time     | event           |
		| XHIBIT | {{seq}}30  | 1100 |         | {{seq}}31 | Harrow Crown Court | B{{seq}}-23 | B{{seq}}023 | B{{seq}}ABC-23  | 10:13:00 | Hearing started |
		| CPP    | {{seq}}30  | 1100 |         | {{seq}}31 | Harrow Crown Court | B{{seq}}-33 | B{{seq}}033 | B{{seq}}ABC-33  | 10:23:00 | Hearing started |

