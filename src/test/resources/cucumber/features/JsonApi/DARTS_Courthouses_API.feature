Feature: Courthouse endpoint

@JSON_API
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

  @DMP-1250
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

  @DMP-635
  Scenario: POST courthouse
    Given I call POST courthouses API using json body:
      """
        {
        "courthouse_name": "automation{{seq}}",
        "code": {{seq}},
        "display_name": "Automation {{seq}}"
        }
      """
    Then the API status code is 201
    And the API response contains:
      """
        {
          "courthouse_name": "automation{{seq}}",
          "code": 2002,
          "display_name": "Automation {{seq}}",
          "created_date_time": "{{timestamp}}",
          "last_modified_date_time": "{{timestamp}}"
        }
      """

  @DMP-746
  Scenario: POST courthouse - Duplicate courthouse
    Given I call POST courthouses API using json body:
      """
        {
        "courthouse_name": "Harrow Crown Court",
        "code": 10005,
        "display_name": "Harrow Crown Court"
        }
      """
    Then the API status code is 409
    And the API response contains:
        """
          {
           "type": "COURTHOUSE_100",
           "title": "Provided courthouse name already exists.",
           "status": 409
          }
        """


