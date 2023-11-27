package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.Prompt;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.Substitutions;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDef_prompt extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_prompt");
	
	private Prompt prompt;
	
	public StepDef_prompt(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		prompt = new Prompt(webDriver);
	}
	
	
	@Then("^I pause the test$")
	public void pauseTest() {
	    prompt.displayPopup();
	};
	
	
	@Then("^I pause the test with message \"([^\"]*)\"$")
	public void pauseTest(String message) {
	prompt.displayPopup(Substitutions.substituteValue(message));
	};
	
	
	@Then("^I pause the test with header \"([^\"]*)\" message \"([^\"]*)\"$")
	public void pauseTest(String header, String message) {
	prompt.displayPopup(header, Substitutions.substituteValue(message));
	};
	
	
	@When("^I prompt for input \"([^\"]*)\" for \"([^\"]*)\"$")
	public void promptForInput(String message, String field) throws Exception {
    	NAV.set_valueTo(field, prompt.inputDialog(message));
	}
	
}