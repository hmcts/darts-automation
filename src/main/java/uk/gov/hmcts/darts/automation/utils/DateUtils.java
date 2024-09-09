package uk.gov.hmcts.darts.automation.utils;

import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import java.util.Calendar;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.zone.ZoneRules;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;


public class DateUtils {
	private static Logger log = LogManager.getLogger("DateUtils");
	private static int instanceCount = 0;

	static {
		log.info("Instance count: " + ++instanceCount);
	}
	
	public static String datePlusCalDays(String calDays) {
		return datePlusCalDays(Integer.parseInt(calDays));
	}
	
	public static String dateMinusCalDays(String calDays) {
		return dateMinusCalDays(Integer.parseInt(calDays));
	}
	
	public static String datePlusCalDays(int calDays) {
		return datePlusCalDays(calDays, "dd-MM-yyyy");
	}
	
	public static String dateMinusCalDays(int calDays) {
		return dateMinusCalDays(calDays, "dd-MM-yyyy");
	}
	
	public static String datePlusWeekDays(String weekDays) {
		return datePlusWeekDays(Integer.parseInt(weekDays));
	}
	
	public static String dateMinusWeekDays(String weekDays) {
		return dateMinusWeekDays(Integer.parseInt(weekDays));
	}
	
	public static String datePlusWeekDays(int weekDays) {
		if (weekDays < 0) {
			return dateMinusWeekDays(0 - weekDays, "dd-MM-yyyy");
		} else {
			return datePlusWeekDays(weekDays, "dd-MM-yyyy");
		}
	}
	
	public static String dateMinusWeekDays(int weekDays) {
		return dateMinusWeekDays(weekDays, "dd-MM-yyyy");
	}

	
	public static String datePlusMonths(String interval) {
		return datePlusMonths(Integer.parseInt(interval.strip()));
	}
	
	public static String datePlusYears(String interval) {
		return datePlusYears(Integer.parseInt(interval.strip()));
	}
	
	public static String dateMinusMonths(String interval) {
		return dateMinusMonths(Integer.parseInt(interval.strip()));
	}
	
	public static String datePlusMonths(int interval) {
		return datePlusMonths(interval, "dd-MM-yyyy");
	}
	
	public static String dateMinusMonths(int interval) {
		return dateMinusMonths(interval, "dd-MM-yyyy");
	}
	
	public static String datePlusYears(int interval) {
		return datePlusYears(interval, "dd-MM-yyyy");
	}
	
	public static String numdatePlusCalDays(String weekDays) {
		return numdatePlusCalDays(Integer.parseInt(weekDays));
	}
	
	public static String numdateMinusCalDays(String weekDays) {
		return numdateMinusCalDays(Integer.parseInt(weekDays));
	}
	
	public static String numdatePlusCalDays(int calDays) {
		return datePlusCalDays(calDays, "ddMMyyyy");
	}
	
	public static String numdateMinusCalDays(int calDays) {
		return dateMinusCalDays(calDays, "ddMMyyyy");
	}
	
	public static String numdatePlusWeekDays(String weekDays) {
		return numdatePlusWeekDays(Integer.parseInt(weekDays));
	}
	
	public static String numdateMinusWeekDays(String weekDays) {
		return numdateMinusWeekDays(Integer.parseInt(weekDays));
	}
	
	public static String numdatePlusWeekDays(int weekDays) {
		if (weekDays < 0) {
			return dateMinusWeekDays(0 - weekDays, "ddMMyyyy");
		} else {
			return datePlusWeekDays(weekDays, "ddMMyyyy");
		}
	}
	
	public static String numdateMinusWeekDays(int weekDays) {
		return dateMinusWeekDays(weekDays, "ddMMyyyy");
	}
	
	public static String yyyymmddDatePlusWeekDays(int weekDays) {
		if (weekDays < 0) {
			return dateMinusWeekDays(0 - weekDays, "ddMMyyyy");
		} else {
			return datePlusWeekDays(weekDays, "ddMMyyyy");
		}
	}
	
	public static String numDateTime() {
		String format = "yyyyMMddHHmmssSSS";
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format((Date)cal.getTime());
	}
	
	public static String zonedTimestamp() {
		return DateTimeFormatter
				.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
				.format(ZonedDateTime.now());
	}
	
	public static String localTimestamp() {
		return DateTimeFormatter
				.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
				.format(LocalDateTime.now());
	}
	
	public static String timestamp() {
		return zonedTimestamp();
// Alternative if local time is required for BST - check format to be used
//		return localTimestamp();
	}

	
	public static String datePlusCalDays(int calDays, String format) {
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		cal.add(Calendar.DAY_OF_MONTH, calDays);
		return dateFormat.format((Date)cal.getTime());
	}
	
	public static String dateMinusCalDays(int calDays, String format) {
		return datePlusCalDays(0-calDays, format);
	}
	
	public static String datePlusWeekDays(int weekDays, String format) {
		Date dateToday = new Date();
		int extraDays = 0;
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		int dayToday = cal.get(Calendar.DAY_OF_WEEK);
		if (weekDays < 0) {
			weekDays = 0 - weekDays;
			switch(cal.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SATURDAY: 
				extraDays = 1;
				dayToday = Calendar.FRIDAY;
				break;
			case Calendar.SUNDAY: 
				extraDays = 2;
				dayToday = Calendar.FRIDAY;
				break;
			}
			int daysThisWeek = dayToday - Calendar.SUNDAY;
			int weekEnds = weekDays / 5;
			extraDays = extraDays + weekEnds * 2;
			int daysOver = weekDays % 5;
			if (daysOver >= daysThisWeek) {
				extraDays = extraDays + 2;
			}
			cal.add(Calendar.DAY_OF_MONTH, 0-weekDays-extraDays);
		} else {
			switch(cal.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SATURDAY: 
				extraDays = 2;
				dayToday = Calendar.MONDAY;
				break;
			case Calendar.SUNDAY: 
				extraDays = 1;
				dayToday = Calendar.MONDAY;
				break;
			}
			int daysThisWeek = Calendar.SATURDAY - dayToday;
			int weekEnds = weekDays / 5;
			extraDays = extraDays + weekEnds * 2;
			int daysOver = weekDays % 5;
			if (daysOver >= daysThisWeek) {
				extraDays = extraDays + 2;
			}
			cal.add(Calendar.DAY_OF_MONTH, weekDays+extraDays);
		}
		return dateFormat.format((Date)cal.getTime());
	}

// dateMinusWeekDays() is now superfluous - dateplusweekdays() handles negatives
	public static String dateMinusWeekDays(int weekDays, String format) {
		Date dateToday = new Date();
		int extraDays = 0;
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		int dayToday = cal.get(Calendar.DAY_OF_WEEK);
		switch(cal.get(Calendar.DAY_OF_WEEK)) {
		case Calendar.SATURDAY: 
			extraDays = 1;
			dayToday = Calendar.FRIDAY;
			break;
		case Calendar.SUNDAY: 
			extraDays = 2;
			dayToday = Calendar.FRIDAY;
			break;
		}
		int daysThisWeek = dayToday - Calendar.SUNDAY;
		int weekEnds = weekDays / 5;
		extraDays = extraDays + weekEnds * 2;
		int daysOver = weekDays % 5;
		if (daysOver >= daysThisWeek) {
			extraDays = extraDays + 2;
		}
		cal.add(Calendar.DAY_OF_MONTH, 0-weekDays-extraDays);
		return dateFormat.format((Date)cal.getTime());
	}

	
	public static String datePlusMonths(int months, String format) {
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		cal.add(Calendar.MONTH, months);
		return dateFormat.format((Date)cal.getTime());
	}
	
	public static String datePlusYears(int years, String format) {
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		cal.add(Calendar.YEAR, years);
		return dateFormat.format((Date)cal.getTime());
	}
	
	public static String dateMinusMonths(int months, String format) {
		return datePlusMonths(0-months, format);
	}
	
	public static String datePlus(String offset, String format) {
		if (offset.endsWith("w")) {
			return datePlusWeekDays(Integer.parseInt(offset.substring(0, offset.length() - 1).strip()), format);
		} else {
			if (offset.endsWith("c")) {
				return datePlusCalDays(Integer.parseInt(offset.substring(0, offset.length() - 1).strip()), format);
			} else {
				if (offset.isBlank()) {
					return datePlusCalDays(0, format);
				} else {
					return datePlusCalDays(Integer.parseInt(offset.strip()), format);
				}
			}
		}
	}
	
	public static String substituteDateValue(String subsString) {
		String substitutedValue = "";
		String substitutionString = "";
		if (subsString.startsWith("date-") || subsString.startsWith("date+")) {
			boolean requireDelimChange = (subsString.endsWith("/"));
			if (requireDelimChange) {
				subsString = subsString.substring(0, subsString.length()-1);
			}
			if (subsString.startsWith("date-yyyymmdd")) {
				substitutionString = datePlus(subsString.substring(13), "yyyy-MM-dd");
			} else {
				if (subsString.endsWith("w")) {
					substitutionString = datePlusWeekDays(subsString.substring(4, subsString.length()-1));
				} else {
					if (subsString.endsWith("c")) {
						substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-1));
					} else {
						if (subsString.endsWith("n")) {
							substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-1)).replace("-", "");
						} else {
							if (subsString.endsWith("months")) {
								substitutionString = datePlusMonths(subsString.substring(4, subsString.length()-6));
							} else {
								if (subsString.endsWith("years")) {
									substitutionString = datePlusYears(subsString.substring(4, subsString.length()-5));
								} else {
									substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-0));
								}
							}
						}
					}
				}
			}
			if (requireDelimChange) {
				substitutionString = substitutionString.replace("-", "/");
			}
		} else {
			if (subsString.startsWith("numdate-") || subsString.startsWith("numdate+")) {
				if (subsString.endsWith("w")) {
					substitutionString = numdatePlusWeekDays(subsString.substring(7, subsString.length()-1));
				} else {
					if (subsString.endsWith("c")) {
						substitutionString = numdatePlusCalDays(subsString.substring(7, subsString.length()-1));
					} else {
						if (subsString.endsWith("n")) {
							substitutionString = numdatePlusCalDays(subsString.substring(7, subsString.length()-1)).replace("-", "");
						} else {
							substitutionString = numdatePlusCalDays(subsString.substring(7, subsString.length()-0));	
						}
					}
				}
			} else {
				if (subsString.startsWith("datetime")) {
					substitutionString = numDateTime();
				} else {
					if (subsString.equals("yyyymmdd")) {
						substitutionString = todayYyyymmdd();
					} else {
						if (subsString.startsWith("dd-")) {
							substitutionString = subsString.substring(3, 5);
						} else {
							if (subsString.startsWith("mm-")) {
								substitutionString = subsString.substring(6, 8);
							} else {
								if (subsString.startsWith("yyyy-")) {
									substitutionString = subsString.substring(11, 15);
								} else {
									if (subsString.startsWith("timestamp-")) {
										substitutionString = timestamp(subsString.substring(10, 18));
									} else {
										if (subsString.startsWith("displaydate-")) {
											substitutionString = displayDate(subsString.substring(12));
										} else {
											if (subsString.startsWith("displaydate0-")) {
												substitutionString = displayDate0(subsString.substring(13));
											} else {
												if (subsString.startsWith("utc-")) {
													substitutionString = utcTimestamp(subsString.substring(4));
												} else {
													if (subsString.startsWith("retention-")) {
														substitutionString = retention(subsString.substring(10));
													} else {
														Assertions.fail("Invalid value to substitute =>" + subsString );
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return substitutionString;
	}
	
	public static String todayYyyymmdd() {
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return dateFormat.format((Date)cal.getTime());		
	}

	public static String todayDdmmyy() {
		LocalDate date = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
		return date.format(formatter);
	}
	
	public static String timestamp(String time) {
		return todayYyyymmdd() + "T" + time + ".000Z";
	}
	
	public static String todayDisplay() {
		LocalDate date = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy", Locale.ENGLISH);
		return date.format(formatter);
	}
	
	public static String todayDisplay0() {
		LocalDate date = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.ENGLISH);
		return date.format(formatter);
	}
	
	public static String dateAsYyyyMmDd(String string) {
		return datePart(string, "yyyy") + "-" + datePart(string, "mm") + "-" + datePart(string, "dd");
	}
	
	public static String displayDate(String string) {
		LocalDate date = LocalDate.parse(dateAsYyyyMmDd(string));
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy", Locale.ENGLISH);
		return date.format(formatter);
	}
	
	public static String displayDate0(String string) {
		LocalDate date = LocalDate.parse(dateAsYyyyMmDd(string));
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.ENGLISH);
		return date.format(formatter);
	}
	
	public static String datePart(String string, String part) {
		String substitutedString = Substitutions.substituteValue(string).split("T")[0];
		if (substitutedString.isBlank()) {
			substitutedString = todayYyyymmdd();
		}
		String [] split = substitutedString.split(substitutedString.contains("/") ? "/" : "-");
		if (split.length == 3) {
			switch(part.toLowerCase()) {
				case "d":
				case "dd":
					if (split[0].length() < 3) {
						return split[0];
					} else {
						return split[2];
					}
				case "m":
				case "mm":
					return split[1];
				case "y":
				case "yy":
				case "yyyy":
					if (split[0].length() > 2) {
						return split[0];
					} else {
						if (split[2].length() > 2) {
							return split[2];
						} else {
							return "20" + split[2];
						}
					}
				default:
					Assertions.fail("Invalid part of date " + part + " for date " + string);
			}
		} else {
			Assertions.fail("Invalid date: " + string);
		}
		return null;
	}
	
	public static String timePart(String string, String part) {
		String substitutedString = Substitutions.substituteValue(string);
		String [] split = ((substitutedString.length() > 8) ? substitutedString.split("T")[1] : substitutedString).split(":");
		if (split.length == 3) {
			switch(part.toLowerCase()) {
				case "h":
				case "hh":
					return split[0];
				case "m":
				case "mm":
				case "min":
					return split[1];
				case "s":
				case "ss":
					return split[2].split("Z")[0].split("\\.")[0];
				default:
					Assertions.fail("Invalid part of time " + part + " for time " + string);
			}
		} else {
			Assertions.fail("Invalid time: " + string);
		}
		return null;
	}
	
	public static String makeTimestamp(String dateTime, String date, String time) {
		if (dateTime.isBlank()) {
			return makeTimestamp(date, time);
		} else {
			return makeTimestamp(dateTime);
		}
	}
	
	public static String makeTimestamp(String dateTime) {
		String [] split = dateTime.contains("T") ? dateTime.split("T") : dateTime.split(" ");
		if (split.length == 2) {
			return makeTimestamp(split[0], split[1]);
		} else {
			if (dateTime.length() == 8) {
				if (dateTime.contains(":")) {
					return makeTimestamp("", dateTime);
				} else {
					if (dateTime.contains("-") || dateTime.contains("/")) {
						return makeTimestamp(dateTime, "");
					} else {
						return dateTime;
					}
				}
			} else {
				return dateTime;
			}
		}
	}
	
	public static String makeTimestamp(String date, String time) {
		String [] split = date.split(date.contains("/") ? "/" : "-");
		if (split.length == 3) {
			if (split[0].length() > 2) {
				return String.format("%s-%s-%sT%s.000Z", split[0], split[1], split[2], time.substring(0, 8));
			} else {
				if (split[2].length() > 2) {
					return String.format("%s-%s-%sT%s.000Z", split[2], split[1], split[0], time);
				} else {
					return String.format("20%s-%s-%sT%s.000Z", split[2], split[1], split[0], time);
				}
			}
		} else {
			if (date.isBlank()) {
				if (time.isBlank()) {
					return "";
				} else {
					return makeTimestamp(todayYyyymmdd(), time);
				}
			} else {
				if (time.isBlank()) {
					return date;
				} else {
					return timestamp(time);
				}
			}
		}
	}
	
/*
 *  event & audio timestamps are stored in the database as UTC 
 *          "as timezones can change so this helps prevent inconsistent results from tests at different execution times"
 *          hopefully we won't change to BST all year or align with continental Europe in the future ...
 * 
 */
	public static String utcTimestamp(String localTimestamp) {
		String currentOffset;
		
//		try {
//			currentOffset = "+" + zonedTimestamp().split("+")[1];
//		} catch (Exception e) {
//			currentOffset = "+00:00";
//		}
		
		ZoneId zoneId = ZoneId.of("Europe/London");
		ZoneRules zoneRules = zoneId.getRules();
		ZonedDateTime now = ZonedDateTime.now(zoneId);
		currentOffset = now.getOffset().toString();
		boolean isDst = zoneRules.isDaylightSavings(now.toInstant());
		
		localTimestamp = localTimestamp.replace(" ", "T");
		
		if (!(localTimestamp.endsWith("Z") || localTimestamp.contains("+"))) {
			localTimestamp = localTimestamp + currentOffset;
		}
		
		Instant zonedTimestamp = Instant.parse(localTimestamp);
		
		return zonedTimestamp.toString();
	}
	
/*
 *  return current date + retention supplied in Y%M%D% format 
 *          return date is in timestamp format with zero time
 * 
 */
	public static String retention(String offset) {
		String offsetU = offset.toUpperCase();
		Date dateToday = new Date();
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		try {
			String[] splitY = offsetU.split("Y");
			String years = "0";
			String months = "0";
			String days = "0";
			String afterY;
			if (splitY.length == 1) {
				if (offsetU.endsWith("M") || offsetU.endsWith("D")) {
					years = "0";
					afterY = splitY[0];
				} else {
					years = splitY[0];
					afterY = "";
				}
			} else {
				years = splitY[0];
				afterY = splitY[1];
			}
			cal.add(Calendar.YEAR, Integer.parseInt(years));
			
			
			String[] splitM = afterY.split("M");
			String afterM;
			if (splitM.length == 1) {
				if (afterY.endsWith("D")) {
					months = "0";
					afterM = splitM[0];
				} else {
					months = splitM[0];
					afterM = "";
				}
			} else {
				months = splitM[0];
				afterM = splitM[1];
			}
			cal.add(Calendar.MONTH, Integer.parseInt(months));
			
			String[] splitD = afterM.split("D");
			if (splitD[0].equals("")) {
				days = "0";
			} else {
				days = splitD[0];
			}
			cal.add(Calendar.DAY_OF_MONTH, Integer.parseInt(days));
		} catch ( Exception e) {
			log.fatal("Error calculating offset date for {}: cal", offset, cal);
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String retentionString = dateFormat.format((Date)cal.getTime());
		
		ZonedDateTime utcDateTime = ZonedDateTime.of(LocalDate.parse(retentionString), LocalTime.parse("00:00:00"), ZoneId.of("UTC+00:00"));
		ZonedDateTime actualDateTime = utcDateTime.withZoneSameInstant(ZoneId.of("Europe/London"));

		String currentOffset = actualDateTime.getOffset().toString();

		return DateTimeFormatter
		.ofPattern("yyyy-MM-dd' 'HH:mm:ss")
		.format(actualDateTime) + (currentOffset.equals("Z") ? "+00" : currentOffset.substring(0, 3));
	}
	
	public static String returnNumericDateCcyymmdd(String date) {
		String [] split = date.split(date.contains("/") ? "/" : "-");
		if (split.length == 3) {
			if (split[0].length() > 2) {
				return split[0] + split[1] + split[2];
			} else {
				if (split[2].length() > 2) {
					return split[2] + split[1] + split[0];
				} else {
					return "20" + split[2] + split[1] + split[0];
				}
			}
		} else {
			if (date.length() == 6) {
				return  "20" + date;
			} else {
				return date;
			}
		}
	}
	
	public static String returnNumericTime(String time) {
		if (time.length() > 8) {
			time = time.substring(0, 8);
		}
		String []  split = time.split(":");
		switch (split.length) {
		case 3:
			return split[0] + split[1] + split[2];
		case 2:
			return split[0] + split[1] + "00";
		default:
			if (time.length() > 6) {
				return time.substring(0, 6);
			} else {
				return time + "000000".substring(0, 6 - time.length());
			}
			
		}
	}
	
	public static String makeNumericDateTime(String dateTime, String date, String time) {
		if (dateTime.isBlank()) {
			return makeNumericDateTime(date, time);
		} else {
			return makeNumericDateTime(dateTime);
		}
	}
	
	public static String makeNumericDateTime(String dateTime) {
		String [] split = dateTime.contains("T") ? dateTime.split("T") : dateTime.split(" ");
		if (split.length == 2) {
			return makeNumericDateTime(split[0], split[1]);
		} else {
			if (dateTime.contains(":")) {
				return makeNumericDateTime("", dateTime);
			} else {
				return dateTime;
			}
		}
	}
	
	public static String makeNumericDateTime(String date, String time) {
		String [] split = date.split(date.contains("/") ? "/" : "-");
		if (split.length == 3) {
			if (split[0].length() > 2) {
				return String.format("%s%s%s%s", split[0], split[1], split[2], returnNumericTime(time));
			} else {
				if (split[2].length() > 2) {
					return String.format("%s-%s-%sT%s.000Z", split[2], split[1], split[0], returnNumericTime(time));
				} else {
					return String.format("20%s-%s-%sT%s.000Z", split[2], split[1], split[0], returnNumericTime(time));
				}
			}
		} else {
			if (date.isBlank()) {
				if (time.isBlank()) {
					return "";
				} else {
					return makeNumericDateTime(todayYyyymmdd(), time);
				}
			} else {
				if (time.isBlank()) {
					return date;
				} else {
					return date + returnNumericTime(time);
				}
			}
		}
	}
	
	@Test
	public void test1() {
		System.out.println("========================");
		System.out.println("          1");
		System.out.println("========================");
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("2023-12-09 12:00:00"));
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("09-12-23 12:00:00"));
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("2023-12-09T12:00:00.000Z"));
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("2023-12-09", "12:00:00"));
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("09-12-2023", "12:00:00"));
		Assertions.assertEquals("2023-12-09T12:00:00.000Z", makeTimestamp("09/12/23", "12:00:00"));
		Assertions.assertEquals(makeTimestamp("", "12:00:00"), makeTimestamp("12:00:00"));
		Assertions.assertEquals("9 Dec 2023", displayDate("2023-12-09"));
		Assertions.assertEquals("31 Dec 2023", displayDate("31-12-2023"));
		Assertions.assertEquals("12", datePart("12-34-45", "dd"));
		Assertions.assertEquals("12", datePart("12/34/2045", "dd"));
		Assertions.assertEquals("12", datePart("2045/34/12", "dd"));
		Assertions.assertEquals("34", datePart("12/34/2045", "mm"));
		Assertions.assertEquals("2045", datePart("12-34-45", "yy"));
		Assertions.assertEquals("2045", datePart("12/34/2045", "yy"));
		Assertions.assertEquals("2045", datePart("2045/34/12", "yy"));
	}
	
	@Test
	public void test2() {
		System.out.println("========================");
		System.out.println("          2");
		System.out.println("========================");
		System.out.println(makeTimestamp("", "12:00:00"));
		System.out.println(todayDisplay());
		System.out.println(timestamp());
		System.out.println(timestamp("12:34:45"));
		System.out.println(substituteDateValue("timestamp-12:34:45"));
		System.out.println(datePart("", "dd"));
		System.out.println(substituteDateValue("date+0/"));
	}
	
	@Test
	public void test3() {
		System.out.println("========================");
		System.out.println("          3");
		System.out.println("========================");
		System.out.println(substituteDateValue("date-7 months"));
		System.out.println(substituteDateValue("date-7months"));
		System.out.println(substituteDateValue("date-84 months"));
		System.out.println(substituteDateValue("date-84months"));
		System.out.println(substituteDateValue("date-7 years/"));
		System.out.println(substituteDateValue("date-7years/"));
		System.out.println(substituteDateValue("date-7/"));
		System.out.println(substituteDateValue("date-7c/"));
		System.out.println(substituteDateValue("date-7w/"));
		System.out.println(substituteDateValue("date-7n"));
		System.out.println("-----------------------");
		System.out.println(substituteDateValue("date+7 months"));
		System.out.println(substituteDateValue("date+7months"));
		System.out.println(substituteDateValue("date+84 months"));
		System.out.println(substituteDateValue("date+84months"));
		System.out.println(substituteDateValue("date+7 years/"));
		System.out.println(substituteDateValue("date+7years/"));
		System.out.println(substituteDateValue("date+7/"));
		System.out.println(substituteDateValue("date+7c/"));
		System.out.println(substituteDateValue("date+7w/"));
		System.out.println(substituteDateValue("date+7n"));
		System.out.println("-----------------------");
		System.out.println(substituteDateValue("numdate+7"));
		System.out.println(substituteDateValue("numdate+7c"));
		System.out.println(substituteDateValue("numdate+7w"));
		System.out.println(substituteDateValue("numdate+7n"));
		System.out.println("-----------------------");
		System.out.println(substituteDateValue("numdate-7"));
		System.out.println(substituteDateValue("numdate-7c"));
		System.out.println(substituteDateValue("numdate-7w"));
		System.out.println(substituteDateValue("numdate-7n"));
	}
	
	@Test
	public void test4() {
		System.out.println("========================");
		System.out.println("          4");
		System.out.println("========================");
		System.out.println(makeNumericDateTime("20220311091900", "", ""));
		System.out.println(makeNumericDateTime(timestamp(), "", ""));
		System.out.println(makeNumericDateTime(timestamp("12:00:00"), "", ""));
		
		System.out.println(makeNumericDateTime("12:00:00", "", ""));
		System.out.println(makeNumericDateTime("", "", "12:00:00"));
		System.out.println(makeNumericDateTime("", "20240101", "12:00:00.000Z"));
	}
	
	@Test
	public void test5() {
		System.out.println("========================");
		System.out.println("          5");
		System.out.println("========================");
		System.out.println(timestamp());
		System.out.println(makeTimestamp(timestamp()));
	}
	
	@Test
	public void test6() {
		System.out.println("========================");
		System.out.println("          6");
		System.out.println("========================");
		Assertions.assertEquals(datePlusWeekDays(-1, "dd-MM-yyyy"), dateMinusWeekDays(1, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-2, "dd-MM-yyyy"), dateMinusWeekDays(2, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-3, "dd-MM-yyyy"), dateMinusWeekDays(3, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-4, "dd-MM-yyyy"), dateMinusWeekDays(4, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-5, "dd-MM-yyyy"), dateMinusWeekDays(5, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-6, "dd-MM-yyyy"), dateMinusWeekDays(6, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-7, "dd-MM-yyyy"), dateMinusWeekDays(7, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-8, "dd-MM-yyyy"), dateMinusWeekDays(8, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-9, "dd-MM-yyyy"), dateMinusWeekDays(9, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-10, "dd-MM-yyyy"), dateMinusWeekDays(10, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-11, "dd-MM-yyyy"), dateMinusWeekDays(11, "dd-MM-yyyy"));
		Assertions.assertEquals(datePlusWeekDays(-12, "dd-MM-yyyy"), dateMinusWeekDays(12, "dd-MM-yyyy"));
	}
	
	@Test
	public void test7() {
		System.out.println("========================");
		System.out.println("          7");
		System.out.println("========================");
		System.out.println(substituteDateValue("date-yyyymmdd"));
		System.out.println(substituteDateValue("date-yyyymmdd-7"));
		System.out.println(substituteDateValue("date-yyyymmdd-7 c"));
		System.out.println(substituteDateValue("date-yyyymmdd-5 w"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd-7"), substituteDateValue("date-yyyymmdd-7 c"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd-7"), substituteDateValue("date-yyyymmdd-5 w"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd-7c"), substituteDateValue("date-yyyymmdd-7 c"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd-5w"), substituteDateValue("date-yyyymmdd-5 w"));
		System.out.println(substituteDateValue("date-yyyymmdd+7"));
		System.out.println(substituteDateValue("date-yyyymmdd+7 c"));
		System.out.println(substituteDateValue("date-yyyymmdd+5 w"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd+7"), substituteDateValue("date-yyyymmdd+7 c"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd+7"), substituteDateValue("date-yyyymmdd+5 w"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd+7c"), substituteDateValue("date-yyyymmdd+7 c"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd+5w"), substituteDateValue("date-yyyymmdd+5 w"));
		Assertions.assertEquals(substituteDateValue("date-yyyymmdd"), substituteDateValue("date-yyyymmdd+0"));
	}
	
	@Test
	public void test8() {
		System.out.println("========================");
		System.out.println("          8");
		System.out.println("========================");
		System.out.println(utcTimestamp("2024-06-10T10:43:25.720"));
		System.out.println(substituteDateValue("utc-2024-06-10T10:43:25.720"));
		System.out.println(utcTimestamp("2024-06-10 10:43:25.720"));
		System.out.println(utcTimestamp(timestamp()));
	}
	
	@Test
	public void test9() {
		System.out.println("========================");
		System.out.println("          9");
		System.out.println("========================");
		System.out.println(Substitutions.substituteValue("{{retention-3Y4M5D}}"));
		System.out.println(Substitutions.substituteValue("{{retention-3Y0M0D}}"));
		System.out.println(Substitutions.substituteValue("{{retention-3Y4M5D}}"));
	}

}