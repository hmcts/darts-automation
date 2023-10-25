package uk.gov.hmcts.darts.automation.utils;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;

public class Alerts {
	private WebDriver driver;
	private static Logger log = LogManager.getLogger("Alerts");
	private WaitUtils wait;
	private NavigationShared NAV;


	public Alerts(WebDriver driver) {
		this.driver = driver;
		wait = new WaitUtils(driver);
		NAV = new NavigationShared(driver);
		
	}
    
	
	public Alert waitForAlert(Integer seconds) {
		log.info("Waiting for alert to appear");
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(seconds));
		Alert alert = wait.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions.alertIsPresent());
		log.info("Saw Alert - Continuing");
		return alert;
	}

	public void dismissAlert() {
		Alert alert = waitForAlert(5);
		String alertText = alert.getText().trim();
		alert.dismiss();
		log.info("Dismissed Alert " + alertText);
		NAV.waitForBrowserReadyState();
	}

	public void dismissAlert(String expectedText) {
		Alert alert = waitForAlert(5);
		String alertText = alert.getText().trim();
		Assertions.assertTrue(expectedText.equals(alertText),
				"Alert text expected =>" + expectedText 
				+ "<= actual =>" + alertText + "<=");
		alert.dismiss();
		log.info("Dismissed Alert " + expectedText);
		NAV.waitForBrowserReadyState();
	}
	
	public void acceptAlert() {
		Alert alert = waitForAlert(5);
		String alertText = alert.getText().trim();
		alert.accept();
		log.info("Accepted Alert" + alertText);
		NAV.waitForBrowserReadyState();
	}
	
	public void acceptAlert(String expectedText) {
		Alert alert = waitForAlert(5);
		String alertText = alert.getText().trim();
		Assertions.assertTrue(expectedText.equals(alertText),
				"Alert text expected =>" + expectedText 
							+ "<= actual =>" + alertText + "<=");
		alert.accept();
		log.info("Accepted Alert " + expectedText);
		NAV.waitForBrowserReadyState();
	}

	public void dismissNotification() { //closeAlert closeBtn
		wait.activateImplicitWait();
		WebElement notificationCrossToClose = driver.findElement(By.xpath("//*[@id='closeAlert'] | //*[@id='closeBtn']"));
		wait.toBeClickAble(notificationCrossToClose);
		notificationCrossToClose.click();
		log.info("Dismissed notification message");
		NAV.waitForBrowserReadyState();
	}
			

}