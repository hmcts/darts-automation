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

public class Portal {
	private static Logger log = LogManager.getLogger("Portal");

    private WebDriver webDriver;

    public Portal(WebDriver driver) {
        this.webDriver = driver;
    }
    
    public void clickOnBreadcrumbLink(String label) {
    	webDriver.findElement(By.xpath("//a[text()=\"" + label + "\" and contains(@class,'breadcrumb')]")).click();
    }

}