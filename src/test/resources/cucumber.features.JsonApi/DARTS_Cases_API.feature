Feature: Cases Endpoints

  @DMP-458
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
    Examples:
      | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     |
      | Harrow Crown Court | T20230001   | fred       | test judge | test prosecutor | test defender |

  @DMP-458
  Scenario: test /cases with courtroom in json body
    Given I call POST cases API using json body:
      """
        {
          "case_id": 10458,
          "courthouse": "Harrow Crown Court",
          "courtroom": "",
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
    Then the API status code is 400
    Then the API response contains:
      """
        {
        "title": "Bad Request",
        "status": 400,
        "detail": "JSON parse error: Unrecognized field \"case_id\" (class uk.gov.hmcts.darts.cases.model.AddCaseRequest), not marked as ignorable"
        }
      """
  @DMP-462
  Scenario: test POST /courtlogs
    Given I call POST courtlogs API using json body:
    """
      {
        "log_entry_date_time": "2023-11-28T14:30:31.410Z",
        "courthouse": "Harrow Crown Court",
        "courtroom": "Rayners room",
        "case_numbers": [
            "T20230001"
          ],
         "text": "AUTOMATION LOG"
      }
    """
    Then the API status code is 201
    Then the API response contains:
    """
      {
       "code": "201",
        "message": "CREATED"
      }
    """

@test
Scenario: test POST /court-logs
  When I add courtlog using json
    | dateTime      | courthouse         | courtroom    | case_number | text                       |
    | {{timestamp}} | Harrow Crown Court | Rayners room | T20230001   | AUTOMATION LOG - T20230001 |