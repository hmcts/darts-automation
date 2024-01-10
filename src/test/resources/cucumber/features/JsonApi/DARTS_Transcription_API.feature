Feature: Transcription Endpoints

  @DMP-1335 @JSON_API
  Scenario: Return all data from the "transcription_type" table
    When I call GET /transcriptions/types API
    Then the API status code is 200
    Then the API response contains:
		"""
		[
  			{ "trt_id": 1, "description": "Sentencing remarks" },
  			{ "trt_id": 2, "description": "Summing up (including verdict)" },
  			{ "trt_id": 3, "description": "Antecedents" },
  			{ "trt_id": 4, "description": "Argument and submission of ruling" },
  			{ "trt_id": 5, "description": "Court Log" },
  			{ "trt_id": 6, "description": "Mitigation" },
  			{ "trt_id": 7, "description": "Proceedings after verdict" },
  			{ "trt_id": 8, "description": "Prosecution opening of facts" },
  			{ "trt_id": 9, "description": "Specified Times" },
  			{ "trt_id": 999, "description": "Other" }
			]
		"""

  @DMP-1336 @DMP-1598
  Scenario: Transcription Urgency Priority / Sort Order
    Given I authenticate as a Judge user
    When I call GET /transcriptions/urgencies API
    Then the API status code is 200
    Then the API response contains:
    """
    [
    {
        "transcription_urgency_id": 2,
        "description": "Overnight",
        "priority_order": 1
    },
    {
        "transcription_urgency_id": 7,
        "description": "Up to 2 working days",
        "priority_order": 2
    },
    {
        "transcription_urgency_id": 4,
        "description": "Up to 3 working days",
        "priority_order": 3
    },
    {
        "transcription_urgency_id": 5,
        "description": "Up to 7 working days",
        "priority_order": 4
    },
    {
        "transcription_urgency_id": 6,
        "description": "Up to 12 working days",
        "priority_order": 5
    },
    {
        "transcription_urgency_id": 3,
        "description": "Other",
        "priority_order": 6
    }
]
    """

