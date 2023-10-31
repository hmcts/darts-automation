package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.Prompt;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.pageObjects.Portal;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StepDef_portal extends StepDef_base {

    private static Logger log = LogManager.getLogger("StepDef_portal");
    private Portal portal;
    private Prompt prompt;
    private WaitUtils WAIT;
  
	public StepDef_portal(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
        prompt = new Prompt(webDriver);
        portal = new Portal(webDriver);
        WAIT = new WaitUtils(webDriver);
    }

    @Given("^I am on the portal page$")
    public void onPortalPage() throws Exception {
        NAV.navigateToUrl(ReadProperties.main("portal_url"));
    }

    @Given("^I am on the landing page$")
    public void onLandingPage() throws Exception {
        NAV.navigateToUrl(ReadProperties.main("portal_url"));
    }

    @Given("I am logged on to DARTS as an/a {word} user")
    public void logonAsUser(String type) throws Exception {
    	portal.logonAsUser(type);
    }

    @When("^I enter the security code$")
    public void enterSecurityCode() throws Exception {
        NAV.set_valueTo("Enter your verification code below", prompt.inputDialog("Enter Security Code"));
    }

    @When("^I see phone number \"([^\"]*)\" on the page$")
    public void seePhoneNumberOnThePage(String arg1) throws Exception {
        NAV.textPresentOnPage("XXX-XXX-" + arg1.substring(arg1.length() - 5));
    }

    @When("^I click on the breadcrumb link \"([^\"]*)\"$")
    public void clickOnBreadcrumbLink(String link) {
        portal.clickOnBreadcrumbLink(link);
    }

    @When("^I set the time fields of \"([^\"]*)\" to \"([^\"]*)\"$")
    public void setTimeFields(String header, String time) throws Exception {
        String[] timeSplit = time.split(":");
        NAV.setValueByLabelInLocationTo(header, "Hour", timeSplit[0]);
        NAV.setValueByLabelInLocationTo(header, "Minutes", timeSplit[1]);
        NAV.setValueByLabelInLocationTo(header, "Seconds", timeSplit[2]);
    }


    @Then("I see the transcription-count is \"([^\"]*)\"$")
    public void iSeeTheTranscriptionCountIs(String count) {
        portal.TranscriptionCountOnPage(count);
    }

    @Then("I see the notification-count is \"([^\"]*)\"$")
    public void iSeeTheNotificationCountIs(String count) throws Exception {
        portal.notificationCount(count);
    }

}
