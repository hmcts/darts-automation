package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.docstring.DocString;
import uk.gov.hmcts.darts.automation.utils.JsonApi;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;
import uk.gov.hmcts.darts.automation.utils.JsonString;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.Database;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

public class StepDef_testData extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_testData");
	private Database DB;
	private JsonApi jsonApi;
	
	
	public StepDef_testData(SharedDriver driver, TestData testdata, NavigationShared ns) {
		super(driver, testdata, ns);
		DB = new Database();
		jsonApi = new JsonApi();
	}
	
	@Given("I use {word} {word}")
	public void setValue(String arg1, String arg2) throws Exception {
		testdata.setProperty(arg1, arg2);
	}
	
	@Given("^courthouse \"([^\"]*)\" exists$")
	public void courthouseExists(String courtHouse) throws Exception {
		testdata.setProperty("courthouse_name", courtHouse);
		if (!DB.courtExists(courtHouse)) {
	    	JsonString jsonString = new JsonString();
	    	jsonString.addJsonLine("courthouse_name", courtHouse);
	    	jsonString.addJsonLine("code", testdata.getProperty("courthouse_code"));
	    	jsonApi.postApi("courthouses", jsonString.jsonValue());
		}
	}
	
	@Given("^case \"([^\"]*)\" exists for courthouse \"([^\"]*)\"")
	public void caseExistsForCourthouse(String caseNumber, String courtHouse) throws Exception {
		testdata.setProperty("case_numbers", caseNumber);
		testdata.setProperty("courthouse_name", courtHouse);
		if (!DB.courtCaseExists(courtHouse, caseNumber)) {
			courthouseExists(courtHouse);
		String json = JsonUtils.buildCaseJson(courtHouse, caseNumber, "defendant for " + caseNumber,
				"judge for " + caseNumber,
				"prosecutor for" + caseNumber,
				"defender for " + caseNumber);
		jsonApi.postApi("courthouses", json);
		}	
	}
		
}
