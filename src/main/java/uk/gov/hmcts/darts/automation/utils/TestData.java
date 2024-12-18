package uk.gov.hmcts.darts.automation.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.Calendar;
import java.util.Arrays;
import java.util.Properties;
import java.util.StringJoiner;
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
import java.nio.file.Files;
import java.nio.file.Paths;

import org.junit.jupiter.api.Assertions;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;


public class TestData {
	private static Logger log = LogManager.getLogger("TestData");
	static String parameterFileName = "src/test/resources/testdata.properties";
	
	static String currentYear =  Year.now().toString();
	static Properties propFile; // = new Properties();
	static Properties properties; // = new Properties();
	public String statusCode = "";
	public String responseString = "";
	private static int instanceCount = 0;
	public String userId = "";
	
	static {
		propFile = new Properties();
		properties = new Properties();
		try(FileInputStream inStream = new FileInputStream(new File(parameterFileName))) {
			try {
				propFile.load(inStream);
			} catch (Exception e) {
				log.fatal("Error loading properties >"+parameterFileName);
				e.printStackTrace();
			}
		} catch (Exception e) {
			log.fatal("Error loading properties file >"+parameterFileName);
			e.printStackTrace();
		}
		log.info("Instance count: " + ++instanceCount);
	}


/*
 * 
 * Read property from properties file
 * 
 */
	static String readProperty(String property) {
		
		return propFile.getProperty(property);
	}
	
/*
 * 
 * Save properties to property file
 * 
 */
	
	static void saveProperty(String property, String value) {
		properties.setProperty(property, value);
		propFile.setProperty(property, value);
		
		try {
			propFile.store(new FileWriter(parameterFileName), "values to substitute in scenarios");
		} catch (IOException e) {
			Assertions.fail("Error saving property: " + property);
		}
	}
	
/*
 * 
 * Get property unique per run
 * 
 * increment some default values
 * 
 */
	public static String getProperty(String property) {
		String returnValue;
		try {
			returnValue = properties.getProperty(Thread.currentThread().getId() + "_" + property);
			if (returnValue == null) {
				returnValue = readProperty(property);
				if (returnValue != null) {
					switch(property) {
						case "case_number": 
							String courtHouse = getProperty("courthouse");
							if (!courtHouse.isBlank()) {
								String caseType = getProperty("case_type");
								if (!caseType.isBlank()) {
									returnValue = getNextCaseNumber(getProperty("courthouse"), getProperty("case_type"));
								}
							}
							break;
						case "event_id":
						case "courthouse_code":
							returnValue = increment(returnValue);
							saveProperty(property, returnValue);
							break;
					}
					properties.put(property, returnValue);
					log.info("value for " + property + " from properties file - returning " + returnValue);
				} else {
					log.info("value for " + property + " not found " + returnValue);
					returnValue = "";
				}
			} else {
				log.info("value for " + property + " previously accessed - returning " + returnValue);
			}
		} catch (Exception e) {
			returnValue = readProperty(property);
			if (returnValue != null) {
				properties.put(property, returnValue);
				log.info("value for " + property + " from properties (after exception - should not happen) - returning " + returnValue);
			} else {
				log.info("value for " + property + " not found in properties (after exception - should not happen) - returning " + returnValue);
				returnValue = "";
			}
		}
		return returnValue;
	}
	
/*
 * parse argument string of property=value pairs separated by commas 
 * 
 * verifies that property is in the | separated list(with | at each end) 
 * 
 * and store in properties
 * 
 */
	public void parseArgument(String arg1, String validValues) {
		int errors = 0;
		if (arg1.length() > 0) {
			String [] arg = arg1.split(",");
			for (int index = 0; index < arg.length; index ++) {
				String [] pair = arg[index].split("=");
				if (pair.length != 2
						|| (!validValues.isBlank() && validValues.indexOf("|"+pair[0]+"|") < 0)) {
					errors++;
					log.fatal("invalid argument [" + (index + 1) + "] : " + arg[index]);
				} else {
					log.info("storing property " + pair[0] + " as " + pair[1]);
					setProperty(pair[0], pair[1]);
				}
			}
			if (errors > 0) {
				log.fatal("" + errors + " errors parsing argument");
				Assertions.fail("" + errors + " errors parsing argument");
			}
		} else {
			log.info("no data in argument");
		}
	}
	
	public void setProperty(String property, String value) {
		properties.setProperty(Thread.currentThread().getId() + "_" + property, value);
		log.debug("Value added to properties:", property, value);
	}
	
	public int getIntProperty(String property) {
		return Integer.parseInt(getProperty(property));
	}
	
	public long getLongProperty(String property) {
		return Long.parseLong(getProperty(property));
	}
	
	public static String increment(String value) {
		int currentLength = value.length();
		char[] character = value.toCharArray();
		int pos = currentLength - 1;
		while ((pos >= 0)  
				&& ((character[pos] >= '0') && (character[pos] <= '9'))) {
			pos--;
		}
		String prefix = "";
		String numPart = value;
		if (pos != -1) {
			prefix = value.substring(0, pos + 1);
			numPart = value.substring(pos + 1);
		}
		long newVal = Long.parseLong(numPart) + 1;
		String format = "%s%0" + String.valueOf(currentLength - pos - 1) + "d";
		return String.format(format, prefix, newVal);
	}
	
	public static String getNext(String property) {
		String nextValue = properties.getProperty(property);
		if (nextValue == null) {
			nextValue = propFile.getProperty(property);
			if (nextValue == null) {
				nextValue = "0";
			}
			nextValue = increment(nextValue);
			saveProperty(property, nextValue);
		}
		return nextValue;
	}
	
	public static String getNextSeqNo() {
		String seq = "000" + getNext("seq");
		return seq.substring(seq.length() - 4);
	}
	
	public static String getNextCaseNumber(String courtHouse, String caseType) {
		String propertyKey = "CaseNumber-" + courtHouse + "-" + caseType;
		String caseNumber = properties.getProperty(propertyKey);
		if (caseNumber == null) {
			caseNumber = propFile.getProperty(propertyKey);
			if (caseNumber == null) {
				caseNumber = caseType + "20209999";
			}
			caseNumber = incrementCaseNumber(caseNumber);
			saveProperty(propertyKey, caseNumber);
		}
		return caseNumber;
	}
	
	/*
	 * Increment Case Number based on expected structure
	 * x	1 alpha
	 * 9999 4 year
	 * 9999 4 (or potentially more in test) index starting 1 per courthouse
	 * At change of year, reset index to 1
	 * 
	 */
	public static String incrementCaseNumber(String currentCaseNumber) {
		String caseYear = currentCaseNumber.substring(1, 5);
		int caseNum = Integer.parseInt(currentCaseNumber.substring(5));
		if (!caseYear.equals(currentYear)) {
			caseYear = currentYear;
			caseNum = 0;
		}
		return String.format("%s%s%04d",currentCaseNumber.substring(0, 1), caseYear, ++caseNum);
	}
	
	public static String readTextFile(String filename) {
		return readTextFile(filename, ReadProperties.main("testdataFolder"));
	}
	
	public static String readTextFile(String filename, String directory) {
		log.info("reading file {}/{}", directory, filename);
		String filePath = new StringJoiner(File.separator)
				.add(directory).add(Substitutions.substituteValue(filename)).toString();
		String text;
		try {
// n.b. readAllBytes works for binary files too
			text = new String(Files.readAllBytes(Paths.get(filePath)));
			return text;
		} catch (IOException e) {
			log.warn("error reading file {}", filePath);
			e.printStackTrace();
			return null;
		}
	}
	
	@Test
	public void test_increment() {
		log.info(increment("123"));
		log.info(increment("A123"));
		log.info(increment("A999"));
		log.info(increment("A0123"));
		log.info(increment("A0999"));
		log.info(increment("A1A123"));
		log.info(increment("0"));
		log.info(increment("000"));
		log.info(incrementCaseNumber("A20201234"));
		log.info(incrementCaseNumber("A20239999"));
		log.info(incrementCaseNumber("A202310000"));
		log.info(incrementCaseNumber("A20231234"));
		log.info(getNextCaseNumber("TREV", "X"));
		log.info(getNextCaseNumber("TREV", "X"));
		log.info(getNextCaseNumber("TREV1", "X"));
		log.info(getNextCaseNumber("TREV1", "Y"));
		log.info(getNextCaseNumber("TREV2", "X"));
		log.info(getNext("TREV"));
		log.info(getNext("TREV"));
		log.info(getNext("TREV1"));
		log.info(getNext("TREV1"));
		log.info(getNext("TREV2"));
		log.info(getNext("TREV2"));
	}
	
	@Test
	public void testparse() throws Exception {
		parseArgument("aaa=1,bbb=2,ccc=my o my", "|aaa|bbb|ccc|");
		parseArgument("", "");
		parseArgument("", "|aaa|bbb|ccc|");
	}

}
