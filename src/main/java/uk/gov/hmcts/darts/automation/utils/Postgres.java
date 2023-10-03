package uk.gov.hmcts.darts.automation.utils;

/*
 * Functions to access postgres database
 * 
 * Consider adding case-insensitive calls using iLike('%<value>%')
 * 
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;


public class Postgres {
	private static Logger log = LogManager.getLogger("Postgres");

	private final String databaseAddress = "jdbc:postgresql://" + ReadProperties.apiDbHost + ":" + ReadProperties.apiDbPort + "/" + ReadProperties.apiDbSchema;
	private final String databaseUser = ReadProperties.apiDbUserName;
	private final String databasePassword = ReadProperties.apiDbPassword;

	Connection conn = null;

	public Postgres() {

	}
	/*
	 * Connect to the PostgreSQL database
	 * 
	 * @return a Connection object
	 * 
	 * 
	 */

	public void connect() {
		if (conn == null) {
			log.info("About to connect to postgres db");
			try {
				conn = DriverManager.getConnection(databaseAddress, databaseUser, databasePassword);
				log.info("Connected to the PostgreSQL server successfully.");
			} catch (SQLException e) {
				log.fatal(e.getMessage());
			}
		} else {
			log.info("Connection already exists");
		}
	}

	public void closeConnection() {
		if (conn == null) {
			log.info("Connection not open");
		} else {
			try {
				conn.close();
				log.info("Closed connection to the PostgreSQL server successfully.");
			} catch (SQLException e) {
				log.fatal(e.getMessage());
			}
		}
	}
	
	String extractSingleValueFromResultSet(ResultSet rs) throws Exception {
		if (rs.next()) {
			String returnString = rs.getString(1);
			if (returnString == null) {
				returnString = "null";
			}
			log.info("Value found: " + returnString);
			if (rs.next()) {
				log.warn("More than 1 row returned");
			}
			return returnString;
		} else {
			throw new Exception("No rows found");
		}
	}

	public String returnSingleValue(String sql) throws Exception {
		log.info("database select: " + sql);
		connect();
		try (Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			return extractSingleValueFromResultSet(rs);
		} catch (Exception e) {
			log.fatal("Error in database call " + e.getMessage());
			throw new Exception(e.getMessage());
		}
	}

	public String returnSingleValue(String sql, String key1) throws Exception {
		log.info("database select: " + sql + " " + key1);
		connect();
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, key1);
			try (ResultSet rs = stmt.executeQuery()) {
				return extractSingleValueFromResultSet(rs);
			}
		} catch (Exception e) {
			log.fatal("Error in database call " + e.getMessage());
			throw new Exception(e.getMessage());
		}
	}

	public String returnSingleValue(String sql, String keyVal1, String keyVal2) throws Exception {
		log.info("database select: " + sql + " : " + keyVal1 + " : " + keyVal2);
		connect();
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, keyVal1);
			stmt.setString(2, keyVal2);
			try (ResultSet rs = stmt.executeQuery()) {
				return extractSingleValueFromResultSet(rs);
			} catch (Exception e) {
				log.fatal("Error in database call " + e.getMessage());
				throw new Exception(e.getMessage());
			}
		}
	}

	public String returnSingleValue(String table, String keyCol, String keyVal, String returnCol) throws Exception {
		String sql = "select " + returnCol
				+ " from " + ReadProperties.apiDbSchema + "." + table
				+ " where " + keyCol + " = " + delimitedValue(table, keyCol, keyVal);
		return returnSingleValue(sql);
	}

	public String returnSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String returnCol) throws Exception {
		String sql = "select " + returnCol
				+ " from " + ReadProperties.apiDbSchema + "." + table
				+ " where " + keyCol1 + " = " + delimitedValue(table, keyCol1, keyVal1)
				+ " and " + keyCol2 + " = " + delimitedValue(table, keyCol2, keyVal2);
		return returnSingleValue(sql);
	}

	public ResultSet executeSql(String sql) throws Exception {
		connect();
		try (Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			return rs;
		}
	}

	public int deleteRow(String table, String key, String keyVal) throws Exception {
		log.info("Database delete: " + table + " " + key + " " + keyVal);
		String sql = "delete from " + table + " where " + key + " = " +  delimitedValue(table, key, keyVal);
		return deleteRow(sql);
	}

	public int deleteRow(String sql) throws Exception {
		int deleteCount = 0;
		connect();
		conn.setAutoCommit(false);
		log.info("Database delete: " + sql);
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			deleteCount = stmt.executeUpdate();
			if (deleteCount == 1) {
				conn.commit();
			} else {
				conn.rollback();
				if (deleteCount == 0) {
					throw new Exception("No rows deleted");
				} else {
					throw new Exception("Excess rows deleted " + deleteCount);
				}
			}
		}
		return deleteCount;
	}
	
	String delimitedValue(String table, String column, String value) throws Exception {
		String columnType = returnSingleValue("select pg_typeof(" + column + ") "
				+ "from darts." + table
				+ " LIMIT 1");
		String delimiter = "";
		if (value == null || value.equalsIgnoreCase("null")) {
			value = "null";
		} else {
			switch(columnType.split(" ")[0].toLowerCase()) {
			case "character": 
			case "string": 
			case "date": 
					delimiter = "'";
					break;
			default : delimiter = "";
			}
		}
		return delimiter + value + delimiter;
	}

	public int deleteRows(String sql) throws Exception {
		int deleteCount = 0;
		connect();
		conn.setAutoCommit(false);
		log.info("Database delete: " + sql);
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			deleteCount = stmt.executeUpdate();
			if (deleteCount == 0) {
				conn.rollback();
				throw new Exception("No rows deleted");
			} else {
				conn.commit();
				log.info("Rows deleted " + deleteCount);
			}
		}
		return deleteCount;
	}

	public int updateRow(String table, String keyCol, String keyVal, String UpdateCol, String newVal) throws Exception {
		log.info("Database update: " + table + " " + keyCol + " " + keyVal + " " + UpdateCol + " " + newVal);
		String sql = "update darts." + table 
				+ " set " + UpdateCol + " = " + delimitedValue(table, UpdateCol, newVal)
				+ " where " + keyCol + " = "  + delimitedValue(table, keyCol, keyVal);
		int updateCount = 0;
		connect();
		conn.setAutoCommit(false);
		log.info("Database update: " + sql);
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			updateCount = stmt.executeUpdate();
			if (updateCount == 1) {
				conn.commit();
			} else {
				conn.rollback();
				if (updateCount == 0) {
					throw new Exception("No rows updated");
				} else {
					throw new Exception("Excess rows updated " + updateCount);
				}
			}
		}
		return updateCount;
	}
	

	public int updateRow(String sql) throws Exception {
		int updateCount = 0;
		connect();
		conn.setAutoCommit(false);
		log.info("Database update: " + sql);
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			updateCount = stmt.executeUpdate();
			if (updateCount == 1) {
				conn.commit();
			} else {
				conn.rollback();
				if (updateCount == 0) {
					throw new Exception("No rows updated");
				} else {
					throw new Exception("Excess rows updated " + updateCount);
				}
			}
		}
		return updateCount;
	}

	public String setSingleValue(String table, String keyCol, String keyVal, String updateCol, String updateVal) throws Exception {
		String initialValue = returnSingleValue(table, keyCol, keyVal, updateCol);
		updateRow(table, keyCol, keyVal, updateCol, updateVal);
		return initialValue;
	}

	@Test
	public void test() throws Exception {
		Postgres pg = new Postgres();
		Assertions.assertEquals(pg.delimitedValue("court_case", "case_number", "12"), "'12'");
		Assertions.assertEquals(pg.delimitedValue("court_case", "case_number", null), "null");
		Assertions.assertEquals(pg.delimitedValue("court_case", "case_number", "null"), "null");
		Assertions.assertEquals(pg.delimitedValue("court_case", "case_closed", "12"), "12");
		Assertions.assertEquals(pg.delimitedValue("court_case", "cas_id", "12"), "12");
		Assertions.assertEquals(pg.delimitedValue("court_case", "cth_id", "12"), "12");
		Assertions.assertEquals(pg.delimitedValue("court_case", "cth_id", "null"), "null");
		Assertions.assertEquals(pg.delimitedValue("court_case", "cth_id", null), "null");
		Assertions.assertEquals(pg.returnSingleValue("select cas_id from darts.court_case where case_number = '174'"), "81");
		Assertions.assertEquals(pg.returnSingleValue("select case_closed from darts.court_case where case_number = '174'"), "null");
		Assertions.assertEquals(pg.returnSingleValue("select case_number from darts.court_case where case_number = '174'"), "174");
		String originalValue = pg.setSingleValue("court_case", "case_number", "174", "case_closed", "true");
		Assertions.assertEquals(originalValue, "null");
		Assertions.assertEquals(pg.setSingleValue("court_case", "case_number", "174", "case_closed", originalValue), "t");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "case_number", "174", "case_closed"), "null");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "case_number", "174", "case_number"), "174");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "case_number", "174", "cas_id"), "81");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "case_number", "174", "case_closed"), "null");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "cas_id", "81", "case_number"), "174");
		Assertions.assertEquals(pg.returnSingleValue("court_case", "cth_id", "2", "case_number"), "461_Case1");
	}





}