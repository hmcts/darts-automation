Feature: Portal Tests

@TS @DB
Scenario: test update sql
	Given I execute update sql:
	"""
	update darts.court_case 
	set case_closed = null 
	where case_number = '174';
	"""

@TS @DB
Scenario: test select sql
	Given I execute select sql:
	"""
	select cas_id 
	from darts.court_case 
	where case_number = '174'; 
	"""

@TS @DB @TREV_TEST_DB
Scenario: test update single field 
#  Given Case 174 exists in court "LEEDS"
#	When I set table court_case column case_closed to null where case_number = 174
#	Then I see table court_case column case_closed where case_number = 174 is null
	 And I see table court_case column cas_id is "81" where case_number = "T20220001" and cth_id = "81"
	 And I see table court_case column case_number is "174" where case_number = "174"
	
