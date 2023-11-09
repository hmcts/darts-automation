package uk.gov.hmcts.darts.automation.utils;

import java.util.ArrayList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;

public class XmlString {
	private static Logger log = LogManager.getLogger("xmlString");
	
	public String xmlString = "";
	String sep = "";
	ArrayList<String> openTags;
	
	public XmlString() {
		xmlString = "";
		sep = "";
		openTags = new ArrayList<String>();
	}

/*
* Add field to xml 
* 
*/
	public XmlString addTag(String tag, String value) {
		if (value != null && !value.isBlank()) {
			if (value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			xmlString = xmlString + sep + "  <" + tag + ">" + value + "</" + tag + ">"; 
			sep = "\r\n";
		}
		return this;
	}
	
	public XmlString addTag(String tag, Long value) {
		xmlString = xmlString + sep + "  <" + tag + ">" + value + "</" + tag + ">"; 
		sep = "\r\n";
		return this;
	}
	
/*
 * Add xml opening tag only
 * 
 */
	public XmlString addTag(String tag) {
			xmlString = xmlString + sep + "<" + tag; 
			sep = ">\r\n";
			openTags.add(tag);
		return this;
	}
	
	public XmlString addValue(String value) {
		xmlString = xmlString + (sep.startsWith(">") ? ">":"") + value + "</" + openTags.get(openTags.size() - 1) + ">";
		sep = "\r\n";
		openTags.remove(openTags.size() - 1);
	return this;
}
	
/*
 * Add xml closing tag only
 * 
 */
	public XmlString addEndTag() {
			xmlString = xmlString + sep + "</" + openTags.get(openTags.size() - 1) + ">"; 
			sep = "\r\n";
			openTags.remove(openTags.size() - 1);
		return this;
	}
	
	public XmlString addAttribute(String attribute, String value) {
		if (value == null || value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
		}
		if (sep.startsWith(">")) {
			xmlString = xmlString + " " + attribute + "=\"" + value + "\"";
		} else {
			log.fatal("Attribute {} value {} could not be added - tag is already closed", attribute, value);
		}
		return this;
	}
	
	public String xmlValue() {
		xmlString = xmlString + (sep.startsWith(">") ? ">":"");
		sep = "\r\n";
		while (openTags.size() > 0) {
			addEndTag();
		}
		return xmlString;
	}

@Test
	public void testXml() {
		XmlString xmlString = new XmlString();
		String xml = xmlString
				.addTag("getCourtLog")
				.addAttribute("xmlns", "http://com.synapps.mojdarts.service.com")
				.addTag("courthouse")
				.addAttribute("xmlns", "")
				.addValue("DMP-467-LIVERPOOL")
				.addTag("caseNumber")
				.addAttribute("xmlns", "")
				.addValue("DMP-467-Case001")
				.addTag("startTime")
				.addAttribute("xmlns", "")
				.addValue("20230811160000")
				.addTag("endTime")
				.addAttribute("xmlns", "")
				.addValue("20230930170000")
				.xmlValue();
		System.out.println(xml);
	}
	
}
