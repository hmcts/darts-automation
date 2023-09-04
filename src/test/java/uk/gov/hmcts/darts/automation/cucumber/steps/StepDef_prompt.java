package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.Prompt;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDef_prompt extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_prompt");
	
	private Prompt man;
	
	public StepDef_prompt(SharedDriver driver, NavigationShared ns) {
		super(driver, ns);
		man = new Prompt(webDriver);
	}
	
	
	@Then("^I pause the test$")
	public void pauseTest() {
	    man.displayPopup();
	};
	
	
	@Then("^I pause the test with message \"([^\"]*)\"$")
	public void pauseTest(String message) {
	man.displayPopup(message);
	};
	
	
	@Then("^I pause the test with header \"([^\"]*)\" message \"([^\"]*)\"$")
	public void pauseTest(String header, String message) {
	man.displayPopup(header, message);
	};
	
	
	@When("^I prompt for input \"([^\"]*)\" for \"([^\"]*)\"$")
	public void promptForInput(String message, String field) throws Exception {
    	NAV.set_valueTo(field, man.inputDialog(message));
	}
	
}