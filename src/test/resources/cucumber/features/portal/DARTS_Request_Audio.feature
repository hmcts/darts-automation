Feature: Request Audio

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @DMP-694 @DMP-1048 @DMP-2121 @DMP-2562 @regression @ts667
Scenario: Request Audio data creation

  Given I create a case
    | courthouse         | courtroom  | case_number | defendants     | judges           | prosecutors         | defenders         |
    | Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | Def B{{seq}}-6 | Judge B{{seq}}-6 | testprosecutorsix   | testdefendersix   |
    | Harrow Crown Court | B{{seq}}-7 | B{{seq}}007 | Def B{{seq}}-7 | Judge B{{seq}}-7 | testprosecutorseven | testdefenderseven |
    | Harrow Crown Court | B{{seq}}-8 | B{{seq}}008 | Def B{{seq}}-8 | Judge B{{seq}}-8 | testprosecutoreight | testdefendereight |
    | Harrow Crown Court | B{{seq}}-9 | B{{seq}}009 | Def B{{seq}}-9 | Judge B{{seq}}-9 | testprosecutornine  | testdefendernine  |

  Given I authenticate from the CPP source system
  Given I create an event
    | message_id | type | sub_type | event_id   | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
    | {{seq}}006 | 1100 |          | {{seq}}006 | Harrow Crown Court | B{{seq}}-6 | B{{seq}}006  | B{{seq}}ABC-6 | {{timestamp-10:00:00}} |                             |                     |
    | {{seq}}007 | 1100 |          | {{seq}}007 | Harrow Crown Court | B{{seq}}-7 | B{{seq}}007  | B{{seq}}ABC-7 | {{timestamp-10:00:00}} |                             |                     |
    | {{seq}}008 | 1100 |          | {{seq}}008 | Harrow Crown Court | B{{seq}}-8 | B{{seq}}008  | B{{seq}}ABC-8 | {{timestamp-10:00:00}} |                             |                     |
    | {{seq}}009 | 1100 |          | {{seq}}009 | Harrow Crown Court | B{{seq}}-9 | B{{seq}}009  | B{{seq}}ABC-9 | {{timestamp-10:00:00}} |                             |                     |

  When I load an audio file
    | courthouse         | courtroom  | case_numbers | date        | startTime | endTime  | audioFile   |
    | Harrow Crown Court | B{{seq}}-6 | B{{seq}}006  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1.mp2 |
    | Harrow Crown Court | B{{seq}}-7 | B{{seq}}007  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1.mp2 |
    | Harrow Crown Court | B{{seq}}-8 | B{{seq}}008  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1.mp2 |
    | Harrow Crown Court | B{{seq}}-9 | B{{seq}}009  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1.mp2 |

@DMP-2300 @regression
  Scenario: Audio is not available to preview message.

  #NOTE: DMP-2300 NEEDS TO RUN STRAIGHT AFTER THE DATA CREATION TO GET THE PREVIEW MESSAGE
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page
  And I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  Then I see "This audio is not currently available in DARTS, please try again later." on the page

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @DMP-1048 @regression
Scenario: Request Audio with Request Type Playback Only

  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
    | B{{seq}}006 | Harrow Crown Court | B{{seq}}-6 | JUDGE B{{seq}}-6 | Def B{{seq}}-6 |

  #Case Details

  When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"

  #Hearing Details

  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "Events and audio recordings" on the page
  And I see "B{{seq}}ABC-6" on the page

  When I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Playback Only" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  #And I see "<Restriction>" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-6" on the page
  And I see "Audio details" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page

  #Order Confirmation

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  #And I see "<Restriction>" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-6" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @DMP-1048 @regression
Scenario: Request Audio with Request Type Download

  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID     | Courthouse         | Courtroom  | Judge(s)         | Defendant(s)   |
    | B{{seq}}006 | Harrow Crown Court | B{{seq}}-6 | JUDGE B{{seq}}-6 | Def B{{seq}}-6 |

  #Case Details

  When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"

  #Hearing Details

  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "Events and audio recordings" on the page
  And I see "B{{seq}}ABC-6" on the page

  When I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  #And I see "<Restriction>" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-6" on the page
  And I see "Audio details" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page

  #Order Confirmation

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  #And I see "<Restriction>" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-6" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page

@DMP-685 @regression
Scenario: Request Audio Confirm your Order Cancel link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "B{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  And I see "Confirm your Order" on the page
  And I click on the "Cancel" link
  Then I see "B{{seq}}ABC-6" on the page

@DMP-685 @regression
Scenario: Request Audio Confirm Order Back link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "B{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  And I see "Confirm your Order" on the page
  And I click on the "Back" link
  Then I see "B{{seq}}ABC-6" on the page

@DMP-694 @regression
Scenario: Request Audio Error Messages
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "B{{seq}}ABC-6" on the page

  When I press the "Get Audio" button
  Then I see "You must include a start time for your audio recording" on the page
  And I see "You must include an end time for your audio recording" on the page
  And I see "You must select a request type" on the page

@DMP-694 @regression
Scenario: Request Audio request type error message
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
  Then I see "B{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I press the "Get Audio" button
  Then I see "You must select a request type" on the page

@DMP-686 @regression
Scenario: Order Confirmation - Return to hearing date link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}008"
  And I press the "Search" button
  And I click on "B{{seq}}008" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-8"
  Then I see "B{{seq}}ABC-8" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  Then I see "Confirm your Order" on the page

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  And I click on the "Return to hearing date" link
  And I see "B{{seq}}ABC-8" on the page

@DMP-686 @regression
Scenario: Order Confirmation - Back to search results link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}007"
  And I press the "Search" button
  And I click on "B{{seq}}007" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-7"
  Then I see "B{{seq}}ABC-7" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  Then I see "Confirm your Order" on the page

  When I press the "Confirm" button
  And I see "Your order is complete" on the page
  And I click on the "Back to search results" link
  Then I see "Search for a case" on the page

@DMP-695 @regression
Scenario: Request Audio by setting Start Time and End Time

  #Manually enter in Start Time and End Time

  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}009"
  And I press the "Search" button
  And I click on "B{{seq}}009" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "B{{seq}}-9"
  Then I see "B{{seq}}ABC-9" on the page

  When I select the "Audio preview and events" radio button
  And I set the time fields of "Start Time" to "10:01:00"
  And I set the time fields of "End Time" to "10:02:00"
  And I select the "Playback Only" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}009" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-9" on the page
  And I see "Audio details" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page

  #Order Confirmation

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  And I see "B{{seq}}009" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def B{{seq}}-9" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page

@DMP-658 @regression @review
Scenario Outline: Request Audio Events only available for hearing
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                  | Courthouse | Courtroom | Judge(s) | Defendant(s) |
    | CASE1009                                                 | Swansea    | Multiple  | Mr Judge | Jow Bloggs   |
    | !\nRestriction\nThere are restrictions against this case | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*     |
    | CASE1009                                                 | Liverpool  | ROOM_A    |          |              |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  Then I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page

  When I select the "Events only" radio button
  And I check the checkbox in the same row as "14:07:33" "Interpreter sworn-in"
  And I set the time fields below "End Time" to "14:08:33"
  And I select the "Playback Only" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  And I see "<Restriction>" on the page
  And I see "Case details" on the page
  And I see "<CaseID>" on the page
  And I see "<Courthouse>" on the page
  And I see "<Defendants>" on the page
  And I see "Audio details" on the page
  And I see "<HearingDate>" on the page
  And I see "<StartTime>" on the page
  And I see "<EndTime>" on the page
  And I press the "Confirm" button

  #Order Confirmation

  Then I see "Your order is complete" on the page
  And I see "<Restriction>" on the page
  And I see "<CaseID>" on the page
  And I see "<Courthouse>" on the page
  And I see "<Defendants>" on the page
  And I see "<HearingDate>" on the page
  And I see "<StartTime>" on the page
  And I see "<EndTime>" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to" on the page
  Examples:
    | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                              |
    | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 14:07:33  | 14:08:33 | There are restrictions against this case |

@DMP-692
Scenario Outline: Preview Audio Player Loading
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                  | Courthouse | Courtroom | Judge(s) | Defendant(s) |
    | CASE1009                                                 | Swansea    | Multiple  | Mr Judge | Jow Bloggs   |
    | !\nRestriction\nThere are restrictions against this case | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*     |
    | CASE1009                                                 | Liverpool  | ROOM_A    |          |              |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  Then I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page

  When I select the "Audio preview and events" radio button
  And I press the "Play preview" button in the same row as "<StartTime>" "<EndTime>"
  Then I see "<Text>" in the same row as "<StartTime>" "<EndTime>"
  Examples:
    | StartTime            | EndTime            | Text                                 |
    | Start time: 10:00:00 | End time: 11:14:05 | Loading Audio Preview... Please Wait |

@DMP-966 @review
Scenario: Hearing table sorted with time
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                  | Courthouse | Courtroom | Judge(s) | Defendant(s) |
    | CASE1009                                                 | Swansea    | Multiple  | Mr Judge | Jow Bloggs   |
    | !\nRestriction\nThere are restrictions against this case | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*     |
    | CASE1009                                                 | Liverpool  | ROOM_A    |          |              |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  And I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                 | Event                | Text                    |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | Start time: 10:00:00 | Preview Audio        | End time: 11:14:05      |

  When I click on "Time" in the table header
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                 | Event                | Text                    |
    | *NO-CHECK* | Start time: 10:00:00 | Preview Audio        | End time: 11:14:05      |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |

@DMP-2121
Scenario: Update preview button on hearing screen

  Given I am logged on to DARTS as a requester user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  And I see "{{seq}}ABC-6" on the page
  Then I see "Play preview" on the page

  @DMP-2300
  Scenario: Audio is not available to preview message.

  #NOTE: DMP-2300 NEEDS TO RUN STRAIGHT AFTER THE DATA CREATION TO GET THE PREVIEW MESSAGE
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page
  And I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  Then I see "This audio is not currently available in DARTS, please try again later." on the page

  @DMP-2562 @regression
  Scenario: Request download audio for Admin user
    When I am logged on to DARTS as an Admin user
    And I click on the "Search" link
    And I see "Search for a case" on the page
    And I set "Case ID" to "B{{seq}}006"
    And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Case ID     | Courthouse         | Courtroom  | Judge(s)                        | Defendant(s)   |
      | B{{seq}}006 | Harrow Crown Court | B{{seq}}-6 | {{upper-case-Judge B{{seq}}-6}} | Def B{{seq}}-6 |

    When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
    Then I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:01:00"
    And I set the time fields of "End Time" to "10:02:00"
    And I select the "Playback Only" radio button
    And I press the "Get Audio" button
    Then I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def B{{seq}}-6" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page

    When I press the "Confirm" button
    Then I see "Your order is complete" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page
    And I see "We are preparing your audio." on the page
    And I see "When it is ready we will send an email to Darts Admin and notify you in the DARTS application." on the page
    And I see "Return to hearing date" on the page
    And I see "Back to search results" on the page
    Then I click on the "Back to search results" link

    When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
    And I click on "{{displaydate}}" in the same row as "B{{seq}}-6"
    And I see "Events and audio recordings" on the page
    And I set the time fields of "Start Time" to "10:01:00"
    And I set the time fields of "End Time" to "10:02:00"
    And I select the "Download" radio button
    And I press the "Get Audio" button
    And I see "Confirm your Order" on the page
    And I see "Case details" on the page
    And I see "B{{seq}}006" on the page
    And I see "Harrow Crown Court" on the page
    And I see "Def B{{seq}}-6" on the page
    And I see "Audio details" on the page
    And I see "{{displaydate}}" on the page
    And I see "10:01:00" on the page
    And I see "10:02:00" on the page
    And I press the "Confirm" button
    Then I see "Your order is complete" on the page
    


@DMP-4035 @regression
  Scenario Outline: Admin user can hide audio
    Given I am logged on to the admin portal as an Admin user
      And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
      And I click on the "Search" link
      And I see "You can search for cases, hearings, events and audio." on the page
      And I set "Case ID" to "<caseId>"
      And I press the "Search" button
      And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                       | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I click on the "{{med_id}}" link
     And I press the "Hide or delete" button
     And I press the "Hide or delete" button
    Then I see "Select a reason for hiding and/or deleting the file" on the page

    When I select the "Other reason to hide only" radio button
     And I press the "Hide or delete" button
    Then I see "Enter a ticket reference" on the page

    When I set "Enter ticket reference" to "T{{seq}}001"
     And I press the "Hide or delete" button
    Then I see "Provide details relating to this action" on the page

    When I set "Comments" to "DMP-4035"
    Then I see "You have 248 characters remaining" on the page
    When I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
     And I see "Check for associated files" on the page
     And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    When I press the "Continue" button
    Then I see "Important" on the page
     And I see "This file is hidden in DARTS" on the page
     And I see "DARTS users cannot view this file. You can unhide the file." on the page
     And I see "Hidden by - Darts Admin" on the page
     And I see "Reason - Other reason to hide only" on the page
     And I see "T{{seq}}001 - DMP-4035" on the page
     
    When I click on the "Back" link
     And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |
      
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to DARTS as an requester user
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "<caseId>" link
     And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I see "There is no audio for this hearing date" on the page
    
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to the admin portal as an Admin user
     And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
     And I click on the "Search" link
     And I see "You can search for cases, hearings, events and audio." on the page
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I click on the "{{med_id}}" link
     And I press the "Unhide" button
     And I click on the "Back" link
     And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |
      
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to DARTS as an requester user
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "<caseId>" link
     And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                    | Event           | Text          |
    | *NO-CHECK* | 10:00:00                | Hearing started | B{{seq}}ABC-6 |
    | *NO-CHECK* | <startTime> - <endTime> | *NO-CHECK*      | *NO-CHECK*    |

Examples:
	| courthouse         | courtroom  | caseId      | startTime | endTime  |
	| Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | 10:01:00  | 10:02:00 |



@DMP-4035 @regression
  Scenario Outline: Admin user can delete audio
    Given I am logged on to the admin portal as an Admin user
      And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
      And I click on the "Search" link
      And I see "You can search for cases, hearings, events and audio." on the page
      And I set "Case ID" to "<caseId>"
      And I press the "Search" button
      And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |

    When I click on the "{{med_id}}" link
     And I press the "Hide or delete" button
     And I press the "Hide or delete" button
    Then I see "Select a reason for hiding and/or deleting the file" on the page

    When I select the "<reason>" radio button
     And I press the "Hide or delete" button
    Then I see "Enter a ticket reference" on the page

    When I set "Enter ticket reference" to "<ticketNo>"
     And I press the "Hide or delete" button
    Then I see "Provide details relating to this action" on the page

    When I set "Comments" to "DMP-4035"
    Then I see "You have 248 characters remaining" on the page
    When I press the "Hide or delete" button
    Then I see "Files successfully hidden or marked for deletion" on the page
     And I see "Check for associated files" on the page
     And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    When I press the "Continue" button
    Then I see "Important" on the page
     And I see "This file is hidden in DARTS and is marked for manual deletion" on the page
     And I see "DARTS user cannot view this file. You can unmark for deletion and it will no longer be hidden." on the page
     And I see "Marked for manual deletion by - Darts Admin" on the page
     And I see "Reason - <reason>" on the page
     And I see "<ticketNo> - DMP-4035" on the page
     
    When I click on the "Back" link
     And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |
      
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to DARTS as an requester user
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "<caseId>" link
     And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
    Then I see "There is no audio for this hearing date" on the page
    
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to the admin portal as an Admin user
     And I select column med_id from table CASE_AUDIO where cas.case_number = "<caseId>" and courthouse_name = "<courthouse>"
     And I click on the "Search" link
     And I see "You can search for cases, hearings, events and audio." on the page
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "Audio" link
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | Yes    |

    When I click on the "{{med_id}}" link
     And I press the "Unmark for deletion and unhide" button
     And I click on the "Back" link
     And I press the "Search" button
    Then I verify the HTML table contains the following values
      | Audio ID   | Courthouse   | Courtroom   | Start Time                      | End Time                      | Channel | Hidden |
      | {{med_id}} | <courthouse> | <courtroom> | {{displaydate0}} at <startTime> | {{displaydate0}} at <endTime> | 1       | No     |
      
		When I Sign out
		Then I see "Sign in to the DARTS Portal" on the page
		
		When I am logged on to DARTS as an requester user
     And I set "Case ID" to "<caseId>"
     And I press the "Search" button
     And I click on the "<caseId>" link
     And I click on the "{{displaydate}}" link
    Then I see "Events and audio recordings" on the page
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                    | Event           | Text          |
    | *NO-CHECK* | 10:00:00                | Hearing started | B{{seq}}ABC-6 |
    | *NO-CHECK* | <startTime> - <endTime> | *NO-CHECK*      | *NO-CHECK*    |

Examples:
	| courthouse         | courtroom  | caseId      | startTime | endTime  | reason                    | ticketNo    |
	| Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | 10:01:00  | 10:02:00 | Public interest immunity  | T{{seq}}002 |
	| Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | 10:01:00  | 10:02:00 | Classified above official | T{{seq}}003 |
	| Harrow Crown Court | B{{seq}}-6 | B{{seq}}006 | 10:01:00  | 10:02:00 | Other reason to delete    | T{{seq}}004 |
