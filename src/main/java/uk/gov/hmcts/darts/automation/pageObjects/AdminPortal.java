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
    
    public void reactivateUser(String userName) throws Exception {
		if (DB.returnSingleValue("select is_active "
				+ "from darts.user_account "
				+ "where lower(user_name) = '" + userName.toLowerCase() + "'").equals("f")) {
    		try {
		    	NAV.click_link_by_text("Users");
		    	NAV.set_valueTo("Full name", userName);
		    	NAV.checkRadioButton("All");
		    	NAV.press_buttonByName("Search");
		    	NAV.clickText_inSameRow_asText("View", userName);
		    	NAV.press_buttonByName("Activate user");
		    	NAV.press_buttonByName("Reactivate user");
		    	log.info("User {} set to active", userName);
	    	} catch (Exception e) {
	    		log.warn("User {} not set to active", userName);
	    	}
    	} else {
	    	log.info("User {} already active", userName);
    	}
    }
    
    public void addGroupsToUser(String userName, String group, String role) throws Exception {
		if (DB.returnSingleValue("select count(group_name) "
				+ "from " + DB.tableName("USER_GROUP") + " "
				+ "where lower(user_name) = '" + userName.toLowerCase() + "' "
				+ "and lower(group_name) = '" + group.toLowerCase() + "'").equals("0")) {
	    	try {
		    	NAV.click_link_by_text("Users");
		    	NAV.set_valueTo("Full name", userName);
		    	NAV.press_buttonByName("Search");
		    	NAV.clickText_inSameRow_asText("View", userName);
		    	portal.clickOnSubMenuLink("Groups");
		    	NAV.press_buttonByName("Assign groups");
		    	NAV.set_valueTo("Filter by group name", group);
		    	if (role.isBlank()) {
		    		NAV.checkUncheckCheckboxInTableRow(group, "check");
		    	} else {
		    		NAV.checkUncheckCheckboxInTableRow(group, role, "check");
		    	}
		    	NAV.press_buttonByName("Assign groups (1)");
		    	log.info("User {} added to group {}", userName, group);
	    	} catch (Exception e) {
	    		log.warn("User {} not added to group {}", userName, group);
	    	}
		}
    }
}