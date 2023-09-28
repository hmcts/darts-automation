package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.Alerts;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDef_alerts extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_alerts");
	
	private Alerts ALR;
	
	public StepDef_alerts(SeleniumWebDriver driver) {
		super(driver);
		ALR = new Alerts(webDriver);
	}
		
	
	@Then("^I dismiss the alert$")
	public void dismissAlert() {
	    try {
	    	ALR.dismissAlert();
	    } catch (Exception e) {
	    	log.error("Could not dismiss the alert");
	    }
	};
	
	@Then("^I dismiss the \"([^\"]*)\" alert$")
	public void dismissAlert(String arg1) {
	    try {
	    	ALR.dismissAlert(arg1);
	    } catch (Exception e) {
	    	log.error("Could not dismiss the alert");
	    }
	};
	
	@Then("^I accept the alert$")
	public void acceptAlert() {
	    try {
	    	ALR.acceptAlert();
	    } catch (Exception e) {
	    	log.error("Could not accept the alert");
	    }
	};
	
	@Then("^I accept the \"([^\"]*)\" alert$")
	public void acceptAlert(String arg1) {
	    try {
	    	ALR.acceptAlert(arg1);
	    } catch (Exception e) {
	    	log.error("Could not accept the alert");
	    }
	};
	
	@When("^I dismiss the popup$")
	public void dismissPopup() {
	    ALR.dismissNotification();
	};
	
}