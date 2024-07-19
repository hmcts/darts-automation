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
	
	public static String extractValue(String xml, String tag) {
		String result = "";
		String[] split1 = xml.split("<" + tag + "[^>]*>", 2);
		if (split1.length > 1) {
			String[] split2 = split1[1].split("</" + tag + ">");
			if (split2.length > 1) {
				result = split2[0];
			}
		}
		return result;
	}
	
	public static String removeWhitespace(String xml) {
		return xml.trim().replaceAll("((\s|\n)*)<", "<");
	}
	
	public static String removeCdata(String input) {
		if (input.contains("<![CDATA[")) {
			String[] split1 = input.split("<!\\[CDATA\\[");
			String[] split2 = split1[1].split("\\]\\]>");
			input = split1[0] + split2[0].replace("&", "&amp").replace("<", "&lt;").replace(">", "&gt;") + split2[1];
		}
		return input;
	}
	
//	public static String extractXmlValue(String xml, String path) {
//		String returnValue = "";
//		XmlPath xmlPath = new XmlPath(xml);
//		returnValue = xmlPath.getString(path);
//		log.info("xml at {} is {}", path, returnValue);
//		return returnValue;
//	}
    
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
				.addTag("courtroom", courtroom)
				.addTagGroup("defendants", "defendant", defendants, "~")
				.addTagGroup("judges", "judge", judges, "~")
				.addTagGroup("prosecutors", "prosecutor", prosecutors, "~")
	    		.addTagGroup("defenders", "defender", defenders, "~");
		return xmlString.xmlValue();
    }
    
    public static String buildGetCasesXml(String courthouse,
    		String courtroom,
    		String date) {
    	XmlString xmlString = new XmlString()
    			.addTag("com:getCases")
    			.addAttribute("xmlns:com", "http://com.synapps.mojdarts.service.com")
				.addTag("courthouse", courthouse)
				.addTag("courtroom", courtroom)
				.addTag("date", date)
				.addEndTag();
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
    
    public static String buildRegisterNodeXml(String courthouse,
    		String courtroom,
    		String hostname,
    		String ipAddress,
    		String macAddress,
    		String nodeType) {
    	XmlString xmlString = new XmlString()
//    			.addStartCdata()
				.startEncoding()
    			.addTag("node")
    			.addAttribute("type", nodeType)
				.addTag("courthouse", courthouse)
    			.addTag("courtroom", courtroom)
    			.addTag("hostname", hostname)
    			.addTag("ip_address", ipAddress)
    			.addTag("mac_address", macAddress)
    			.addEndTag()
//    			.addEndCdata();
				.endEncoding();
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
    		String timestamp,
    		String defendant,
    		String urn,
    		String judge,
    		String prosecution,
    		String defence) {
    	XmlString xmlString = new XmlString()
    			.addTag("messageId", messageId)
    			.addTag("type", type)
    			.addTag("subType", subType)
//    			.useLineEnd(false)
    			.addTag("document")
				.startEncoding()
//    			.addStartCdata()
					.addTag("cs:DailyList")
	    			.addAttribute("xmlns:cs", "http://www.courtservice.gov.uk/schemas/courtservice")
	    			.addAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
	    			.addAttribute("xsi:schemaLocation", "http://www.courtservice.gov.uk/schemas/courtservice DailyList-v5-2.xsd")
	    			.addAttribute("xmlns:apd", "http://www.govtalk.gov.uk/people/AddressAndPersonalDetails")
						.addTag("cs:DocumentID")
							.addTag("cs:DocumentName", documentName)
							.addTag("cs:UniqueID", documentName)
							.addTag("cs:DocumentType", "DL")
							.addTag("cs:TimeStamp", timestamp)
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
							.addTag("cs:PublishedTime", timestamp)
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
		case "york":
	    	xmlString.addTag("cs:CrownCourt")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode")
						.addAttribute("CourtHouseShortName", "YORK")
						.addValue("467")
						.addTag("cs:CourtHouseName", "YORK")
						.addEndTag()
						.addTag("cs:CourtLists")
						.addTag("cs:CourtList")
						.addTag("cs:CourtHouse")
						.addTag("cs:CourtHouseType", "Crown Court")
						.addTag("cs:CourtHouseCode", "467")
						.addTag("cs:CourtHouseName", "YORK")
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
						.addTag("cs:CourtHouseCode", "10005")
						.addTag("cs:CourtHouseName", "Harrow Crown Court")
						.addEndTag();
		}
		xmlString.addTag("cs:Sittings")
					.addTag("cs:Sitting")
					.addTag("cs:CourtRoomNumber", courtroom)
					.addTag("cs:SittingSequenceNo", "1")
					.addTag("cs:SittingAt", startTime + ":00")
					.addTag("cs:SittingPriority", "T")
					.addTag("cs:Judiciary")
						.addTag("cs:Judge")
							.addTag("apd:CitizenNameForename", "ignored")
							.addTag("apd:CitizenNameSurname", "ignored")
							.addTag("apd:CitizenNameRequestedName", judge)
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
					
					.addTag("cs:Advocate")
						.addTag("cs:PersonalDetails")
							.addTag("cs:Name")
								.addTag("apd:CitizenNameTitle", "ignored")
								.addTag("apd:CitizenNameForename", XmlString.split(prosecution, 0))
								.addTag("apd:CitizenNameSurname", XmlString.split(prosecution, 1))
								.addTag("apd:CitizenNameSuffix", "ignored")
								.addTag("apd:CitizenNameRequestedName", "ignored")
							.addEndTag()
							.addTag("cs:MaskedName", "String")
							.addTag("cs:IsMasked", "yes")
							.addTag("cs:DateOfBirth")
								.addTag("apd:BirthDate", "1967-08-13")
								.addTag("apd:VerifiedBy", "not verified")
							.addEndTag()
							.addTag("cs:Age", "0")
							.addTag("cs:Sex", "unknown")
							.addTag("cs:Address")
								.addTag("apd:Line", "1 Address")
								.addTag("apd:Line", "2 Address")
								.addTag("apd:PostCode", "A0 0AA")
							.addEndTag()
						.addEndTag()
						.addTag("cs:ContactDetails")
							.addTag("apd:Email")
								.addAttribute("EmailPreferred", "yes")
								.addAttribute("EmailUsage", "work")
								.addTag("apd:EmailAddress")
								.addEndTag()
							.addEndTag()
							.addTag("apd:Telephone")
								.addAttribute("TelPreferred", "yes")
								.addAttribute("TelMobile", "yes")
								.addAttribute("TelUse", "work")
								.addTag("apd:TelNationalNumber", " ")
								.addTag("apd:TelExtensionNumber", "0")
								.addTag("apd:TelCountryCode", "0")
							.addEndTag()
							.addTag("apd:Fax")
								.addAttribute("FaxPreferred", "yes")
								.addAttribute("FaxMobile", "yes")
								.addAttribute("FaxUse", "work")
								.addTag("apd:FaxNationalNumber", " ")
								.addTag("apd:FaxExtensionNumber", "0")
								.addTag("apd:FaxCountryCode", "0")
							.addEndTag()
						.addEndTag()
						.addTag("cs:StartDate", "1967-08-13")
						.addTag("cs:EndDate", "1967-08-13")
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
								.addTag("apd:CitizenNameForename", XmlString.split(defendant, 0))
								.addTag("apd:CitizenNameSurname", XmlString.split(defendant, 1))
								.addTag("apd:CitizenNameRequestedName", "ignored")
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
//						.addTag("cs:Charges")
//							.addTag("cs:Charge")
//								.addAttribute("IndictmentCountNumber", "0")
//								.addAttribute("CJSoffenceCode", "SA00002")
//								.addTag("cs:OffenceStatement", "Guiding a sleigh under the influence of alcohol")
//							.addEndTag()
//						.addEndTag()
						.addTag("cs:CustodyStatus", "In custody")
			.addTag("cs:Counsel")
				.addTag("cs:Advocate")
					.addTag("cs:PersonalDetails")
						.addTag("cs:Name")
							.addTag("apd:CitizenNameTitle", "Ms")
							.addTag("apd:CitizenNameForename", XmlString.split(defence, 0))
							.addTag("apd:CitizenNameSurname", XmlString.split(defence, 1))
							.addTag("apd:CitizenNameSuffix", "")
							.addTag("apd:CitizenNameRequestedName", "")
						.addEndTag()
						.addTag("cs:MaskedName", "String")
						.addTag("cs:IsMasked", "yes")
						.addTag("cs:DateOfBirth")
							.addTag("apd:BirthDate", "1967-08-13")
							.addTag("apd:VerifiedBy", "not verified")
						.addEndTag()
						.addTag("cs:Age", "0")
						.addTag("cs:Sex", "unknown")
						.addTag("cs:Address")
							.addTag("apd:Line", "")
							.addTag("apd:Line", "")
							.addTag("apd:PostCode", "A0 0AA")
						.addEndTag()
					.addEndTag()
					.addTag("cs:ContactDetails")
						.addTag("apd:Email")
							.addAttribute("EmailPreferred", "yes")
							.addAttribute("EmailUsage", "work")
							.addTag("apd:EmailAddress", "")
						.addEndTag()
						.addTag("apd:Telephone")
							.addAttribute("TelPreferred", "yes")
							.addAttribute("TelMobile", "yes")
							.addAttribute("TelUse", "work")
							.addTag("apd:TelNationalNumber", " ")
							.addTag("apd:TelExtensionNumber", "0")
							.addTag("apd:TelCountryCode", "0")
						.addEndTag()
						.addTag("apd:Fax")
							.addAttribute("FaxPreferred", "yes")
							.addAttribute("FaxMobile", "yes")
							.addAttribute("FaxUse", "work")
							.addTag("apd:FaxNationalNumber", " ")
							.addTag("apd:FaxExtensionNumber", "0")
							.addTag("apd:FaxCountryCode", "0")
						.addEndTag()
					.addEndTag()
					.addTag("cs:StartDate", "1967-08-13")
					.addTag("cs:EndDate", "1967-08-13")
				.addEndTag()
			.addEndTag()
	
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
//			.addEndCdata()
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
				.startEncoding()
//    			.addStartCdata()
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
//    			.addEndCdata()
				.startEncoding()
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
				+ "<document>" + LINE_END
				+ "  &lt;be:DartsEvent xmlns:be=\"urn:integration-cjsonline-gov-uk:pilot:entities\" ID=\"string4\" Y=\"2023\" M=\"11\" D=\"10\" H=\"12\" MIN=\"34\" S=\"45\"&gt;" + LINE_END
				+ "    &lt;be:CourtHouse&gt;string5&lt;/be:CourtHouse&gt;" + LINE_END
				+ "    &lt;be:CourtRoom&gt;string6&lt;/be:CourtRoom&gt;" + LINE_END
				+ "    &lt;be:Case_numbers&gt;" + LINE_END
				+ "      &lt;be:Case_number&gt;string7&lt;/be:Case_number&gt;" + LINE_END
				+ "    &lt;/be:Case_numbers&gt;" + LINE_END
				+ "    &lt;be:EventText&gt;string8&lt;/be:EventText&gt;" + LINE_END
				+ "    &lt;be:RetentionPolicy&gt;" + LINE_END
				+ "      &lt;be:CaseRetentionFixedPolicy&gt;string10&lt;/be:CaseRetentionFixedPolicy&gt;" + LINE_END
				+ "      &lt;be:CaseTotalSentence&gt;string11&lt;/be:CaseTotalSentence&gt;" + LINE_END
				+ "    &lt;/be:RetentionPolicy&gt;" + LINE_END
				+ "  &lt;/be:DartsEvent&gt;" + LINE_END
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
				"62AA1010646",
				"judge name",
				"prosecutor name",
				"defence name"));
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
    
    @Test
	public void testXml7() {
    	System.out.println(removeCdata("      <messageId>{{seq}}4014</messageId>\r\n"
    			+ "      <type>10100</type>\r\n"
    			+ "      <document>\r\n"
    			+ "  <![CDATA[<be:DartsEvent xmlns:be=\"urn:integration-cjsonline-gov-uk:pilot:entities\" ID=\"{{seq}}14014\" Y=\"{{date-yyyy}}\" M=\"{{date-mm}}\" D=\"{{date-dd}}\" H=\"12\" MIN=\"04\" S=\"10\">\r\n"
    			+ "    <be:CourtHouse>Harrow Crown Court</be:CourtHouse>\r\n"
    			+ "    <be:CourtRoom>Room {{seq}}C</be:CourtRoom>\r\n"
    			+ "    <be:CaseNumbers>\r\n"
    			+ "      <be:CaseNumber>T{{seq}}251,T{{seq}}252</be:CaseNumber>\r\n"
    			+ "    </be:CaseNumbers>\r\n"
    			+ "    <be:EventText>text {{seq}} CD1</be:EventText>\r\n"
    			+ "  </be:DartsEvent>]]>\r\n"
    			+ "</document>"));
    }

}