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


public class Database {
	private static Logger log = LogManager.getLogger("Database");
	Postgres pg;

	public Database() {
		pg = new Postgres();
	}
	
	public boolean courtExists(String courthouse) throws Exception {
		return pg.returnSingleValue("courthouse", "courthouse_name", courthouse, "count(courthouse_name)").equals("1");
	}
	
	public boolean courtCaseExists(String courtHouse, String caseNumber) throws Exception {
		return pg.returnSingleValue("select count(1) "
				+ "from darts.court_case cc " 
				+ "full outer join darts.courthouse cth "
				+ "on cc.cth_id = cth.cth_id "
				+ "where cc.case_number = ? "
				+ "and cth.courthouse_name = ?", caseNumber, courtHouse).equals("1");
	}

	@Test
	public void test() throws Exception {
	}





}