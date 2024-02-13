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
        portal = new Portal(webDriver, testdata);
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
    
    @When("I Sign out")
    public void signOut() throws Exception {
    	portal.signOut();
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

    @When("^I set the time fields below \"([^\"]*)\" to \"([^\"]*)\"$")
    public void setTimeFieldsBelowText(String header, String time) throws Exception {
        String[] timeSplit = time.split(":");
        NAV.setValueByFirstLabelFollowingText(header, "Hour", timeSplit[0]);
        NAV.setValueByFirstLabelFollowingText(header, "Minutes", timeSplit[1]);
        NAV.setValueByFirstLabelFollowingText(header, "Seconds", timeSplit[2]);
    }


    @Then("I see the transcription-count is \"([^\"]*)\"$")
    public void iSeeTheTranscriptionCountIs(String count) {
        portal.TranscriptionCountOnPage(count);
    }

    @Then("I see the notification-count is \"([^\"]*)\"$")
    public void iSeeTheNotificationCountIs(String count) throws Exception {
        portal.notificationCount(count);
    }

    @Given("I navigate to the url \"([^\"]*)\"$")
    public void iNavigateToTheUrl(String endpoint) throws Exception {
        NAV.navigateToUrl(ReadProperties.main("portal_url") + endpoint);
    }

    @Then("I verify the download file matches \"([^\"]*)\"$")
    public void iVerifyTheDownloadFileMatches(String fileName) {
        try {
            portal.downloadFileMatches(fileName);
        } catch (Exception exception){
            log.fatal("File {} cannot be found", fileName);
        }
    }

    @When("I click on the pagination link \"([^\"]*)\"$")
    public void iClickOnPaginationLink(String linkName) throws Exception {
        NAV.click_link_by_text(linkName);
    }

    @Given("I play the audio player$")
    public void iPlayTheAudioPlayer() {
        portal.playAudioPlayer();
    }

    @Then("I upload the file \"([^\"]*)\" at \"([^\"]*)\"$")
    public void uploadTheDocument(String filename,String uploadLabel) throws Exception {
        portal.uploadDocument(filename, uploadLabel);
    }

    @Then("I wait for {} minutes")
    public void waitForTime(int waitTime) {
        portal.wait(waitTime);
    }

    @Then("I wait for \"([^\"]*)\" minutes with \"([^\"]*)\" to appear for \"([^\"]*)\"$")
    public void waitForAudioFileWithStartTime(String waitTime, String startTime, String caseNumber) {
        portal.waitForAudioFile(waitTime, startTime, caseNumber);
    }
}
