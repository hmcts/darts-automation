Feature: Audio Request Endpoint

  @DMP-1726
  Scenario: Audio Request PATCH Endpoint
    Given I authenticate as a Requester user
    When I call GET audio-requests/v2 API with header "user_id=-37" and query params "expired=false"
    Then the API status code is 200
    Then the API response contains:
    """
          {
            "media_request_id": 7733,
            "case_id": 141,
            "hearing_id": 11757,
            "request_type": "PLAYBACK",
            "case_number": "CASE1009",
            "courthouse_name": "Swansea",
            "hearing_date": "2023-12-05",
            "start_ts": "2023-12-05T01:18:59Z",
            "end_ts": "2023-12-05T09:18:59Z",
            "media_request_status": "FAILED"
        }
    """
    And the API response contains:
    """
      {
            "media_request_id": 7773,
            "transformed_media_id": 57,
            "case_id": 141,
            "hearing_id": 142,
            "request_type": "PLAYBACK",
            "case_number": "CASE1009",
            "courthouse_name": "Swansea",
            "hearing_date": "2023-08-15",
            "start_ts": "2023-08-15T13:00:00Z",
            "end_ts": "2023-08-15T14:01:00Z",
            "media_request_status": "COMPLETED",
            "transformed_media_filename": "CASE1009_15_Aug_2023_1"
        }
    """

  @DMP-1726
  Scenario: Audio Request PATCH Endpoint
    Given I authenticate as a Requester user
    When I call GET audio-requests/v2 API with header "user_id=-37" and query params "expired=false"
    Then the API status code is 200
    Then the API response contains:
    """
    {
            "media_request_id": 7753,
            "case_id": 141,
            "hearing_id": 11757,
            "request_type": "PLAYBACK",
            "case_number": "CASE1009",
            "courthouse_name": "Swansea",
            "hearing_date": "2023-12-05",
            "start_ts": "2023-12-05T01:18:59Z",
            "end_ts": "2023-12-05T09:18:59Z",
            "media_request_status": "FAILED"
        }
    """

  @DMP-1726
  Scenario: Audio Request PATCH Endpoint
    Given I authenticate as a Requester user
    When I call GET audio-requests/v2 API with header "user_id=-37" and query params "expired=true"
    Then the API status code is 200
    Then the API response contains:
    """
          {
            "media_request_id": 7713,
            "transformed_media_id": 56,
            "case_id": 141,
            "hearing_id": 142,
            "request_type": "PLAYBACK",
            "case_number": "CASE1009",
            "courthouse_name": "Swansea",
            "hearing_date": "2023-08-15",
            "start_ts": "2023-08-15T14:00:00Z",
            "end_ts": "2023-08-15T14:01:00Z",
            "transformed_media_expiry_ts": "2023-12-13T09:20:02.27543Z",
            "media_request_status": "EXPIRED",
            "transformed_media_filename": "CASE1009_15_Aug_2023_1"
        }
    """
