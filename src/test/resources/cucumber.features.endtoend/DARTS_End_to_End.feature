Feature: Events Endpoints

  @end_to_end
  Scenario Outline: Create a case
    When I create a case
      | courthouse   | case_number   | defendants   | judges   | prosecutors   | defenders   |
      | <courthouse> | <case_number> | <defendants> | <judges> | <prosecutors> | <defenders> |
    Then the API status code is 201
    Then the API response contains:
      """
        {
          "case_id": 10458,
          "courthouse": "Harrow Crown Court",
          "case_number": "T20230001",
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
    And I am logged on to DARTS as an external user
    When I click on the "Search" link
    And I click on the "Advanced search" link
    And I set "Courthouse" to "<courthouse>" and click away
    Then I set "Case ID" to "<case_number>"
    And I press the "Search" button
    And I see "1 result" on the page
    And I click on "<case_number>" in the same row as "<courthouse>"
    And I see "<case_number>" on the page
    And I see "<courthouse>" on the page
    And I see "<defendants>" on the page
    Examples:
      | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     |
      | Harrow Crown Court | T20230001   | fred       | test judge | test prosecutor | test defender |

  @end_to_end
  Scenario Outline: Create a events
    When I create an event
      | message_id  | type | sub_type | event_id | courthouse   | courtroom   | case_numbers  | event_text      | date_time                | case_retention_fixed_policy | case_total_sentence | start_time               | end_time                 |
      | MID20230001 | 1100 |          | 16558    | <courthouse> | <courtroom> | <case_number> | Hearing Started | 2023-12-07T14:30:00.000Z |                             |                     | 2023-12-07T01:18:59.903Z | 2023-12-07T01:28:59.903Z |
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
    And I click on "<case_number>" in the same row as "<courthouse>"
    And I see "<case_number>" on the page
    And I see "<courthouse>" on the page
    And I see "<defendants>" on the page
    And I click on "<HearingDate>" in the same row as "<courtroom>"
    Examples:
      | courthouse         | case_number | defendants | courtroom    | HearingDate |
      | Harrow Crown Court | T20230001   | fred       | Rayners room | 7 Dec 2023  |