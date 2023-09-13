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
    	eventJson.addJsonLine("message_id", messageId);
    	eventJson.addJsonLine("type", type);
    	eventJson.addJsonLine("sub_type", subType);
    	eventJson.addJsonLine("event_id", eventId);
    	eventJson.addJsonLine("courthouse", courthouse);
    	eventJson.addJsonLine("courtroom", courtroom);
    	eventJson.addJsonSeq("case_numbers", caseNumbers);
    	eventJson.addJsonLine("event_text", eventText);
    	eventJson.addJsonLine("date_time", dateTime);
    	if (!caseRetentionFixedPolicy.isBlank() || !caseTotalSentence.isBlank() ) {
    		eventJson.addSubSequence("retention_policy");
	    	eventJson.addJsonLine("case_retention_fixed_policy", caseRetentionFixedPolicy);
	    	eventJson.addJsonLine("case_total_sentence", caseTotalSentence);
    		eventJson.endSubSequence();
    	}
		return eventJson.jsonValue();
    }
    
    public static String buildCaseJson(String courthouse,
    		String caseNumber,
    		String defendant,
    		String judge,
    		String prosecutor,
    		String defender) {
    	JsonString jsonString = new JsonString();
    	jsonString.addJsonLine("courthouse", courthouse);
    	jsonString.addJsonLine("case_number", caseNumber);
    	
    	jsonString.addJsonSeq("defendants", defendant);
    	jsonString.addJsonSeq("judges", judge);
    	jsonString.addJsonSeq("prosecutors", prosecutor);
    	jsonString.addJsonSeq("defenders", defender);
		return jsonString.jsonValue();
    }
    
    @Test
	public void testJson() {
		System.out.println(buildEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "string10", "string11"));
		System.out.println(buildEventJson("string1", "string2", "string3", "string4", "string5", "string6", "string7", "string8", "string9", "blank", ""));
		
	}


}