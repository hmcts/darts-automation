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

    private static int WAIT_TIME = 20;
    
    private WebDriver webDriver;
    private TestData TD;
    private Database DB;
    private WaitUtils WAIT_UTILS;

    public DbUtils(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        DB = new Database();
        WAIT_UTILS = new WaitUtils(webDriver);
    }
    
    public void waitForCaseCreation(String courthouse, String courtroom, String caseNumber)  throws Exception {
        int waitTimeInSeconds = WAIT_TIME;
    	log.info("Waiting {} secs for case to be inserted: {} {} {}", waitTimeInSeconds, courthouse, courtroom, caseNumber);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(2));  
        Function<WebDriver, Boolean> caseIsReady = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	String caseCount = "";
				try {
					caseCount = DB.returnSingleValue("CASE_HEARING",
			    			"upper(courthouse_name)",  courthouse.toUpperCase(), 
			    			"upper(courtroom_name)",  courtroom.toUpperCase(), 
			    			"case_number",  caseNumber,
			    			"cas_id");
				} catch (Exception e) {
					log.warn("Exception in database call \r\n {e}");
				}
            	log.info("Case count: {}", caseCount);
            	return !caseCount.equals("0");
            };
        };
        try {
            wait.until(caseIsReady);
            log.info("case ready");
        } catch (TimeoutException e) {
            log.fatal("Wait complete - case not ready");
            Assertions.fail("Case not created");
        }
    }
    
    public void waitForCaseCreation(String courthouse, String caseNumber) {
        int waitTimeInSeconds = WAIT_TIME;
    	log.info("Waiting {} secs for case to be inserted: {} {}", waitTimeInSeconds, courthouse, caseNumber);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(2));  
        Function<WebDriver, Boolean> caseIsReady = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	String caseCount = "";
				try {
					caseCount = DB.returnSingleValue("CASE_HEARING",
							"cas.case_number", caseNumber, 
							"upper(courthouse_name)", courthouse.toUpperCase(),
							"count(cas.case_number)");
				} catch (Exception e) {
					log.warn("Exception in database call \r\n {e}");
				}
            	log.info("Case count: {}", caseCount);
            	return !caseCount.equals("0");
            };
        };
        try {
            wait.until(caseIsReady);
            log.info("case ready");
        } catch (TimeoutException e) {
            log.fatal("Wait complete - case not ready");
            Assertions.fail("Case not created");
        }
    }
    
    public void waitForDailyListToBeProcessed(String courthouse) {
        int waitTimeInSeconds = WAIT_TIME;
    	log.info("Waiting {} secs for daily list to be processed: {}", waitTimeInSeconds, courthouse);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(webDriver)
                .withTimeout(Duration.ofSeconds(waitTimeInSeconds))
                .pollingEvery(Duration.ofSeconds(2));  
        Function<WebDriver, Boolean> noDailyList = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {
            	String listCount = "";
				try {
					listCount = DB.returnSingleValue("darts.daily_list",
							"listing_courthouse", courthouse, 
							"job_status", "NEW",
							"start_dt", DateUtils.todayYyyymmdd(),
							"count(dal_id)");
				} catch (Exception e) {
					log.warn("Exception in database call \r\n {e}");
				}
            	log.info("List count: {}", listCount);
            	return listCount.equals("0");
            };
        };
        try {
            wait.until(noDailyList);
            log.info("no daily lists waiting to be processed");
            WAIT_UTILS.pause(10);
        } catch (TimeoutException e) {
            log.warn("Wait complete - daily list not processed for: {}", courthouse);
        }
    }
    
}