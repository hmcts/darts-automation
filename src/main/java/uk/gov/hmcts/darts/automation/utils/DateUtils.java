package uk.gov.hmcts.darts.automation.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.Calendar;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class DateUtils {
	private static Logger log = LogManager.getLogger("DateUtils");
	
	
	public static String datePlusCalDays(String calDays) {
		return datePlusCalDays(Integer.parseInt(calDays), "dd-MM-yyyy");
	}
	
	public static String dateMinusCalDays(String calDays) {
		return dateMinusCalDays(Integer.parseInt(calDays), "dd-MM-yyyy");
	}
	
	public static String datePlusCalDays(int calDays) {
		return datePlusCalDays(calDays, "dd-MM-yyyy");
	}
	
	public static String dateMinusCalDays(int calDays) {
		return dateMinusCalDays(calDays, "dd-MM-yyyy");
	}
	
	public static String datePlusWeekDays(String weekDays) {
		return datePlusWeekDays(Integer.parseInt(weekDays), "dd-MM-yyyy");
	}
	
	public static String dateMinusWeekDays(String weekDays) {
		return dateMinusWeekDays(Integer.parseInt(weekDays), "dd-MM-yyyy");
	}
	
	public static String datePlusWeekDays(int weekDays) {
		return datePlusWeekDays(weekDays, "dd-MM-yyyy");
	}
	
	public static String dateMinusWeekDays(int weekDays) {
		return dateMinusWeekDays(weekDays, "dd-MM-yyyy");
	}
	
	
	public static String datePlusMonths(String weekDays) {
		return datePlusMonths(Integer.parseInt(weekDays), "dd-MM-yyyy");
	}
	
	public static String dateMinusMonths(String weekDays) {
		return dateMinusMonths(Integer.parseInt(weekDays), "dd-MM-yyyy");
	}
	
	public static String datePlusMonths(int calDays) {
		return datePlusMonths(calDays, "dd-MM-yyyy");
	}
	
	public static String dateMinusMonths(int calDays) {
		return dateMinusMonths(calDays, "dd-MM-yyyy");
	}
	
	public static String numdatePlusCalDays(String weekDays) {
		return datePlusCalDays(Integer.parseInt(weekDays), "ddMMyyyy");
	}
	
	public static String numdateMinusCalDays(String weekDays) {
		return dateMinusCalDays(Integer.parseInt(weekDays), "ddMMyyyy");
	}
	
	public static String numdatePlusCalDays(int calDays) {
		return datePlusCalDays(calDays, "ddMMyyyy");
	}
	
	public static String numdateMinusCalDays(int calDays) {
		return dateMinusCalDays(calDays, "ddMMyyyy");
	}
	
	public static String numdatePlusWeekDays(String weekDays) {
		return datePlusWeekDays(Integer.parseInt(weekDays), "ddMMyyyy");
	}
	
	public static String numdateMinusWeekDays(String weekDays) {
		return dateMinusWeekDays(Integer.parseInt(weekDays), "ddMMyyyy");
	}
	
	public static String numdatePlusWeekDays(int weekDays) {
		return datePlusWeekDays(weekDays, "ddMMyyyy");
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
	
	public static String dateMinusMonths(int months, String format) {
		return datePlusMonths(0-months, format);
	}
	
	public static String substituteValue(String value) throws Exception {
		String substitutedValue = "";
		String substitutionString = "";
		int subsEnd = value.indexOf("}}");
		int subsStart = value.lastIndexOf("{{", subsEnd);
		if ((subsStart >= 0) && (subsEnd > subsStart)) {
			String subsString = value.substring(subsStart+2, subsEnd).toLowerCase();
			if (subsString.startsWith("date-")) {
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
								substitutionString = datePlusCalDays(subsString.substring(4, subsString.length()-0));
							}
						}
					}
				}
				if (requireDelimChange) {
					substitutionString = substitutionString.replace("-", "/");
				}
			} else {
				if (subsString.toLowerCase().startsWith("date+")) {
					boolean requireDelimChange = (subsString.endsWith("/"));
					if (requireDelimChange) {
						subsString = subsString.substring(0, subsString.length()-1);
					}
					if (subsString.endsWith("w")) {
						substitutionString = datePlusWeekDays(subsString.substring(5, subsString.length()-1));
					} else {
						if (subsString.endsWith("c")) {
							substitutionString = datePlusCalDays(subsString.substring(5, subsString.length()-1));
						} else {
							if (subsString.endsWith("n")) {
								substitutionString = datePlusCalDays(subsString.substring(5, subsString.length()-1)).replace("-", "");
							} else {
								if (subsString.endsWith(" months")) {
									substitutionString = datePlusMonths(subsString.substring(5, subsString.length()-7));
								} else {
									substitutionString = datePlusCalDays(subsString.substring(5, subsString.length()-0));
								}
							}
						}
					}
					if (requireDelimChange) {
						substitutionString = substitutionString.replace("-", "/");
					}
				} else {
					if (subsString.startsWith("numdate-")) {
						if (subsString.endsWith("w")) {
							substitutionString = numdateMinusWeekDays(subsString.substring(8, subsString.length()-1));
						} else {
							if (subsString.endsWith("c")) {
								substitutionString = numdateMinusCalDays(subsString.substring(8, subsString.length()-1));
							} else {
								if (subsString.endsWith("n")) {
									substitutionString = numdateMinusCalDays(subsString.substring(8, subsString.length()-1)).replace("-", "");
								} else {
									substitutionString = numdateMinusCalDays(subsString.substring(8, subsString.length()-0));	
								}
							}
						}
					} else {
						if (subsString.toLowerCase().startsWith("numdate+")) {
							if (subsString.endsWith("w")) {
								substitutionString = numdatePlusWeekDays(subsString.substring(8, subsString.length()-1));
							} else {
								if (subsString.endsWith("c")) {
									substitutionString = numdatePlusCalDays(subsString.substring(8, subsString.length()-1));
								} else {
									if (subsString.endsWith("n")) {
										substitutionString = numdatePlusCalDays(subsString.substring(8, subsString.length()-1)).replace("-", "");
									} else {
										substitutionString = numdatePlusCalDays(subsString.substring(8, subsString.length()-0));		
									}
								}
							}
						} else {
							if (subsString.toLowerCase().startsWith("datetime")) {
								substitutionString = numDateTime();
							} else {
								if (subsString.toLowerCase().equals("yyyymmdd")) {
									substitutionString = todayYyyymmdd();
								} else {
									if (subsString.toLowerCase().startsWith("dd-")) {
										substitutionString = subsString.substring(3, 5);
									} else {
										if (subsString.toLowerCase().startsWith("mm-")) {
											substitutionString = subsString.substring(6, 8);
										} else {
											if (subsString.toLowerCase().startsWith("yyyy-")) {
												substitutionString = subsString.substring(11, 15);
											} else {
												throw new Exception("Invalid value to substitute =>" + subsString );
											}
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
			return substituteValue(substitutedValue);
		} else {
			log.info("nothing to substitute =>"+value);
			return value;
		}
	}
	
	public static String todayYyyymmdd() {
		Date dateToday = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateToday);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		return dateFormat.format((Date)cal.getTime());		
	}
	
	public static String todayDdmmyy() {
		LocalDate date = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
		return date.format(formatter);
	}

}
