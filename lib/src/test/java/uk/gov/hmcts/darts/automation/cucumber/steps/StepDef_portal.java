package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
//import uk.gov.hmcts.darts.automation.pageObjects.Portal;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StepDef_portal extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_portal");
//	private final WebDriver webDriver;
//	private Portal portal;
	
	
	public StepDef_portal(SharedDriver driver, NavigationShared ns) {
		super(driver, ns);
	}
	
	
	@Given("^I am on the portal page$")
	public void onPortalPage() throws Exception {
		NAV.navigateToUrl(ReadProperties.main("staging_url"));
	}
	
//	@When("^I click the search button$")
//	public void clickTheSearchButton() throws Exception {
//		portal.clickTheSearchButton();
//	}
	
}