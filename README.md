# darts-automation
Automated test framework for DARTS

Framework retired as of 21/02/2025 and will no longer be maintained.
New Playwright framework is available at: https://github.com/hmcts/darts-automation-playwright

Environment variables required from ide / jenkins:

	FUNC_TEST_ROPC_USERNAME
	FUNC_TEST_ROPC_PASSWORD
	FUNC_TEST_ROPC_GLOBAL_USERNAME
	FUNC_TEST_ROPC_GLOBAL_PASSWORD
	AAD_B2C_ROPC_CLIENT_ID
	AAD_B2C_ROPC_CLIENT_SECRET
	DARTS_API_DB_SCHEMA
	DARTS_API_DB_HOST
	DARTS_API_DB_DATABASE
	DARTS_API_DB_PORT
	DARTS_API_DB_USERNAME
	DARTS_API_DB_PASSWORD
	AAD_TENANT_ID
	AAD_CLIENT_ID
	AAD_CLIENT_SECRET
	AUTOMATION_USERNAME
	AUTOMATION_PASSWORD
	AUTOMATION_TRANSCRIBER_USERNAME
	AUTOMATION_LANGUAGE_SHOP_TEST_USERNAME
	AUTOMATION_EXTERNAL_PASSWORD
	AUTOMATION_JUDGE_TEST_USERNAME
	AUTOMATION_REQUESTER_TEST_USERNAME
	AUTOMATION_APPROVER_TEST_USERNAME
	AUTOMATION_APPEAL_COURT_TEST_USERNAME
	AUTOMATION_INTERNAL_PASSWORD
	AUTOMATION_REQUESTER_APPROVER_USERNAME
	AUTOMATION_REQUESTER_APPROVER_PASSWORD
	AUTOMATION_SUPER_USER_USERNAME
	XHIBIT_USERNAME
	XHIBIT_PASSWORD
	CPP_USERNAME
	CPP_PASSWORD
	DAR_MID_TIER_USERNAME
	DAR_MID_TIER_PASSWORD
	DARTS_ADMIN_USERNAME
	DARTS_ADMIN2_USERNAME
	
To run locally, use
	
	RUN_LOCAL=true
	seq_prefix=n   choose a number 2-9 to prefix the sequence number when RUN_LOCAL=true

n.b. not using RUN_LOCAL=true when not run from jenkins will cause jenkins runs to fail
	
When run locally, optionally:

	run_Headless=true
	seq_prefix=n   choose a number 2-9 to prefix the sequence number when RUN_LOCAL=true

RUN_LOCAL should only be set to true when running locally, not from jenkins

Audio & transcription files must be in git. Add to resources/audioFiles or resources/transcriptionFiles 

Default environment is staging
To run on other environments e.g. demo when running locally, set Environment variables
	environment
	DARTS_API_DB_HOST_<environment> 
	DARTS_API_DB_PASSWORD_<environment>

Files to exclude from version control:
	testdata.properties
	TestRunner_Cucumber.java