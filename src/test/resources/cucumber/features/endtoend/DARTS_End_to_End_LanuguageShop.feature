Feature: LANGUAGE SHOP USER

  @end2end @end2end3 @DMP-2201
  Scenario Outline: LANGUAGE SHOPE USER

    Given I authenticate from the XHIBIT source system
    Given I add a daily lists
      | messageId    | type   | subType   | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp  | defendant    |
      | <message_id> | <type> | <subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <startTime> | <endDate> | <dateTime> | <defendants> |



    Examples:
      | message_id            | courthouse         | courtroom | case_number | documentName          | type | subType | startDate  | startTime | endDate | dateTime      | defendants          |
      | DARTS_E2E_{{date+0/}} | Harrow Crown Court | {{seq}}   | S{{seq}}001 | Dailylist_{{date+0/}} | DL   | DL      | {{date-2}} |           |         | {{timestamp}} | S{{seq}} defendants |


