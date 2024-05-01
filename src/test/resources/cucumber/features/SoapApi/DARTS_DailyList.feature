Feature: Cases EndPoint using SOAP

#
# n.b. for CPP, case number is held in the URN field
#
	
@Daily_List @SOAP_API @DMP-2968
Scenario Outline: Daily List Single Case Scenario - lists for today and tomorrow
		First is replaced
		Second is ignored when processed
		Third is processed & create a case
		Daily list for tomorrow is not processed today
  Given I authenticate from the <source> source system
# First daily list for today
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber   | startDate   | startTime | endDate   | timeStamp   | defendant   |
  | <messageId>1  | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 16:00     | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>1"
# Overwrite first daily list for today
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber   | startDate   | startTime | endDate   | timeStamp   | defendant   |
  | <messageId>1  | <type> | <subType> | <documentName>2 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 17:00     | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>2" and message_id = "<messageId>1"
# Second daily list for today
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber   | startDate   | startTime | endDate   | timeStamp   | defendant   |
  | <messageId>2  | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 18:00     | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>2"
# Daily list for tomorrow
  When I add a daily list
  | messageId     | type   | subType   | documentName    | courthouse   | courtroom   | caseNumber   | startDate  | startTime | endDate   | timeStamp   | defendant   |
  | <messageId>3  | <type> | <subType> | <documentName>3 | <courthouse> | <courtroom> | <caseNumber> | {{date+1}} | 10:00     | {{date+1}} | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>3" and message_id = "<messageId>3"
  When I process the daily list for courthouse <courthouse>
  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "<documentName>1" and message_id = "<messageId>2"
   And I see table darts.daily_list column job_status is "IGNORED" where unique_id = "<documentName>2" and message_id = "<messageId>1"
   And I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>3" and message_id = "<messageId>3"
   And I see table CASE_HEARING column case_closed is "f" where case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
Examples:
  | source | messageId                      | type  | subType | documentName             | courthouse         | courtroom | caseNumber  | startDate    | startTime | endDate    | timeStamp     | defendant             |
  | XHIBIT | 58b211f4-426d-81be-00{{seq}}00 | DL    | DL      | DL {{date+0/}} {{seq}}00 | Harrow Crown Court | 1         | T{{seq}}101 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}101 defendant |
  | CPP    | 58b211f4-426d-81be-00{{seq}}01 | CPPDL | DL      | DL {{date+0/}} {{seq}}01 | Harrow Crown Court | 1         | T{{seq}}111 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}111 defendant |

	
@Daily_List @SOAP_API @DMP-2968
Scenario: Daily List VIQ User fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f4-426d-81be-000{{seq}}001</messageId>
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
	
@Daily_List @SOAP_API @DMP-2968
Scenario: Daily List malformed fails
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f4-426d-81be-000{{seq}}001</messageId>
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
	
@Daily_List @SOAP_API @DMP-2968
Scenario: Daily List successful
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
   			<messageId>58b211f4-426d-81be-000{{seq}}001</messageId>
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
	Then the API status code is 200
   And I see table darts.daily_list column job_status is "NEW" where unique_id = "CSDDL170974{{seq}}001" and message_id = "58b211f4-426d-81be-000{{seq}}001"
  When I process the daily list for courthouse "York"
  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "CSDDL170974{{seq}}001" and message_id = "58b211f4-426d-81be-000{{seq}}001"
   And I see table CASE_HEARING column case_closed is "f" where case_number = "T{{seq}}010" and courthouse_name = "York" and courtroom_name = "1"
  
