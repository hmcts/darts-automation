package uk.gov.hmcts.darts.automation.utils;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import io.restassured.path.xml.*;

import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class XmlUtils {
	private static Logger log = LogManager.getLogger("XmlUtils");
	private static String LINE_END = System.lineSeparator();
	
	public XmlUtils() {
		
	}
	
	public static String extractXmlValue(String xml, String path) {
		String returnValue = "";
		XmlPath xmlPath = new XmlPath(xml);
		returnValue = xmlPath.getString(path);
		log.info("xml at {} is {}", path, returnValue);
		return returnValue;
	}
    
    public static String buildAddEventXml(String messageId,
    		String type,
    		String subType,
    		String eventId,
    		String courthouse,
    		String courtroom,
    		String caseNumbers,
    		String eventText,
    		String dateTime,
    		String caseRetentionFixedPolicy,
    		String caseTotalSentence) {
    	XmlString xmlString = new XmlString()
    			.addTag("messageId", messageId)
    			.addTag("type", type)
    			.addTag("subType", subType)
    			.addTag("document")
				.startEncoding()
				.addTag("be:DartsEvent")
    			.addAttribute("xmlns:be", "urn:integration-cjsonline-gov-uk:pilot:entities")
    			.addAttribute("ID", eventId)
    			.addAttribute("Y", DateUtils.datePart(dateTime, "Y"))
				.addAttribute("M", DateUtils.datePart(dateTime, "M"))
				.addAttribute("D", DateUtils.datePart(dateTime, "D"))
    			.addAttribute("H", DateUtils.timePart(dateTime, "H"))
				.addAttribute("MIN", DateUtils.timePart(dateTime, "MIN"))
				.addAttribute("S", DateUtils.timePart(dateTime, "S"))
				.addTag("be:CourtHouse", courthouse)
    			.addTag("be:CourtRoom", courtroom)
    			.addTagGroup("be:CaseNumbers", "be:CaseNumber", caseNumbers)
    			.addTag("be:EventText", eventText);
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		xmlString.addTag("be:RetentionPolicy");
    		xmlString.addTag("be:CaseRetentionFixedPolicy", caseRetentionFixedPolicy);
    		xmlString.addTag("be:CaseTotalSentence", caseTotalSentence);
    		xmlString.addEndTag();
    	}
		xmlString.addEndTag();
    	xmlString.endEncoding()
    			.addEndTag();
		return xmlString.xmlValue();
    }
    
    public static String buildAddCaseXml(String courthouse,
    		String courtroom,
    		String caseNumber,
    		String defendants,
    		String judges,
    		String prosecutors,
    		String defenders) {
    	XmlString xmlString = new XmlString()
				.addTag("case")
				.addAttribute("type", "")
				.addAttribute("id", caseNumber)
				.addTag("courthouse", courthouse)
				.addTag("courthouse", courtroom)
				.addTagGroup("defendants", "defendant", defendants, "~")
				.addTagGroup("judges", "judge", judges, "~")
				.addTagGroup("prosecutors", "prosecutor", prosecutors, "~")
	    		.addTagGroup("defenders", "defender", defenders, "~");
		return xmlString.xmlValue();
    }
    
    public static String buildAddLogXml(String courthouse,
    		String courtroom,
    		String caseNumbers,
    		String text,
    		String dateTime) {
    	XmlString xmlString = new XmlString()
    			.addTag("log_entry")
    			.addAttribute("Y", DateUtils.datePart(dateTime, "Y"))
				.addAttribute("M", DateUtils.datePart(dateTime, "M"))
				.addAttribute("D", DateUtils.datePart(dateTime, "D"))
    			.addAttribute("H", DateUtils.timePart(dateTime, "H"))
				.addAttribute("MIN", DateUtils.timePart(dateTime, "MIN"))
				.addAttribute("S", DateUtils.timePart(dateTime, "S"))
				.addTag("courthouse", courthouse)
    			.addTag("courtroom", courtroom)
    			.addTagGroup("case_numbers", "case_number", caseNumbers)
    			.addTag("text", text)
    			.addEndTag();
		return xmlString.xmlValue();
    }
    
    public static String buildGetLogXml(String courthouse,
    		String caseNumber,
    		String startTime,
    		String endTime) {
    	XmlString xmlString = new XmlString()
    			.addTag("getCourtLog")
    			.addAttribute("xmlns", "http://com.synapps.mojdarts.service.com")
				.addTag("courthouse")
				.addAttribute("xmlns", "")
				.addValue(courthouse)
    			.addTag("caseNumber")
				.addAttribute("xmlns", "")
    			.addValue(caseNumber)
    			.addTag("startTime")
				.addAttribute("xmlns", "")
    			.addValue(DateUtils.makeNumericDateTime(startTime))
    			.addTag("endTime")
				.addAttribute("xmlns", "")
    			.addValue(DateUtils.makeNumericDateTime(endTime))
    			.addEndTag();
		return xmlString.xmlValue();
    }
    
    public static String buildAddDailyListXml(String messageId,
    		String type,
    		String subType,
    		String documentName,
    		String courthouse,
    		String courtroom,
    		String caseNumber,
    		String startDate,
    		String startTime,
    		String endDate,
    		String timeStamp,
    		String defendant,
    		String urn) {
    	XmlString xmlString = new XmlString()
    			.addTag("messageId", messageId)
    			.addTag("type", type)
    			.addTag("subType", subType)
//    			.useLineEnd(false)
    			.addTag("document")
				.startEncoding()
					.addTag("cs:DailyList")
	    			.addAttribute("xmlns:cs", "http://www.courtservice.gov.uk/schemas/courtservice")
	    			.addAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
	    			.addAttribute("xsi:schemaLocation", "http://www.courtservice.gov.uk/schemas/courtservice DailyList-v5-2.xsd")
	    			.addAttribute("xmlns:apd", "http://www.govtalk.gov.uk/people/AddressAndPersonalDetails")
						.addTag("cs:DocumentID")
							.addTag("cs:DocumentName", documentName)
							.addTag("cs:UniqueID", documentName)
							.addTag("cs:DocumentType", "DL")
							.addTag("cs:TimeStamp", timeStamp)
							.addTag("cs:Version", "1.0")
							.addTag("cs:SecurityClassification", "NPM")
							.addTag("cs:SellByDate", "2010-12-15")
							.addTag("cs:XSLstylesheetURL", "http://www.courtservice.gov.uk/transforms/courtservice/dailyListHtml.xsl")
						.addEndTag()
						.addTag("cs:ListHeader")
							.addTag("cs:ListCategory", "Criminal")
							.addTag("cs:StartDate", DateUtils.dateAsYyyyMmDd(startDate))
							.addTag("cs:EndDate", DateUtils.dateAsYyyyMmDd(endDate))
							.addTag("cs:Version", "FINAL v1")
							.addTag("cs:CRESTprintRef", "MCD/112585")
							.addTag("cs:PublishedTime", timeStamp)
							.addTag("cs:CRESTlistID", "12298")
						.addEndTag();
		switch (courthouse.toLowerCase()) {
		case "bath":
	    	xmlString.addTag("cs:CrownCourt")
					.addTag("cs:CourtHouseType", "Crown Court")
					.addTag("cs:CourtHouseCode")
					.addAttribute("CourtHouseShortName", "BATH")
					.addValue("1122334455")
					.addTag("cs:CourtHouseName", "Bath")
					.addTag("cs:CourtHouseAddress")
					.addTag("apd:Line", "THE CROWN COURT AT BATH")
					.addTag("apd:Line", "Wharf Rd")
					.addTag("apd:Line", "Frimley Green")
					.addTag("apd:Line", "Camberley")
					.addTag("apd:PostCode", "GU16 6PT")
				.addEndTag()
				.addTag("cs:CourtHouseDX", "DX 12345 BATH")
					.addTag("cs:CourtHouseTelephone", "01252 836464")
					.addTag("cs:CourtHouseFax", "01252 836464")
				.addEndTag()
				.addTag("cs:CourtLists")
					.addTag("cs:CourtList")
						.addTag("cs:CourtHouse")
							.addTag("cs:CourtHouseType", "Crown Court")
							.addTag("cs:CourtHouseCode", "1122334455")
							.addTag("cs:CourtHouseName", "Bath")
						.addEndTag();
	    	break;
		case "swansea":
	    	xmlString.addTag("cs:CrownCourt")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode")
						.addAttribute("CourtHouseShortName", "SWANSEA")
						.addValue("1122334455")
						.addTag("cs:CourtHouseName", "Swansea")
						.addTag("cs:CourtHouseAddress")
						.addTag("apd:Line", "THE CROWN COURT AT SWANSEA")
						.addTag("apd:Line", "Wharf Rd")
						.addTag("apd:Line", "Frimley Green")
						.addTag("apd:Line", "Camberley")
						.addTag("apd:PostCode", "GU16 6PT")
						.addEndTag()
						.addTag("cs:CourtHouseDX", "DX 12345 SWANSEA")
						.addTag("cs:CourtHouseTelephone", "01252 836464")
						.addTag("cs:CourtHouseFax", "01252 836464")
						.addEndTag()
						.addTag("cs:CourtLists")
						.addTag("cs:CourtList")
						.addTag("cs:CourtHouse")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode", "1122334455")
						.addTag("cs:CourtHouseName", "Swansea")
						.addEndTag();
	    	break;
		case "lake":
	    	xmlString.addTag("cs:CrownCourt")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode")
						.addAttribute("CourtHouseShortName", "LAKE")
						.addValue("1122334455")
						.addTag("cs:CourtHouseName", "Lakeside Country Club")
						.addTag("cs:CourtHouseAddress")
							.addTag("apd:Line", "THE CROWN COURT AT LAKESIDE")
							.addTag("apd:Line", "Wharf Rd")
							.addTag("apd:Line", "Frimley Green")
							.addTag("apd:Line", "Camberley")
							.addTag("apd:PostCode", "GU16 6PT")
						.addEndTag()
						.addTag("cs:CourtHouseDX", "DX 12345 LAKESIDE")
						.addTag("cs:CourtHouseTelephone", "01252 836464")
						.addTag("cs:CourtHouseFax", "01252 836464")
						.addEndTag()
						.addTag("cs:CourtLists")
						.addTag("cs:CourtList")
						.addTag("cs:CourtHouse")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode", "1122334455")
						.addTag("cs:CourtHouseName", "Lakeside Country Club")
						.addEndTag();
	    	break;
		default:
	    	xmlString.addTag("cs:CrownCourt")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode")
						.addAttribute("CourtHouseShortName", "Harrow Crown Court")
						.addValue("10005")
						.addTag("cs:CourtHouseName", "Harrow Crown Court")
						.addTag("cs:CourtHouseAddress")
						.addTag("apd:Line", "THE CROWN COURT AT HARROW")
						.addTag("apd:Line", "Wharf Rd")
						.addTag("apd:Line", "Frimley Green")
						.addTag("apd:Line", "Camberley")
						.addTag("apd:PostCode", "GU16 6PT")
						.addEndTag()
						.addTag("cs:CourtHouseDX", "DX 12345 HARROW")
						.addTag("cs:CourtHouseTelephone", "01252 836464")
						.addTag("cs:CourtHouseFax", "01252 836464")
						.addEndTag()
						.addTag("cs:CourtLists")
						.addTag("cs:CourtList")
						.addTag("cs:CourtHouse")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode", "1122334455")
						.addTag("cs:CourtHouseName", "Harrow Crown Court")
						.addEndTag();
		}
		xmlString.addTag("cs:Sittings")
					.addTag("cs:Sitting")
					.addTag("cs:CourtRoomNumber", courtroom)
					.addTag("cs:SittingSequenceNo", "1")
					.addTag("cs:SittingAt", startTime)
					.addTag("cs:SittingPriority", "T")
					.addTag("cs:Judiciary")
						.addTag("cs:Judge")
							.addTag("apd:CitizenNameSurname", "Judge N1")
							.addTag("apd:CitizenNameRequestedName", "Judge N2")
							.addTag("cs:CRESTjudgeID", "0")
						.addEndTag()
					.addEndTag()
					.addTag("cs:Hearings")
						.addTag("cs:Hearing")
							.addTag("cs:HearingSequenceNumber", "1")
							.addTag("cs:HearingDetails")
								.addAttribute("HearingType", "TRL")
							.addTag("cs:HearingDescription", "For Trial")
							.addTag("cs:HearingDate", DateUtils.dateAsYyyyMmDd(startDate))
						.addEndTag()
						.addTag("cs:CRESThearingID", "1")
						.addTag("cs:TimeMarkingNote", startTime.substring(0, 5) + " AM")
						.addTag("cs:CaseNumber", caseNumber)
						.addTag("cs:Prosecution")
							.addAttribute("ProsecutingAuthority", "Crown Prosecution Service")
						.addTag("cs:ProsecutingReference", "CPS")
						.addTag("cs:ProsecutingOrganisation")
						.addTag("cs:OrganisationName", "Crown Prosecution Service")
					.addEndTag()
				.addEndTag()
				.addTag("cs:CommittingCourt")
					.addTag("cs:CourtHouseType", "Magistrates Court")
					.addTag("cs:CourtHouseCode")
						.addAttribute("CourtHouseShortName", "BAM") 
						.addValue("2725")
					.addTag("cs:CourtHouseName", "BARNET MAGISTRATES COURT")
					.addTag("cs:CourtHouseAddress")
						.addTag("apd:Line", "7C HIGH STREET")
						.addTag("apd:Line", "-")
						.addTag("apd:Line", "BARNET")
						.addTag("apd:PostCode", "EN5 5UE")
					.addEndTag()
					.addTag("cs:CourtHouseDX", "DX 8626 BARNET")
					.addTag("cs:CourtHouseTelephone", "02084419042")
				.addEndTag()
				.addTag("cs:Defendants")
					.addTag("cs:Defendant")
						.addTag("cs:PersonalDetails")
						.addTag("cs:Name")
							.addTag("apd:CitizenNameForename", "Franz")
							.addTag("apd:CitizenNameSurname", "KAFKA")
						.addEndTag()
						.addTag("cs:IsMasked", "no")
						.addTag("cs:DateOfBirth")
							.addTag("apd:BirthDate", "1962-06-12")
							.addTag("apd:VerifiedBy", "not verified")
						.addEndTag()
						.addTag("cs:Sex", "male")
						.addTag("cs:Address")
							.addTag("apd:Line", "ADDRESS LINE 1")
							.addTag("apd:Line", "ADDRESS LINE 2")
							.addTag("apd:Line", "ADDRESS LINE 3")
							.addTag("apd:Line", "ADDRESS LINE 4")
							.addTag("apd:Line", "SOMETOWN, SOMECOUNTY")
							.addTag("apd:PostCode", "GU12 7RT")
						.addEndTag()
					.addEndTag()
					.addTag("cs:ASNs")
					.addTag("cs:ASN", "0723XH1000000262665K")
				.addEndTag()
				.addTag("cs:CRESTdefendantID", "29161")
				.addTag("cs:PNCnumber", "20123456789L")
				.addTag("cs:URN", urn)
				.addTag("cs:CustodyStatus", "In custody")
				.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
			.addEndTag()
					.endEncoding()
//	    			.useLineEnd(true)
					.addEndTag();

		return xmlString.xmlValue();
    }
    
    public static String buildAddAudioXml(String courthouse,
    		String courtroom,
    		String caseNumbers,
    		String startDateTime,
    		String endDateTime,
    		String fileName,
    		String channel) {
    	XmlString xmlString = new XmlString()
    			.addTag("ns5:addAudio")
    			.addAttribute("xmlns:ns2", "http://core.datamodel.fs.documentum.emc.com/")
    			.addAttribute("xmlns:ns3", "http://properties.core.datamodel.fs.documentum.emc.com/")
    			.addAttribute("xmlns:ns4", "http://content.core.datamodel.fs.documentum.emc.com/")
    			.addAttribute("xmlns:ns5", "http://com.synapps.mojdarts.service.com")
    			.addAttribute("xmlns:ns6", "http://rt.fs.documentum.emc.com/")
    			.addTag("document")
    			.addStartCdata()
    			.addTag("audio")
    			.addTag("start")
    			.addAttribute("Y", DateUtils.datePart(startDateTime, "Y"))
				.addAttribute("M", DateUtils.datePart(startDateTime, "M"))
				.addAttribute("D", DateUtils.datePart(startDateTime, "D"))
    			.addAttribute("H", DateUtils.timePart(startDateTime, "H"))
				.addAttribute("MIN", DateUtils.timePart(startDateTime, "MIN"))
				.addAttribute("S", DateUtils.timePart(startDateTime, "S"))
				.addEndTag()
    			.addTag("end")
    			.addAttribute("Y", DateUtils.datePart(endDateTime, "Y"))
				.addAttribute("M", DateUtils.datePart(endDateTime, "M"))
				.addAttribute("D", DateUtils.datePart(endDateTime, "D"))
    			.addAttribute("H", DateUtils.timePart(endDateTime, "H"))
				.addAttribute("MIN", DateUtils.timePart(endDateTime, "MIN"))
				.addAttribute("S", DateUtils.timePart(endDateTime, "S"))
				.addEndTag()
				.addTag("channel", channel)
				.addTag("max_channels", "4")
				.addTag("mediaformat", "mp2")
				.addTag("mediafile", fileName)
				.addTag("courthouse", courthouse)
    			.addTag("courtroom", courtroom)
    			.addTagGroup("case_numbers", "case_number", caseNumbers)
    			.addEndTag()
    			.addEndCdata()
    			.addEndTag()
    			.addEndTag();
    			
		return xmlString.xmlValue();
    }
    
    @Test
	public void testXml1() {
		Assertions.assertEquals("<case type=\"\" id=\"string2\">" + LINE_END
				+ "  <courthouse>string1</courthouse>" + LINE_END
				+ "  <courtroom>cr</courtroom>" + LINE_END
				+ "  <defendants>" + LINE_END
				+ "    <defendant>string3A</defendant>" + LINE_END
				+ "    <defendant>string3B</defendant>" + LINE_END
				+ "  </defendants>" + LINE_END
				+ "  <judges>" + LINE_END
				+ "    <judge>string4</judge>" + LINE_END
				+ "  </judges>" + LINE_END
				+ "  <prosecutors>" + LINE_END
				+ "    <prosecutor>string5</prosecutor>" + LINE_END
				+ "  </prosecutors>" + LINE_END
				+ "  <defenders>" + LINE_END
				+ "    <defender>string6</defender>" + LINE_END
				+ "  </defenders>" + LINE_END
				+ "</case>",
				buildAddCaseXml("string1", "cr", "string2", "string3A~string3B", "string4", "string5", "string6"));
    }
    
    @Test
	public void testXml2() {
		Assertions.assertEquals("<messageId>string1</messageId>" + LINE_END
				+ "<type>string2</type>" + LINE_END
				+ "<subType>string3</subType>" + LINE_END
				+ "<document ID=\"string4\" Y=\"2023\" M=\"11\" D=\"10\" H=\"12\" MIN=\"34\" S=\"45\">" + LINE_END
				+ "  &lt;CourtHouse&gt;string5&lt;/CourtHouse&gt;" + LINE_END
				+ "  &lt;CourtRoom&gt;string6&lt;/CourtRoom&gt;" + LINE_END
				+ "  &lt;Case_numbers&gt;" + LINE_END
				+ "    &lt;Case_number&gt;string7&lt;/Case_number&gt;" + LINE_END
				+ "  &lt;/Case_numbers&gt;" + LINE_END
				+ "  &lt;EventText&gt;string8&lt;/EventText&gt;" + LINE_END
				+ "  &lt;RetentionPolicy&gt;" + LINE_END
				+ "    &lt;CaseRetentionFixedPolicy&gt;string10&lt;/CaseRetentionFixedPolicy&gt;" + LINE_END
				+ "    &lt;CaseTotalSentence&gt;string11&lt;/CaseTotalSentence&gt;" + LINE_END
				+ "  &lt;/RetentionPolicy&gt;" + LINE_END
				+ "</document>", 
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "2023-11-10T12:34:45Z", "string10", "string11"));
    }
    
    @Test
	public void testXml3() {
		Assertions.assertEquals("<messageId>string1</messageId>" + LINE_END
				+ "<type>string2</type>" + LINE_END
				+ "<subType>string3</subType>" + LINE_END
				+ "<document ID=\"string4\" Y=\"2023\" M=\"11\" D=\"10\" H=\"12\" MIN=\"34\" S=\"45\">" + LINE_END
				+ "  &lt;CourtHouse&gt;string5&lt;/CourtHouse&gt;" + LINE_END
				+ "  &lt;CourtRoom&gt;string6&lt;/CourtRoom&gt;" + LINE_END
				+ "  &lt;Case_numbers&gt;" + LINE_END
				+ "    &lt;Case_number&gt;case1&lt;/Case_number&gt;" + LINE_END
				+ "    &lt;Case_number&gt;case2&lt;/Case_number&gt;" + LINE_END
				+ "  &lt;/Case_numbers&gt;" + LINE_END
				+ "  &lt;EventText&gt;string8&lt;/EventText&gt;" + LINE_END
				+ "  &lt;RetentionPolicy&gt;" + LINE_END
				+ "    &lt;CaseRetentionFixedPolicy&gt;&lt;/CaseRetentionFixedPolicy&gt;" + LINE_END
				+ "  &lt;/RetentionPolicy&gt;" + LINE_END
				+ "</document>",
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "case1,case2", "string8", "2023-11-10T12:34:45Z", "blank", ""));
		
	}
    
    @Test
	public void testXml4() {
		Assertions.assertEquals("<log_entry Y=\"2023\" M=\"11\" D=\"10\" H=\"12\" MIN=\"34\" S=\"45\">" + LINE_END
				+ "  <courtHouse>courthousename</courtHouse>" + LINE_END
				+ "  <courtRoom>courtroomname</courtRoom>" + LINE_END
				+ "  <case_numbers>" + LINE_END
				+ "    <case_number>case1</case_number>" + LINE_END
				+ "    <case_number>case2</case_number>" + LINE_END
				+ "  </case_numbers>" + LINE_END
				+ "  <text>logtext</text>" + LINE_END
				+ "</log_entry>",
				buildAddLogXml("courthousename", "courtroomname", "case1,case2", "logtext", "2023-11-10T12:34:45Z"));
		
	}
    
    @Test
	public void testXml5() {
    	System.out.println(buildAddDailyListXml("DARTS_E2E_2024-01-30-auto", 
				"DL", 
				"DL",
				"DL 30/01/24 FINAL v1",
				"xx",
				"room2",
				"T2024009",
				"2024-01-30",
				"10:00:00",
				"2024-01-30",
				"2024-01-30T12:34:45+00:00",
				"def name",
				"62AA1010646"));
    }
    
    @Test
	public void testXml6() {
    	System.out.println(buildAddAudioXml("ch",
		    	 "cr",
		    	 "c1,c2",
		    	 "2024-03-01T12:00:00",
		    	 "2024-03-02T12:00:00",
		    	 "fn",
		    	 "0"));
    }

}