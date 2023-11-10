package uk.gov.hmcts.darts.automation.utils;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

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
    	XmlString eventXml = new XmlString();
    	eventXml.addTag("message_id", messageId);
    	eventXml.addTag("type", type);
    	eventXml.addTag("sub_type", subType);
    	eventXml.addTag("event_id", eventId);
    	eventXml.addTag("courthouse", courthouse);
    	eventXml.addTag("courtroom", courtroom);
    	eventXml.addTag("case_numbers", caseNumbers);
    	eventXml.addTag("event_text", eventText);
    	eventXml.addTag("date_time", dateTime);
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		eventXml.addTag("retention_policy");
	    	eventXml.addTag("case_retention_fixed_policy", caseRetentionFixedPolicy);
	    	eventXml.addTag("case_total_sentence", caseTotalSentence);
    		eventXml.addEndTag();
    	}
		return eventXml.xmlValue();
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
				.addTag("courthouse", courthouse);
    	if (!defendants.isBlank()) {
			xmlString.addTag("defendants")
					.addTags("defendant", defendants, "~")
					.addEndTag();
    	}
    	if (!judges.isBlank()) {
			xmlString.addTag("judges")
					.addTags("judge", judges, "~")
					.addEndTag();
    	}
    	if (!prosecutors.isBlank()) {
			xmlString.addTag("prosecutors")
					.addTags("prosecutor", prosecutors, "~")
					.addEndTag();
    	}
    	if (!defenders.isBlank()) {
	    	xmlString.addTag("defenders")
	    			.addTags("defender", defenders, "~")
					.addEndTag();
    	}
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
		Assertions.assertEquals("{\r\n"
				+ "  \"message_id\": \"string1\",\r\n"
				+ "  \"type\": \"string2\",\r\n"
				+ "  \"sub_type\": \"string3\",\r\n"
				+ "  \"event_id\": \"string4\",\r\n"
				+ "  \"courthouse\": \"string5\",\r\n"
				+ "  \"courtroom\": \"string6\",\r\n"
				+ "  \"case_numbers\": [\r\n"
				+ "    \"string7\"\r\n"
				+ "  ],\r\n"
				+ "  \"event_text\": \"string8\",\r\n"
				+ "  \"date_time\": \"string9\",\r\n"
				+ "  \"retention_policy\": {\r\n"
				+ "  \"case_retention_fixed_policy\": \"string10\",\r\n"
				+ "  \"case_total_sentence\": \"string11\"\r\n"
				+ "  }\r\n"
				+ "}", 
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "string10", "string11"));
    }
    
    @Test
	public void testXml3() {
		Assertions.assertEquals("{\r\n"
				+ "  \"message_id\": \"string1\",\r\n"
				+ "  \"type\": \"string2\",\r\n"
				+ "  \"sub_type\": \"string3\",\r\n"
				+ "  \"event_id\": \"string4\",\r\n"
				+ "  \"courthouse\": \"string5\",\r\n"
				+ "  \"courtroom\": \"string6\",\r\n"
				+ "  \"case_numbers\": [\r\n"
				+ "    \"string7\"\r\n"
				+ "  ],\r\n"
				+ "  \"event_text\": \"string8\",\r\n"
				+ "  \"date_time\": \"string9\",\r\n"
				+ "  \"retention_policy\": {\r\n"
				+ "  \"case_retention_fixed_policy\": \"\"\r\n"
				+ "  }\r\n"
				+ "}",
				buildAddEventXml("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "blank", ""));
		
	}


}