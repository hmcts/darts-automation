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
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;


public class Database extends Postgres {
	private static Logger log = LogManager.getLogger("Database");
//	Postgres pg;
	
	final String courtroomJoin = 
			"darts.courtroom ctr\r\n" +
			"left join darts.courthouse cth\r\n" +
			"on cth.cth_id = ctr.cth_id\r\n";
	
	final String courtCaseJoin = 
			"darts.court_case cas\r\n" +
			"inner join darts.courthouse cth\r\n" +
			"on cth.cth_id = cas.cth_id\r\n";
	
	final String eventJoin = 
			"darts.court_case cas\r\n" +
			"left join darts.hearing hea\r\n" +
			"--on hea.cas_id = cas.cas_id\r\n" +
			"using (cas_id)\r\n" +
			"left join darts.hearing_event_ae he\r\n" +
			"--on he.hea_id = hea.hea_id\r\n" +
			"using (hea_id)\r\n" +
			"left join darts.event eve\r\n" +
			"--on eve.eve_id = he.eve_id\r\n" +
			"using (eve_id)\r\n" +
			"left join darts.event_handler evh\r\n" +
			"on evh.evh_id = eve.evh_id\r\n" +
			"left join darts.courtroom ctr\r\n" +
			"on ctr.ctr_id = hea.ctr_id\r\n" +
			"-- or ctr.ctr_id = eve.ctr_id\r\n" +
			"left join darts.courthouse cth\r\n" +
			"on ctr.cth_id = cth.cth_id\r\n";
	
	final String caseAudioJoin = "darts.courthouse cth\r\n"
			+ "inner join darts.courtroom ctr\r\n"
			+ "using(cth_id)\r\n"
			+ "inner join darts.hearing hea\r\n"
			+ "using (ctr_id)\r\n"
			+ "inner join darts.court_case cas\r\n"
			+ "using (cth_id)\r\n"
			+ "inner join darts.hearing_media_ae hm\r\n"
			+ "using (hea_id)\r\n"
			+ "left join darts.media med\r\n"
			+ "using (med_id)\r\n";

	public Database(){
//		pg = new Postgres();
		super();
	}
	
	public String tableName(String input) {
		switch (input.toUpperCase()) {
		case "COURTCASE":
			return courtCaseJoin;
		case "EVENT":
			return eventJoin;
		case "COURTROOM":
			return courtroomJoin;
		case "CASE_AUDIO":
			return caseAudioJoin;
		default:
			return input;
		}
	}
	
	public boolean courtExists(String courthouse) throws Exception {
		return returnSingleValue("darts.courthouse", "courthouse_name", courthouse, "count(courthouse_name)").equals("1");
	}
	
	public boolean courtCaseExists(String courtHouse, String caseNumber) throws Exception {
		return returnSingleValue("select count(1) "
				+ "from " + courtCaseJoin
				+ "where cas.case_number = ? "
				+ "and cth.courthouse_name = ?", caseNumber, courtHouse).equals("1");
	}
	
	public int updateRow(String table, String keyCol, String keyVal, String UpdateCol, String newVal) throws Exception {
		return super.updateRow(tableName(table), keyCol, keyVal, UpdateCol, newVal);
	}
	
	public int updateRow(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String UpdateCol, String newVal) throws Exception {
		return super.updateRow(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, UpdateCol, newVal);
	}
	
	public int updateRow(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3, String UpdateCol, String newVal) throws Exception {
		return super.updateRow(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, keyCol3, keyVal3, UpdateCol, newVal);
	}
	
	public String setSingleValue(String table, String keyCol, String keyVal, String updateCol, String updateVal) throws Exception {
		return super.setSingleValue(tableName(table), keyCol, keyVal, updateCol, updateVal);
	}
	
	public String setSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String updateCol, String updateVal) throws Exception {
		return super.setSingleValue(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, updateCol, updateVal);
	}
	
	public String setSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3, String updateCol, String updateVal) throws Exception {
		return super.setSingleValue(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, keyCol3, keyVal3, updateCol, updateVal);
	}
	
	public String returnSingleValue(String table, String keyCol1, String keyVal1, String returnCol) throws Exception {
		return super.returnSingleValue(tableName(table), keyCol1, keyVal1, returnCol);
	}
	
	public String returnSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String returnCol) throws Exception {
		return super.returnSingleValue(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, returnCol);
	}
	
	public String returnSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3, String returnCol) throws Exception {
		return super.returnSingleValue(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, keyCol3, keyVal3, returnCol);
	}
	
	public String returnSingleValue(String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3, String keyCol4, String keyVal4, String returnCol) throws Exception {
		return super.returnSingleValue(tableName(table), keyCol1, keyVal1, keyCol2, keyVal2, keyCol3, keyVal3, keyCol4, keyVal4, returnCol);
	}

	@Test
	public void test() throws Exception {
		Database db = new Database();
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", "12"), "'12'");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", null), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", "null"), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_closed", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cas_id", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", "null"), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", null), "null");
// following tests rely on data existing in tables
//		Assertions.assertEquals(db.returnSingleValue("select cas_id from darts.court_case where case_number = '174'"), "81");
//		Assertions.assertEquals(db.returnSingleValue("select case_closed from darts.court_case where case_number = '174'"), "null");
//		Assertions.assertEquals(db.returnSingleValue("select case_number from darts.court_case where case_number = '174'"), "174");
//		String originalValue = db.setSingleValue("darts.court_case", "case_number", "174", "case_closed", "true");
//		Assertions.assertEquals(originalValue, "null");
//		Assertions.assertEquals(db.setSingleValue("darts.court_case", "case_number", "174", "case_closed", originalValue), "t");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "case_number", "174", "case_closed"), "null");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "case_number", "174", "case_number"), "174");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "case_number", "174", "cas_id"), "81");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "case_number", "174", "case_closed"), "null");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "cas_id", "81", "case_number"), "174");
//		Assertions.assertEquals(db.returnSingleValue("darts.court_case", "cth_id", "2", "case_number"), "461_Case1");
//		Assertions.assertEquals(db.returnSingleValue(courtCaseJoin, "courthouse", "Swansea", "case_number", "461_Case1", "case_number"), "461_Case1");
		System.out.println(db.returnSingleValue("select usr_id from darts.user_account where user_email_address = 'darts.requester@hmcts.net'"));
		System.out.println(db.returnSingleValue("darts.user_account", "user_email_address",  "darts.requester@hmcts.net", "usr_id"));
		System.out.println(db.returnSingleValue("CASE_AUDIO", "courthouse_name", "Harrow Crown Court",  "courtroom_name", "1171",
				"cas.case_number", "S1171021",
				"hearing_date", "2024-03-20",
				"max(med_id)"));
	}





}