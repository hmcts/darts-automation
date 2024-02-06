package uk.gov.hmcts.darts.automation.pageObjects;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.io.IOException;
import java.time.Duration;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import uk.gov.hmcts.darts.automation.utils.*;

public class Portal {
    private static Logger log = LogManager.getLogger("Portal");

    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;
    private TestData TD;

    public Portal(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
    }

    public void clickOnBreadcrumbLink(String label) {
        NAV.waitForPageLoad();
        String substitutedValue = Substitutions.substituteValue(label);
        //webDriver.findElement(By.xpath("//a[text()=\"" + label + "\" and contains(@class,'govuk-breadcrumbs__link')]")).click();
        webDriver.findElement(By.xpath("//a[@class='govuk-breadcrumbs__link'][contains(text(),'" + substitutedValue + "')]")).click();

    }

    public void TranscriptionCountOnPage(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'transcription-count') and contains(text(),'" + count + "')]"));
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
                loginToPortal_ExternalUser(ReadProperties.automationUserId, ReadProperties.automationPassword);
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
                log.fatal("Unknown user type - {}" + type.toUpperCase());
        }

    }


    public void loginToPortal_ExternalUser(String username, String password) throws Exception {
        TD.userId = "";
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
        TD.userId = username;
        NAV.checkRadioButton("I'm an employee of HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("Sign in");
        NAV.waitForBrowserReadyState();
        if (webDriver.findElements(By.xpath("//input[@type='" + "email" + "']")).size() == 0) {
            List<WebElement> another = webDriver.findElements(By.xpath("//*[text() = 'Use another account']"));
            if (another.size() == 1) {
                another.get(0).click();
            }
            NAV.waitForBrowserReadyState();
        }

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
// When signing in for a second time, the stay signed in box may not appear
        WAIT.waitForTextOnPage("Stay signed in?", "Search for a case");
        if (webDriver.findElements(By.xpath("//*[text() ='" + "Stay signed in?" + "']")).size() == 1) {
            NAV.waitForBrowserReadyState();
            NAV.press_buttonByName("No");
            NAV.waitForBrowserReadyState();
            WAIT.waitForTextOnPage("except where otherwise stated");
            NAV.waitForBrowserReadyState();
        }
    }

    public void signOut() throws Exception {
        NAV.click_link_by_text("Sign out");
        if (!TD.userId.isBlank()) {
            WebElement webElement = webDriver.findElement(By.xpath("//div//*[translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')=\"" + TD.userId.toLowerCase() + "\"]"));
            webElement.click();
        }
        NAV.waitForBrowserReadyState();
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("Sign in", 15);
    }

    public void notificationCount(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'notifications') and contains(text(),'" + count + "')]"));
    }

    public void downloadFileMatches(String fileName) throws IOException {
        String substitutedValue = Substitutions.substituteValue(fileName);

        String workspaceDir = ReadProperties.getDownloadFilepath();
        File directory = new File(workspaceDir);
        boolean downloadFilePresence = false;

        File[] filesList = directory.listFiles();
        if (Objects.nonNull(filesList)) {
            for (File file : filesList) {
                //downloadinFilePresence = file.getName().toLowerCase().contains(substitutedValue.toLowerCase());
                if (file.getName().toLowerCase().contains(substitutedValue.toLowerCase())) {
                    log.info("File downloaded {} found and matched as expected", substitutedValue);
                    downloadFilePresence = true;
                    break;
                }
            }
            if (!downloadFilePresence) {
                log.error("File {} is not downloaded and cannot be found", substitutedValue);
            }
        } else {
            log.error("The directory is empty or could not be read.");
        }

        Assert.assertTrue("The expected file was not downloaded.", downloadFilePresence);
    if (downloadFilePresence) {
        deleteDocument_withName_fromDownloads(workspaceDir);
    }
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

    public void playAudioPlayer() {

        NAV.waitForBrowserReadyState();

        // Wait for the audio to be ready to play
        new WebDriverWait(webDriver, Duration.ofSeconds(60)).until(ExpectedConditions.jsReturnsValue(
                "return document.querySelector('audio').readyState >= 3;"
        ));

        // Execute JavaScript to play the audio
        ((JavascriptExecutor) webDriver).executeScript("document.querySelector('audio').play();");

        // Wait for the audio to start playing
        new WebDriverWait(webDriver, Duration.ofSeconds(10)).until(ExpectedConditions.jsReturnsValue(
                "return (document.querySelector('audio').currentTime > 0);"
        ));

        boolean isAudioPlaying = (boolean) ((JavascriptExecutor) webDriver).executeScript(
                "var audio = document.getElementsByTagName('audio')[0];" +
                        "return !audio.paused && audio.currentTime > 0;"
        );


        if (isAudioPlaying) {
            log.info("Audio is playing correctly.");
        } else {
            log.info("Audio is not playing correctly.");
        }
        Assertions.assertTrue(isAudioPlaying);
    }

    public void uploadDocument(String filename, String uploadLabel) throws Exception {
        String substitutedValue = Substitutions.substituteValue(filename);

        try {
            NAV.waitForBrowserReadyState();
            WebElement uploadElement = NAV.findInputFieldByLabelText(uploadLabel);

            if (uploadElement != null) {
                substitutedValue = substitutedValue + (substitutedValue.endsWith(".doc") || substitutedValue.endsWith(".docx") ? "" : ".doc");
                String filepath = ReadProperties.getUploadFilepath() + filename;
                log.info("Filepath: {}", filepath);

                uploadElement.sendKeys(filepath);
                log.info("File uploaded successfully.");
            } else {
                log.error("Upload element not found!");
            }
        } catch (Exception e) {
            log.error("Error uploading document: {}", e.getMessage());
            throw e;
        }
    }

    public void waitForAudioFile(String waitTime, String startTime, String caseNumber) {
        String substitutedValue = Substitutions.substituteValue(caseNumber);
        String substitutedValue1 = Substitutions.substituteValue(startTime);
        int waitTimeInSeconds = Integer.parseInt(waitTime) * 60;
        log.info("WAIT TIME {}", waitTimeInSeconds);

        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(10))
                .ignoring(NoSuchElementException.class)
                .ignoring(StaleElementReferenceException.class);

        Function<WebDriver, Boolean> checkForAudioFile = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
                log.info("Starting fluent wait");
                NAV.waitForBrowserReadyState();
                String xpath = "//tr[td[normalize-space(.)='" + substitutedValue1 + "'] and td[a[normalize-space(.)='" + substitutedValue + "']]]";
                List<WebElement> elements = webDriver.findElements(By.xpath(xpath));
                if (elements.size() != 0) {
                    log.info("Audio file found.");
                    return true; // Element is present
                } else {
                    NAV.refreshPage(); // Refresh the page if element not found
                    return false;
                }
            }
        };
        try {
            wait.until(checkForAudioFile);
        } catch (TimeoutException e) {
            log.info("Audio file not found within the specified wait time.");
        }
    }
}