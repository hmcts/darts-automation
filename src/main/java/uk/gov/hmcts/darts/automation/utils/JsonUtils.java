package uk.gov.hmcts.darts.automation.utils;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
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

	static class JsonString {
		public String jsonString = "";
		String sep = "";
		public JsonString() {
			jsonString = "{";
			sep = "\r\n";
		}
    
/*
 * Add field to json 
 * 
 */
    public JsonString addJsonLine(String tag, String value) {
    	if (!value.isBlank()) {
    		if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
    			value = "";
    		}
    		jsonString = jsonString + sep + "  \"" + tag + "\": \"" + value + "\""; 
    		sep = ",\r\n";
    	}
    	return this;
    }
    
    public JsonString addJsonSeq(String tag, String value) {
    	if (!value.isBlank()) {
    		if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
    			value = "";
    		}
    		jsonString = jsonString + sep + "  \"" + tag + "\": [\r\n    \"" + value + "\"\r\n  ]"; 
    		sep = ",\r\n";
    	}
    	return this;
    }
    
    public JsonString addSubSequence(String name) {
    	jsonString = jsonString + sep + "  \"" + name + "\": {\r\n"; 
    	sep = "";
    	return this;
    }
    
    public JsonString endSubSequence() {
    	jsonString = jsonString + "\r\n  }"; 
		sep = ",\r\n";
    	return this;
    }
    
    public String jsonValue() {
    	return jsonString + "\r\n}";
    }
		
		
	}
    
    public static String buildEventJson(String messageId,
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
    	JsonString eventJson = new JsonString();
    	eventJson.addJsonLine("message_id" , messageId);
    	eventJson.addJsonLine("type" , type);
    	eventJson.addJsonLine("sub_type" , subType);
    	eventJson.addJsonLine("event_id" , eventId);
    	eventJson.addJsonLine("courthouse" , courthouse);
    	eventJson.addJsonLine("courtroom" , courtroom);
    	eventJson.addJsonSeq("case_numbers" , caseNumbers);
    	eventJson.addJsonLine("event_text" , eventText);
    	eventJson.addJsonLine("date_time" , dateTime);
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		eventJson.addSubSequence("retention_policy");
	    	eventJson.addJsonLine("case_retention_fixed_policy" , caseRetentionFixedPolicy);
	    	eventJson.addJsonLine("case_total_sentence" , caseTotalSentence);
    		eventJson.endSubSequence();
    	}
		return eventJson.jsonValue();
    }
    
    @Test
	public void testJson() {
		System.out.println(buildEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "string10", "string11"));
		System.out.println(buildEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "blank", ""));
		
	}


}