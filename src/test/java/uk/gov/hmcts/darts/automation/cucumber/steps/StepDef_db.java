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
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.Substitutions;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.Database;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

public class StepDef_db extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_db");
	private Database DB;
	
	
	public StepDef_db(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		DB = new Database();
	}
	
	@When("I execute update sql:")
	public void executeUpdateSql(String docString) throws Exception {
		log.info("about to update sql", docString);
		DB.updateRow(Substitutions.substituteValue(docString));
	}
	
	@When("^I set table ([^\"]*) column ([^\"]*) to \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\"$")
	public void setSingleValue(String table, String updateCol, String updateVal, String keyCol1, String keyVal1) throws Exception {
		log.info("about to update field " + table + " " + keyCol1 + " " + keyVal1 + " " + updateCol + " " + updateVal);
		DB.setSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), updateCol, Substitutions.substituteValue(updateVal));
	}
	
	@When("^I set table ([^\"]*) column ([^\"]*) to \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void setSingleValue(String table, String updateCol, String updateVal, String keyCol1, String keyVal1, String keyCol2, String keyVal2) throws Exception {
		log.info("about to update field " + table + " " + keyCol1 + " " + keyVal1 + " " + keyCol2 + " " + keyVal2 + " " + updateCol + " " + updateVal);
		DB.setSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), updateCol, Substitutions.substituteValue(updateVal));
	}
	
	@When("^I set table ([^\"]*) column ([^\"]*) to \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void setSingleValue(String table, String updateCol, String updateVal, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3) throws Exception {
		log.info("about to update field " + table + " " + keyCol1 + " " + keyVal1 + " " + keyCol2 + " " + keyVal2 + " " + keyCol3 + " " + keyVal3 + " " + updateCol + " " + updateVal);
		DB.setSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), keyCol3, Substitutions.substituteValue(keyVal3), updateCol, Substitutions.substituteValue(updateVal));
	}

	@When("^I select column ([^\"]*) from table ([^\"]*) where ([^\"]*) = \"([^\"]*)\"$")
	public void selectTableValue(String col, String table, String keyCol1, String keyVal1) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1 + " " + col);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), col);
		testdata.setProperty(col, returnVal);
	}

	@When("^I select column ([^\"]*) from table ([^\"]*) where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void selectTableValue(String col, String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1  + " " + keyCol2 + " " + keyVal2 + " " + col);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), col);
		testdata.setProperty(col, returnVal);
	}

	@When("^I select column ([^\"]*) from table ([^\"]*) where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void selectTableValue(String col, String table, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1  + " " + keyCol2 + " " + keyVal2  + " " + keyCol3 + " " + keyVal3 + " " + col);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), keyCol3, Substitutions.substituteValue(keyVal3), col);
		testdata.setProperty(col, returnVal);
	}

	@Then("^I see table ([^\"]*) column ([^\"]*) is \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\"$")
	public void verifyTableValue(String table, String col, String expectedVal, String keyCol1, String keyVal1) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1 + " " + col + " " + expectedVal);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), col);
		Assertions.assertEquals(Substitutions.substituteValue(expectedVal), returnVal);
	}

	@Then("^I see table ([^\"]*) column ([^\"]*) is \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void verifyTableValue(String table, String col, String expectedVal, String keyCol1, String keyVal1, String keyCol2, String keyVal2) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1  + " " + keyCol2 + " " + keyVal2 + " " + col + " " + expectedVal);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), col);
		Assertions.assertEquals(Substitutions.substituteValue(expectedVal), returnVal);
	}

	@Then("^I see table ([^\"]*) column ([^\"]*) is \"([^\"]*)\" where ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\" and ([^\"]*) = \"([^\"]*)\"$")
	public void verifyTableValue(String table, String col, String expectedVal, String keyCol1, String keyVal1, String keyCol2, String keyVal2, String keyCol3, String keyVal3) throws Exception {
		log.info("about to return field" + " " + table + " " + keyCol1 + " " + keyVal1  + " " + keyCol2 + " " + keyVal2  + " " + keyCol3 + " " + keyVal3 + " " + col + " " + expectedVal);
		String returnVal = DB.returnSingleValue(table, keyCol1, Substitutions.substituteValue(keyVal1), keyCol2, Substitutions.substituteValue(keyVal2), keyCol3, Substitutions.substituteValue(keyVal3), col);
		Assertions.assertEquals(Substitutions.substituteValue(expectedVal), returnVal);
	}
	
	@Then("I execute select sql:")
	public void executeSelectSql(String docString) throws Exception {
		DB.returnSingleValue(Substitutions.substituteValue(docString));
	}
	
	@Then("^I see sql returns value \"([^\"]*)\"")
	public void executeSelectSql(String expectedVal, String docString) throws Exception {
		String returnVal = DB.returnSingleValue(Substitutions.substituteValue(docString));
		Assertions.assertEquals(Substitutions.substituteValue(expectedVal), returnVal);
	}
	
	@Then("^I execute sql and save the return value as ([^\"]*)")
	public void saveSelectSql(String name, String docString) throws Exception {
		String returnVal = DB.returnSingleValue(Substitutions.substituteValue(docString));
		testdata.setProperty(name, returnVal);
	}
	

	
}