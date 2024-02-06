Feature: LANGUAGE SHOP USER

  @end2end @end2end3 @DMP-2201
  Scenario Outline: LANGUAGE SHOPE USER

    Given I add daily list
      | messageId       | type      | subType      | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp  | defendant    |
      | <DL_message_id> | <DL_type> | <DL_subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <startTime> | <endDate> | <dateTime> | <defendants> |
    Given I authenticate from the XHIBIT source system
    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text     | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 10100 |          | <eventId> | <courthouse> | <courtroom> | <case_number> | Case called on | <dateTime> | <caseRetention>             | <totalSentence>     |
    Given I add courtlogs
      | dateTime   | courthouse   | courtroom   | case_numbers  | text       |
      | <dateTime> | <courthouse> | <courtroom> | <case_number> | <keywords> |
    Given I create an event
      | message_id   | type  | sub_type | event_id  | courthouse   | courtroom   | case_numbers  | event_text                  | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <message_id> | 20612 |          | <eventId> | <courthouse> | <courtroom> | <case_number> | Appeal interpreter sworn in | <dateTime> | <caseRetention>             | <totalSentence>     |

    When I am logged on to DARTS as an APPROVER user
    Then I click on the "Search" link
    Then I click on the "Advanced search" link
    Then I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants>  |

    Examples:
      | DL_message_id         | courthouse         | courtroom | case_number | documentName          | DL_type | DL_subType | startDate  | startTime | endDate     | dateTime      | defendants          | judges         | message_id | eventId     | caseRetention | totalSentence | keywords       |
      | DARTS_E2E_{{date+0/}} | Harrow Crown Court | {{seq}}   | S{{seq}}001 | Dailylist_{{date+0/}} | DL      | DL         | {{date-2}} | 10:00:00  | {{date+30}} | {{timestamp}} | S{{seq}} defendants | S{{seq}} judge | {{seq}}001 | {{seq}}1001 |               |               | SIT LOG{{seq}} |


