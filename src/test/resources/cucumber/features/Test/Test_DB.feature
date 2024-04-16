Feature: Database Tests

@TS @DB @DB1
Scenario: test update sql
	Given I execute update sql:
	"""
	update darts.court_case 
	set case_closed = null 
	where case_number = '174';
	"""

@TS @DB @DB2
Scenario: test select sql
	Given I execute select sql:
	"""
	select cas_id 
	from darts.court_case 
	where case_number = '174'; 
	"""

@TS @DB @DB3
Scenario: test select sql
	Given I execute sql and save the return value as save1
	"""
	select cas_id 
	from darts.court_case 
	where case_number = '174'; 
	"""
	And I execute sql and save the return value as save2
	"""
	select case_number
	from darts.court_case 
	where cas_id = {{save1}}; 
	"""
  Then I pause the test with message "case no {{save2}}"
	

@TS @DB @DB4
Scenario: test update single field 
#  Given Case 174 exists in court "LEEDS"
  Given I pause the test with message "do not expect value {{save2}}"
	When I set table darts.court_case column case_closed to "true" where case_number = "174"
	And I set table darts.court_case column case_closed to "false" where case_number = "174" and cas_id = "81"
	Then I see table darts.court_case column case_closed is "f" where case_number = "174"
	 And I see table darts.court_case column case_number is "174" where cas_id = "81"
	 And I see table COURTCASE column cas.cas_id is "2765" where case_number = "T20220001" and courthouse_name = "Swansea"

@TS @DB @DB5
Scenario: test update single field
	Then I select column cas_id from table COURTCASE where case_number = "K11158001" and courthouse_name = "Harrow Crown Court"
	 And I select column car_id from table darts.case_retention where cas_id = "{{cas_id}}"
	 Then I pause the test with message "cas_id {{cas_id}} car_id {{car_id}}"
	
