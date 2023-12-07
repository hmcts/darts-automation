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
    			.addAttribute("ID", eventId)
    			.addAttribute("Y", DateUtils.datePart(dateTime, "Y"))
				.addAttribute("M", DateUtils.datePart(dateTime, "M"))
				.addAttribute("D", DateUtils.datePart(dateTime, "D"))
    			.addAttribute("H", DateUtils.timePart(dateTime, "H"))
				.addAttribute("MIN", DateUtils.timePart(dateTime, "MIN"))
				.addAttribute("S", DateUtils.timePart(dateTime, "S"))
				.startEncoding()
				.addTag("CourtHouse", courthouse)
    			.addTag("CourtRoom", courtroom)
    			.addTagGroup("Case_numbers", "Case_number", caseNumbers)
    			.addTag("EventText", eventText);
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		xmlString.addTag("RetentionPolicy");
    		xmlString.addTag("CaseRetentionFixedPolicy", caseRetentionFixedPolicy);
    		xmlString.addTag("CaseTotalSentence", caseTotalSentence);
    		xmlString.addEndTag();
    	}
    	xmlString.endEncoding()
    			.addEndTag();
		return xmlString.xmlValue();
    }
    
    public static String buildAddCaseXml(String courthouse,
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
				.addTag("courtHouse", courthouse)
    			.addTag("courtRoom", courtroom)
    			.addTagGroup("case_numbers", "case_number", caseNumbers)
    			.addTag("text", text)
    			.addEndTag();
		return xmlString.xmlValue();
    }
    
    @Test
	public void testXml1() {
		Assertions.assertEquals("<case type=\"\" id=\"string2\">" + LINE_END
				+ "  <courthouse>string1</courthouse>" + LINE_END
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
				buildAddCaseXml("string1", "string2", "string3A~string3B", "string4", "string5", "string6"));
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
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "2023-11-10 12:34:45", "string10", "string11"));
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
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "case1,case2", "string8", "2023-11-10 12:34:45", "blank", ""));
		
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
				buildAddLogXml("courthousename", "courtroomname", "case1,case2", "logtext", "2023-11-10 12:34:45"));
		
	}


}