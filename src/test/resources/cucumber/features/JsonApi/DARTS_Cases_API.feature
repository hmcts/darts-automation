@JSON_API @json_cases
Feature: Cases Endpoints

  @DMP-458 @regression
  Scenario: Create a case
    When I create a case using json
      | courthouse         | case_number | defendants | judges     | prosecutors     | defenders     |
      | Harrow Crown Court | T20230001   | fred       | test judge | test prosecutor | test defender |
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

  @DMP-458 @regression
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
      
  @DMP-462 @regression
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


@regression
Scenario: test GET cases
	When I select column cas.cas_id from table COURTCASE where case_number = "T20220001" and courthouse_name = "Swansea"
	And  I authenticate as a requester user
	And  I call GET cases/{{cas.cas_id}}/hearings API
	Then the API status code is 200
	And the API response contains:
	"""
[
    {
        "id": 275757,
        "date": "2024-03-20",
        "judges": [
            
        ],
        "courtroom": "32",
        "transcript_count": 0
    },
    {
        "id": 3125,
        "date": "2023-08-11",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 16869,
        "date": "2023-12-20",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 17289,
        "date": "2024-01-02",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 17829,
        "date": "2024-01-04",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 23629,
        "date": "2024-01-16",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 64529,
        "date": "2024-03-21",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 46297,
        "date": "2024-02-15",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 62549,
        "date": "2024-03-15",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 52069,
        "date": "2024-02-27",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 62829,
        "date": "2024-03-18",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 60309,
        "date": "2024-03-12",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    },
    {
        "id": 86489,
        "date": "2024-05-02",
        "judges": [
            
        ],
        "courtroom": "1",
        "transcript_count": 0
    }
]
	"""

