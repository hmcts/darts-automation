@ts6
Feature: Case Retention

  @DMP-1369 @DMP-1406 @DMP-1413 @DMP-1899 @regression
  Scenario: Case retention data creation
    Given I create a case
      | courthouse         | courtroom  | case_number | defendants     | judges           | prosecutors               | defenders               |
      | Harrow Crown Court | {{seq}}-30 | R{{seq}}EF1 | Def {{seq}}-30 | Judge {{seq}}-30 | testprosecutor {{seq}}-30 | testdefender {{seq}}-30 |
      | Harrow Crown Court | {{seq}}-31 | R{{seq}}GH1 | Def {{seq}}-31 | Judge {{seq}}-31 | testprosecutor {{seq}}-31 | testdefender {{seq}}-31 |
      | Harrow Crown Court | {{seq}}-32 | R{{seq}}IJ1 | Def {{seq}}-32 | Judge {{seq}}-32 | testprosecutor {{seq}}-32 | testdefender {{seq}}-32 |
      | Harrow Crown Court | {{seq}}-33 | R{{seq}}KL1 | Def {{seq}}-33 | Judge {{seq}}-33 | testprosecutor {{seq}}-33 | testdefender {{seq}}-33 |
      | Harrow Crown Court | {{seq}}-34 | R{{seq}}MN1 | Def {{seq}}-34 | Judge {{seq}}-34 | testprosecutor {{seq}}-34 | testdefender {{seq}}-34 |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              |
      | {{seq}}001 | 1100 |          | {{seq}}1169 | Harrow Crown Court | {{seq}}-30 | R{{seq}}EF1  | {{seq}}ABC-30 | {{timestamp-10:02:00}} |
      | {{seq}}001 | 1100 |          | {{seq}}1170 | Harrow Crown Court | {{seq}}-31 | R{{seq}}GH1  | {{seq}}ABC-31 | {{timestamp-10:03:00}} |
      | {{seq}}001 | 1100 |          | {{seq}}1171 | Harrow Crown Court | {{seq}}-32 | R{{seq}}IJ1  | {{seq}}ABC-32 | {{timestamp-10:04:00}} |
      | {{seq}}001 | 1100 |          | {{seq}}1172 | Harrow Crown Court | {{seq}}-33 | R{{seq}}KL1  | {{seq}}ABC-33 | {{timestamp-10:05:00}} |
      | {{seq}}001 | 1100 |          | {{seq}}1173 | Harrow Crown Court | {{seq}}-34 | R{{seq}}MN1  | {{seq}}ABC-34 | {{timestamp-10:06:00}} |

  @DMP-1406 @DMP-1899 @DMP-1369 @DMP-2161 @DMP-1437 @DMP-1439 @regression
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
    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom   | case_numbers  | event_text        | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}005 | 30300 |          | {{seq}}1177 | Harrow Crown Court | <courtroom> | <case_number> | Close case{{seq}} | {{timestamp-11:00:00}} | <caseRetention>             | <totalSentence>     |

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
      | Date retention changed | Retention date          | Amended by | Retention policy        | Comments | Status  |
      | *NO-CHECK*             | <display_retentiondate> | *NO-CHECK* | <retention_displayname> |          | PENDING |

    # 7 days Past Case Close Event
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    And I see "Change retention date" on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date          | Amended by | Retention policy        | Comments | Status   |
      | *NO-CHECK*             | <display_retentiondate> | *NO-CHECK* | <retention_displayname> |          | COMPLETE |

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
    Then I see "<retention_displayname>" on the page
    And I click on the "Change retention date" link
    And I click on the "Retain permanently (99 years)" link
    And I set "Why are you making this change?" to "AC5 99 Years Permanent Retention"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "<case_number>" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Change case retention date" on the page
    And I see "{{displaydate0{{date+99years}}}} (Permanent)" in the same row as "Retain case until"
    And I see "AC5 99 Years Permanent Retention" in the same row as "Reason for change"
    And I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate0{{date+99years}}}}" in the same row as "Retain case until"

    #DMP-2161-AC4 Valid specific date
    And I click on the "Change retention date" link
    And I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2035"
    And I set "Why are you making this change?" to "AC4"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
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
    And I see "You cannot set retention date earlier than " on the page
    And I see "Enter a date to retain the case until" on the page
    And I see "You cannot set retention date earlier than " on the page
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
    Then I see "<retention_displayname>" on the page
    And I click on the "Change retention date" link
    And  I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2023"
    And I set "Why are you making this change?" to "AC2"
    And I click on the "Continue" link
    And I see "Change case retention date" on the page
    Then I see an error message "You do not have permission to reduce the current retention date."
    Then I see an error message "Please refer to the DARTS retention policy guidance."
    Then I click on the "Cancel" link
    And I see "Case retention date" on the page

    Examples:
      | case_number | caseRetention | totalSentence | retention_displayname | display_retentiondate             | courtroom  | ref |
      | R{{seq}}EF1 | 1             | 1Y0M0D        | Not Guilty            | {{displayDate-{{date+1 years}}}}  | {{seq}}-30 | 30  |
      | R{{seq}}GH1 | 2             | 7Y0M0D        | Non Custodial         | {{displayDate-{{date+7 years}}}}  | {{seq}}-31 | 31  |
      | R{{seq}}IJ1 | 3             | 3Y0M0D        | Custodial             | {{displayDate-{{date+7 years}}}}  | {{seq}}-32 | 32  |
      | R{{seq}}KL1 | 3             | 8Y0M0D        | Custodial             | {{displayDate-{{date+8 years}}}}  | {{seq}}-33 | 33  |

  @DMP-1406 @DMP-1899 @DMP-1369 @DMP-2161 @DMP-1437 @DMP-1439 @regression
  Scenario Outline: Case Retention Date - Case Details, Current retention details, audit history LIFE SENTENCE
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
    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom   | case_numbers  | event_text        | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}005 | 30300 |          | {{seq}}1177 | Harrow Crown Court | <courtroom> | <case_number> | Close case{{seq}} | {{timestamp-11:00:00}} | <caseRetention>             | <totalSentence>     |

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
      | Date retention changed | Retention date          | Amended by | Retention policy        | Comments | Status  |
      | *NO-CHECK*             | <display_retentiondate> | *NO-CHECK* | <retention_displayname> |          | PENDING |

    # 7 days Past Case Close Event
    Then I select column cas_id from table darts.court_case where case_number = "<case_number>"
    Then I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    Then I click on the breadcrumb link "<case_number>"
    And I click on the "<case_number>" link
    And I click on the "View or change" link
    And I see "Change retention date" on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date          | Amended by | Retention policy        | Comments | Status   |
      | *NO-CHECK*             | <display_retentiondate> | *NO-CHECK* | <retention_displayname> |          | COMPLETE |

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
    Then I see "<retention_displayname>" on the page
    And I click on the "Change retention date" link
    And I click on the "Retain permanently (99 years)" link
    And I set "Why are you making this change?" to "AC5 99 Years Permanent Retention"
    And I click on the "Continue" link
    Then I see "Check retention date change" on the page
    And I see "<case_number>" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Change case retention date" on the page
    And I see "{{displaydate0{{date+99years}}}} (Permanent)" in the same row as "Retain case until"
    And I see "AC5 99 Years Permanent Retention" in the same row as "Reason for change"
    And I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate0{{date+99years}}}}" in the same row as "Retain case until"

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
    Then I see "<retention_displayname>" on the page
    And I click on the "Change retention date" link
    And  I click on the "Retain until a specific date" link
    And I set "Enter a date to retain the case until" to "01/11/2023"
    And I set "Why are you making this change?" to "AC2"
    And I click on the "Continue" link
    And I see "Change case retention date" on the page
    Then I see an error message "You do not have permission to reduce the current retention date."
    Then I see an error message "Please refer to the DARTS retention policy guidance."
    Then I click on the "Cancel" link
    And I see "Case retention date" on the page

    Examples:
      | case_number | caseRetention | totalSentence | retention_displayname | display_retentiondate             | courtroom  | ref |
      | R{{seq}}MN1 | 4             | 99Y0M0D       | Life                  | {{displayDate-{{date+99 years}}}} | {{seq}}-34 | 34  |

  @DMP-1413 @regression
  Scenario: Change Retention Date by increasing it with specific date
    Given I create a case
      | courthouse         | courtroom  | case_number  | defendants     | judges           | prosecutors               | defenders               |
      | Harrow Crown Court | {{seq}}-11 | R{{seq}}AB11 | Def {{seq}}-11 | Judge {{seq}}-11 | testprosecutor {{seq}}-11 | testdefender {{seq}}-11 |

    Given I authenticate from the CPP source system
    Given I create an event
      | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              |
      | {{seq}}011 | 1100 |          | {{seq}}1169 | Harrow Crown Court | {{seq}}-11 | R{{seq}}AB11 | {{seq}}ABC-11 | {{timestamp-10:02:00}} |

    Given I am logged on to DARTS as an JUDGE user
    When I click on the "Search" link
    And I set "Case ID" to "R{{seq}}AB11"
    And I press the "Search" button
    And I click on the "R{{seq}}AB11" link
    And I see "No date applied" on the page
    And I click on the "View or change" link
    And I see "This case is still open or was recently closed." on the page
    And I see "R{{seq}}AB11" on the page
    And I see "A retention policy has yet to be applied to this case." on the page
    And I see "No history to show" on the page

  #Close case
    Given I authenticate from the CPP source system
    When I create an event
      | message_id | type  | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
      | {{seq}}001 | 30300 |          | {{seq}}1168 | Harrow Crown Court | {{seq}}-29 | R{{seq}}AB11 | {{seq}}ABC-29 | {{timestamp-10:00:00}} | 3                           | 3Y3M3D              |

    Then I click on the breadcrumb link "R{{seq}}AB11"
    And I see "No date applied" on the page

    # 7 days Past Case Close Event
    And I select column cas_id from table darts.court_case where case_number = "R{{seq}}AB11"
    And I set table darts.case_retention column current_state to "COMPLETE" where cas_id = "{{cas_id}}"

    And I click on the "View or change" link
    And I see "R{{seq}}AB11" in the same row as "Case ID"
    And I see "A retention policy has yet to be applied to this case." on the page
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by | Retention policy | Comments | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK* | Custodial        |          | COMPLETE |

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
    And I see "R{{seq}}AB11" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def {{seq}}-11" in the same row as "Defendant(s)"
    And I see "This is my reason for increasing the retention date" in the same row as "Reason for change"

    When I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate0}}" in the same row as "Date applied"
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Custodial        |                                                     | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |

  #DMP-1413-AC3 Reducing retention date, specific date

    When I press the "Change retention date" button
    And I select the "Retain until a specific date" radio button
    And I set "Enter a date to retain the case until" to "{{date+2920/}}"

    And I set "Why are you making this change?" to "Reason for reducing retention date by one year"
    And I see "You have 154 characters remaining" on the page
    And I press the "Continue" button

  #DMP-1437 Check your retention date change screen
    Then I see "Check retention date change" on the page
    And I see "R{{seq}}AB11" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "Def {{seq}}-11" in the same row as "Defendant(s)"
    And I see "Reason for reducing retention date by one year" in the same row as "Reason for change"

    Then I click on "Change" in the same row as "Retain case until"
    And I press the "Continue" button

    Then I click on "Change" in the same row as "Reason for change"
    And I press the "Continue" button

    When I press the "Confirm retention date change" button

  #DMP-1439 Confirmation of retention date change screen
    Then I see "Case retention date changed." on the page
    And I see "R{{seq}}AB11" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "{{displaydate0}}" in the same row as "Date applied"
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Custodial        |                                                     | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | Reason for reducing retention date by one year      | COMPLETE |

  #DMP-1413-AC2 Mark for permanent retention

    When I press the "Change retention date" button
    And I select the "Retain permanently (99 years)" radio button
    And I set "Why are you making this change?" to "Reason for retaining this case permanently"
    And I see "You have 158 characters remaining" on the page
    And I press the "Continue" button
    Then I see "Check retention date change" on the page
    And I see "R{{seq}}AB11" in the same row as "Case ID"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "(Permanent)" on the page
    And I see "Reason for retaining this case permanently" in the same row as "Reason for change"

    When I press the "Confirm retention date change" button
    Then I see "Case retention date changed." on the page
    And I see "{{displaydate0}}" in the same row as "Date applied"
    And I see "DARTS Permanent Policy" in the same row as "DARTS Retention policy applied"
    Then I verify the HTML table "Retention audit history" contains the following values
      | Date retention changed | Retention date | Amended by   | Retention policy | Comments                                            | Status   |
      | *NO-CHECK*             | *NO-CHECK*     | *NO-CHECK*   | Custodial        |                                                     | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | This is my reason for increasing the retention date | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Manual           | Reason for reducing retention date by one year      | COMPLETE |
      | *NO-CHECK*             | *NO-CHECK*     | global_judge | Permanent        | Reason for retaining this case permanently          | COMPLETE |