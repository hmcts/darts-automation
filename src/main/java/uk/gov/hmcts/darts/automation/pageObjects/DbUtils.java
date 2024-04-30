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
import java.time.Duration;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import uk.gov.hmcts.darts.automation.utils.*;

public class DbUtils {
    private static Logger log = LogManager.getLogger("DbUtils");

    private WebDriver webDriver;
    private TestData TD;
    private Database DB;

    public DbUtils(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        DB = new Database();
    }
    
    public void waitForCaseCreation(String courthouse, String courtroom, String caseNumber)  throws Exception {
        int waitTimeInSeconds = 300;
    	log.info("Waiting {} secs for case to be inserted: {} {} {}", waitTimeInSeconds, courthouse, courtroom, caseNumber);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(20));  
        Function<WebDriver, Boolean> requestedAudioIsReady = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	String casId = "";
				try {
			    	casId = DB.returnSingleValue("CASE_HEARING", 
			    			"upper(courthouse_name)",  courthouse.toUpperCase(), 
			    			"upper(courtroom_name)",  courtroom.toUpperCase(), 
			    			"case_number",  caseNumber,
			    			"cas_id");
				} catch (Exception e) {
					log.warn("Exception in database call \r\n {e}");
				}
            	log.warn("cas_id: {}", casId);
            	return !casId.isBlank();
            };
        };
        try {
            wait.until(requestedAudioIsReady);
            log.info("Audio request ready");
        } catch (TimeoutException e) {
            log.warn("Wait complete - request not ready");
        }
    }
    
}