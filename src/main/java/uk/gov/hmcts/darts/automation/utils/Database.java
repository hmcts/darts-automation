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

	final String caseHearingJoin = "darts.courthouse cth\r\n"
			+ "inner join darts.courtroom ctr\r\n"
			+ "using(cth_id)\r\n"
			+ "inner join darts.hearing hea\r\n"
			+ "using (ctr_id)\r\n"
			+ "inner join darts.court_case cas\r\n"
			+ "using (cas_id)\r\n";

	final String caseHearingJudgeJoin = "darts.courthouse cth\r\n"
			+ "inner join darts.courtroom ctr\r\n"
			+ "using(cth_id)\r\n"
			+ "inner join darts.hearing hea\r\n"
			+ "using (ctr_id)\r\n"
			+ "inner join darts.court_case cas\r\n"
			+ "using (cas_id)\r\n"
			+ "left join darts.hearing_judge_ae\r\n"
			+ "using (hea_id)\r\n"
			+ "inner join darts.judge jud\r\n"
			+ "using (jud_id)\r\n";
	
	final String caseJudgeJoin = "darts.courthouse cth\r\n"
			+ "inner join darts.court_case cas\r\n"
			+ "using (cth_id)\r\n"
			+ "left join darts.case_judge_ae\r\n"
			+ "using (cas_id)\r\n"
			+ "inner join darts.judge jud\r\n"
			+ "using (jud_id)\r\n";

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
		
		final String hearingMediaRequestJoin = "darts.court_case cas\n"
				+ "inner join darts.hearing hea\n"
				+ "using (cas_id)\n"
				+ "inner join darts.courtroom ctr\n"
				+ "using (ctr_id)\n"
				+ "inner join darts.courthouse cth\n"
				+ "on ctr.cth_id = cth.cth_id\n"
				+ "left join darts.media_request mer\n"
				+ "using (hea_id)\n"
				+ "left join darts.user_account usr\n"
				+ "on usr.usr_id = mer.requestor\r\n";
		
		final String caseManagementRetentionJoin = "darts.case_management_retention cmr\r\n"
				+ "join darts.retention_policy_type rpt\r\n"
				+ "using(rpt_id)\r\n";
		
		final String caseRetentionJoin = "darts.case_retention car\r\n"
				+ "join darts.retention_policy_type rpt\r\n"
				+ "using(rpt_id)\r\n";
		
		final String transcriptionJoin = "darts.transcription\r\n"
				+ "left join darts.transcription_status\r\n"
				+ "using (trs_id)\r\n"
				+ "left join darts.transcription_urgency\r\n"
				+ "using (tru_id)\r\n"
				+ "left join darts.transcription_type\r\n"
				+ "using (trt_id)\r\n";
		
		final String caseTranscriptionJoin = "darts.court_case cas\r\n"
				+ "left join darts.hearing hea\r\n"
				+ "using(cas_id)"
				+ "inner join darts.courtroom ctr\r\n"
				+ "using(ctr_id)\r\n"
				+ "left join darts.courthouse cth\r\n"
				+ "on ctr.cth_id = cth.cth_id\r\n"
				+ "left join darts.hearing_transcription_ae\r\n"
				+ "using(hea_id)\r\n"
				+ "left join darts.transcription tra\r\n"
				+ "using(tra_id)\r\n"
				+ "left join darts.transcription_status trs\r\n"
				+ "using (trs_id)\r\n"
				+ "left join darts.transcription_urgency tru\r\n"
				+ "using (tru_id)\r\n"
				+ "left join darts.transcription_type trt\r\n"
				+ "using (trt_id)\r\n";
		
		final String nodeRegisterJoin = "darts.node_register\r\n"
				+ "left join darts.courtroom\r\n"
				+ "using(ctr_id)\r\n"
				+ "left join darts.courthouse\r\n"
				+ "using(cth_id)\r\n";

	public Database(){
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
		case "CASE_HEARING":
			return caseHearingJoin;
		case "CASE_HEARING_JUDGE":
			return caseHearingJudgeJoin;
		case "CASE_JUDGE":
			return caseJudgeJoin;
		case "CASE_AUDIO":
			return caseAudioJoin;
		case "HEARING_MEDIA_REQUEST":
			return hearingMediaRequestJoin;
		case "CASE_RETENTION":
			return caseRetentionJoin;
		case "CASE_MANAGEMENT_RETENTION":
			return caseManagementRetentionJoin;
		case "TRANSCRIPTION":
			return transcriptionJoin;
		case "CASE_TRANSCRIPTION":
			return caseTranscriptionJoin;
		case "NODE_REGISTER":
			return nodeRegisterJoin;
		default:
			return input;
		}
	}
	
	public boolean courtExists(String courthouse) throws Exception {
		return returnSingleValue("darts.courthouse", "upper(courthouse_name)", courthouse.toUpperCase(), "count(courthouse_name)").equals("1");
	}
	
	public boolean courtCaseExists(String courtHouse, String caseNumber) throws Exception {
		return returnSingleValue("select count(1) "
				+ "from " + courtCaseJoin
				+ "where cas.case_number = ? "
				+ "and upper(cth.courthouse_name) = ?", caseNumber, courtHouse.toUpperCase()).equals("1");
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
	public void testDB1() throws Exception {
		Database db = new Database();
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", "12"), "'12'");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", null), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_number", "null"), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "case_closed", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cas_id", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", "12"), "12");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", "null"), "null");
		Assertions.assertEquals(db.delimitedValue("darts.court_case", "cth_id", null), "null");
		Assertions.assertEquals(db.delimitedValue("darts.event", "event_ts", "2024-12-12 10:00:00+00"), "'2024-12-12 10:00:00+00'");
		Assertions.assertEquals(db.delimitedValue("darts.event", "event_ts", "null"), "null");
		Assertions.assertEquals(db.delimitedValue("darts.event", "event_ts", null), "null");
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
		System.out.println(db.returnSingleValue("HEARING_MEDIA_REQUEST",
				"courthouse_name",  "Harrow Crown Court",
				"case_number",  "S1200021",
				"hearing_date", DateUtils.dateAsYyyyMmDd("26-03-2024"),
				"requestor", "-37",
				"max(mer_id)"));

		System.out.println(db.returnSingleValue("darts.media_request",
				"mer_id", "23645",
				"request_status"));
		
		System.out.println(db.returnSingleValue("CASE_HEARING_JUDGE", 
				"cas.cas_id", "95302",
				"judge_name"
				));

//		System.out.println(db.returnSingleValue("darts.transformed_media",
//				"mer_id", "23645",
//				"trm_id"));
	}

	@Test
	public void testDB2() throws Exception {
		System.out.println("*******  2 *******");
		Database db = new Database();
		System.out.println(db.returnSingleValue("EVENT",
				"eve.eve_id", "616358",
				"event_ts"));
	}





}