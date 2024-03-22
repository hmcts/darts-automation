Feature: Case Retention

  @DMP-1369 @DMP-1406 @DMP-1413 @DMP-1899 @regression
  Scenario: Case retention data creation
    Given I create a case using json
      | courthouse         | case_number | defendants     | judges           | prosecutors            | defenders            |
      | Harrow Crown Court | R{{seq}}001 | Def {{seq}}-28 | Judge {{seq}}-28 | testprosecutor {{seq}} | testdefender {{seq}} |
      | Harrow Crown Court | R{{seq}}002 | Def {{seq}}-29 | Judge {{seq}}-29 | testprosecutor {{seq}} | testdefender {{seq}} |
    Given I create an event using json
      | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              |
      | {{seq}}001 | 1100 |          | {{seq}}1167 | Harrow Crown Court | {{seq}}-28 | R{{seq}}001  | {{seq}}KH1    | {{timestamp-10:00:00}} |
      | {{seq}}001 | 1100 |          | {{seq}}1168 | Harrow Crown Court | {{seq}}-29 | R{{seq}}002  | {{seq}}ABC-29 | {{timestamp-10:00:00}} |

  @DMP-1406 @DMP-1899 @DMP-1369 @DMP-2161 @regression
  Scenario Outline: Case Retention Date - Case Details, Current retention details, audit history
    #Case is open
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

    #DMP-2161-AC5 Permanent retention
    Then I Sign out
    Then I see "Sign in to the DARTS Portal" on the page
    Given I am logged on to DARTS as an Judge user
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    Then I see "Default" on the page
    And I click on the "Change retention date" link
    And I click on the "Retain permanently (99 years)" link
    And I set "Why are you making this change?" to "AC5 99 Years Permanent Retention"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "<case_number>" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def {{seq}}-28" in the same row as "Defendant(s)"
    And I see "Change case retention date" on the page
    And I see "{{displaydate(date+99years)}} (Permanent)" in the same row as "Retain case until"
    And I see "AC5 99 Years Permanent Retention" in the same row as "Reason for change"
    And I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate(date+99years)}}" in the same row as "Retain case until"

    #DMP-2161-AC4 Valid specific date
    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2035"
    And I set "Why are you making this change?" to "AC4"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "01 Nov 2035" on the page
    And I click on the "Confirm retention date change" link
    And I see "Case retention date changed." on the page
    And I see "Case retention date" on the page

    #DMP-1450-AC3 Mandtory reason field
    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2032"
    And I set "Why are you making this change?" to ""
    And I click on the "Continue" link
    Then I see "Change case retention date" on the page
    And I see "You must explain why you are making this change" on the page
    And I see "Why are you making this change?" on the page
    And I see "You must explain why you are making this change" on the page
    And I click on the "Cancel" link

    #DMP-2161-AC1 Max retention exceeded
    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/01/2136"
    And I set "Why are you making this change?" to "AC1"
    And I click on the "Continue" link
    Then I see "Change case retention date" on the page
    And I see an error message "You cannot retain a case for more than 99 years after the case closed"

    #DMP-2161-AC3 ,DMP-1450-AC2 Retention date too early
    And I click on the "Cancel" link
    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2024"
    And I set "Why are you making this change?" to "AC3"
    And I click on the "Continue" link
    Then I see "Change case retention date" on the page
    And I see "You cannot set retention date earlier than {{date+2556/}}" on the page
    And I see "Enter a date to retain the case until" on the page
    And I see "You cannot set retention date earlier than {{date+2556/}}" on the page
    And I click on the "Cancel" link

    # DMP-2161-AC2 DMP-1450-AC1 Sign in as a Requester
    Then I Sign out
    Then I see "Sign in to the DARTS Portal" on the page
    Given I am logged on to DARTS as an REQUESTER user
    When I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    Then I see "Default" on the page
    And I click on the "Change retention date" link
    And  I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2023"
    And I set "Why are you making this change?" to "AC2"
    And I click on the "Continue" link
    And I see "Change case retention date" on the page
    Then I see an error message "You do not have permission to reduce the current retention date."
    Then I see an error message "Please refer to the DARTS retention policy guidance."

    Examples:
      | case_number |
      | R{{seq}}001 |

@DMP-1413 @regression
Scenario: Change Retention Date by increasing it with specific date
  Given I am logged on to DARTS as an JUDGE user
  When I click on the "Search" link
  And I set "Case ID" to "R{{seq}}002"
  And I press the "Search" button
  And I click on the "R{{seq}}002" link
  And I see "No date applied" on the page
  And I click on the "View or change" link
  And I see "This case is still open or was recently closed." on the page
  And I see "R{{seq}}002" on the page
  And I see "A retention policy has yet to be applied to this case." on the page
  And I see "No history to show" on the page

  #Close case
  When I create an event using json
    | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              |
    | {{seq}}001 | 30300 |          | {{seq}}1168 | Harrow Crown Court | {{seq}}-29 | R{{seq}}002  | {{seq}}ABC-29 | {{timestamp-10:00:00}} |

  Then I click on the breadcrumb link "R{{seq}}002"
  And I see "No date applied" on the page
  And I select column cas_id from table darts.court_case where case_number = "R{{seq}}002"
  And I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"
  And I click on the "View or change" link
  And I see "R{{seq}}002" in the same row as "Case ID"
  And I see "A retention policy has yet to be applied to this case." on the page
  Then I verify the HTML table "Retention audit history" contains the following values
    | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status   |
    | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Default          |          | COMPLETE |

  #Increasing retention date, specific date
  When I press the "Change retention date" button
  And I see "Change case retention date" on the page
  #DMP-1413-AC7 Cancel link
  And I click on the "Cancel" link
  Then I do not see "Change case retention date" on the page
  And I see "Current retention details" on the page

  #DMP-1413-AC1 Add specific retention data
  When I press the "Change retention date" button
  And I select the "Retain until a specific date" radio button
  And I see "Use dd/mm/yyyy format. For example, 31/01/2023." on the page
  And I set "Enter a date to retain the case until" to "{{date+3285/}}"

  #DMP-1413-AC4 and #DMP-1413-AC5 Free text reason
  When I see "You have 200 characters remaining" on the page
  And I set "Why are you making this change?" to "This is my reason for increasing the retention date"
  And I see "You have 149 characters remaining" on the page
  #DMP-1413-AC6 Continue button, next screen
  And I press the "Continue" button
  Then I see "Check retention date change" on the page
  And I see "R{{seq}}002" in the same row as "Case ID"
  And I see "Harrow Crown Court" in the same row as "Courthouse"
  And I see "Def {{seq}}-29" in the same row as "Defendant(s)"
  And I see "This is my reason for increasing the retention date" in the same row as "Reason for change"

  When I press the "Confirm retention date change" button
  Then I see "Case retention date changed." on the page
  And I see "{{displaydate}}" in the same row as "Date applied"
  Then I verify the HTML table "Retention audit history" contains the following values
    | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
    | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Default          |                                                     | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |

  #DMP-1413-AC3 Reducing retention date, specific date

  When I press the "Change retention date" button
  And I select the "Retain until a specific date" radio button
  And I set "Enter a date to retain the case until" to "{{date+2920/}}"

  And I set "Why are you making this change?" to "Reason for reducing retention date by one year"
  And I see "You have 154 characters remaining" on the page
  And I press the "Continue" button
  Then I see "Check retention date change" on the page
  And I see "R{{seq}}002" in the same row as "Case ID"
  And I see "Harrow Crown Court" in the same row as "Courthouse"
  And I see "Def {{seq}}-29" in the same row as "Defendant(s)"
  And I see "Reason for reducing retention date by one year" in the same row as "Reason for change"

  When I press the "Confirm retention date change" button
  Then I see "Case retention date changed." on the page
  And I see "{{displaydate}}" in the same row as "Date applied"
  Then I verify the HTML table "Retention audit history" contains the following values
    | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
    | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Default          |                                                     | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | Reason for reducing retention date by one year      | COMPLETE |

  #DMP-1413-AC2 Mark for permanent retention

  When I press the "Change retention date" button
  And I select the "Retain permanently (99 years)" radio button
  And I set "Why are you making this change?" to "Reason for retaining this case permanently"
  And I see "You have 158 characters remaining" on the page
  And I press the "Continue" button
  Then I see "Check retention date change" on the page
  And I see "R{{seq}}002" in the same row as "Case ID"
  And I see "Harrow Crown Court" in the same row as "Courthouse"
  And I see "Def {{seq}}-29" in the same row as "Defendant(s)"
  And I see "(Permanent)" on the page
  And I see "Reason for retaining this case permanently" in the same row as "Reason for change"

  When I press the "Confirm retention date change" button
  Then I see "Case retention date changed." on the page
  And I see "{{displaydate}}" in the same row as "Date applied"
  And I see "DARTS Permanent Policy" in the same row as "DARTS Retention policy applied"
  Then I verify the HTML table "Retention audit history" contains the following values
    | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
    | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Default          |                                                     | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | Reason for reducing retention date by one year      | COMPLETE |
    | *NO-CHECK*             | *NO-CHECK*     | global_judge | Permanent        | Reason for retaining this case permanently          | COMPLETE |