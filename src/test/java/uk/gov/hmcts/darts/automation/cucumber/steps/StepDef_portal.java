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
import uk.gov.hmcts.darts.automation.utils.Database;
import uk.gov.hmcts.darts.automation.pageObjects.Portal;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;

public class StepDef_portal extends StepDef_base {

    private static Logger log = LogManager.getLogger("StepDef_portal");
    private Portal portal;
    private Prompt prompt;
    private WaitUtils WAIT;
    private Database DB;
    private String savedRequestId;
  
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

    @Given("I am logged on to the admin portal as an/a {word} user")
    public void logonToAdminPortal(String type) throws Exception {
    	portal.logonToAdminPortal(type);
    }

    @Given("I am logged on to DARTS as an/a {word} user")
    public void logonToDartsPortal(String type) throws Exception {
    	portal.logonToDartsPortal(type);
    }

    @When("^I enter the security code$")
    public void enterSecurityCode() throws Exception {
        NAV.set_valueTo("Enter your verification code below", prompt.inputDialog("Enter Security Code"));
    }
    
    @When("I Sign out")
    public void signOut() throws Exception {
    	portal.signOut();
    }

    @When("^I click on the \"([^\"]*)\" sub-menu link$")
    public void clickOnSubMenuLink(String link) {
    	portal.clickOnSubMenuLink(link);
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

    @Then("I wait until the audio file has been loaded for courthouse  \"([^\"]*)\" courtroom  \"([^\"]*)\" case  \"([^\"]*)\" date  \"([^\"]*)\"")
    public void waitForAudioToBeLoaded(String courthouse, String courtroom, String caseNumber, String hearingDate) throws Exception {
    	portal.waitForAudioToBeLoaded(courthouse, courtroom, caseNumber, hearingDate);
    }
	
 // sample cucumber:
 // Then I wait for the audio file to be ready
 // |courthouse|courtroom|case_number|hearing_date|
 	@Then("^I wait for the audio file to be loaded$")
 	public void waitForAudioToBeLoadedMap(List<Map<String,String>> dataTable) throws Exception {
 		for (Map<String, String> map : dataTable) {
 			portal.waitForAudioToBeLoaded(
 					getValue(map, "courthouse"),
 					getValue(map, "courtroom"),
 					getValue(map, "case_number"),
 					getValue(map, "hearing_date"));
 		}
 	}
 	
	
 // sample cucumber:
 // Then I wait for the requested audio file to be ready
 // |user|courthouse|case_number|hearing_date|
 	@Then("^I wait for the requested audio file to be ready$")
 	public void waitForRequestedAudioFileToBeReady(List<Map<String,String>> dataTable) throws Exception {
 		for (Map<String, String> map : dataTable) {
 			String requestId = getValue(map, "requestId");
 			if (requestId.isEmpty()) {
	 			portal.waitForRequestedAudioToBeReady(
	 					getValue(map, "user"),
	 					getValue(map, "courthouse"),
	 					getValue(map, "case_number"),
	 					getValue(map, "hearing_date"));
 			} else {
 				portal.waitForRequestedAudioToBeReady(requestId);
 			}
 		}
 	}
 	
 	@Then("^I wait for the audio Request ID to be ready$")
 	public void waitForAudioRequestIdToBeReady() throws Exception {
    	if (savedRequestId.isBlank()) {
    		log.fatal("Request ID must already have been already captured by the step \"* I see the Request ID\"");
    		Assert.fail("Request ID must already have been captured by \"* I see the Request ID\"");
    	}
		portal.waitForRequestedAudioToBeReady(savedRequestId);
 	}

    @Then("I wait for (the )text {string} on (the )same row as (the )link {string}")
    public void waitForUpdatedRow(String text, String link) {
        portal.waitForUpdatedRow(text, link);
    }
    
    @Then("I see the Request ID")
    public void saveRequestId() {
    	savedRequestId = portal.returnRequestId();
    	testdata.setProperty("requestId", savedRequestId);
    }
    
    @Then("^I see the sub-menu link \"([^\"]*)\"$")
    public void seeSubMenuLink(String link) {
    	portal.subMenuLinkVisible(link);
    }
    
    @Then("^Cookie \"([^\"]*)\" \"([^\"]*)\" value is \"([^\"]*)\"$")
    public void cookieValueIs(String cookie, String name, String expectedValue) throws Exception {
    	String actualValue = portal.getCookie(cookie, name);
    	Assertions.assertTrue(actualValue.equals(expectedValue), "Expected " + expectedValue + " but is " + actualValue);
    }

// Verifies existence of links in datatable with link text as the column header & Y/N/Linked page heading
	@Then("^I verify links with text:$")
	public void verifyLinksWithText(List<List<String>> dataTable) throws Exception {
		Assertions.assertTrue(dataTable.size() > 1);
		int errorCount = 0;
		String errorLinks = "";
		for (int rowNum = 1; rowNum < dataTable.size(); rowNum++) {
			for (int colNum = 0; colNum < dataTable.get(0).size(); colNum++) {
				String linkText = dataTable.get(0).get(colNum);
				String linkTest = (dataTable.get(rowNum).get(colNum) == null) ? "" : dataTable.get(rowNum).get(colNum);
				boolean linkExists = NAV.linkText_visible(linkText);
				if (linkTest.equalsIgnoreCase("N")) {
					if (linkExists) {
						log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
						errorCount++;
						errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
					}
				} else {
					if (linkTest.isBlank()) {
						log.info("Links for {} in row {} not checked, link exists={}", linkText, rowNum, linkExists);
					} else {
						if (linkExists) {
							NAV.click_link_by_text(linkText);
							int elements = NAV.countElementWithText(linkTest.equalsIgnoreCase("Y") ? linkText : linkTest, "h1");
							if (elements != 1) {
								log.error("Error in header for {} in row {} : {}", linkText, rowNum, linkTest);
								errorCount++;
							}
						} else {
							log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
							errorCount++;
							errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
						}
					}
				}
			}
		}
		Assertions.assertEquals(0, errorCount, "Errors found verifying links: " + errorLinks);
	}

// Verifies existence of sub-menu links in datatable with link text as the column header & Y/N/Linked page heading
	@Then("^I verify sub-menu links for \"([^\"]*)\":$")
	public void verifySubMenuLinks(String link, List<List<String>> dataTable) throws Exception {
		NAV.click_link_by_text(link);
		Assertions.assertTrue(dataTable.size() > 1);
		int errorCount = 0;
		String errorLinks = "";
		for (int rowNum = 1; rowNum < dataTable.size(); rowNum++) {
			for (int colNum = 0; colNum < dataTable.get(0).size(); colNum++) {
				String linkText = dataTable.get(0).get(colNum);
				String linkTest = (dataTable.get(rowNum).get(colNum) == null) ? "" : dataTable.get(rowNum).get(colNum);
				boolean linkExists = portal.subMenuLinkVisible(linkText);
				if (linkTest.equalsIgnoreCase("N")) {
					if (linkExists) {
						log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
						errorCount++;
						errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
					}
				} else {
					if (linkTest.isBlank()) {
						log.info("Links for {} in row {} not checked, link exists={}", linkText, rowNum, linkExists);
					} else {
						if (linkExists) {
							portal.clickOnSubMenuLink(linkText);
//							if (!linkTest.equalsIgnoreCase("X")) {
								int elements = portal.countSubMenuHeaders(linkTest.equalsIgnoreCase("Y") ? linkText : linkTest);
//								if (elements != 1) {
								if ((linkTest.equalsIgnoreCase("X") && elements != 0) || (!linkTest.equalsIgnoreCase("X") && elements != 1)) {
									log.error("Error in header for {} in row {} : {}", linkText, rowNum, linkTest);
									errorCount++;
									errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText + "(" + linkTest + ")";
//								}
							}
						} else {
							log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
							errorCount++;
							errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
						}
					}
				}
			}
		}
		Assertions.assertEquals(0, errorCount, "Errors found verifying links: " + errorLinks);
	}
	
	@Given("that courthouse \"([^\"]*)\" case \"([^\"]*)\" does not exist")
	public void caseDoesNotExist(String courthouse, String caseNumber) throws Exception {
		String count = DB.returnSingleValue("COURTCASE", "count(cas_id)", "courthouse_name", "courthouse", "case_number", "caseNumber");
		Assertions.assertEquals("0", count, "Case already exists");
	}
}
