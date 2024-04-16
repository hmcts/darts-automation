package uk.gov.hmcts.darts.automation.utils;

import io.restassured.path.json.JsonPath;
import io.restassured.path.json.config.JsonPathConfig;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class JsonUtils {
	private static Logger log = LogManager.getLogger("JsonUtils");

	public JsonUtils() {
		
	}
	
	public static String extractJsonValue(String json, String tag) {
		String returnValue = "";
		JsonPath jsonPath = new JsonPath(json);
		returnValue = jsonPath.getString(tag);
		log.info("json tag {} :: json value {}",tag,returnValue);
		return returnValue;
	}
	
	static String addTimestamp(String time) {
		if (time == null || time.isBlank()) {
			return DateUtils.timestamp();
		} else {
			if (time.equalsIgnoreCase("blank") || time.equalsIgnoreCase("empty")) {
				return "";
			} else {
				return time;
			}
		}
	}
    
    public static String buildAddEventJson(String messageId,
    		String type,
    		String subType,
    		String eventId,
    		String courthouse,
    		String courtroom,
    		String caseNumbers,
    		String eventText,
    		String dateTime,
    		String caseRetentionFixedPolicy,
    		String caseTotalSentence,
    		String startTime,
    		String endTime) {
    	JsonString eventJson = new JsonString();
    	eventJson.addJsonLine("message_id", messageId);
    	eventJson.addJsonLine("type", type);
    	eventJson.addJsonLine("sub_type", subType);
    	eventJson.addJsonLine("event_id", eventId);
    	eventJson.addJsonLine("courthouse", courthouse);
    	eventJson.addJsonLine("courtroom", courtroom);
    	eventJson.addJsonSeq("case_numbers", caseNumbers);
    	eventJson.addJsonLine("event_text", eventText);
    	eventJson.addJsonLine("date_time", addTimestamp(dateTime));
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		eventJson.addSubSequence("retention_policy");
	    	eventJson.addJsonLine("case_retention_fixed_policy", caseRetentionFixedPolicy);
	    	eventJson.addJsonLine("case_total_sentence", caseTotalSentence);
    		eventJson.endSubSequence();
    	}
    	eventJson.addJsonLine("start_time", startTime);
    	eventJson.addJsonLine("end_time", endTime);
		return eventJson.jsonValue();
    }
    
    public static String buildAddCaseJson(String courthouse,
    		String courtroom,
    		String caseNumber,
    		String defendant,
    		String judge,
    		String prosecutor,
    		String defender) {
    	JsonString jsonString = new JsonString();
    	jsonString.addJsonLine("courthouse", courthouse);
    	jsonString.addJsonLine("courtroom", courtroom);
    	jsonString.addJsonLine("case_number", caseNumber);
    	jsonString.addJsonSeq("defendants", defendant);
    	jsonString.addJsonSeq("judges", judge);
    	jsonString.addJsonSeq("prosecutors", prosecutor);
    	jsonString.addJsonSeq("defenders", defender);
		return jsonString.jsonValue();
    }

	public static String buildAddCourtLogJson(String dateTime,
										  String courthouse,
										  String courtroom,
										  String case_number,
										  String text) {
		JsonString jsonString = new JsonString();
		jsonString.addJsonLine("log_entry_date_time", dateTime);
		jsonString.addJsonLine("courthouse", courthouse);

		jsonString.addJsonLine("courtroom", courtroom);
		jsonString.addJsonSeq("case_numbers", case_number);
		jsonString.addJsonLine("text", text);
		return jsonString.jsonValue();
	}
    
    public static String buildAddCourthouseJson(String courthouse,
    		String code,
    		String displayName) {
    	JsonString jsonString = new JsonString();
    	jsonString.addJsonLine("courthouse_name", courthouse);
    	jsonString.addJsonLineNoQuotes("code", code);
    	jsonString.addJsonLine("display_name", displayName.isBlank() ? courthouse : displayName);
		return jsonString.jsonValue();
    }
  
    public static String buildAddAudioJson(String courthouse,
    		String courtroom,
    		String caseNumbers,
    		String startDateTime,
    		String endDateTime,
    		String fileName) {
    	JsonString jsonString = new JsonString()
		    	.addJsonLine("started_at", startDateTime)
		    	.addJsonLine("ended_at", endDateTime)
		    	.addJsonLine("channel", 1)
		    	.addJsonLine("total_channels", 4)
		    	.addJsonLine("format", "mp2")
		    	.addJsonLine("filename", fileName)
		    	.addJsonLine("courthouse", courthouse)
		    	.addJsonLine("courtroom", courtroom);
    	switch (fileName.toLowerCase()) {
    	case "sample1":
	    	jsonString.addJsonLine("file_size", 937.96)
	    			.addJsonLine("checksum", "aQlozKNmM84agyCpJu26fw==");
	    	break;
    	default:
        	jsonString.addJsonLine("file_size", 1)
					.addJsonLine("checksum", "");
    	}
    	jsonString.addJsonSeq("cases", caseNumbers);
    		
		return jsonString.jsonValue();
    }
    
    @Test
	public void testJson() {
		Assertions.assertEquals(buildAddEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "string10", "string11", "", ""), "{\r\n"
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
				+ "}");
		Assertions.assertEquals(buildAddEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "blank", "", "", ""), "{\r\n"
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
				+ "}");
		
	}


}