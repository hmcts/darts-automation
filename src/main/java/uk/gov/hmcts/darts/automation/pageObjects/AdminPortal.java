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

public class AdminPortal {
    private static Logger log = LogManager.getLogger("AdminPortal");

    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;
    private TestData TD;
    private Database DB;
    private JsonApi jsonApi;

    public AdminPortal(WebDriver driver, TestData testdata) {
        this.webDriver = driver;
        this.TD = testdata;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
        DB = new Database();
    	jsonApi = new JsonApi();
    }

    public void clickOnSubMenuLink(String linkText) {
        String substitutedValue = Substitutions.substituteValue(linkText);
        webDriver.findElement(By.xpath("//app-tabs//a[@class='moj-sub-navigation__link'][contains(text(),'" + substitutedValue + "')]")).click();
        NAV.waitForPageLoad();
    }
}