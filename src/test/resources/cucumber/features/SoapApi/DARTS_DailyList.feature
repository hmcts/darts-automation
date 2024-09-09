Feature: Add Daily List using SOAP

#
# n.b. for CPP, case number is held in the URN field
#
	
@Daily_List @SOAP_API @DMP-2968 @regression @DAILY_LIST
  @reads-and-writes-system-properties
Scenario Outline: Daily List Single Case Scenario - lists for today and tomorrow
		First is replaced
		Second is ignored when processed
		Third is processed & create a case
		Daily list for tomorrow is not processed today
		
	Given that courthouse "<courthouse>" case "<caseNumber>1" does not exist
	Given that courthouse "<courthouse>" case "<caseNumber>3" does not exist
	Given that courthouse "<courthouse>" case "<caseNumber>9" does not exist
  Given I wait until there is not a daily list waiting for "<courthouse>"
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>1"
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>9"
  Given I see table COURTCASE column count(cas_id) is "0" where courthouse_name = "<courthouse>" and case_number = "<caseNumber>3"
   And I see table darts.daily_list column count(job_status) is "0" where message_id = "<messageId>1" and unique_id = "<documentName>1"
   And I see table darts.daily_list column count(job_status) is "0" where message_id = "<messageId>2" and unique_id = "<documentName>1"
   And I see table darts.daily_list column count(job_status) is "0" where message_id = "<messageId>1" and unique_id = "<documentName>2"
   And I see table darts.daily_list column count(job_status) is "0" where message_id = "<messageId>9" and unique_id = "<documentName>9"
  Given I authenticate from the <source> source system
# First daily list for today
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber    | startDate   | startTime | endDate   | timeStamp   | defendant   | judge               | prosecution         | defence          |
  | <messageId>1  | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber>1 | <startDate> | 16:00     | <endDate> | <timeStamp> | <defendant> | judge name {{seq}}0 | prosecutor {{seq}}0 | defence {{seq}}0 |
  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>1" and unique_id = "<documentName>1"
# Overwrite first daily list for today (will be ignored)
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber    | startDate   | startTime | endDate   | timeStamp   | defendant   | judge               | prosecution         | defence          |
  | <messageId>1  | <type> | <subType> | <documentName>2 | <courthouse> | <courtroom> | <caseNumber>1 | <startDate> | 17:00     | <endDate> | <timeStamp> | <defendant> | judge name {{seq}}1 | prosecutor {{seq}}1 | defence {{seq}}1 |
  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>1" and unique_id = "<documentName>2"
# Second daily list for today (will be processed)
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber    | startDate   | startTime | endDate   | timeStamp   | defendant   | judge              | prosecution        | defence         |
#TODO changed documentName from 1 to 3 due to defect
#  | <messageId>2  | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber>1 | <startDate> | 18:00     | <endDate> | <timeStamp> | <defendant> | judge name {{seq}} | prosecutor {{seq}} | defence {{seq}} |
  | <messageId>2  | <type> | <subType> | <documentName>3 | <courthouse> | <courtroom> | <caseNumber>1 | <startDate> | 18:00     | <endDate> | <timeStamp> | <defendant> | judge name {{seq}} | prosecutor {{seq}} | defence {{seq}} |
#TODO changed documentName from 1 to 3 due to defect
#  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>2" and unique_id = "<documentName>1"
  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>2" and unique_id = "<documentName>3"
# Daily list for tomorrow
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber    | startDate  | startTime | endDate    | timeStamp   | defendant   | judge               | prosecution         | defence          |
  | <messageId>9  | <type> | <subType> | <documentName>9 | <courthouse> | <courtroom> | <caseNumber>9 | {{date+1}} | 10:00     | {{date+1}} | <timeStamp> | <defendant> | judge name {{seq}}9 | prosecutor {{seq}}9 | defence {{seq}}9 |
  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>9" and unique_id = "<documentName>9"
  When I process the daily list for courthouse "<courthouse>"
   And I wait for case "<caseNumber>1" courthouse "<courthouse>"
#TODO changed documentName from 1 to 3 due to defect
#  Then I see table darts.daily_list column job_status is "PROCESSED" where message_id = "<messageId>2" and unique_id = "<documentName>1"
  Then I see table darts.daily_list column job_status is "PROCESSED" where message_id = "<messageId>2" and unique_id = "<documentName>3"
   And I see table darts.daily_list column job_status is "IGNORED" where message_id = "<messageId>1" and unique_id = "<documentName>2"
   And I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>9" and unique_id = "<documentName>9"
   And I select column cas.cas_id from table CASE_HEARING where courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and case_number = "<caseNumber>1"
   And I select column hea_id from table CASE_HEARING where cas.cas_id = "{{cas.cas_id}}" and hearing_date = "{{date-yyyymmdd-0}}"
   And I see table CASE_HEARING column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_HEARING_JUDGE column judge_name is "{{upper-case-judge name {{seq}}}}" where hea_id = "{{hea_id}}"
   And I see table CASE_JUDGE column judge_name is "{{upper-case-judge name {{seq}}}}" where cas_id = "{{cas.cas_id}}"
   And I see table darts.prosecutor column prosecutor_name is "prosecutor {{seq}}" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "defence {{seq}}" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column defendant_name is "<defendant>" where cas_id = "{{cas.cas_id}}"
   And I select column jud_id from table CASE_JUDGE where cas_id = "{{cas.cas_id}}"
# Daily list for second case today (will be processed)
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber    | startDate   | startTime | endDate   | timeStamp   | defendant               | judge              | prosecution        | defence        |
  | <messageId>3  | <type> | <subType> | <documentName>3 | <courthouse> | 2           | <caseNumber>3 | <startDate> | 13:00     | <endDate> | <timeStamp> | <caseNumber>3 defendant | judge name {{seq}} | prosecutor {{seq}} | defence {{seq}} |
  Then I see table darts.daily_list column job_status is "NEW" where message_id = "<messageId>3" and unique_id = "<documentName>3"
  When I process the daily list for courthouse "<courthouse>"
   And I wait for case "<caseNumber>3" courthouse "<courthouse>"
  Then I see table darts.daily_list column job_status is "PROCESSED" where message_id = "<messageId>3" and unique_id = "<documentName>3"
   And I select column cas.cas_id from table CASE_HEARING where courthouse_name = "<courthouse>" and courtroom_name = "2" and case_number = "<caseNumber>3"
   And I select column hea_id from table CASE_HEARING where cas.cas_id = "{{cas.cas_id}}" and hearing_date = "{{date-yyyymmdd-0}}"
   And I see table CASE_HEARING column case_closed is "f" where cas.cas_id = "{{cas.cas_id}}"
   And I see table CASE_HEARING_JUDGE column judge_name is "{{upper-case-judge name {{seq}}}}" where hea_id = "{{hea_id}}" and jud_id = "{{jud_id}}"
   And I see table CASE_JUDGE column judge_name is "{{upper-case-judge name {{seq}}}}" where cas_id = "{{cas.cas_id}}" and jud_id = "{{jud_id}}"
   And I see table darts.prosecutor column prosecutor_name is "prosecutor {{seq}}" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defence column defence_name is "defence {{seq}}" where cas_id = "{{cas.cas_id}}"
   And I see table darts.defendant column defendant_name is "<caseNumber>3 defendant" where cas_id = "{{cas.cas_id}}"
Examples:
  | source | messageId                      | type  | subType | documentName             | courthouse         | courtroom | caseNumber  | startDate    | startTime | endDate    | timeStamp     | defendant             |
  | XHIBIT | 58b211f5-426d-81be-00{{seq}}00 | DL    | DL      | DL {{date+0/}} {{seq}}00 | Harrow Crown Court | 1         | T{{seq}}101 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}101 defendant |
  | CPP    | 58b211f5-426d-81be-00{{seq}}01 | CPPDL | DL      | DL {{date+0/}} {{seq}}01 | Harrow Crown Court | 1         | T{{seq}}111 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}111 defendant |

	
@Daily_List @SOAP_API @DMP-2968 @regression @DAILY_LIST
Scenario: Daily List VIQ User fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f5-426d-81be-00{{seq}}001</messageId>
    			<type>DL</type>
    			<subType>DL</subType>
    			<document>
<![CDATA[<cs:DailyList xmlns:cs="http://www.courtservice.gov.uk/schemas/courtservice" xmlns:p2="http://www.govtalk.gov.uk/people/bs7666" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails">
    <cs:DocumentID>
        <cs:DocumentName>DailyList_467_{{numdate+0}}000001.xml</cs:DocumentName>
        <cs:UniqueID>CSDDL170974{{seq}}001</cs:UniqueID>
        <cs:DocumentType>DL</cs:DocumentType>
        <cs:TimeStamp>{{timestamp}}</cs:TimeStamp>
    </cs:DocumentID>
    <cs:ListHeader>
        <cs:ListCategory>Criminal</cs:ListCategory>
        <cs:StartDate>{{yyyymmdd}}</cs:StartDate>
        <cs:EndDate>{{yyyymmdd}}</cs:EndDate>
        <cs:Version>NOT VERSIONED</cs:Version>
        <cs:PublishedTime>{{timestamp}}</cs:PublishedTime>
    </cs:ListHeader>
    <cs:CrownCourt>
        <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
        <cs:CourtHouseCode CourtHouseShortName="YORK">467</cs:CourtHouseCode>
        <cs:CourtHouseName>YORK</cs:CourtHouseName>
    </cs:CrownCourt>
    <cs:CourtLists>
        <cs:CourtList>
            <cs:CourtHouse>
                <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
                <cs:CourtHouseCode>467</cs:CourtHouseCode>
                <cs:CourtHouseName>YORK</cs:CourtHouseName>
            </cs:CourtHouse>
            <cs:Sittings>
                <cs:Sitting>
                    <cs:CourtRoomNumber>1</cs:CourtRoomNumber>
                    <cs:SittingSequenceNo>1</cs:SittingSequenceNo>
                    <cs:SittingAt>10:30:00</cs:SittingAt>
                    <cs:SittingPriority>T</cs:SittingPriority>
                    <cs:Judiciary>
                        <cs:Judge>
                            <apd:CitizenNameForename>NONE</apd:CitizenNameForename>
                            <apd:CitizenNameSurname>NONE</apd:CitizenNameSurname>
                            <apd:CitizenNameRequestedName>NONE</apd:CitizenNameRequestedName>
                        </cs:Judge>
                    </cs:Judiciary>
                    <cs:Hearings>
                        <cs:Hearing>
                            <cs:HearingSequenceNumber>1</cs:HearingSequenceNumber>
                            <cs:HearingDetails HearingType="PLE">
                                <cs:HearingDescription>For Plea</cs:HearingDescription>
                                <cs:HearingDate>{{yyyymmdd}}</cs:HearingDate>
                            </cs:HearingDetails>
                            <cs:TimeMarkingNote>10:30 AM</cs:TimeMarkingNote>
                            <cs:CaseNumber>T{{seq}}010</cs:CaseNumber>
                            <cs:Prosecution ProsecutingAuthority="Other Prosecutor">
                                <cs:ProsecutingReference>Other Prosecutor</cs:ProsecutingReference>
                                <cs:ProsecutingOrganisation>
                                    <cs:OrganisationName>Other Prosecutor</cs:OrganisationName>
                                </cs:ProsecutingOrganisation>
                            </cs:Prosecution>
                            <cs:Defendants>
                                <cs:Defendant>
                                    <cs:PersonalDetails>
                                        <cs:Name>
                                            <apd:CitizenNameForename>Casper</apd:CitizenNameForename>
                                            <apd:CitizenNameSurname>Daugherty</apd:CitizenNameSurname>
                                            <apd:CitizenNameRequestedName>Casper Daugherty</apd:CitizenNameRequestedName>
                                        </cs:Name>
                                        <cs:IsMasked>no</cs:IsMasked>
                                    </cs:PersonalDetails>
                                    <cs:URN>50MD1811194</cs:URN>
                                    <cs:Charges>
                                        <cs:Charge IndictmentCountNumber="0" CJSoffenceCode="SA00002">
                                            <cs:OffenceStatement>Sex offences - abuse position of trust - engage in sexual activity</cs:OffenceStatement>
                                        </cs:Charge>
                                    </cs:Charges>
                                </cs:Defendant>
                            </cs:Defendants>
                        </cs:Hearing>
                    </cs:Hearings>
                </cs:Sitting>
            </cs:Sittings>
        </cs:CourtList>
    </cs:CourtLists>
</cs:DailyList>]]>
</document>
	"""
	Then the API status code is 500
	
@Daily_List @SOAP_API @DMP-2968 @regression @DAILY_LIST
Scenario: Daily List malformed fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f5-426d-81be-00{{seq}}001</messageId>
    			<type>DL</type>
    			<subType>DL</subType>
    			<document>
<![CDATA[<cs:DailyList xmlns:cs="http://www.courtservice.gov.uk/schemas/courtservice" xmlns:p2="http://www.govtalk.gov.uk/people/bs7666" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails">
    <cs:DocumentID>
        <cs:DocumentName>DailyList_467_{{numdate+0}}000001.xml</cs:DocumentName>
        <cs:UniqueID>CSDDL170974{{seq}}001</cs:UniqueID>
        <cs:DocumentType>DL</cs:DocumentType>
        <cs:TimeStamp>{{timestamp}}</cs:TimeStamp>
    </cs:DocumentID>
    <cs:ListHeader>
        <cs:ListCategory>Criminal</cs:ListCategory>
        <cs:StartDate>{{yyyymmdd}}</cs:StartDate>
        <cs:EndDate>{{yyyymmdd}}</cs:EndDate>
        <cs:Version>NOT VERSIONED</cs:Version>
        <cs:PublishedTime>{{timestamp}}</cs:PublishedTime>
    </cs:ListHeader>
    <cs:CrownCourt>
        <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
        <cs:CourtHouseCode CourtHouseShortName="YORK">467</cs:CourtHouseCode>
        <cs:CourtHouseName>YORK</cs:CourtHouseName>
    </cs:CrownCourt>
    <cs:CourtLists>
        <cs:CourtList>
            <cs:CourtHouse>
                <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
                <cs:CourtHouseCode>467</cs:CourtHouseCode>
                <cs:CourtHouseName>YORK</cs:CourtHouseName>
            </cs:CourtHouse>
            <cs:Sittings>
                <cs:Sitting>
                    <cs:CourtRoomNumber>1</cs:CourtRoomNumber>
                    <cs:SittingSequenceNo>1</cs:SittingSequenceNo>
                    <cs:SittingAt>10:30:00</cs:SittingAt>
                    <cs:SittingPriority>T</cs:SittingPriority>
                    <cs:Judiciary>
                        <cs:Judge>
                            <apd:CitizenNameForename>NONE</apd:CitizenNameForename>
                            <apd:CitizenNameSurname>NONE</apd:CitizenNameSurname>
                            <apd:CitizenNameRequestedName>NONE</apd:CitizenNameRequestedName>
                        </cs:Judge>
                    </cs:Judiciary>
                    <cs:Hearings>
                        <cs:Hearing>
                            <cs:HearingSequenceNumber>1</cs:HearingSequenceNumber>
                            <cs:HearingDetails HearingType="PLE">
                                <cs:HearingDescription>For Plea</cs:HearingDescription>
                                <cs:HearingDate>{{yyyymmdd}}</cs:HearingDate>
                            </cs:HearingDetails>
                            <cs:TimeMarkingNote>10:30 AM</cs:TimeMarkingNote>
                            <cs:CaseNumber>T{{seq}}010</cs:CaseNumber>
                            <cs:Prosecution ProsecutingAuthority="Other Prosecutor">
                                <cs:ProsecutingReference>Other Prosecutor</cs:ProsecutingReference>
                                <cs:ProsecutingOrganisation>
                                    <cs:OrganisationName>Other Prosecutor</cs:OrganisationName>
                                </cs:ProsecutingOrganisation>
                            </cs:Prosecution>
                            <cs:Defendants>
                                <cs:Defendant>
                                    <cs:PersonalDetails>
                                        <cs:Name>
                                            <apd:CitizenNameForename>Casper</apd:CitizenNameForename>
                                            <apd:CitizenNameSurname>Daugherty</apd:CitizenNameSurname>
                                            <apd:CitizenNameRequestedName>Casper Daugherty</apd:CitizenNameRequestedName>
                                        </cs:Name>
                                        <cs:IsMasked>no</cs:IsMasked>
                                    </cs:PersonalDetails>
                                    <cs:URN>50MD1811194</cs:URN>
                                    <cs:Charges>
                                        <cs:Charge IndictmentCountNumber="0" CJSoffenceCode="SA00002">
                                            <cs:OffenceStatement>Sex offences - abuse position of trust - engage in sexual activity</cs:OffenceStatement>
                                        </cs:Charge>
                                    </cs:Charges>
                                </cs:Defendant>
                            </cs:Defendants>
                        </cs:Hearing>
                    </cs:Hearings>
                </cs:Sitting>
            </cs:Sittings
        </cs:CourtList>
    </cs:CourtLists>
</cs:DailyList>]]>
</document>
	"""
	Then the API status code is 400
	
@Daily_List @SOAP_API @DMP-2968 @regression @DAILY_LIST
  @reads-and-writes-system-properties
Scenario: Daily List successful
  Given that courthouse "YORK" case "T{{seq}}110" does not exist
  Given I wait until there is not a daily list waiting for "YORK"
  Given I authenticate from the CPP source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f5-426d-81be-00{{seq}}001</messageId>
    			<type>DL</type>
    			<subType>DL</subType>
    			<document>
<![CDATA[<cs:DailyList xmlns:cs="http://www.courtservice.gov.uk/schemas/courtservice" xmlns:p2="http://www.govtalk.gov.uk/people/bs7666" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails">
    <cs:DocumentID>
        <cs:DocumentName>DailyList_467_{{numdate+0}}000001.xml</cs:DocumentName>
        <cs:UniqueID>CSDDL170974{{seq}}001</cs:UniqueID>
        <cs:DocumentType>DL</cs:DocumentType>
        <cs:TimeStamp>{{timestamp}}</cs:TimeStamp>
    </cs:DocumentID>
    <cs:ListHeader>
        <cs:ListCategory>Criminal</cs:ListCategory>
        <cs:StartDate>{{yyyymmdd}}</cs:StartDate>
        <cs:EndDate>{{yyyymmdd}}</cs:EndDate>
        <cs:Version>NOT VERSIONED</cs:Version>
        <cs:PublishedTime>{{timestamp}}</cs:PublishedTime>
    </cs:ListHeader>
    <cs:CrownCourt>
        <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
        <cs:CourtHouseCode CourtHouseShortName="YORK">467</cs:CourtHouseCode>
        <cs:CourtHouseName>YORK</cs:CourtHouseName>
    </cs:CrownCourt>
    <cs:CourtLists>
        <cs:CourtList>
            <cs:CourtHouse>
                <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
                <cs:CourtHouseCode>467</cs:CourtHouseCode>
                <cs:CourtHouseName>YORK</cs:CourtHouseName>
            </cs:CourtHouse>
            <cs:Sittings>
                <cs:Sitting>
                    <cs:CourtRoomNumber>1</cs:CourtRoomNumber>
                    <cs:SittingSequenceNo>1</cs:SittingSequenceNo>
                    <cs:SittingAt>10:30:00</cs:SittingAt>
                    <cs:SittingPriority>T</cs:SittingPriority>
                    <cs:Judiciary>
                        <cs:Judge>
                            <apd:CitizenNameForename>ignored</apd:CitizenNameForename>
                            <apd:CitizenNameSurname>ignored</apd:CitizenNameSurname>
                            <apd:CitizenNameRequestedName>judge name{{seq}}</apd:CitizenNameRequestedName>
                        </cs:Judge>
                    </cs:Judiciary>
                    <cs:Hearings>
                        <cs:Hearing>
                            <cs:HearingSequenceNumber>1</cs:HearingSequenceNumber>
                            <cs:HearingDetails HearingType="PLE">
                                <cs:HearingDescription>For Plea</cs:HearingDescription>
                                <cs:HearingDate>{{yyyymmdd}}</cs:HearingDate>
                            </cs:HearingDetails>
                            <cs:TimeMarkingNote>10:30 AM</cs:TimeMarkingNote>
                            <cs:CaseNumber>T{{seq}}110</cs:CaseNumber>
                            <cs:Prosecution ProsecutingAuthority="Other Prosecutor">
                                <cs:ProsecutingReference>Prosecution ref</cs:ProsecutingReference>
                                <cs:ProsecutingOrganisation>
                                    <cs:OrganisationName>Other Prosecutor</cs:OrganisationName>
                                </cs:ProsecutingOrganisation>
                <cs:Advocate>
                  <cs:PersonalDetails>
                    <cs:Name>
                      <apd:CitizenNameTitle>ignored</apd:CitizenNameTitle>
                      <apd:CitizenNameForename>PROSECUTOR</apd:CitizenNameForename>
                      <apd:CitizenNameSurname>SURNAME {{seq}}</apd:CitizenNameSurname>
                      <apd:CitizenNameSuffix>ignored</apd:CitizenNameSuffix>
                      <apd:CitizenNameRequestedName>ignored</apd:CitizenNameRequestedName>
                    </cs:Name>
                    <cs:MaskedName>String</cs:MaskedName>
                    <cs:IsMasked>yes</cs:IsMasked>
                    <cs:DateOfBirth>
                      <apd:BirthDate>1967-08-13</apd:BirthDate>
                      <apd:VerifiedBy>not verified</apd:VerifiedBy>
                    </cs:DateOfBirth>
                    <cs:Age>0</cs:Age>
                    <cs:Sex>unknown</cs:Sex>
                    <cs:Address>
                      <apd:Line>1 Address</apd:Line>
                      <apd:Line>2 Address</apd:Line>
                      <apd:PostCode>A0 0AA</apd:PostCode>
                    </cs:Address>
                  </cs:PersonalDetails>
                  <cs:ContactDetails>
                    <apd:Email EmailPreferred="yes" EmailUsage="work">
                      <apd:EmailAddress/>
                    </apd:Email>
                    <apd:Telephone TelPreferred="yes" TelMobile="yes" TelUse="work">
                      <apd:TelNationalNumber> </apd:TelNationalNumber>
                      <apd:TelExtensionNumber>0</apd:TelExtensionNumber>
                      <apd:TelCountryCode>0</apd:TelCountryCode>
                    </apd:Telephone>
                    <apd:Fax FaxPreferred="yes" FaxMobile="yes" FaxUse="work">
                      <apd:FaxNationalNumber> </apd:FaxNationalNumber>
                      <apd:FaxExtensionNumber>0</apd:FaxExtensionNumber>
                      <apd:FaxCountryCode>0</apd:FaxCountryCode>
                    </apd:Fax>
                  </cs:ContactDetails>
                  <cs:StartDate>1967-08-13</cs:StartDate>
                  <cs:EndDate>1967-08-13</cs:EndDate>
                </cs:Advocate>
                            </cs:Prosecution>
                            <cs:Defendants>
                                <cs:Defendant>
                                    <cs:PersonalDetails>
                                        <cs:Name>
                                            <apd:CitizenNameForename>Casper</apd:CitizenNameForename>
                                            <apd:CitizenNameSurname>Daugherty{{seq}}</apd:CitizenNameSurname>
                                            <apd:CitizenNameRequestedName>John Snow</apd:CitizenNameRequestedName>
                                        </cs:Name>
                                        <cs:IsMasked>no</cs:IsMasked>
                                    </cs:PersonalDetails>
                                    <cs:URN>T{{seq}}110</cs:URN>
                                    <cs:Charges>
                                        <cs:Charge IndictmentCountNumber="0" CJSoffenceCode="SA00002">
                                            <cs:OffenceStatement>Sex offences - abuse position of trust - engage in sexual activity</cs:OffenceStatement>
                                        </cs:Charge>
                                    </cs:Charges>
                  <cs:Counsel>
                    <cs:Advocate>
                      <cs:PersonalDetails>
                        <cs:Name>
                          <apd:CitizenNameTitle>Ms</apd:CitizenNameTitle>
                          <apd:CitizenNameForename>solicitor</apd:CitizenNameForename>
                          <apd:CitizenNameSurname>surname {{seq}}</apd:CitizenNameSurname>
                          <apd:CitizenNameSuffix></apd:CitizenNameSuffix>
                          <apd:CitizenNameRequestedName></apd:CitizenNameRequestedName>
                        </cs:Name>
                        <cs:MaskedName>String</cs:MaskedName>
                        <cs:IsMasked>yes</cs:IsMasked>
                        <cs:DateOfBirth>
                          <apd:BirthDate>1967-08-13</apd:BirthDate>
                          <apd:VerifiedBy>not verified</apd:VerifiedBy>
                        </cs:DateOfBirth>
                        <cs:Age>0</cs:Age>
                        <cs:Sex>unknown</cs:Sex>
                        <cs:Address>
                          <apd:Line></apd:Line>
                          <apd:Line></apd:Line>
                          <apd:PostCode>A0 0AA</apd:PostCode>
                        </cs:Address>
                      </cs:PersonalDetails>
                      <cs:ContactDetails>
                        <apd:Email EmailPreferred="yes" EmailUsage="work">
                          <apd:EmailAddress/>
                        </apd:Email>
                        <apd:Telephone TelPreferred="yes" TelMobile="yes" TelUse="work">
                          <apd:TelNationalNumber> </apd:TelNationalNumber>
                          <apd:TelExtensionNumber>0</apd:TelExtensionNumber>
                          <apd:TelCountryCode>0</apd:TelCountryCode>
                        </apd:Telephone>
                        <apd:Fax FaxPreferred="yes" FaxMobile="yes" FaxUse="work">
                          <apd:FaxNationalNumber> </apd:FaxNationalNumber>
                          <apd:FaxExtensionNumber>0</apd:FaxExtensionNumber>
                          <apd:FaxCountryCode>0</apd:FaxCountryCode>
                        </apd:Fax>
                      </cs:ContactDetails>
                      <cs:StartDate>1967-08-13</cs:StartDate>
                      <cs:EndDate>1967-08-13</cs:EndDate>
                    </cs:Advocate>
                  </cs:Counsel>
                                </cs:Defendant>
                            </cs:Defendants>
                        </cs:Hearing>
                    </cs:Hearings>
                </cs:Sitting>
            </cs:Sittings>
        </cs:CourtList>
    </cs:CourtLists>
</cs:DailyList>]]>
</document>
	"""
	Then the API status code is 200
   And I see table darts.daily_list column job_status is "NEW" where unique_id = "CSDDL170974{{seq}}001" and message_id = "58b211f5-426d-81be-00{{seq}}001"
  When I process the daily list for courthouse "YORK"
   And I wait for case "T{{seq}}110" courthouse "YORK"
  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "CSDDL170974{{seq}}001" and message_id = "58b211f5-426d-81be-00{{seq}}001"
   And I see table CASE_HEARING column case_closed is "f" where case_number = "T{{seq}}110" and courthouse_name = "YORK" and courtroom_name = "1"
  

	
@Daily_List @SOAP_API @DMP-2968 @regression @DAILY_LIST
  @reads-and-writes-system-properties
Scenario: Daily List successful with TimeMarkingNote 3:00 PM
  Given that courthouse "YORK" case "T{{seq}}120" does not exist
  Given I wait until there is not a daily list waiting for "YORK"
  Given I authenticate from the CPP source system
   And I see table darts.daily_list column count(job_status) is "0" where unique_id = "CSDDL170974{{seq}}002" and message_id = "58b211f5-426d-81be-00{{seq}}002"
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f5-426d-81be-00{{seq}}002</messageId>
    			<type>DL</type>
    			<subType>DL</subType>
    			<document>
<![CDATA[<cs:DailyList xmlns:cs="http://www.courtservice.gov.uk/schemas/courtservice" xmlns:p2="http://www.govtalk.gov.uk/people/bs7666" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails">
    <cs:DocumentID>
        <cs:DocumentName>DailyList_467_{{numdate+0}}000002.xml</cs:DocumentName>
        <cs:UniqueID>CSDDL170974{{seq}}002</cs:UniqueID>
        <cs:DocumentType>DL</cs:DocumentType>
        <cs:TimeStamp>{{timestamp}}</cs:TimeStamp>
    </cs:DocumentID>
    <cs:ListHeader>
        <cs:ListCategory>Criminal</cs:ListCategory>
        <cs:StartDate>{{yyyymmdd}}</cs:StartDate>
        <cs:EndDate>{{yyyymmdd}}</cs:EndDate>
        <cs:Version>NOT VERSIONED</cs:Version>
        <cs:PublishedTime>{{timestamp}}</cs:PublishedTime>
    </cs:ListHeader>
    <cs:CrownCourt>
        <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
        <cs:CourtHouseCode CourtHouseShortName="YORK">467</cs:CourtHouseCode>
        <cs:CourtHouseName>YORK</cs:CourtHouseName>
    </cs:CrownCourt>
    <cs:CourtLists>
        <cs:CourtList>
            <cs:CourtHouse>
                <cs:CourtHouseType>Crown Court</cs:CourtHouseType>
                <cs:CourtHouseCode>467</cs:CourtHouseCode>
                <cs:CourtHouseName>YORK</cs:CourtHouseName>
            </cs:CourtHouse>
            <cs:Sittings>
                <cs:Sitting>
                    <cs:CourtRoomNumber>1</cs:CourtRoomNumber>
                    <cs:SittingSequenceNo>1</cs:SittingSequenceNo>
                    <cs:SittingAt>13:30:00</cs:SittingAt>
                    <cs:SittingPriority>T</cs:SittingPriority>
                    <cs:Judiciary>
                        <cs:Judge>
                            <apd:CitizenNameForename>ignored</apd:CitizenNameForename>
                            <apd:CitizenNameSurname>ignored</apd:CitizenNameSurname>
                            <apd:CitizenNameRequestedName>judge name{{seq}}</apd:CitizenNameRequestedName>
                        </cs:Judge>
                    </cs:Judiciary>
                    <cs:Hearings>
                        <cs:Hearing>
                            <cs:HearingSequenceNumber>1</cs:HearingSequenceNumber>
                            <cs:HearingDetails HearingType="PLE">
                                <cs:HearingDescription>For Plea</cs:HearingDescription>
                                <cs:HearingDate>{{yyyymmdd}}</cs:HearingDate>
                            </cs:HearingDetails>
                            <cs:TimeMarkingNote>3:00 PM</cs:TimeMarkingNote>
                            <cs:CaseNumber>T{{seq}}120</cs:CaseNumber>
                            <cs:Prosecution ProsecutingAuthority="Other Prosecutor">
                                <cs:ProsecutingReference>Prosecution ref</cs:ProsecutingReference>
                                <cs:ProsecutingOrganisation>
                                    <cs:OrganisationName>Other Prosecutor</cs:OrganisationName>
                                </cs:ProsecutingOrganisation>
                <cs:Advocate>
                  <cs:PersonalDetails>
                    <cs:Name>
                      <apd:CitizenNameTitle>ignored</apd:CitizenNameTitle>
                      <apd:CitizenNameForename>PROSECUTOR</apd:CitizenNameForename>
                      <apd:CitizenNameSurname>SURNAME {{seq}}</apd:CitizenNameSurname>
                      <apd:CitizenNameSuffix>ignored</apd:CitizenNameSuffix>
                      <apd:CitizenNameRequestedName>ignored</apd:CitizenNameRequestedName>
                    </cs:Name>
                    <cs:MaskedName>String</cs:MaskedName>
                    <cs:IsMasked>yes</cs:IsMasked>
                    <cs:DateOfBirth>
                      <apd:BirthDate>1967-08-13</apd:BirthDate>
                      <apd:VerifiedBy>not verified</apd:VerifiedBy>
                    </cs:DateOfBirth>
                    <cs:Age>0</cs:Age>
                    <cs:Sex>unknown</cs:Sex>
                    <cs:Address>
                      <apd:Line>1 Address</apd:Line>
                      <apd:Line>2 Address</apd:Line>
                      <apd:PostCode>A0 0AA</apd:PostCode>
                    </cs:Address>
                  </cs:PersonalDetails>
                  <cs:ContactDetails>
                    <apd:Email EmailPreferred="yes" EmailUsage="work">
                      <apd:EmailAddress/>
                    </apd:Email>
                    <apd:Telephone TelPreferred="yes" TelMobile="yes" TelUse="work">
                      <apd:TelNationalNumber> </apd:TelNationalNumber>
                      <apd:TelExtensionNumber>0</apd:TelExtensionNumber>
                      <apd:TelCountryCode>0</apd:TelCountryCode>
                    </apd:Telephone>
                    <apd:Fax FaxPreferred="yes" FaxMobile="yes" FaxUse="work">
                      <apd:FaxNationalNumber> </apd:FaxNationalNumber>
                      <apd:FaxExtensionNumber>0</apd:FaxExtensionNumber>
                      <apd:FaxCountryCode>0</apd:FaxCountryCode>
                    </apd:Fax>
                  </cs:ContactDetails>
                  <cs:StartDate>1967-08-13</cs:StartDate>
                  <cs:EndDate>1967-08-13</cs:EndDate>
                </cs:Advocate>
                            </cs:Prosecution>
                            <cs:Defendants>
                                <cs:Defendant>
                                    <cs:PersonalDetails>
                                        <cs:Name>
                                            <apd:CitizenNameForename>Casper</apd:CitizenNameForename>
                                            <apd:CitizenNameSurname>Daugherty{{seq}}</apd:CitizenNameSurname>
                                            <apd:CitizenNameRequestedName>John Snow</apd:CitizenNameRequestedName>
                                        </cs:Name>
                                        <cs:IsMasked>no</cs:IsMasked>
                                    </cs:PersonalDetails>
                                    <cs:URN>T{{seq}}110</cs:URN>
                                    <cs:Charges>
                                        <cs:Charge IndictmentCountNumber="0" CJSoffenceCode="SA00002">
                                            <cs:OffenceStatement>Sex offences - abuse position of trust - engage in sexual activity</cs:OffenceStatement>
                                        </cs:Charge>
                                    </cs:Charges>
                  <cs:Counsel>
                    <cs:Advocate>
                      <cs:PersonalDetails>
                        <cs:Name>
                          <apd:CitizenNameTitle>Ms</apd:CitizenNameTitle>
                          <apd:CitizenNameForename>solicitor</apd:CitizenNameForename>
                          <apd:CitizenNameSurname>surname {{seq}}</apd:CitizenNameSurname>
                          <apd:CitizenNameSuffix></apd:CitizenNameSuffix>
                          <apd:CitizenNameRequestedName></apd:CitizenNameRequestedName>
                        </cs:Name>
                        <cs:MaskedName>String</cs:MaskedName>
                        <cs:IsMasked>yes</cs:IsMasked>
                        <cs:DateOfBirth>
                          <apd:BirthDate>1967-08-13</apd:BirthDate>
                          <apd:VerifiedBy>not verified</apd:VerifiedBy>
                        </cs:DateOfBirth>
                        <cs:Age>0</cs:Age>
                        <cs:Sex>unknown</cs:Sex>
                        <cs:Address>
                          <apd:Line></apd:Line>
                          <apd:Line></apd:Line>
                          <apd:PostCode>A0 0AA</apd:PostCode>
                        </cs:Address>
                      </cs:PersonalDetails>
                      <cs:ContactDetails>
                        <apd:Email EmailPreferred="yes" EmailUsage="work">
                          <apd:EmailAddress/>
                        </apd:Email>
                        <apd:Telephone TelPreferred="yes" TelMobile="yes" TelUse="work">
                          <apd:TelNationalNumber> </apd:TelNationalNumber>
                          <apd:TelExtensionNumber>0</apd:TelExtensionNumber>
                          <apd:TelCountryCode>0</apd:TelCountryCode>
                        </apd:Telephone>
                        <apd:Fax FaxPreferred="yes" FaxMobile="yes" FaxUse="work">
                          <apd:FaxNationalNumber> </apd:FaxNationalNumber>
                          <apd:FaxExtensionNumber>0</apd:FaxExtensionNumber>
                          <apd:FaxCountryCode>0</apd:FaxCountryCode>
                        </apd:Fax>
                      </cs:ContactDetails>
                      <cs:StartDate>1967-08-13</cs:StartDate>
                      <cs:EndDate>1967-08-13</cs:EndDate>
                    </cs:Advocate>
                  </cs:Counsel>
                                </cs:Defendant>
                            </cs:Defendants>
                        </cs:Hearing>
                    </cs:Hearings>
                </cs:Sitting>
            </cs:Sittings>
        </cs:CourtList>
    </cs:CourtLists>
</cs:DailyList>]]>
</document>
	"""
	Then the API status code is 200
   And I see table darts.daily_list column job_status is "NEW" where unique_id = "CSDDL170974{{seq}}002" and message_id = "58b211f5-426d-81be-00{{seq}}002"
  When I process the daily list for courthouse "YORK"
   And I wait for case "T{{seq}}120" courthouse "YORK"
  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "CSDDL170974{{seq}}002" and message_id = "58b211f5-426d-81be-00{{seq}}002"
   And I see table CASE_HEARING column case_closed is "f" where case_number = "T{{seq}}120" and courthouse_name = "YORK" and courtroom_name = "1"
  
  