package uk.gov.hmcts.darts.automation.pageObjects;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;
import com.jayway.jsonpath.*;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.Duration;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.function.Function;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import uk.gov.hmcts.darts.automation.utils.*;
import uk.gov.hmcts.darts.automation.utils.Credentials;

public class Portal {
    private static Logger log = LogManager.getLogger("Portal");

    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;
    private TestData TD;
    private Database DB;
    private JsonApi jsonApi;

	private static int AUDIO_WAIT_TIME_IN_SECONDS = 900;

    public Portal(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
        DB = new Database();
    	jsonApi = new JsonApi();
    }

    public void clickOnBreadcrumbLink(String label) {
        NAV.waitForPageLoad();
        String substitutedValue = Substitutions.substituteValue(label);
        //webDriver.findElement(By.xpath("//a[text()=\"" + label + "\" and contains(@class,'govuk-breadcrumbs__link')]")).click();
        webDriver.findElement(By.xpath("//a[@class='govuk-breadcrumbs__link'][contains(text(),'" + substitutedValue + "')]")).click();
        NAV.waitForPageLoad();
    }

    public void TranscriptionCountOnPage(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'transcription-count') and contains(text(),'" + count + "')]"));
    }
    
    public void allowCookies(boolean allow) {
    	try {
            NAV.press_buttonByName(allow ? "Accept" : "Reject" + " additional cookies");
            NAV.press_buttonByName("Hide cookie message");
    	} catch (Exception e) {
    		
    	}
    }

    public void logonToDartsPortal(String userType) throws Exception {
    	log.info("About to navigate to admin portal & login as user type " + userType);
    	logonAsUser(ReadProperties.main("portal_url"), userType);
    }

    public void logonToAdminPortal(String userType) throws Exception {
    	log.info("About to navigate to DARTS portal & login as user type " + userType);
    	logonAsUser(ReadProperties.main("portal_url") + "/admin", userType);
    }

    public void logonAsUser(String url, String userType) throws Exception {
    	NAV.navigateToUrl(url);
        NAV.waitForBrowserReadyState(20);
        waitForNavigation(url, "Sign in to the DARTS Portal");
    	allowCookies(false);
    	String userName = Credentials.userName(userType);
    	String password = Credentials.password(userType);
        WAIT.waitForTextOnPage("I have an account for DARTS through my organisation."); // body
        WAIT.waitForTextOnPage("except where otherwise stated");						// footer
//        NAV.waitForPageLoad();
        switch (userType.toUpperCase()) {
            case "EXTERNAL":
            case "TRANSCRIBER":
            case "LANGUAGESHOP":
            case "ADMIN":
            case "ADMIN2":
            case "SUPERUSER":
                loginToPortal_ExternalUser(userName, password);
                break;
            case "REQUESTER":
            case "APPROVER":
            case "REQUESTERAPPROVER":
            case "JUDGE":
            case "APPEALCOURT":
                loginToPortal_InternalUser(userName, password);
                break;
            default:
                log.fatal("Unknown user type - {}" + userType);
        }

    }


    public void loginToPortal_ExternalUser(String username, String password) throws Exception {
        TD.userId = "";
        NAV.checkRadioButton("I work with the HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState(90);
        WAIT.waitForTextOnPage("This sign in page is for users who do not work for HMCTS.");
        NAV.set_valueTo("Enter your email", username);
        NAV.set_valueTo("Enter your password", password);
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState(90);
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
        NAV.waitForBrowserReadyState(90);
        WAIT.waitForTextOnPage("Sign in");
        NAV.waitForBrowserReadyState(90);
        if (webDriver.findElements(By.xpath("//input[@type='" + "email" + "']")).isEmpty()) {
            List<WebElement> another = webDriver.findElements(By.xpath("//*[text() = 'Use another account']"));
            if (another.size() == 1) {
                another.get(0).click();
            }
            NAV.waitForBrowserReadyState(90);
        }

// Following line fails when run from Jenkins but would be preferable
//        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Email address, phone number or Skype"), username);
        setInputField("email", username);
        NAV.press_buttonByName("Next");
        NAV.waitForBrowserReadyState(90);
        WAIT.waitForTextOnPage("Enter password");
        NAV.waitForBrowserReadyState(90);
// Following line fails when run from Jenkins but would be preferable
//        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Password"), password);
        setInputField("password", password);
        NAV.press_buttonByName("Sign in");
        NAV.waitForBrowserReadyState(90);
// When signing in for a second time, the stay signed in box may not appear
        WAIT.waitForTextOnPage("Stay signed in?", "Search for a case");
		if (webDriver.findElements(By.xpath("//*[text() ='" + "Stay signed in?" + "']")).size() == 1) {
	        NAV.waitForBrowserReadyState();
	        NAV.press_buttonByName("No");
	        NAV.waitForBrowserReadyState(90);
		}
	        WAIT.waitForTextOnPage("except where otherwise stated");
	        NAV.waitForBrowserReadyState(90);
    }

    public void signOut() throws Exception {
        NAV.click_link_by_text("Sign out");
        if (!TD.userId.isBlank()) {
            WebElement webElement = webDriver.findElement(By.xpath("//div//*[translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')=\"" + TD.userId.toLowerCase() + "\"]"));
            webElement.click();
        }
        NAV.waitForBrowserReadyState();
        NAV.waitForBrowserReadyState(90);
        WAIT.waitForTextOnPage("Sign in", 15);
    }

    public void notificationCount(String count) {
        NAV.waitForPageLoad();
        webDriver.findElement(By.xpath("//span[contains(@id, 'notifications') and contains(text(),'" + count + "')]"));
    }

    public void downloadFileMatches(String fileName) throws IOException {
        String substitutedValue = Substitutions.substituteValue(fileName);
        WAIT.pause(60);

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

	public void downloadFileMatches(String caseNumber, String fileName) throws IOException {
        String substitutedValue = Substitutions.substituteValue(caseNumber) + 
        		"_" +
        		DateUtils.todayDisplay0().replace(" ", "_")
        		+ "_1.mp3";
        WAIT.pause(60);

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

    public void waitForNavigation(String url, String text) {
        int waitTimeInSeconds = 150;
        log.info("WAIT TIME {}", waitTimeInSeconds);
		By byXpath = By.xpath("//*[contains(.,'" 
				+ text
				+ "')]");

        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(30))
                .ignoring(NoSuchElementException.class)
                .ignoring(StaleElementReferenceException.class);

        Function<WebDriver, Boolean> checkForTextPresent = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
                NAV.waitForBrowserReadyState();
                if (webDriver.findElements(byXpath).size() != 0) {
                    log.info("url {} with text {} found", url, text);
                    return true; // Element is present
                } else {
                	webDriver.navigate().to(url); // Refresh the page if element not found
                    return false;
                }
            }
        };
        try {
            wait.until(checkForTextPresent);
        } catch (TimeoutException e) {
            log.fatal("url {} with text {} not reached within the specified wait time.", url, text);
        }
    }
    
    public void wait(int waitTime) {
        int waitTimeInSeconds = waitTime * 60;
        log.info("WAIT TIME {}", waitTimeInSeconds);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds));  
        Function<WebDriver, Boolean> justWait = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {  
                return false;
            };
        };
        try {
            wait.until(justWait);
        } catch (TimeoutException e) {
            log.info("Wait {} seconds complete", waitTime);
        }
    }
    
    public void waitForAudioToBeLoaded(String courthouse, String courtroom, String caseNumber, String hearingDate) throws Exception {
    	log.info("Waiting for audio file to be loaded - {} {} {} for {}", courthouse, courtroom, caseNumber, hearingDate);
    	String mediaId = DB.returnSingleValue("CASE_AUDIO", 
    			"courthouse_name", courthouse,  
    			"courtroom_name", courtroom,
				"cas.case_number", caseNumber,
				"hearing_date", hearingDate,
				"max(med_id)");
        int waitTimeInSeconds = AUDIO_WAIT_TIME_IN_SECONDS;
        log.info("wait time {} courthouse {}, courtroom {}, case {}, date {}", waitTimeInSeconds, courthouse, courtroom, caseNumber, DateUtils.dateAsYyyyMmDd(hearingDate));
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(10));  
        Function<WebDriver, Boolean> audioIsLoaded = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	ApiResponse apiResponse = jsonApi.getApi("audio/preview/" + mediaId);
            	return apiResponse.statusCode.equals("200");
            };
        };
        try {
            wait.until(audioIsLoaded);
            log.info("Audio loaded");
        } catch (TimeoutException e) {
            log.warn("Wait complete - not found");
        }
    }
    
    public void waitForAudioRequestToBeReady(String user, String courthouse, String caseNumber, String hearingDate) throws Exception {
    	log.info("Waiting for audio file to be loaded - {} {} {} for {}", courthouse, caseNumber, hearingDate, user);
    	String userName = Credentials.userName(user);
    	String user_id = DB.returnSingleValue("darts.user_account", "user_email_address",  userName, "usr_id");
        int waitTimeInSeconds = AUDIO_WAIT_TIME_IN_SECONDS;
        String jsonQuery = new StringBuilder("$..[?(@.case_number=='")
        		.append(caseNumber)
        		.append("' && @.courthouse_name=='")
        		.append(courthouse)
        		.append("' && @.hearing_date =='")
        		.append(DateUtils.dateAsYyyyMmDd(hearingDate))
        		.append("' && @.media_request_status=='COMPLETED')].media_request_status")
        		.toString();
        log.info(jsonQuery);
        log.info("wait time {} for user {}, courthouse {}, case {}, date {}", waitTimeInSeconds, user_id, courthouse, caseNumber, DateUtils.dateAsYyyyMmDd(hearingDate));
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(10));  
        Function<WebDriver, Boolean> audioIsLoaded = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	ApiResponse apiResponse = jsonApi.getApiWithParams("audio-requests/v2", "user_id=" + user_id, "expired=false", "");
            	List<String> audioCount = JsonPath.read(apiResponse.responseString, jsonQuery);
            	log.warn(audioCount);
            	return audioCount.size() > 0;
            };
        };
        try {
            wait.until(audioIsLoaded);
            log.info("Audio loaded");
        } catch (TimeoutException e) {
            log.warn("Wait complete - not found");
        }
    }
    
    public void waitForRequestedAudioToBeReady(String user, String courthouse, String caseNumber, String hearingDate) throws Exception {
    	log.info("Waiting for requested audio file to be ready - {} {} {} for {}", courthouse, caseNumber, hearingDate, user);
    	String userName = Credentials.userName(user);
    //	String usr_id = DB.returnSingleValue("darts.user_account", "user_email_address",  userName, "usr_id");
    	String mer_id = DB.returnSingleValue("HEARING_MEDIA_REQUEST", 
    			"courthouse_name",  courthouse, 
    			"case_number",  caseNumber,
    			"hearing_date", DateUtils.dateAsYyyyMmDd(hearingDate),
    			"lower(user_email_address)", userName,
    			"max(mer_id)");
        int waitTimeInSeconds = AUDIO_WAIT_TIME_IN_SECONDS;
        log.info("wait time {} for user {}, courthouse {}, case {}, date {}", waitTimeInSeconds, user, courthouse, caseNumber, DateUtils.dateAsYyyyMmDd(hearingDate));
        try {
        	waitForRequestedAudioToBeReady(mer_id);
        } catch (Exception | AssertionError e) {
            log.fatal("Wait complete - request not ready for user {}, courthouse {}, case {}, date {}", 
            		user, courthouse, caseNumber, hearingDate);
            Assertions.fail("Request not ready");
        }
    }
    
    public void waitForRequestedAudioToBeReady(String requestId) throws Exception {
        int waitTimeInSeconds = AUDIO_WAIT_TIME_IN_SECONDS;
    	log.info("Waiting {} secs for requested audio file to be ready requestId: {}", waitTimeInSeconds, requestId);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(30));  
        Function<WebDriver, Boolean> requestedAudioIsReady = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	String requestStatus = "";
				try {
					requestStatus = DB.returnSingleValue("darts.media_request",
							"mer_id", requestId, 
							"request_status");
				} catch (Exception e) {
					log.warn("Exception in database call \r\n {e}");
				}
            	log.warn("Request status: {}", requestStatus);
            	return requestStatus.equalsIgnoreCase("COMPLETED");
            };
        };
        try {
            wait.until(requestedAudioIsReady);
            log.info("Audio request ready");
        } catch (TimeoutException e) {
            log.fatal("Wait complete - request not ready for request id {}", requestId);
            Assertions.fail("Request not ready");
        }
    }

    public void waitForUpdatedRow(String text, String link) {
        String substitutedValueLink = Substitutions.substituteValue(link);
        String substitutedValueText = Substitutions.substituteValue(text);
        int waitTimeInSeconds = AUDIO_WAIT_TIME_IN_SECONDS;
        log.info("WAIT TIME {}", waitTimeInSeconds);

        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(30))
                .ignoring(NoSuchElementException.class)
                .ignoring(StaleElementReferenceException.class);

        Function<WebDriver, Boolean> checkForRowFieldsPresent = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
                log.info("Starting fluent wait");
                NAV.waitForBrowserReadyState();
                String xpath = "//tr[./td[normalize-space(.)='" + substitutedValueText + "'] and ./td[a[normalize-space(.)='" + substitutedValueLink + "']]]";
                List<WebElement> elements = webDriver.findElements(By.xpath(xpath));
                if (elements.size() != 0) {
                    log.info("Link " + link + " found for " + text);
                    return true; // Element is present
                } else {
                    NAV.refreshPage(); // Refresh the page if element not found
                    return false;
                }
            }
        };
        try {
            wait.until(checkForRowFieldsPresent);
        } catch (TimeoutException e) {
            log.fatal("Link " + link + " NOT found for " + text + " within the specified wait time.");
        }
    }
    
    public String returnRequestId() {
    	String requestId = webDriver.findElement(By.xpath("//h1[text()='Your order is complete']"
    			+ "/following-sibling::div[starts-with(normalize-space(text()),'Your request ID')]"
    			+ "/strong")).getText();
    	log.info("Request ID found: {}", requestId);
    	return requestId;
    }

    public void clickOnSubMenuLink(String linkText) {
        String substitutedValue = Substitutions.substituteValue(linkText);
        webDriver.findElement(By.xpath("//app-tabs//a[@class='moj-sub-navigation__link'][contains(text(),'" + substitutedValue + "')]")).click();
        NAV.waitForPageLoad();
    }

	public boolean subMenuLinkVisible(String linkText) {
		log.info("Going to check whether sub-menu link text =>" + linkText + "<= is present on the page");
		boolean isVisible = false;
		WebElement link;
		try {
			link = webDriver.findElement(By.xpath("//app-tabs//a[@class='moj-sub-navigation__link'][contains(text(),'" + Substitutions.substituteValue(linkText) + "')]"));
			isVisible = link.isDisplayed();
		} catch (Exception e) {
			isVisible = false;
		}
		return isVisible;
	}

	public int countSubMenuHeaders(String text) {
		log.info("About to look for sub-Menu header containing {}", text);
		By by = By.xpath("//h2[normalize-space(.)=\"" + text + "\"]"
				+ " | //h1[normalize-space(.)=\"" + text + "\"]");
		try {
			List<WebElement> webELements = new WebDriverWait(webDriver, Duration.ofSeconds(5))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(NoSuchElementException.class)
				.until(ExpectedConditions
					.numberOfElementsToBeMoreThan(by, 0));
			if (webELements.size() != 1) {
				log.warn("Number of subMenu headers with text {} was {}", text, webELements.size()); 
			}
			return webELements.size();
		} catch (Exception | AssertionError e) {
			return 0;
		}
	}
	
	public String getCookie(String cookie, String name) throws Exception {
		String cookieValue = webDriver.manage().getCookieNamed(cookie).getValue();
		if (cookieValue == null || cookieValue.isBlank()) {
			return "";
		}
		return java.net.URLDecoder.decode(cookieValue, "UTF-8")
				.split(",")[0]
				.split("\"" + name + "\":")[1];
	}
}