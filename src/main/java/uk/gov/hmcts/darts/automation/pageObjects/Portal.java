package uk.gov.hmcts.darts.automation.pageObjects;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;

public class Portal {
	private static Logger log = LogManager.getLogger("Portal");

    private WebDriver webDriver;
    private NavigationShared NAV;

    public Portal(WebDriver driver) {
        this.webDriver = driver;
        NAV = new NavigationShared(webDriver);
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
}