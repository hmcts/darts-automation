package uk.gov.hmcts.darts.automation.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.Calendar;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

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
		return datePlusMonths(Integer.parseInt(interval));
	}
	
	public static String datePlusYears(String interval) {
		return datePlusYears(Integer.parseInt(interval));
	}
	
	public static String dateMinusMonths(String interval) {
		return dateMinusMonths(Integer.parseInt(interval));
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
	
	public static String numDateTime() {
		String format = "yyyyMMddHHmmssSSS";
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format((Date)cal.getTime());
	}
	
	public static String timestamp() {
		return DateTimeFormatter
				.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSXX")
				.format(ZonedDateTime.now());
// Alternatives if local time is required for BST - check format to be used
//				.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//				.format(LocalDateTime.now());
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
	
	public static String substituteDateValue(String subsString) {
		String substitutedValue = "";
		String substitutionString = "";
		if (subsString.startsWith("date-") || subsString.startsWith("date+")) {
			boolean requireDelimChange = (subsString.endsWith("/"));
			if (requireDelimChange) {
				subsString = subsString.substring(0, subsString.length()-1);
			}
			if (subsString.endsWith("w")) {
				substitutionString = datePlusWeekDays(subsString.substring(4, subsString.length()-1));
			} else {
				if (subsString.endsWith("c")) {
					substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-1));
				} else {
					if (subsString.endsWith("n")) {
						substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-1)).replace("-", "");
					} else {
						if (subsString.endsWith(" months")) {
							substitutionString = datePlusMonths(subsString.substring(4, subsString.length()-7));
						} else {
							if (subsString.endsWith(" years")) {
								substitutionString = datePlusYears(subsString.substring(4, subsString.length()-6));
							} else {
								substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-0));
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
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy");
		return date.format(formatter);
	}
	
	public static String dateAsYyyyMmDd(String string) {
		return datePart(string, "yyyy") + "-" + datePart(string, "mm") + "-" + datePart(string, "dd");
	}
	
	public static String displayDate(String string) {
		LocalDate date = LocalDate.parse(dateAsYyyyMmDd(string));
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy");
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
		String [] split = dateTime.split(" ");
		if (split.length == 2) {
			return makeTimestamp(split[0], split[1]);
		} else {
			if ((dateTime.length() == 8) && dateTime.contains(":")) {
				return makeTimestamp("", dateTime);
			} else {
				return dateTime;
			}
		}
	}
	
	public static String makeTimestamp(String date, String time) {
		String [] split = date.split(date.contains("/") ? "/" : "-");
		if (split.length == 3) {
			if (split[0].length() > 2) {
				return String.format("%s-%s-%sT%s.000Z", split[0], split[1], split[2], time);
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
					return date + " " + time;
				}
			}
		}
	}
	
	@Test
	public void test1() {
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
		System.out.println("-----------------------");
		System.out.println(substituteDateValue("date-7 months"));
		System.out.println(substituteDateValue("date-7 years/"));
		System.out.println(substituteDateValue("date-7/"));
		System.out.println(substituteDateValue("date-7c/"));
		System.out.println(substituteDateValue("date-7w/"));
		System.out.println(substituteDateValue("date-7n"));
		System.out.println("-----------------------");
		System.out.println(substituteDateValue("date+7 months"));
		System.out.println(substituteDateValue("date+84 months"));
		System.out.println(substituteDateValue("date+7 years/"));
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

}
