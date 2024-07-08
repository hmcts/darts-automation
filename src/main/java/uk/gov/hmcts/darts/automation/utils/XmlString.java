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
	boolean encoded = false;
	String saveString = "";
	String lineEnd = LINE_END;
	
	public XmlString() {
		xmlString = "";
		sep = "";
		openTags = new ArrayList<String>();
		encoded = false;
		lineEnd = LINE_END;
	}
	
	String sep() {
//		return String.format("%s%" + ((openTags.size() > 0) ? (openTags.size() * 2) : "") + "s", sep, "");
		return String.format("%s%" + ((openTags.size() > 0 && !lineEnd.isEmpty()) ? (openTags.size() * 2) : "") + "s", sep, "");
	}
	
/*
 * return String split by whichever separator is used between multiple values in order of "~", ",", " "
 */
	public static String[] split(String string) {
		String sep = "";
		if (string.contains("~")) 
			return string.split("~");
		else 
			if (string.contains(",")) 
				return string.split(",");
			else
				if (string.contains(" ")) 
					return string.split(" ");
				else
					log.info("no separator found in string {}", string);
		return string.split(" ");
	}

	public static String split(String string, int index) {
		String[] split = split(string);
		if (split.length > index) {
			return split[index];
		}
		return "";
	}
	
	public XmlString useLineEnd(boolean lf) {
		lineEnd = lf ? LINE_END : "";
		return this;
	}

/*
* Add field to xml 
* 
*/
	public XmlString addTag(String tag, String attributes, String value) {
		if (value != null && !value.equalsIgnoreCase("MISSING")) {
			if (value == null || value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			xmlString = xmlString + sep() + "<" + tag + " " + Substitutions.substituteValue(attributes) + ">" + Substitutions.substituteValue(value) + "</" + tag + ">"; 
			sep = lineEnd;
		}
		return this;
	}
	public XmlString addTag(String tag, String value) {
		if (value != null && !value.equalsIgnoreCase("MISSING")) {
			if (value == null || value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
			}
			xmlString = xmlString + sep() + "<" + tag + ">" + Substitutions.substituteValue(value) + "</" + tag + ">"; 
			sep = lineEnd;
		}
		return this;
	}
	
	public XmlString addTag(String tag, Long value) {
		xmlString = xmlString + sep() + "  <" + tag + ">" + value + "</" + tag + ">"; 
		sep = lineEnd;
		return this;
	}
	
	public XmlString addTags(String tag, String[] values) {
		for (String value:values) {
			addTag(tag, value);
		}
		return this;
	}
	
	public XmlString addTags(String tag, String values, String separator) {
//		if (!values.isBlank()) {
			addTags(tag, values.split(separator));
//		}
		return this;
	}
	
	public XmlString addTags(String tag, String values) {
//		if (!values.isBlank()) {
			addTags(tag, split(values));
//		}
		return this;
	}
	
	public XmlString addTagGroup(String parent, String tag, String[] values) {
//		if (values.length > 0) {
			addTag(parent);
			addTags(tag, values);
			addEndTag();
//		}
		return this;
	}
	
	public XmlString addTagGroup(String parent, String tag, String values, String separator) {
//		if (!values.isBlank()) {
			addTagGroup(parent, tag, values.split(separator));
//		}
		return this;
	}
	
	public XmlString addTagGroup(String parent, String tag, String values) {
		addTagGroup(parent, tag, split(values));
		return this;
	}
	
	public XmlString startEncoding() {
		if (sep.startsWith(">")) {
			saveString = xmlString + ">";
			sep = sep.substring(1);
		} else {
			saveString = xmlString;
		}
		xmlString = "";
		encoded = true;
		return this;
	}
	
	public XmlString endEncoding() {
		if (sep.startsWith(">")) {
			xmlString = xmlString + ">";
			sep = sep.substring(1);
		}
		encoded = false;
		xmlString = saveString + encodeEntities(xmlString);
		return this;
	}
	
	String encodeEntities(String xml) {
		String result;
		if (xml.contains("&lt;")) {
			result = xml;
		} else {
			result = xml.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
		}
		return result;	
	}
	
/*
 * Add xml opening tag only
 * 
 */
	public XmlString addTag(String tag) {
		xmlString = xmlString + sep() + "<" + tag; 
		openTags.add(tag);
		sep = ">" + lineEnd;
		return this;
	}

/*
 * Add value to tag & close tag
 * 
 */
	public XmlString addValue(String value) {
		String tag = openTags.remove(openTags.size() - 1);
		xmlString = xmlString + (sep.startsWith(">") ? ">":"") + Substitutions.substituteValue(value) + "</" + tag + ">";
		sep = lineEnd;
		return this;
	}
	
/*
 * Add xml closing tag only
 * 
 */
	public XmlString addEndTag() {
		String tag = openTags.remove(openTags.size() - 1);
		if (sep.equals(">" + lineEnd)) {
			xmlString = xmlString + " />";
		} else {
			xmlString = xmlString + sep() + "</" + tag + ">"; 
		}
		sep = lineEnd;
		return this;
	}
	
	public XmlString addAttribute(String attribute, String value) {
		if (value == null || value.equalsIgnoreCase("BLANK") || value.equalsIgnoreCase("EMPTY")) {
				value = "";
		}
		if (sep.startsWith(">")) {
			xmlString = xmlString + " " + attribute + "=\"" + Substitutions.substituteValue(value) + "\"";
		} else {
			log.fatal("Attribute {} value {} could not be added - tag is already closed", attribute, value);
		}
		return this;
	}

/*
 * Add ready formed attribute=value pair(s)
 * 
 */
	public XmlString addAttributes(String attribute) {
		if (attribute != null && !attribute.isBlank()) {
			if (sep.startsWith(">")) {
				xmlString = xmlString + " " + Substitutions.substituteValue(attribute);
			} else {
				log.fatal("Attribute {} could not be added - tag is already closed", attribute);
			}
		}
		return this;
	}
	
	public XmlString addAttributes(String[] attributes) {
		for (String attribute : attributes) {
			addAttributes(attribute);
		}
		return this;
	}
	
/*
 * Add xml start CDATA
 * 
 */
	public XmlString addStartCdata() {
		xmlString = xmlString + sep() + "<![CDATA["; 
// future could use		openTags.add("CDATA");
		sep = "";
		return this;
	}
	
/*
 * Add xml end CDATA
 * 
 */
	public XmlString addEndCdata() {
		xmlString = xmlString + sep() + "]]>"; 
// future could use		addEndTag(); if openTags.add("CDATA"); is used
		sep = "";
		return this;
	}

/*
 * Add xml fragment
 * 
 */
	public XmlString addFragment(String xmlFragment) {
		xmlString = xmlString + sep + Substitutions.substituteValue(xmlFragment);
		sep = lineEnd;
		return this;
	}
	
	public String xmlValue() {
		xmlString = xmlString + (sep.startsWith(">") ? ">":"");
		sep = lineEnd;
		while (openTags.size() > 0) {
			addEndTag();
		}
		log.info(xmlString);
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
				.addFragment(new XmlString().addTag("extra", "extraValue").xmlValue())
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
