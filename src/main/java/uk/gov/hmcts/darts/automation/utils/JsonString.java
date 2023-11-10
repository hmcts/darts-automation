package uk.gov.hmcts.darts.automation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class JsonString {
	private static Logger log = LogManager.getLogger("JsonString");
	private static String LINE_END = System.lineSeparator();
	
	public String jsonString = "";
	String sep = "";
	
	public JsonString() {
		jsonString = "{";
		sep = LINE_END;
	}

/*
* Add field to json 
* 
*/
	public JsonString addJsonLine(String tag, String value) {
		if (value != null && !value.isBlank()) {
			if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			jsonString = jsonString + sep + "  \"" + tag + "\": \"" + value + "\""; 
			sep = "," + LINE_END;
		}
		return this;
	}
	
	public JsonString addJsonLine(String tag, Long value) {
			jsonString = jsonString + sep + "  \"" + tag + "\": " + value; 
			sep = "," + LINE_END;
		return this;
	}
	
/*
 * Add json value without quotes around value
 * 
 */
	public JsonString addJsonValue(String tag, String value) {
		if (value != null && !value.isBlank()) {
			if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			jsonString = jsonString + sep + "  \"" + tag + "\": " + value; 
			sep = "," + LINE_END;
		}
		return this;
	}
	
	public JsonString addJsonSeq(String tag, String value) {
		if (value != null && !value.isBlank()) {
			if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			jsonString = jsonString + sep + "  \"" + tag + "\": [" + LINE_END + "    \"" + value + "\"" + LINE_END + "  ]"; 
			sep = "," + LINE_END;
		}
		return this;
	}
	
	public JsonString addSubSequence(String name) {
		jsonString = jsonString + sep + "  \"" + name + "\": {" + LINE_END; 
		sep = "";
		return this;
	}
	
	public JsonString endSubSequence() {
		jsonString = jsonString + LINE_END + "  }"; 
		sep = "," + LINE_END;
		return this;
	}
	
	public String jsonValue() {
		return jsonString + LINE_END + "}";
	}
	
	
}
