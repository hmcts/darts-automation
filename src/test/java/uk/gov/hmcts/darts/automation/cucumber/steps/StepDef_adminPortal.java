package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;
import uk.gov.hmcts.darts.automation.utils.DateUtils;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;
import uk.gov.hmcts.darts.automation.utils.Prompt;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.pageObjects.AdminPortal;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

public class StepDef_adminPortal extends StepDef_base {

    private static Logger log = LogManager.getLogger("StepDef_portal");
    private AdminPortal adminPortal;
    private Prompt prompt;
    private WaitUtils WAIT;
  
	public StepDef_adminPortal(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
        prompt = new Prompt(webDriver);
        adminPortal = new AdminPortal(webDriver, testdata);
        WAIT = new WaitUtils(webDriver);
    }

    @When("^I click on the sub-menu link \"([^\"]*)\"$")
    public void clickOnSubMenuLink(String link) {
    	adminPortal.clickOnSubMenuLink(link);
    }

}
