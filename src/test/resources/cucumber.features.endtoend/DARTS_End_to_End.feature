Feature: Events Endpoints

  @end2end @end2end6
   #Created a case and event via Post courtlog
  Scenario Outline: Create a case
    When I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Then the API status code is 201
    Then the API response contains:
      """
        {
          "case_id":
      """
    Then the API response contains:
      """
          "courthouse": "Harrow Crown Court",
          "case_number":
          """
    Then the API response contains:
  """
          "defendants": [
              "fred"
            ],
           "judges": [
              "test judge"
            ],
          "prosecutors": [
              "test prosecutor"
            ],
           "defenders": [
              "test defender"
            ]
         }
      """
    When I add courtlog using json
      | dateTime      | courthouse   | courtroom   | case_number   | text                           |
      | {{timestamp}} | <courthouse> | <courtroom> | <case_number> | AUTOMATION LOG - <case_number> |
    Then the API status code is 201
    Then the API response contains:
    """
      {
       "code": "201",
        "message": "CREATED"
      }
    """
    And I am logged on to DARTS as an external user
    When I click on the "Search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number> | <courthouse> | <courtroom> | <judges> | <defendants>  |
    Then I click on the "Clear search" link
    And "Courthouse" is ""
    And "Case ID" is ""
    Then I set ""

    Examples:
      | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     | courtroom    |
      | Harrow Crown Court | T2023000231   | fred       | test judge | test prosecutor | test defender | Rayners room |

  @end2end @end2end6
  Scenario Outline: Create a case and hearing via events
    When I create an event
      | message_id  | type | sub_type | event_id | courthouse   | courtroom   | case_numbers  | event_text             | date_time     | case_retention_fixed_policy | case_total_sentence | start_time    | end_time      |
      | MID20230001 | 1100 |          | 16558    | <courthouse> | <courtroom> | <case_number> | Hearing Started{{seq}} | {{timestamp}} |                             |                     | {{timestamp}} | {{timestamp}} |
    Then the API status code is 201
    Then the API response contains:
    """
    {
    "code": "201",
    "message": "CREATED"
    }
    """
    And I am logged on to DARTS as an external user
    When I click on the "Search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I see "1 result" on the page
    Then I verify the HTML table contains the following values
      | Case ID       | Courthouse   | Courtroom   | Judge(s) | Defendants(s) |
      | <case_number> | <courthouse> | <courtroom> |          |               |

    Then I click on the "Clear search" link
    And "Courthouse" is ""
    And "Case ID" is ""
    And I set "Courthouse" to "<courthouse>" and click away
    Then I set "Courtroom" to "<courtroom>"
    And I select the "Specific date" radio button with label "Specific date"
    And I press the "Choose date" button
    Then I press the "<datepart>" button
    And I press the "Search" button
    And I see "1 result" on the page

    Examples:
      | courthouse         | case_number | courtroom    | HearingDate     | StartTime              | EndTime                | datepart |
      | Harrow Crown Court | T2023000233 | Rayners room | {{displaydate}} | {{timestamp-12:06:40}} | {{timestamp-12:06:40}} | {{dd-}}  |