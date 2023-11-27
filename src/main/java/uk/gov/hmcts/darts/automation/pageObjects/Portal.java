package uk.gov.hmcts.darts.automation.pageObjects;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import uk.gov.hmcts.darts.automation.utils.GenUtils;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;

public class Portal {
	private static Logger log = LogManager.getLogger("Portal");

    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;

    public Portal(WebDriver driver) {
        this.webDriver = driver;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
    }
    
    public void clickOnBreadcrumbLink(String label) {
        NAV.waitForPageLoad();
    	//webDriver.findElement(By.xpath("//a[text()=\"" + label + "\" and contains(@class,'govuk-breadcrumbs__link')]")).click();
        webDriver.findElement(By.xpath("//a[@class='govuk-breadcrumbs__link'][contains(text(),'"+label+"')]")).click();

    }

    public void TranscriptionCountOnPage(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'transcription-count') and contains(text(),'"+count+"')]"));
    }
    

    public void logonAsUser(String type) throws Exception {
    	log.info("About to navigate to homepage & login as user type " + type);
        NAV.navigateToUrl(ReadProperties.main("portal_url"));
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("I have an account for DARTS through my organisation.");
        WAIT.waitForTextOnPage("except where otherwise stated");
        NAV.waitForPageLoad();
        switch (type.toUpperCase()) {
            case "EXTERNAL":
                loginToPortal_ExternalUser(ReadProperties.automationUserId,ReadProperties.automationPassword);
                break;
            case "TRANSCRIBER":
                loginToPortal_ExternalUser(ReadProperties.automationTranscriberUserId, ReadProperties.automationExternalPassword);
                break;
            case "LANGUAGESHOP":
                loginToPortal_ExternalUser(ReadProperties.automationLanguageShopTestUserId, ReadProperties.automationExternalPassword);
                break;
            case "REQUESTER":
                loginToPortal_InternalUser(ReadProperties.automationRequesterTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "APPROVER":
                loginToPortal_InternalUser(ReadProperties.automationApproverTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "REQUESTERAPPROVER":
                loginToPortal_InternalUser(ReadProperties.automationRequesterApproverTestUserId, ReadProperties.automationRequesterApproverTestPassword);
                break;
            case "JUDGE":
                loginToPortal_InternalUser(ReadProperties.automationJudgeTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "APPEALCOURT":
                loginToPortal_InternalUser(ReadProperties.automationAppealCourtTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            default:
                log.fatal("Unknown user type - {}"+ type.toUpperCase());
        }

    }


    public void loginToPortal_ExternalUser(String username, String password) throws Exception {
        NAV.checkRadioButton("I work with the HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("This sign in page is for users who do not work for HMCTS.");
        NAV.set_valueTo("Enter your email", username);
        NAV.set_valueTo("Enter your password", password);
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("except where otherwise stated");
    }

// Following is a workaround for placeholder not being recognised when run from Jenkins
    public WebElement setInputField(String type, String value) {
    	log.info("About to set input element type: " + type + " to " + value);
    	WebElement webElement = webDriver.findElement(By.xpath("//input[@type='" + type + "']"));
    	webElement.click();
    	webElement.sendKeys(value);
    	webElement.sendKeys(Keys.TAB);
    	return webElement;
    }

    public void loginToPortal_InternalUser(String username, String password) throws Exception {
        NAV.checkRadioButton("I'm an employee of HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("Sign in");
        NAV.waitForBrowserReadyState();
// Following line fails when run from Jenkins but would be preferable
//        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Email address, phone number or Skype"), username);
        setInputField("email", username);
        NAV.press_buttonByName("Next");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("Enter password");
        NAV.waitForBrowserReadyState();
// Following line fails when run from Jenkins but would be preferable
//        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Password"), password);
        setInputField("password", password);
        NAV.press_buttonByName("Sign in");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("Stay signed in?");
        NAV.waitForBrowserReadyState();
        NAV.press_buttonByName("No");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("except where otherwise stated");
    }

    public void notificationCount(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'notifications') and contains(text(),'"+count+"')]"));
    }

    public void downloadFileMatches(String fileName) throws IOException {
        String workspace_dir = ReadProperties.getDownloadFilepath();
        File directory = new File(workspace_dir);
        boolean downloadinFilePresence = false;
        File[] filesList =directory.listFiles();
        if(Objects.nonNull(filesList)) {
            for (File file : filesList) {
                downloadinFilePresence = file.getName().equalsIgnoreCase(fileName);
                if (downloadinFilePresence) {
                    log.info("File downloaded {} found and matched as expected", fileName);
                    break;
                } else {
                    log.error("File {} is not downloaded and cannot be found", fileName);
                }
            }
        }
        Assert.assertTrue(downloadinFilePresence);
        deleteDocument_withName_fromDownloads(workspace_dir);
    }
    private void deleteDocument_withName_fromDownloads(String workspace_dir) throws IOException {
        try {
            FileUtils.cleanDirectory(new File(workspace_dir));
            log.info("Successfully deleted all documents from the directory: {}", workspace_dir);
        } catch (IOException e) {
            log.error("Error occurred while cleaning the directory: {}", workspace_dir, e);
            throw e;
        }
    }
}