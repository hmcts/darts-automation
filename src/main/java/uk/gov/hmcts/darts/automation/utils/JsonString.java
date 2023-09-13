package uk.gov.hmcts.darts.automation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class JsonString {
	private static Logger log = LogManager.getLogger("JsonString");
	
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
	
	public JsonString addJsonLine(String tag, Long value) {
			jsonString = jsonString + sep + "  \"" + tag + "\": " + value; 
			sep = ",\r\n";
		return this;
	}
	
/*
 * Add json value without quotes around value
 * 
 */
	public JsonString addJsonValue(String tag, String value) {
		if (!value.isBlank()) {
			if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			jsonString = jsonString + sep + "  \"" + tag + "\": " + value; 
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
