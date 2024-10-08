package uk.gov.hmcts.darts.automation.utils;

import java.time.Duration;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;

public class WaitUtils {
	private WebDriver driver;
	private static int TIME_IN_SECONDS = 60;
	private static Logger log = LogManager.getLogger("WaitUtils");

	public WaitUtils(WebDriver driver) {
		this.driver = driver;
	}

	public void waitForList(List<WebElement> name) {
		new WebDriverWait(driver, Duration.ofSeconds(TIME_IN_SECONDS))
			.pollingEvery(Duration.ofMillis(200))
			.ignoring(StaleElementReferenceException.class)
			.until(ExpectedConditions
				.visibilityOfAllElements(name));
		
	}
	
	public void waitForClickableElement(WebElement name, int wait_time) {
		log.info("Waiting for element to be clickable =>"+wait_time+"<= seconds");
		try {
			new WebDriverWait(driver, Duration.ofSeconds(wait_time))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(NoSuchElementException.class)
				.ignoring(StaleElementReferenceException.class)
				.until(ExpectedConditions.elementToBeClickable(name));	
			log.info("Element now clickable => "+name);
		} catch (Exception e) {
			log.error("Timed out waiting for Element to be clickable => "+name);
		}
	}

	public WebElement waitForClickableElement(By by, int wait_time) {
		log.info("Waiting for element to be clickable =>"+wait_time+"<= seconds");
		try {
			WebElement webElement = new WebDriverWait(driver, Duration.ofSeconds(wait_time))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(StaleElementReferenceException.class)
				.ignoring(NoSuchElementException.class)
				.until(ExpectedConditions.elementToBeClickable(by));
			log.info("Element now clickable => "+by);
			return webElement;
		} catch (Exception e) {
			log.error("Timed out waiting for Element to be clickable => "+by);
		}
		return null;
	}

	public void waitForClickableElement(WebElement name) {
		waitForClickableElement(name, TIME_IN_SECONDS);
	}

	public WebElement waitForClickableElement(By by) {
		return waitForClickableElement(by, TIME_IN_SECONDS);
	}

	public void waitForTextOnPage(String text) {
		waitForTextOnPage(text, 10);
	}
	
	public void waitForTextOnPage(String text1, String text2, int wait_time) {
		By byXpath1 = By.xpath("//*[contains(.,'" // This resolves issues where elements are parallel to text
				+ text1
				+ "')]"); 
		By byXpath2 = By.xpath("//*[contains(.,'" // This resolves issues where elements are parallel to text
				+ text2
				+ "')]"); 
		boolean found = (new WebDriverWait(driver, Duration.ofSeconds(wait_time)))
				.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions.or(
						ExpectedConditions.presenceOfElementLocated(byXpath1), 
						ExpectedConditions.presenceOfElementLocated(byXpath2)));
	}
	
	public void waitForTextOnPage(String text1, String text2) {
		waitForTextOnPage(text1, text2, 10);
	}
	
	public void waitForTextOnPage(String text, int wait_time) {
		By byXpath = By.xpath("//*[contains(.,'" // This resolves issues where elements are parallel to text
				+ text
				+ "')]"); 
		WebElement element = (new WebDriverWait(driver, Duration.ofSeconds(wait_time)))
				.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions
				.presenceOfElementLocated(byXpath));
	}
	
	public void waitForTextInvisibility(String text, int wait_time) {
		deactivateImplicitWait();
		By byXpath = By.xpath("//*[contains(.,'" // This resolves issues where elements are parallel to text
				+ text
				+ "')]"); 
		log.info("Waiting for text =>" + text + "<= to disappear");
		Boolean element = (new WebDriverWait(driver, Duration.ofSeconds(wait_time)))
				.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions
				.invisibilityOfElementLocated(byXpath));
		log.info("Finished waiting, element visibility =>" + element);
	}
	

	public void waitForNonList(WebElement name) {
		new WebDriverWait(driver, Duration.ofSeconds(TIME_IN_SECONDS))
			.pollingEvery(Duration.ofMillis(200))
			.until(ExpectedConditions
				.visibilityOf(name));
	}
	
	public void waitForElementNoLongerInTheDOM(WebElement name) {
		new WebDriverWait(driver, Duration.ofSeconds(TIME_IN_SECONDS))
			.pollingEvery(Duration.ofMillis(200))
			.until(ExpectedConditions
				.stalenessOf(name));
	}

	public void waitUntilTitle(WebElement element, String text) {
		new WebDriverWait(driver, Duration.ofSeconds(TIME_IN_SECONDS))
			.pollingEvery(Duration.ofMillis(200))
			.until(ExpectedConditions
				.textToBePresentInElement(element, text));
	}

/*
 * Changed to de-activate as we don't want to use implicit waits
 */
	public void activateImplicitWait() {
		log.info("Don't Activate Implicit wait");
		driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(0)); // Activate implicitlyWait()														
	}

	public void deactivateImplicitWait() {
		
		driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(0)); // nullify implicitlyWait()	
		log.info("Deactivate Implicit wait");
	}
	
	
	public void toBeClickAble(WebElement element) {
		
		new WebDriverWait(driver, Duration.ofSeconds(TIME_IN_SECONDS))
			.pollingEvery(Duration.ofMillis(200))
			.until(ExpectedConditions.elementToBeClickable(element));
		
	}

	public void f_wait(List<WebElement> name) {
		Wait<WebDriver> wait = new FluentWait<WebDriver>(driver)
				.withTimeout(Duration.ofSeconds(30))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(NoSuchElementException.class)
				.ignoring(StaleElementReferenceException.class);

		wait.until(ExpectedConditions.visibilityOfAllElements(name));
	}

	public void f_waitNoList(WebElement name) {
		FluentWait<WebDriver> wait = new FluentWait<WebDriver>(driver)
				.withTimeout(Duration.ofSeconds(60))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(NoSuchElementException.class)
				.ignoring(StaleElementReferenceException.class);

		wait.until(ExpectedConditions.visibilityOf(name));
	}

	public void f_waitElementToClickable(WebElement element) {
		log.info("Waiting for element to be clickable");
		Wait<WebDriver> wait = new FluentWait<WebDriver>(driver)
				.withTimeout(Duration.ofSeconds(30))
				.pollingEvery(Duration.ofMillis(200))
				.ignoring(NoSuchElementException.class)
				.ignoring(StaleElementReferenceException.class);
		try {
			WebElement waitResult = wait.until(ExpectedConditions.elementToBeClickable(element));
			if (waitResult == null) {
				log.warn("Wait timed out **********");
			}
		} catch (Exception e) {
			log.warn("Wait timed out ********** - exception");
		}

	}
    
    public void pause(int seconds) {
        log.info("WAIT TIME {}", seconds);
        Wait<WebDriver> wait = new FluentWait<WebDriver>(driver)
                .withTimeout(Duration.ofSeconds(seconds));  
        Function<WebDriver, Boolean> justWait = new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver webDriver) {  
                return false;
            };
        };
        try {
            wait.until(justWait);
        } catch (TimeoutException e) {
            log.info("Wait {} seconds complete", seconds);
        }
    }

}