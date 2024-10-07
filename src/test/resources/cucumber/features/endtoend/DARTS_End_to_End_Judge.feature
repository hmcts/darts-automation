Feature: Judge

  @end2end @end2end5 @DMP-2200
    @reads-and-writes-system-properties @HearingDate0Prefix
  Scenario Outline: Judge
    #Given I create a case
     # | courthouse   | |case_number   | defendants   | judges   | prosecutors   | defenders   |
      #| <courthouse> | |<case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Given that courthouse "<courthouse>" case "<case_number>" does not exist
    Given I wait until there is not a daily list waiting for "<courthouse>"
    Given I add a daily lists
      | messageId       | type      | subType      | documentName   | courthouse   | courtroom   | caseNumber    | startDate   | startTime   | endDate   | timeStamp   | defendant    | urn           |
      | <DL_message_id> | <DL_type> | <DL_subType> | <documentName> | <courthouse> | <courtroom> | <case_number> | <startDate> | <startTime> | <endDate> | <timeStamp> | <defendants> | <case_number> |
    When I process the daily list for courthouse "<courthouse>"
    And I wait for case "<case_number>" courthouse "<courthouse>"
    Given I create an event
      | message_id | type | sub_type | event_id   | courthouse   | courtroom   | case_numbers  | event_text                    | date_time              | case_retention_fixed_policy | case_total_sentence | start_time    | end_time      | is_mid_tier |
      | {{seq}}001 | 1100 |          | {{seq}}167 | <courthouse> | <courtroom> | <case_number> | Reporting Restriction {{seq}} | {{timestamp-10:00:00}} | <caseRetention>             | <totalSentence>     | {{timestamp}} | {{timestamp}} | true        |

    Given I am logged on to DARTS as an JUDGE user
    Then I set "Case ID" to "<case_number>"
    Then I press the "Search" button
    Then I see "1 result" on the page
    Then I see "<case_number>" in the same row as "<courthouse>"
    When I click on "<case_number>" in the same row as "<courthouse>"
    Then I see "<case_number>" on the page
    Then I click on "<HearingDate>" in the same row as "<courtroom>"
    # Upload annotation
    And I click on the "Annotations" link
    And I press the "Upload annotation" button
    Then I upload the file "<annotation_document>" at "Upload annotation file"
    And I press the "Upload" button
    Then I see "You have added an annotation" on the page
    Then I click on the "Return to case level" link

    #Judge to view documents uploaded by themselves
    Then I click on the "All annotations" link
    Then I verify the HTML table "All annotations" contains the following values
      | Hearing date  | File name             | Format        | Date created  | Comments |
      | <HearingDate> | <annotation_document> | Word Document | <HearingDate> |          |

    Then I click on the "View or change" link
    Then I see "This case is still open or was recently closed." on the page
    Then I see "A retention policy has yet to be applied to this case." on the page

    # Close the case
    Given I create an event
      | message_id | type  | sub_type | event_id   | courthouse         | courtroom  | case_numbers  | event_text | date_time              |
      | {{seq}}001 | 30300 |          | {{seq}}167 | Harrow Crown Court | {{seq}}-28 | <case_number> | {{seq}}KH1 | {{timestamp-10:00:00}} |

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link
    And I see "Retained until" on the page
    And I see "No date applied" on the page
    And I click on the "View or change" link
    And I see "This case is still open or was recently closed." on the page
    And I see "The retention date for this case cannot be changed while the case is open or while a retention policy is currently pending." on the page
    And I see "Case retention date" on the page
    And I see "Case details" on the page
    And I see "<case_number>" on the page
    And I see "Current retention details" on the page
    And I see "A retention policy has yet to be applied to this case." on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status  |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Default          |          | PENDING |

    # 7 days Past Case Close Event
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    And I see "Change retention date" on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Default          |          | COMPLETE |

    Then I press the "Change retention date" button
    And I click on the "Retain permanently (99 years)" link
    And I set "Why are you making this change?" to "99 Years Permanent Retention for <case_number>"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "<case_number>" in the same row as "Case ID"
    And I see "<courthouse>" in the same row as "Courthouse"
    And I see "Change case retention date" on the page
    And I see "{{displaydate(date+99years)}} (Permanent)" in the same row as "Retain case until"
    And I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate(date+99years)}}" in the same row as "Retain case until"

    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "{{date+7years/}}"
    And I set "Why are you making this change?" to "Change Retention for {{seq}}"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "{{displaydate(date+7years)}}" on the page
    And I click on the "Confirm retention date change" link
    And I see "Case retention date changed." on the page
    And I see "Case retention date" on the page
    Then I click on the breadcrumb link "<case_number>"
    And I see "{{displaydate(date+7years)}}" on the page


    Examples:
      | DL_message_id                 | DL_type | DL_subType | documentName          | courthouse      | courtroom   | HearingDate     | case_number      | startDate  | endDate     | timeStamp     | judges              | defendants              | prosecutors           | defenders           | message_id | eventId     | caseRetention | totalSentence | audioFile | startTime | endTime  | annotation_document |
      | DARTS_E2E_{{date+0/}}_{{seq}} | DL      | DL         | Dailylist_{{date+0/}} | {{courthouse1}} | C{{seq}}-88 | {{displaydate}} | S{{seq}}088-B088 | {{date+0}} | {{date+30}} | {{timestamp}} | S{{seq}} judge-B088 | S{{seq}} defendant-B088 | S{{seq}} prosecutor-B | S{{seq}} defender-B | {{seq}}001 | {{seq}}1001 |               |               | sample1   | 08:04:00  | 08:05:00 | Annotations.docx    |