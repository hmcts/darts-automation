package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import uk.gov.hmcts.darts.automation.utils.Prompt;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StepDef_portal extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_portal");
	
	private Prompt prompt;	
	
	public StepDef_portal(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		prompt = new Prompt(webDriver);
	}
	
	@Given("I am logged on to DARTS as an {word} user")
	public void logonInternal(String type) throws Exception {
		NAV.navigateToUrl(ReadProperties.main("portal_url"));
		switch (type.toUpperCase()) {
		case "INTERNAL":
		NAV.checkRadioButton("I'm an employee of HM Courts and Tribunals Service");
			break;
		case "EXTERNAL":
			NAV.checkRadioButton("I work with the HM Courts and Tribunals Service");
			break;
		default:
			log.fatal("Unknown type - expected internal or external");
		}
		NAV.press_buttonByName("Continue");
		NAV.set_valueTo("Enter your email", ReadProperties.automationUserId);
		NAV.set_valueTo("Enter your password", ReadProperties.automationPassword);
		NAV.press_buttonByName("Continue");
	}
	
	@Given("^I am on the portal page$")
	public void onPortalPage() throws Exception {
		NAV.navigateToUrl(ReadProperties.main("portal_url"));
	}
	
	@Given("^I am on the landing page$")
	public void onLandingPage() throws Exception {
		NAV.navigateToUrl(ReadProperties.main("portal_url"));
	}
	
	@When("^I enter the security code$")
	public void enterSecurityCode() throws Exception {
    	NAV.set_valueTo("Enter your verification code below", prompt.inputDialog("Enter Security Code"));
	}
	
	@When("^I see phone number \"([^\"]*)\" on the page$")
	public void seePhoneNumberOnThePage(String arg1) throws Exception {
		NAV.textPresentOnPage("XXX-XXX-" + arg1.substring(arg1.length() - 5));
	}
	
	
}