package uk.gov.hmcts.darts.automation.utils;

import java.util.ArrayList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;

public class XmlString {
	private static Logger log = LogManager.getLogger("xmlString");
	private static String LINE_END = System.lineSeparator();
	
	public String xmlString = "";
	String sep = "";
	ArrayList<String> openTags;
	
	public XmlString() {
		xmlString = "";
		sep = "";
		openTags = new ArrayList<String>();
	}
	
	String sep() {
		return String.format("%s%" + ((openTags.size() > 0)? (openTags.size() * 2):"") + "s", sep, "");
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
			xmlString = xmlString + sep() + "<" + tag + ">" + value + "</" + tag + ">"; 
			sep = LINE_END;
		}
		return this;
	}
	
	public XmlString addTag(String tag, Long value) {
		xmlString = xmlString + sep() + "  <" + tag + ">" + value + "</" + tag + ">"; 
		sep = LINE_END ;
		return this;
	}
	
	public XmlString addTags(String tag, String values, String separator) {
		if (!values.isBlank()) {
			String[] vals = values.split(separator);
			for (String val:vals) {
				addTag(tag, val);
			}
		}
		return this;
	}
	
/*
 * Add xml opening tag only
 * 
 */
	public XmlString addTag(String tag) {
		xmlString = xmlString + sep() + "<" + tag; 
		openTags.add(tag);
		sep = ">" + LINE_END;
		return this;
	}
	
	public XmlString addValue(String value) {
		String tag = openTags.remove(openTags.size() - 1);
		xmlString = xmlString + (sep.startsWith(">") ? ">":"") + value + "</" + tag + ">";
		sep = LINE_END;
	return this;
}
	
/*
 * Add xml closing tag only
 * 
 */
	public XmlString addEndTag() {
		String tag = openTags.remove(openTags.size() - 1);
		xmlString = xmlString + sep() + "</" + tag + ">"; 
		sep = LINE_END;
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
		sep = LINE_END;
		while (openTags.size() > 0) {
			addEndTag();
		}
		return xmlString;
	}

@Test
	public void testXml() {
		String xml = new XmlString()
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

		xml = new XmlString()
				.addTag("log_entry")
				.addAttribute("Y", "2023")
				.addAttribute("M", "07")
				.addAttribute("D", "01")
				.addAttribute("H", "10")
				.addAttribute("MIN", "00")
				.addAttribute("S", "00")
				.addTag("courthouse", "DMP-467-LIVERPOOL")
				.addTag("courtroom", "DMP-467-LIVERPOOL-ROOM_A")
				.addTag("case_numbers")
				.addTag("case_number", "DMP-467-Case011")
				.addEndTag()
				.addTag("text", "abcdefgh1234567890abcdefgh1234567890abcdefgh1234567890abcdefgh12")
				.xmlValue();
		System.out.println(xml);
		
		xml = new XmlString()
				.addTag("case")
				.addAttribute("type", "")
				.addAttribute("id", "T20230000")
				.addTag("courthouse", "DMP-723-LIVERPOOL<")
				.addTag("defendants")
				.addTag("defendant", "DMP-723-AC1-D001")
				.addTag("defendant", "DMP-723-AC1-D002")
				.addEndTag()
				.addTag("judges")
				.addTag("judge", "DMP-723-AC1-J001")
				.addEndTag()
				.addTag("prosecutors")
				.addTag("prosecutor", "DMP-723-AC1-P001")
				.xmlValue();
		System.out.println(xml);
				
				
	}
	
}
