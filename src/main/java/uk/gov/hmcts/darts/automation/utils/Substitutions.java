package uk.gov.hmcts.darts.automation.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.Calendar;
import java.util.Arrays;
import java.util.Properties;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Year;
import java.time.format.DateTimeFormatter;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

import org.junit.jupiter.api.Assertions;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;


public class Substitutions {
	private static Logger log = LogManager.getLogger("Substitutions");
	static String parameterFileName = "src/test/resources/testdata.properties";
	
	static String currentYear =  Year.now().toString();
	static Properties propFile; // = new Properties();
	static Properties properties; // = new Properties();
	public String statusCode = "";
	public String responseString = "";
	private static int instanceCount = 0;
	
	static {
		log.info("Static count: " + ++instanceCount);
	}
	
	public Substitutions() {
		log.info("Create count: " + ++instanceCount);
	}

	
	public static String substituteValue(String value) {
		return substituteValue(value, "{{", "}}");
	}
		
	public static String substituteValue(String value, String delim1, String delim2) {
		String substitutedValue = "";
		String substitutionString = "";
		int subsEnd = value.indexOf(delim2);
		int subsStart = value.lastIndexOf(delim1, subsEnd);
		if ((subsStart >= 0) && (subsEnd > subsStart)) {
			String subsTag = value.substring(subsStart+2, subsEnd);
			String subsString = subsTag.toLowerCase();
			if (subsString.startsWith("date") || subsString.startsWith("numdate") ||
					subsString.startsWith("dd-") || subsString.startsWith("mm-") ||
					subsString.startsWith("yyyy-") || subsString.startsWith("yyyymmdd") ||
					subsString.startsWith("timestamp-") || subsString.startsWith("displaydate-") || 
					subsString.startsWith("displaydate0-") ||
					subsString.startsWith("utc-") || subsString.startsWith("retention-")) {
				substitutionString = DateUtils.substituteDateValue(subsString);
			} else {
				if (subsString.equalsIgnoreCase("seq")) {
					substitutionString = ReadProperties.seq;
				} else {
					if (subsString.equalsIgnoreCase("timestamp")) {
						substitutionString = DateUtils.timestamp();
					} else {
						if (subsString.equalsIgnoreCase("displaydate")) {
							substitutionString = DateUtils.todayDisplay();
						} else {
							if (subsString.equalsIgnoreCase("displaydate0")) {
								substitutionString = DateUtils.todayDisplay0();
							} else {
								if (subsString.startsWith("mac-address-")) {
									substitutionString = macAddress(subsTag.substring(12));
								} else {
									if (subsString.startsWith("ip-address-")) {
										substitutionString = ipAddress(subsTag.substring(11));
									} else {
										if (subsString.startsWith("upper-case-")) {
											substitutionString = subsTag.substring(11).toUpperCase();
										} else {
											substitutionString = TestData.getProperty(subsTag);
										}
									}
								}
							}
						}
					}
				}
			}
			substitutedValue = value.substring(0, subsStart)+substitutionString+value.substring(subsEnd+2);
			log.info("substituted =>"+subsString+"<= with =>"+substitutionString);
			log.info("substituted =>"+value+"<= with =>"+substitutedValue);
			return substituteValue(substitutedValue, delim1, delim2);
		} else {
			log.info("nothing to substitute =>"+value);
			return value;
		}
	}
	
	/*
	 * replace beginning of mac address supplied with sequence number
	 * 
	 */
	static String macAddress(String input) {
		String seq = ReadProperties.seq;
		seq = (seq.length() % 2 == 0) ? seq : "0" + seq;
		String output = "";
		for (int index = 0; index < seq.length(); index = index + 2) {
			output = output + seq.substring(index, index + 2) + "-";
		}
		output = output + input.substring(output.length());
		return output;
	}
	
	/*
	 * replace beginning of ip address supplied with sequence number
	 * use actual part if < 255 and not zero, otherwise use remainder 253
	 * 
	 */
	static String ipAddress(String input) {
		long seq = Long.parseLong(ReadProperties.seq);
		String output = "";
		int blocks = 0;
		while (seq > 0) {
			if (seq % 1000 < 255 && seq % 1000 > 0) {
				output = String.valueOf(seq % 1000) + "." + output;
				seq = seq / 1000;
			} else {
				output = String.valueOf(seq % 253 + 1) + "." + output;
				seq = seq / 253;
			}
			blocks++;
		}
		String [] in = input.split("\\.");
		for (; blocks < 3; blocks++) {
			output = output + in[blocks] + ".";
		}
		output = output + in[3];
		return output;
	}
	
	@Test
	public void test1() {
		System.out.println("========================");
		System.out.println("          1");
		System.out.println("========================");
		System.out.println(substituteValue("{{date-3}}"));
		System.out.println(substituteValue("{{date-3/}}"));
		System.out.println(substituteValue("{{timestamp}}"));
		System.out.println(substituteValue("{{timestamp-12:23:34}}"));
		System.out.println(substituteValue("{{displaydate}}"));
		System.out.println(substituteValue("{{displaydate0}}"));
		System.out.println(substituteValue("{{displayDate-{{date+7 years}}}}"));
		Assertions.assertEquals("12", substituteValue("{{dd-12/34/5678}}"));
		Assertions.assertEquals("9 Dec 2023", substituteValue("{{displaydate-09-12-2023}}"));
		System.out.println(substituteValue("{{displaydate-{{date+99years}}}}"));
		System.out.println(substituteValue("{{displaydate0-{{date+99years}}}}"));
	}
	
	@Test
	public void test2() {
		System.out.println("========================");
		System.out.println("          2");
		System.out.println("========================");
		System.out.println(substituteValue("{{ip-address-123.456.789.012}}"));
		System.out.println(substituteValue("{{mac-address-12-34-56-78-90-Ab}}"));
	}
	
	@Test
	public void test3() {
		System.out.println("========================");
		System.out.println("          3");
		System.out.println("========================");
		System.out.println(substituteValue("{{retention-7Y3M7D}}"));
		System.out.println(substituteValue("{{retention-7Y0M0D}}"));
	}
	
	@Test
	public void test4() {
		System.out.println("========================");
		System.out.println("          4");
		System.out.println("========================");
		System.out.println(substituteValue("{{upper-case-abcd}}"));
		System.out.println(substituteValue("{{upper-case-efGH}}"));
	}
}
