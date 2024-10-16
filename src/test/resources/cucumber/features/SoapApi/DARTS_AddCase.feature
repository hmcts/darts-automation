@regression
Feature: AddCase using SOAP

@DMP-1706 @SOAP_API @ADD_CASE
Scenario Outline: SOAP addCase with 1 defendant
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants      | judges      | prosecutors   | defenders   |
	| <courthouse> | <caseNumber> | <defendantName> | <judgeName> | <prosecutors> | <defenders> |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column judge_name is "<judgeName>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column prosecutor_name is "<prosecutors>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "<defenders>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column defendant_name is "<defendantName>" where cas_id = "{{cas.cas_id}}"

Examples:
	| courthouse         | caseNumber  | defendantName  | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}601 | test defendent | test judge | test prosecutor | test defender |
	
@DMP-1706 @SOAP_API @ADD_CASE
Scenario Outline: SOAP addCase for existing case
  Given I see table COURTCASE column count(cas_id) is "1" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants       | judges       | prosecutors    | defenders    |
	| <courthouse> | <caseNumber> | <defendantName>2 | <judgeName>2 | <prosecutors>2 | <defenders>2 |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column count(jud_id) is "1" where cas_id = "{{cas.cas_id}}" and judge_name = "<judgeName>"
   And I see table CASE_JUDGE column count(jud_id) is "1" where cas_id = "{{cas.cas_id}}" and judge_name = "<judgeName>2"
   And I see table darts.prosecutor column count(prn_id) is "1" where cas_id = "{{cas.cas_id}}" and prosecutor_name = "<prosecutors>"
   And I see table darts.prosecutor column count(prn_id) is "1" where cas_id = "{{cas.cas_id}}" and prosecutor_name = "<prosecutors>2"
   And I see table darts.defence column count(dfc_id) is "1" where cas_id = "{{cas.cas_id}}" and defence_name = "<defenders>"
   And I see table darts.defence column count(dfc_id) is "1" where cas_id = "{{cas.cas_id}}" and defence_name = "<defenders>2"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>2"

Examples:
	| courthouse         | caseNumber  | defendantName  | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}601 | test defendent | test judge | test prosecutor | test defender |
	
@DMP-1706 @SOAP_API @ADD_CASE
Scenario Outline: SOAP addCase with 2 defendants
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants                        | judges      | prosecutors   | defenders   |
	| <courthouse> | <caseNumber> | <defendantName>1~<defendantName>2 | <judgeName> | <prosecutors> | <defenders> |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column judge_name is "<judgeName>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column prosecutor_name is "<prosecutors>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "<defenders>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>1"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>2"

Examples:
	| courthouse         | caseNumber  | defendantName  | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}602 | test defendent | test judge | test prosecutor | test defender |


@DMP-1706 @SOAP_API @ADD_CASE
Scenario Outline: SOAP addCase with 2 of each participant
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants                        | judges                    | prosecutors                   | defenders                 |
	| <courthouse> | <caseNumber> | <defendantName>1~<defendantName>2 | <judgeName>1~<judgeName>2 | <prosecutors>1~<prosecutors>2 | <defenders>1~<defenders>2 |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column count(jud_id) is "1" where cas_id = "{{cas.cas_id}}" and judge_name = "<judgeName>1"
   And I see table CASE_JUDGE column count(jud_id) is "1" where cas_id = "{{cas.cas_id}}" and judge_name = "<judgeName>2"
   And I see table darts.prosecutor column count(prn_id) is "1" where cas_id = "{{cas.cas_id}}" and prosecutor_name = "<prosecutors>1"
   And I see table darts.prosecutor column count(prn_id) is "1" where cas_id = "{{cas.cas_id}}" and prosecutor_name = "<prosecutors>2"
   And I see table darts.defence column count(dfc_id) is "1" where cas_id = "{{cas.cas_id}}" and defence_name = "<defenders>1"
   And I see table darts.defence column count(dfc_id) is "1" where cas_id = "{{cas.cas_id}}" and defence_name = "<defenders>2"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>1"
   And I see table darts.defendant column count(dfd_id) is "1" where cas_id = "{{cas.cas_id}}" and defendant_name = "<defendantName>2"

Examples:
	| courthouse         | caseNumber  | defendantName  | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}603 | test defendent | test judge | test prosecutor | test defender |


@DMP-1706 @SOAP_API @ADD_CASE @review
Scenario Outline: SOAP addCase with participant elements missing
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants   | judges      | prosecutors   | defenders   |
	| <courthouse> | <caseNumber> | <defendantName> | <judgeName> | <prosecutors> | <defenders> |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column count(jud_id) is "0" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column count(prn_id) is "0" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column count(dfc_id) is "0" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column count(dfd_id) is "0" where cas_id = "{{cas.cas_id}}"

Examples:
	| courthouse         | caseNumber  | defendantName   | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}604 | MISSING         | MISSING    | MISSING         | MISSING       |


@DMP-1706 @SOAP_API @ADD_CASE @ClientProblemException
Scenario Outline: SOAP addCase with participant elements empty
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants   | judges      | prosecutors   | defenders   |
	| <courthouse> | <caseNumber> | <defendant1> | <judgeName> | <prosecutors> | <defenders> |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column judge_name is "<judgeName>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column prosecutor_name is "<prosecutors>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "<defenders>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column defendant_name is "<defendant1>" where cas_id = "{{cas.cas_id}}"

Examples:
	| courthouse         | caseNumber  | defendant1      | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}605 |                 |            |                 |               |


@DMP-1706 @SOAP_API @ADD_CASE
Scenario Outline: SOAP addCase courtroom is ignored and still creates a case
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
	When I create a case
	| courthouse   | case_number  | defendants   | judges      | prosecutors   | defenders   | courtroom  |
	| <courthouse> | <caseNumber> | <defendant1> | <judgeName> | <prosecutors> | <defenders> | 1          |
	Then the API status code is 200
   And I select column cas.cas_id from table COURTCASE where courthouse_name = "<courthouse>" and case_number = "<caseNumber>"
   And I see table COURTCASE column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_JUDGE column judge_name is "<judgeName>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column prosecutor_name is "<prosecutors>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "<defenders>" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column defendant_name is "<defendant1>" where cas_id = "{{cas.cas_id}}"

Examples:
	| courthouse         | caseNumber  | defendant1      | judgeName  | prosecutors     | defenders     |
	| Harrow Crown Court | T{{seq}}606 | test defendent1 | test judge | test prosecutor | test defender |


@DMP-1706 @SOAP_API @ADD_CASE
Scenario: addCase successful baseline
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addCase and body:
	"""
<document xmlns="">
<![CDATA[<case type="" id="T{{seq}}607">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>1</courtroom>
  <defendants>
    <defendant>test defendent1</defendant>
  </defendants>
  <judges>
    <judge>test judge</judge>
  </judges>
  <prosecutors>
    <prosecutor>test prosecutor</prosecutor>
  </prosecutors>
  <defenders>
    <defender>test defender</defender>
  </defenders>
</case>]]>
</document>
	"""
	Then the API status code is 200


@DMP-1706 @SOAP_API @ADD_CASE
Scenario: addCase invalid court name fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addCase and body:
	"""
<document xmlns="">
<![CDATA[<case type="" id="T{{seq}}607">
  <courthouse>No Crown Court</courthouse>
  <courtroom>1</courtroom>
  <defendants>
    <defendant>test defendent1</defendant>
  </defendants>
  <judges>
    <judge>test judge</judge>
  </judges>
  <prosecutors>
    <prosecutor>test prosecutor</prosecutor>
  </prosecutors>
  <defenders>
    <defender>test defender</defender>
  </defenders>
</case>]]>
</document>
	"""
	Then the API status code is 404


@DMP-1706 @SOAP_API @ADD_CASE
Scenario: addCase access fron XHIBIT fails
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addCase and body:
	"""
<document xmlns="">
<![CDATA[<case type="" id="T{{seq}}607">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>1</courtroom>
  <defendants>
    <defendant>test defendent1</defendant>
  </defendants>
  <judges>
    <judge>test judge</judge>
  </judges>
  <prosecutors>
    <prosecutor>test prosecutor</prosecutor>
  </prosecutors>
  <defenders>
    <defender>test defender</defender>
  </defenders>
</case>]]>
</document>
	"""
	Then the API status code is 500


	