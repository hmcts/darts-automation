package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.docstring.DocString;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.Postgres;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

public class StepDef_db extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_db");
	private Postgres DB;
	
	
	public StepDef_db(SharedDriver driver, TestData testdata, NavigationShared ns) {
		super(driver, testdata, ns);
		DB = new Postgres();
	}
	
	@Given("I execute update sql:")
	public void executeUpdateSql(String docString) throws Exception {
		log.info("about to update sql", docString);
		DB.updateRow(docString);
	}
	
	@Given("I set table {} column {} to {} where {} = {}")
	public void setSingleValue(String table, String updateCol, String updateVal, String keyCol, String keyVal) throws Exception {
		log.info("about to update field " + table + " " + keyCol + " " + keyVal + " " + updateCol + " " + updateVal);
		DB.setSingleValue(table, keyCol, keyVal, updateCol, updateVal);
	}
	
	@Given("I see table {} column {} where {} = {} is {}")
	public void verifyTableValue(String table, String col, String keyCol, String keyVal, String expectedVal) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol + " " + keyVal + " " + col + " " + expectedVal);
		String returnVal = DB.returnSingleValue(table, keyCol, keyVal, col);
		Assertions.assertEquals(expectedVal, returnVal);
	}
	
	@Given("I execute select sql:")
	public void executeSelectSql(String docString) throws Exception {
		DB.returnSingleValue(docString);
	}
	

	
}