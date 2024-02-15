@DMP-1048-RequestAudio
Feature: Request Audio

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @DMP-694 @regression
Scenario: Request Audio data creation

  Given I create a case
    | courthouse         | case_number | defendants    | judges          | prosecutors         | defenders         |
    | Harrow Crown Court | B{{seq}}006 | Def {{seq}}-6 | Judge {{seq}}-6 | testprosecutorsix   | testdefendersix   |
    | Harrow Crown Court | B{{seq}}007 | Def {{seq}}-7 | Judge {{seq}}-7 | testprosecutorseven | testdefenderseven |

  Given I create an event
    | message_id | type | sub_type | event_id    | courthouse         | courtroom  | case_numbers | event_text    | date_time              | case_retention_fixed_policy | case_total_sentence |
    | {{seq}}006 | 1100 | 	     | {{seq}}1006 | Harrow Crown Court | {{seq}}-6  | B{{seq}}006  | {{seq}}ABC-6  | {{timestamp-10:00:00}} |                             |                     |
    | {{seq}}007 | 1100 | 	     | {{seq}}1007 | Harrow Crown Court | {{seq}}-7  | B{{seq}}007  | {{seq}}ABC-7  | {{timestamp-10:00:00}} |                             |                     |

  #When I authenticate from the darmidtier source system

  When I load an audio file
    | courthouse         | courtroom | case_numbers | date        | startTime | endTime  | audioFile |
    | Harrow Crown Court | {{seq}}-6 | B{{seq}}006  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1   |
    | Harrow Crown Court | {{seq}}-7 | B{{seq}}007  | {{date+0/}} | 10:01:00  | 10:02:00 | sample1   |

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @regression
Scenario: Request Audio with Request Type Playback Only

  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID     | Courthouse         | Courtroom | Judge(s)        | Defendants(s) |
    | B{{seq}}006 | Harrow Crown Court | {{seq}}-6 | Judge {{seq}}-6 | Def {{seq}}-6 |

  #Case Details

  When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"

  #Hearing Details

  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "Events and audio recordings" on the page
  And I see "{{seq}}ABC-6" on the page

  When I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Playback Only" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  #And I see "<Restriction>" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def {{seq}}-6" on the page
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
  And I see "Def {{seq}}-6" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page

@DMP-685 @DMP-651 @DMP-658 @DMP-696 @DMP-695 @DMP-686 @regression
Scenario: Request Audio with Request Type Download NEW

  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID     | Courthouse         | Courtroom | Judge(s)        | Defendants(s) |
    | B{{seq}}006 | Harrow Crown Court | {{seq}}-6 | Judge {{seq}}-6 | Def {{seq}}-6 |

  #Case Details

  When I click on "B{{seq}}006" in the same row as "Harrow Crown Court"

  #Hearing Details

  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "Events and audio recordings" on the page
  And I see "{{seq}}ABC-6" on the page

  When I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  #And I see "<Restriction>" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def {{seq}}-6" on the page
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
  And I see "Def {{seq}}-6" on the page
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
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  And I see "Confirm your Order" on the page
  And I click on the "Cancel" link
  Then I see "{{seq}}ABC-6" on the page

@DMP-685 @regression
Scenario: Request Audio Confirm Order Back link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  And I see "Confirm your Order" on the page
  And I click on the "Back" link
  Then I see "{{seq}}ABC-6" on the page

@DMP-694 @regression
Scenario: Request Audio Error Messages
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

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
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I press the "Get Audio" button
  Then I see "You must select a request type" on the page

@DMP-686 @regression
Scenario: Order Confirmation - Return to hearing date link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  Then I see "Confirm your Order" on the page

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  And I click on the "Return to hearing date" link
  And I see "{{seq}}ABC-6" on the page

@DMP-686 @regression
Scenario: Order Confirmation - Back to search results link
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}007"
  And I press the "Search" button
  And I click on "B{{seq}}007" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-7"
  Then I see "{{seq}}ABC-7" on the page

  When I select the "Audio preview and events" radio button
  And I check the checkbox in the same row as "10:01:00 - 10:02:00" "Audio recording"
  And I select the "Download" radio button
  And I press the "Get Audio" button
  Then I see "Confirm your Order" on the page

  When I press the "Confirm" button
  And I see "Your order is complete" on the page
  And I click on the "Back to search results" link
  Then I see "Search for a case" on the page

@DMP-695 @regression #Manually enter in Start Time and End Time
Scenario: Request Audio by setting Start Time and End Time
  Given I am logged on to DARTS as a transcriber user
  When I click on the "Search" link
  And I set "Case ID" to "B{{seq}}006"
  And I press the "Search" button
  And I click on "B{{seq}}006" in the same row as "Harrow Crown Court"
  And I click on "{{displaydate}}" in the same row as "{{seq}}-6"
  Then I see "{{seq}}ABC-6" on the page

  When I select the "Audio preview and events" radio button
  And I set the time fields of "Start Time" to "10:01:00"
  And I set the time fields of "End Time" to "10:02:00"
  And I select the "Playback Only" radio button
  And I press the "Get Audio" button

  #Confirm your Order

  Then I see "Confirm your Order" on the page
  And I see "Case details" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def {{seq}}-6" on the page
  And I see "Audio details" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page

  #Order Confirmation

  When I press the "Confirm" button
  Then I see "Your order is complete" on the page
  And I see "B{{seq}}006" on the page
  And I see "Harrow Crown Court" on the page
  And I see "Def {{seq}}-6" on the page
  And I see "{{displaydate}}" on the page
  And I see "10:01:00" on the page
  And I see "10:02:00" on the page
  And I see "We are preparing your audio." on the page
  And I see "When it is ready we will send an email to Transcriber and notify you in the DARTS application." on the page

@DMP-658
Scenario Outline: Request Audio Events only available for hearing
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
    | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
    | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  Then I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page

  When I select the "Events only" radio button
  And I check the checkbox in the same row as "13:07:33" "Interpreter sworn-in"
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
    | CaseID   | Courthouse | Defendants | HearingDate | StartTime | EndTime  | Restriction                                           |
    | CASE1009 | Swansea    | Jow Bloggs | 15 Aug 2023 | 13:07:33  | 13:07:33 | Restriction: Judge directed on reporting restrictions |

@DMP-692
Scenario Outline: Preview Audio Player Loading
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
    | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
    | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  Then I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page

  When I select the "Audio preview and events" radio button
  And I press the "Preview Audio" button in the same row as "<StartTime>" "<EndTime>"
  Then I see "<Text>" in the same row as "<StartTime>" "<EndTime>"
  Examples:
    | StartTime            | EndTime            | Text                                 |
    | Start time: 10:00:00 | End time: 11:14:05 | Loading Audio Preview... Please Wait |

@DMP-966
Scenario: Hearing table sorted with time
  Given I am logged on to DARTS as an external user
  And I click on the "Search" link
  And I see "Search for a case" on the page
  And I set "Case ID" to "Case1009"
  And I press the "Search" button
  Then I verify the HTML table contains the following values
    | Case ID                                                               | Courthouse | Courtroom | Judge(s) | Defendants(s) |
    | CASE1009                                                              | Swansea    | Multiple  | Mr Judge | Jow Bloggs    |
    | !\nRestriction\nRestriction: Judge directed on reporting restrictions | *IGNORE*   | *IGNORE*  | *IGNORE* | *IGNORE*      |
    | CASE1009                                                              | Liverpool  | ROOM_A    |          |               |

  #Case Details

  When I click on "CASE1009" in the same row as "Swansea"

  #Hearing Details

  Then I click on "15 Aug 2023" in the same row as "ROOM_A"
  And I see "Swansea" on the page
  And I see "ROOM_A" on the page

  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                 | Event                | Text                    |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | Start time: 10:00:00 | Preview Audio        | End time: 11:14:05      |
  Then I click on "Time" in the table header
  Then I verify the HTML table contains the following values
    | *NO-CHECK* | Time                 | Event                | Text                    |
    | *NO-CHECK* | Start time: 10:00:00 | Preview Audio        | End time: 11:14:05      |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
    | *NO-CHECK* | 13:07:33             | Interpreter sworn-in | Update interpreter flag |
  