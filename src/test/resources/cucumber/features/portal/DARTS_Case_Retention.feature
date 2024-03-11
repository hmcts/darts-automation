Feature: Case Retention

  Scenario: Create a case and the case is open
    Given I create a case using json
      | courthouse         | case_number | defendants     | judges           | prosecutors            | defenders            |
      | Harrow Crown Court | R{{seq}}001 | Def {{seq}}-28 | Judge {{seq}}-28 | testprosecutor {{seq}} | testdefender {{seq}} |
    Given I create an event using json
      | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text | date_time              |
      | {{seq}}001 | 1100 |          | {{seq}}1167 | Harrow Crown Court | {{seq}}-28 | R{{seq}}001  | {{seq}}KH1 | {{timestamp-10:00:00}} |

  @DMP-1406 @DMP-1899 @DMP-1369
    #Case is open
  Scenario Outline: Case Retention Date - Case Details, Current retention details, audit history
    Given I am logged on to DARTS as an JUDGE user
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "<case_number>"
    And I press the "Search" button
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
    And I see "Retention audit history" on the page
    And I see "No history to show" on the page

  # Close the case
    Given I create an event using json
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers  | event_text | date_time              |
      | {{seq}}001 | 30300 |          | {{seq}}1167 | Harrow Crown Court | {{seq}}-28 | <case_number> | {{seq}}KH1 | {{timestamp-10:00:00}} |

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

    #Transcriber Users @DMP-1369
    Then I Sign out

    Then I see "Sign in to the DARTS Portal" on the page
    Given I am logged on to DARTS as an TRANSCRIBER user
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I click on the "<case_number>" link
    And I do not see "Retained until" on the page

    Examples:
      | case_number |
      | R{{seq}}001 |



