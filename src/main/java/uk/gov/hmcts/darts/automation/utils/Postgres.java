package uk.gov.hmcts.darts.automation.utils;

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
   
   public String returnSingleValue(String sql) throws Exception {
	   log.info("database select: " + sql);
	   connect();
	   try (Statement stmt = conn.createStatement();
			   ResultSet rs = stmt.executeQuery(sql)) {
           if (rs.next()) {
        	   String returnString = rs.getString(1);
        	   if (returnString == null) {
        		   returnString = "null";
        	   }
        	   log.info("Value found: " + returnString);
        	   return returnString;
           } else {
			   throw new Exception("No rows found");
           }
	   }
   }
   
   public String returnSingleValue(String table, String keyCol, String keyVal, String returnCol) throws Exception {
	   String sql = "select " + returnCol
			   + " from " + ReadProperties.apiDbSchema + "." + table
			   + " where " + keyCol + " = " + keyVal;
	   return returnSingleValue(sql);
   }
   
   public ResultSet resultset(String sql) throws Exception {
	   connect();
	   try (Statement stmt = conn.createStatement();
			   ResultSet rs = stmt.executeQuery(sql)) {
		   return rs;
	   }
   }
   
   public void updateTable(String sql) throws Exception {
	   connect();
	   conn.setAutoCommit(false);
	   log.info("Database update: " + sql);
	   try (PreparedStatement stmt = conn.prepareStatement(sql)) {
		   int updateCount = stmt.executeUpdate();
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
   }
   
   public String setSingleValue(String table, String keyCol, String keyVal, String updateCol, String updateVal) throws Exception {
	   String initialValue = returnSingleValue(table, keyCol, keyVal, updateCol);
	   String sql = "update " + ReadProperties.apiDbSchema + "." + table
			   + " set " + updateCol + " = " + updateVal
			   + " where " + keyCol + " = " + keyVal;
	   updateTable(sql);
	   return initialValue;
   }

@Test
	public void test() throws Exception {
	   Postgres pg = new Postgres();
	   System.out.println(pg.returnSingleValue("select cas_id from darts.court_case where case_number = '174'"));
	   System.out.println(pg.returnSingleValue("select case_closed from darts.court_case where case_number = '174'"));
	   System.out.println(pg.returnSingleValue("select case_number from darts.court_case where case_number = '174'"));
	   System.out.println(pg.setSingleValue("court_case", "case_number", "'174'", "case_closed", "null"));
	   System.out.println(pg.returnSingleValue("court_case", "case_number", "'174'", "cas_id"));
	   System.out.println(pg.returnSingleValue("court_case", "case_number", "'174'", "case_closed"));
	   System.out.println(pg.returnSingleValue("court_case", "cas_id", "81", "case_number"));
	   System.out.println(pg.returnSingleValue("court_case", "cth_id", "2", "case_number"));
   }
   

	
			

}