Feature: Courthouse endpoint

  Scenario: GET courthouses
    When I call GET courthouses API
    Then the API status code is 200
    And the API response contains:
    """
   {
        "courthouse_name": "Harrow Crown Court",
        "code": 10005,
        "display_name": "Harrow Crown Court",
        "id": 104,
        "created_date_time": "2023-08-17T15:20:20.66018Z",
        "last_modified_date_time": "2023-08-17T15:20:20.660211Z"
    }
    """