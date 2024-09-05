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
import uk.gov.hmcts.darts.automation.utils.Credentials;
import uk.gov.hmcts.darts.automation.pageObjects.Portal;

public class AdminPortal {
    private static Logger log = LogManager.getLogger("AdminPortal");

    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;
    private TestData TD;
    private Database DB;
    private JsonApi jsonApi;
    private Portal portal;

    public AdminPortal(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
        DB = new Database();
    	jsonApi = new JsonApi();
        portal = new Portal(webDriver, testdata);
    }
    
    public void addGroupsToUser(String userName, String group) throws Exception {
    	try {
	    	NAV.click_link_by_text("Users");
	    	NAV.set_valueTo("Full name", userName);
	    	NAV.press_buttonByName("Search");
	    	NAV.clickText_inSameRow_asText("View", userName);
	    	portal.clickOnSubMenuLink("Groups");
	    	NAV.press_buttonByName("Assign groups");
	    	NAV.set_valueTo("Filter by group name", group);
	    	NAV.checkUncheckCheckboxInTableRow(group, "Requester", "check");
	    	NAV.press_buttonByName("Assign groups (1)");
	    	log.info("User {} added to group {}", userName, group);
    	} catch (Exception e) {
    		log.warn("User {} not added to group {}", userName, group);
    	}
    }
}