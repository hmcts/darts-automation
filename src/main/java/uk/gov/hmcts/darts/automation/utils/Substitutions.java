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
					subsString.startsWith("timestamp-") || subsString.startsWith("displaydate-")) {
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
							if (subsString.equalsIgnoreCase("timestamp")) {
								substitutionString = DateUtils.timestamp();
							} else {
								substitutionString = TestData.getProperty(subsTag);
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
	
	@Test
	public void test1() {
		System.out.println(substituteValue("{{date-3}}"));
		System.out.println(substituteValue("{{date-3/}}"));
		System.out.println(substituteValue("{{timestamp}}"));
		System.out.println(substituteValue("{{timestamp-12:23:34}}"));
		System.out.println(substituteValue("{{displaydate}}"));
		Assertions.assertEquals("12", substituteValue("{{dd-12/34/5678}}"));
		Assertions.assertEquals("9 Dec 2023", substituteValue("{{displaydate-09-12-2023}}"));
	}
}
