@JSON_API @json_courthouses
Feature: Courthouse endpoint

  @DMP-1250 @regression
  Scenario: GET courthouses
    When I call GET courthouses API
    Then the API status code is 200
    And the API response contains:
    """
   {
        "courthouse_name": "HARROW CROWN COURT",
        "code": 10005,
        "display_name": "Harrow Crown Court",
        "id": 1356,
        "created_date_time": "2023-08-17T15:20:20.66018Z",
        "last_modified_date_time": "2023-08-17T15:20:20.660211Z"
    }
    """

  @DMP-635 @broken
  Scenario: POST courthouse
    Given I authenticate as an admin user
    When I call POST courthouses API using json body:
      """
        {
        "courthouse_name": "AUTOMATION {{seq}}",
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

  @DMP-746 @broken
  Scenario: POST courthouse - Duplicate courthouse
    Given I call POST courthouses API using json body:
      """
        {
        "courthouse_name": "HARROW CROWN COURT",
        "code": 10005,
        "display_name": "Harrow Crown Court"
        }
      """
    Then the API status code is 405
    And the API response contains:
        """
          {
           "type": "COURTHOUSE_100",
           "title": "Provided courthouse name already exists.",
           "status": 405
          }
        """


