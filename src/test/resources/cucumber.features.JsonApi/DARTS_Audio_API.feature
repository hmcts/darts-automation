Feature: Audio Endpoint

  @DMP-777
  Scenario: GET Audio Endpoint
    Given I authenticate as a EXTERNAL user
    When I call GET /audio/hearings/142/audios API
    Then the API status code is 200
    Then the API response contains:
    """
    {
        "id": 1295,
        "media_start_timestamp": "2023-08-15T13:00:00Z",
        "media_end_timestamp": "2023-08-15T13:01:00Z"
    }
    """

  @DMP-1169-AC1
  Scenario: GET Media - authorized user
    Given I authenticate as a EXTERNAL user
    When I call GET /audio/preview/3833 API
    Then the API status code is 200

  @DMP-1169-AC2
  Scenario: GET Media - unauthorized user
    Given I authenticate as a REQUESTER user
    When I call GET /audio/preview/3833 API
    Then the API status code is 403
    Then the API response contains:
    """
          {
           "type": "AUTHORISATION_100",
           "title": "User is not authorised for the associated courthouse",
           "status": 403
          }
    """

  @DMP-1169-AC3
  Scenario: GET Media - authorized user - No media
    Given I authenticate as a EXTERNAL user
    When I call GET /audio/preview/1123 API
    Then the API status code is 404
    Then the API response contains:
    """
          {
          "type": "AUDIO_102",
          "title": "The requested media cannot be found",
          "status": 404
          }
    """

  @DMP-1169-AC4
  Scenario: GET Media - authorized user - Bad Request
    Given I authenticate as a EXTERNAL user
    When I call GET /audio/preview/1123@ API
    Then the API status code is 400
    Then the API response contains:
    """
        {
        "title": "Bad Request",
        "status": 400,
        "detail": "Failed to convert value of type 'java.lang.String' to required type 'java.lang.Integer'; For input string: \"1123@\""
        }
    """


