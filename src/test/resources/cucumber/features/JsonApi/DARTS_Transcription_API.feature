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