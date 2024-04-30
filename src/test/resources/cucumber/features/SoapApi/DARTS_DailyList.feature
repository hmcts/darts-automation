Feature: Cases EndPoint using SOAP

#
# n.b. for CPP, case number is held in the URN field
#
	
@Daily_List1 @SOAP_API @DMP-2968
Scenario Outline: Daily List Single Case Scenario
  Given I authenticate from the <source> source system
  When I add a daily list
  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
  | <messageId>1 | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 16:00 | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>1"
  When I add a daily list
  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
  | <messageId>1 | <type> | <subType> | <documentName>2 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 17:00 | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>2" and message_id = "<messageId>1"
  When I add a daily list
  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
  | <messageId>2 | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 18:00 | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>2"
  When I process the daily list for courthouse <courthouse>
  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "<documentName>1" and message_id = "<messageId>2"
  Then I see table darts.daily_list column job_status is "IGNORED" where unique_id = "<documentName>2" and message_id = "<messageId>1"
  Then I see table CASE_HEARING column case_closed is "f" where case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
Examples:
  | source | messageId                      | type  | subType | documentName             | courthouse         | courtroom | caseNumber  | startDate    | startTime | endDate    | timeStamp     | defendant             |
  | XHIBIT | 58b211f4-426d-81be-00{{seq}}00 | DL    | DL      | DL {{date+0/}} {{seq}}00 | Harrow Crown Court | 1         | T{{seq}}101 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}101 defendant |
#  | CPP    | 58b211f4-426d-81be-00{{seq}}01 | CPPDL | DL      | DL {{date+0/}} {{seq}}01 | Harrow Crown Court | 1         | T{{seq}}111 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}111 defendant |

	
@Daily_List2 @SOAP_API @DMP-2968
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
	
@Daily_List3 @SOAP_API @DMP-2968
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
	
@Daily_List4 @SOAP_API @DMP-2968
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
   And I process the daily list for courthouse "York"
	

	
@Daily_List6 @SOAP_API @DMP-2968
Scenario Outline: Daily List Single Case Scenario
  Given I authenticate from the <source> source system
  When I add a daily list
  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
  | <messageId>1 | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 16:00 | <endDate> | <timeStamp> | <defendant> |
  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>1"
#  When I add a daily list
#  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
#  | <messageId>1 | <type> | <subType> | <documentName>2 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 17:00 | <endDate> | <timeStamp> | <defendant> |
#  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>2" and message_id = "<messageId>1"
#  When I add a daily list
#  | messageId     | type   | subType   | documentName      | courthouse   | courtroom   | caseNumber   | startDate   | startTime   | endDate   | timeStamp   | defendant   |
#  | <messageId>2 | <type> | <subType> | <documentName>1 | <courthouse> | <courtroom> | <caseNumber> | <startDate> | 18:00 | <endDate> | <timeStamp> | <defendant> |
#  Then I see table darts.daily_list column job_status is "NEW" where unique_id = "<documentName>1" and message_id = "<messageId>2"
  When I process the daily list for courthouse <courthouse>
#  Then I see table darts.daily_list column job_status is "PROCESSED" where unique_id = "<documentName>1" and message_id = "<messageId>2"
#  Then I see table darts.daily_list column job_status is "IGNORED" where unique_id = "<documentName>2" and message_id = "<messageId>1"
  Then I see table CASE_HEARING column case_closed is "f" where case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
Examples:
  | source | messageId                      | type  | subType | documentName             | courthouse         | courtroom | caseNumber  | startDate    | startTime | endDate    | timeStamp     | defendant             |
  | XHIBIT | 58b211f4-426d-81be-00{{seq}}00 | DL    | DL      | DL{{numdate+0}}A{{seq}}00 | York               | 1         | T{{seq}}101 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp-01:00:00}} | T{{seq}}101 defendant |
#  | CPP    | 58b211f4-426d-81be-00{{seq}}01 | CPPDL | DL      | DL {{date+0/}} {{seq}}01 | Harrow Crown Court | 1         | T{{seq}}111 | {{date+0}}   | 10:00:00  | {{date+0}} | {{timestamp}} | T{{seq}}111 defendant |


	
@Daily_List7 @SOAP_API @DMP-2968
Scenario: Daily List successful
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
	      <messageId>58b211f4-426d-81be-009324001</messageId>
      <type>DL</type>
      <subType>DL</subType>
      <document>
  &lt;cs:DailyList xmlns:cs="http://www.courtservice.gov.uk/schemas/courtservice" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.courtservice.gov.uk/schemas/courtservice DailyList-v5-2.xsd" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails"&gt;
    &lt;cs:DocumentID&gt;
      &lt;cs:DocumentName&gt;DL290420249324001&lt;/cs:DocumentName&gt;
      &lt;cs:UniqueID&gt;DL290420249324001&lt;/cs:UniqueID&gt;
      &lt;cs:DocumentType&gt;DL&lt;/cs:DocumentType&gt;
      &lt;cs:TimeStamp&gt;2024-04-29T15:06:01.055+01:00&lt;/cs:TimeStamp&gt;
      &lt;cs:Version&gt;1.0&lt;/cs:Version&gt;
      &lt;cs:SecurityClassification&gt;NPM&lt;/cs:SecurityClassification&gt;
      &lt;cs:SellByDate&gt;2010-12-15&lt;/cs:SellByDate&gt;
      &lt;cs:XSLstylesheetURL&gt;http://www.courtservice.gov.uk/transforms/courtservice/dailyListHtml.xsl&lt;/cs:XSLstylesheetURL&gt;
    &lt;/cs:DocumentID&gt;
    &lt;cs:ListHeader&gt;
      &lt;cs:ListCategory&gt;Criminal&lt;/cs:ListCategory&gt;
      &lt;cs:StartDate&gt;2024-04-29&lt;/cs:StartDate&gt;
      &lt;cs:EndDate&gt;2024-04-29&lt;/cs:EndDate&gt;
      &lt;cs:Version&gt;FINAL v1&lt;/cs:Version&gt;
      &lt;cs:CRESTprintRef&gt;MCD/112585&lt;/cs:CRESTprintRef&gt;
      &lt;cs:PublishedTime&gt;2024-04-29T15:06:01.055Z&lt;/cs:PublishedTime&gt;
      &lt;cs:CRESTlistID&gt;12298&lt;/cs:CRESTlistID&gt;
    &lt;/cs:ListHeader&gt;
    &lt;cs:CrownCourt&gt;
      &lt;cs:CourtHouseType&gt;Crown Court&lt;/cs:CourtHouseType&gt;
      &lt;cs:CourtHouseCode CourtHouseShortName="YORK"&gt;467&lt;/cs:CourtHouseCode&gt;
      &lt;cs:CourtHouseName&gt;YORK&lt;/cs:CourtHouseName&gt;
    &lt;/cs:CrownCourt&gt;
    &lt;cs:CourtLists&gt;
      &lt;cs:CourtList&gt;
        &lt;cs:CourtHouse&gt;
          &lt;cs:CourtHouseType&gt;Crown Court&lt;/cs:CourtHouseType&gt;
          &lt;cs:CourtHouseCode&gt;467&lt;/cs:CourtHouseCode&gt;
          &lt;cs:CourtHouseName&gt;YORK&lt;/cs:CourtHouseName&gt;
        &lt;/cs:CourtHouse&gt;
        &lt;cs:Sittings&gt;
          &lt;cs:Sitting&gt;
            &lt;cs:CourtRoomNumber&gt;1&lt;/cs:CourtRoomNumber&gt;
            &lt;cs:SittingSequenceNo&gt;1&lt;/cs:SittingSequenceNo&gt;
            &lt;cs:SittingAt&gt;16:00:00&lt;/cs:SittingAt&gt;
            &lt;cs:SittingPriority&gt;T&lt;/cs:SittingPriority&gt;
            &lt;cs:Judiciary&gt;
              &lt;cs:Judge&gt;
                &lt;apd:CitizenNameForeame&gt;Judge N1&lt;/apd:CitizenNameForeame&gt;
                &lt;apd:CitizenNameSurname&gt;Judge N3&lt;/apd:CitizenNameSurname&gt;
                &lt;apd:CitizenNameRequestedName&gt;Judge N2&lt;/apd:CitizenNameRequestedName&gt;
                &lt;cs:CRESTjudgeID&gt;0&lt;/cs:CRESTjudgeID&gt;
              &lt;/cs:Judge&gt;
            &lt;/cs:Judiciary&gt;
            &lt;cs:Hearings&gt;
              &lt;cs:Hearing&gt;
                &lt;cs:HearingSequenceNumber&gt;1&lt;/cs:HearingSequenceNumber&gt;
                &lt;cs:HearingDetails HearingType="TRL"&gt;
                  &lt;cs:HearingDescription&gt;For Trial&lt;/cs:HearingDescription&gt;
                  &lt;cs:HearingDate&gt;2024-04-29&lt;/cs:HearingDate&gt;
                &lt;/cs:HearingDetails&gt;
                &lt;cs:CRESThearingID&gt;1&lt;/cs:CRESThearingID&gt;
                &lt;cs:TimeMarkingNote&gt;16:00 AM&lt;/cs:TimeMarkingNote&gt;
                &lt;cs:CaseNumber&gt;T9324102&lt;/cs:CaseNumber&gt;
                &lt;cs:Prosecution ProsecutingAuthority="Crown Prosecution Service"&gt;
                  &lt;cs:ProsecutingReference&gt;CPS&lt;/cs:ProsecutingReference&gt;
                  &lt;cs:ProsecutingOrganisation&gt;
                    &lt;cs:OrganisationName&gt;Crown Prosecution Service&lt;/cs:OrganisationName&gt;
                  &lt;/cs:ProsecutingOrganisation&gt;
                &lt;/cs:Prosecution&gt;
                &lt;cs:Defendants&gt;
                  &lt;cs:Defendant&gt;
                    &lt;cs:PersonalDetails&gt;
                      &lt;cs:Name&gt;
                        &lt;apd:CitizenNameForename&gt;Franz&lt;/apd:CitizenNameForename&gt;
                        &lt;apd:CitizenNameSurname&gt;KAFKA&lt;/apd:CitizenNameSurname&gt;
                      &lt;/cs:Name&gt;
                      &lt;cs:IsMasked&gt;no&lt;/cs:IsMasked&gt;
                      &lt;cs:DateOfBirth&gt;
                        &lt;apd:BirthDate&gt;1962-06-12&lt;/apd:BirthDate&gt;
                        &lt;apd:VerifiedBy&gt;not verified&lt;/apd:VerifiedBy&gt;
                      &lt;/cs:DateOfBirth&gt;
                      &lt;cs:Sex&gt;male&lt;/cs:Sex&gt;
                      &lt;cs:Address&gt;
                        &lt;apd:Line&gt;ADDRESS LINE 1&lt;/apd:Line&gt;
                        &lt;apd:Line&gt;ADDRESS LINE 2&lt;/apd:Line&gt;
                        &lt;apd:Line&gt;ADDRESS LINE 3&lt;/apd:Line&gt;
                        &lt;apd:Line&gt;ADDRESS LINE 4&lt;/apd:Line&gt;
                        &lt;apd:Line&gt;SOMETOWN, SOMECOUNTY&lt;/apd:Line&gt;
                        &lt;apd:PostCode&gt;GU12 7RT&lt;/apd:PostCode&gt;
                      &lt;/cs:Address&gt;
                    &lt;/cs:PersonalDetails&gt;
                    &lt;cs:ASNs&gt;
                      &lt;cs:ASN&gt;0723XH1000000262665K&lt;/cs:ASN&gt;
                    &lt;/cs:ASNs&gt;
                    &lt;cs:CRESTdefendantID&gt;29161&lt;/cs:CRESTdefendantID&gt;
                    &lt;cs:PNCnumber&gt;20123456789L&lt;/cs:PNCnumber&gt;
                    &lt;cs:URN&gt;T9324101&lt;/cs:URN&gt;
                    &lt;cs:CustodyStatus&gt;In custody&lt;/cs:CustodyStatus&gt;
                  &lt;/cs:Defendant&gt;
                &lt;/cs:Defendants&gt;
              &lt;/cs:Hearing&gt;
            &lt;/cs:Hearings&gt;
          &lt;/cs:Sitting&gt;
        &lt;/cs:Sittings&gt;
      &lt;/cs:CourtList&gt;
    &lt;/cs:CourtLists&gt;
  &lt;/cs:DailyList&gt;
</document>
	"""
	Then the API status code is 200
   And I process the daily list for courthouse "YORK"
	