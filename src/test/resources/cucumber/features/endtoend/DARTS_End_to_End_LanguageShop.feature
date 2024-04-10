Feature: Language Shop User

  @end2end @end2end7 @DMP-2201
  Scenario Outline: Language Shop User
    Given I add a daily lists
      | messageId       | type      | subType      | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp   | defendant    | urn           |
      | <DL_message_id> | <DL_type> | <DL_subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <startTime> | <endDate> | <timeStamp> | <defendants> | <case_number> |
    When I process the daily list for courthouse <courthouse>

    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text | date_time   | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 10100 |          | <eventId> | <courthouse> | <courtroom> | <case_number> | <keywords> | <timeStamp> | <caseRetention>             | <totalSentence>     |

    Given I add courtlogs
      | dateTime    | courthouse   | courtroom   | case_numbers  | text       |
      | <timeStamp> | <courthouse> | <courtroom> | <case_number> | <keywords> |

    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.court_case column interpreter_used to "true" where cas_id = "{{cas_id}}"

    Given I am logged on to DARTS as an LANGUAGESHOP user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page

    Examples:
      | DL_message_id                 | DL_type | DL_subType | documentName          | courthouse         | courtroom | case_number | startDate  | startTime | endDate     | timeStamp     | defendants          | message_id | eventId     | caseRetention | totalSentence | keywords       |
      | DARTS_E2E_{{date+0/}}_{{seq}} | DL      | DL         | Dailylist_{{date+0/}} | Harrow Crown Court | {{seq}}   | S{{seq}}001 | {{date+0}} | 10:00:00  | {{date+30}} | {{timestamp}} | S{{seq}} defendants | {{seq}}001 | {{seq}}1001 |               |               | SIT LOG{{seq}} |

