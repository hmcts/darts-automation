Feature: Test operation of post events

  @EVENT_API @EVENT1 @JSON_API
  Scenario Outline: Create a case and hearing via events
    Given that courthouse "<courthouse>" case "<case_number>" does not exist
    When I create a case using json
      | courthouse   | case_number   | defendants    | judges     | prosecutors     | defenders     |
      | <courthouse> | <case_number> | defendant one | test judge | test prosecutor | test defender |
    And  I create an event using json
      | message_id  | type   | sub_type | event_id    | courthouse   | courtroom   | case_numbers  | event_text             | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time |
      | 0001{{seq}} | 407131 |          | 1004{{seq}} | <courthouse> | <courtroom> | <case_number> | 407131                 | {{timestamp-09:03:00}} |                             |                     | {{timestamp-09:03:01}} |          |
      | 0001{{seq}} | 20901  |          | 1004{{seq}} | <courthouse> | <courtroom> | <case_number> | 20901                  | {{timestamp-09:04:00}} |                             |                     | {{timestamp-09:04:01}} |          |
      | 0002{{seq}} | 1100   |          | 1002{{seq}} | <courthouse> | <courtroom> | <case_number> | Hearing Started{{seq}} | {{timestamp-09:05:01}} |                             |                     | {{timestamp-09:06:40}} |          |
      | 0003{{seq}} | 1000   | 1001     | 1003{{seq}} | <courthouse> | <courtroom> | <case_number> | 1000-1001{{seq}}       | {{timestamp-09:07:00}} |                             |                     | {{timestamp-09:07:01}} |          |
      | 0004{{seq}} | 1400   |          | 1004{{seq}} | <courthouse> | <courtroom> | <case_number> | 1400                   | {{timestamp-09:08:00}} |                             |                     | {{timestamp-09:08:01}} |          |
    Then I see table COURTCASE column interpreter_used is "f" where case_number = "<case_number>" and courthouse_name = "<courthouse>"
    When I create an event using json
      | message_id  | type | sub_type | event_id    | courthouse   | courtroom   | case_numbers  | event_text                   | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time |
      | 0005{{seq}} | 2917 | 3979     | 1005{{seq}} | <courthouse> | <courtroom> | <case_number> | Interpreter sworn-in {{seq}} | {{timestamp-09:09:00}} |                             |                     | {{timestamp-09:09:01}} |          |
    Then I see table COURTCASE column interpreter_used is "t" where case_number = "<case_number>" and courthouse_name = "<courthouse>"
    When I create an event using json
      | message_id  | type  | sub_type | event_id    | courthouse   | courtroom   | case_numbers  | event_text                 | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time               |
      | 0006{{seq}} | 2198  | 3933     | 1006{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:10:00}} |                             |                     | {{timestamp-09:10:01}} |                        |

      | 0007{{seq}} | 40790 |          | 1007{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:11:00}} |                             |                     | {{timestamp-09:11:01}} |                        |
      | 0008{{seq}} | 2198  | 3933     | 1008{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:12:00}} |                             |                     | {{timestamp-09:12:01}} | {{timestamp-09:12:59}} |
      | 0009{{seq}} | 21200 | 11000    | 1009{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:13:00}} |                             |                     | {{timestamp-09:13:01}} | {{timestamp-09:13:59}} |
      | 0010{{seq}} | 40735 |          | 1010{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:14:00}} |                             | 1                   | {{timestamp-09:14:01}} | {{timestamp-09:14:59}} |
      | 0011{{seq}} | 2198  | 3934     | 1011{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:15:00}} |                             | sentencing          | {{timestamp-09:15:01}} | {{timestamp-09:15:59}} |
      | 0012{{seq}} | 40750 | 11505    | 1012{{seq}} | <courthouse> | <courtroom> | <case_number> | [Defendant: DEFENDANT ONE] | {{timestamp-09:16:00}} | 4                           | 26Y0M0D             | {{timestamp-09:16:01}} | {{timestamp-09:16:59}} |
      | 0013{{seq}} | 3010  |          | 1013{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:17:00}} |                             |                     | {{timestamp-09:17:01}} | {{timestamp-09:17:59}} |
      | 0014{{seq}} | 21201 |          | 1014{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:18:00}} |                             |                     | {{timestamp-09:18:01}} | {{timestamp-09:18:59}} |
      | 0015{{seq}} | LOG   |          | 1015{{seq}} | <courthouse> | <courtroom> | <case_number> | text {{seq}}               | {{timestamp-09:19:00}} |                             |                     | {{timestamp-09:19:01}} | {{timestamp-09:19:59}} |

    Examples:
      | courthouse         | case_number | courtroom    | HearingDate     | StartTime              | EndTime                |
      | Harrow Crown Court | T{{seq}}002 | Room {{seq}} | {{displaydate}} | {{timestamp-12:06:40}} | {{timestamp-12:06:40}} |


  @EVENT_API @EVENT1A @JSON_API
  Scenario Outline: Create a case and hearing via events
    Given that courthouse "<courthouse>" case "<case_number>" does not exist
    When I create an event using json
      | message_id  | type  | sub_type | event_id    | courthouse   | courtroom   | case_numbers  | event_text                 | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time               |
      | 0012{{seq}} | 40750 | 11505    | 1012{{seq}} | <courthouse> | <courtroom> | <case_number> | [Defendant: DEFENDANT ONE] | {{timestamp-09:16:00}} | 4                           | 26Y0M0D             | {{timestamp-09:16:01}} | {{timestamp-09:16:59}} |

    Examples:
      | courthouse         | case_number | courtroom    | HearingDate     | StartTime              | EndTime                |
      | Harrow Crown Court | T{{seq}}003 | Room {{seq}} | {{displaydate}} | {{timestamp-12:06:40}} | {{timestamp-12:06:40}} |


  @EVENT_API @EVENT2 @JSON_API
  Scenario Outline: Create a case and hearing via events
    Given that courthouse "<courthouse>" case "<case_number>" does not exist
    When I create a case using json
      | courthouse   | case_number   | defendants    | judges     | prosecutors     | defenders     |
      | <courthouse> | <case_number> | defendant one | test judge | test prosecutor | test defender |
    And  I create an event using json
      | message_id | type   | sub_type | event_id   | courthouse   | courtroom   | case_numbers  | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time |
      | 102{{seq}} | 407131 |          | 102{{seq}} | <courthouse> | <courtroom> | <case_number> | 407131{{seq}} | {{timestamp-09:05:01}} |                             |                     | {{timestamp-09:06:40}} |          |
#      | 103{{seq}} | 1000 | 1001     | 103{{seq}} | <courthouse> | <courtroom> | <case_number> | 1000-1001{{seq}}       | {{timestamp-09:07:00}} |                             |                     | {{timestamp-09:07:01}} |      |
#      | 104{{seq}} | 1400 |          | 104{{seq}} | <courthouse> | <courtroom> | <case_number> | 1400                   | {{timestamp-09:08:00}} |                             |                     | {{timestamp-09:08:01}} |      |
#    Then I see table COURTCASE column interpreter_used is "f" where case_number = "<case_number>" and courthouse_name = "<courthouse>"
#    When I create an event using json
#      | message_id  | type | sub_type | event_id    | courthouse   | courtroom   | case_numbers  | event_text             | date_time              | case_retention_fixed_policy | case_total_sentence | start_time             | end_time      |
#      | 105{{seq}} | 2917 | 3979     | 105{{seq}} | <courthouse> | <courtroom> | <case_number> | Interpreter sworn-in {{seq}} | {{timestamp-09:09:00}} |                             |                     | {{timestamp-09:09:01}} |      |
#    Then I see table COURTCASE column interpreter_used is "t" where case_number = "<case_number>" and courthouse_name = "<courthouse>"

    Examples:
      | courthouse         | case_number | courtroom    | HearingDate     | StartTime              | EndTime                |
      | Harrow Crown Court | T{{seq}}003 | Rayners room | {{displaydate}} | {{timestamp-12:06:40}} | {{timestamp-12:06:40}} |
