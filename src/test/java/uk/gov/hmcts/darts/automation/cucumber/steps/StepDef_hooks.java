package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.Alert;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.OutputType;

import io.cucumber.java.Scenario;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDef_hooks extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_hooks");
		
	public StepDef_hooks(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
	}
	
	static Scenario scenario;

	@Then("^I take a screenshot \"([^\"]*)\"$")
	public void takeScreenshot(String caption) {	
		try {
			JavascriptExecutor jse = (JavascriptExecutor)webDriver;
		    jse.executeScript("document.body.style.zoom = '50%';");
			byte[] screenshot = ((TakesScreenshot)webDriver).getScreenshotAs(OutputType.BYTES);
			scenario.attach(screenshot, "image/png", "Screenshot");
		} catch (Exception e) {
			log.info("Failed getting screenshot");
		}
		log.info("Screenshot completed " + caption
						+scenario.getId() + " Thread Id: " + Thread.currentThread().getId());
		scenario.attach(("Screenshot " + caption
				+ "Scenario: " + scenario.getName() + "-"+scenario.getId()).getBytes().toString()
				+ " Thread Id: " + Thread.currentThread().getId(), "text/plain", "Details");
	}
	
	@After
	public void afterScenario(Scenario scenario) {
		log.info("End of scenario: "+scenario.getId()+" Thread Id: " + Thread.currentThread().getId());
		if (scenario.isFailed()) {	
			try {
				JavascriptExecutor jse = (JavascriptExecutor)webDriver;
			    jse.executeScript("document.body.style.zoom = '50%';");
				byte[] screenshot = ((TakesScreenshot)webDriver).getScreenshotAs(OutputType.BYTES);
				scenario.attach(screenshot, "image/png", "Screenshot");
			} catch (Exception e) {
				log.info("Failed getting screenshot");
			}			
		}
		try {
		    try {
		        Alert alert = webDriver.switchTo().alert();
		        log.info("Alert is present " + alert.getText());
		        alert.dismiss();
		        scenario.attach(("Alert is present --- Scenario: " + scenario.getName()+"-"+scenario.getId()).getBytes().toString()
						+ " Thread Id: " + Thread.currentThread().getId(), "text/plain", "Alert is present");
				try {
					JavascriptExecutor jse = (JavascriptExecutor)webDriver;
				    jse.executeScript("document.body.style.zoom = '50%';");
					byte[] screenshot = ((TakesScreenshot)webDriver).getScreenshotAs(OutputType.BYTES);
					scenario.attach(screenshot, "image/png", "Alert is present");
				} catch (Exception e) {
					log.info("Failed getting screenshot");
				}
		    } catch (Exception e) {
		        // no alert - happy days
		    }
		} catch (Exception e) {
			log.error("Error handling possible alert");
		}
		try {
	        scenario.attach("URL: " + webDriver.getCurrentUrl(), "text/plain", "Current url");
		} catch (Exception e) {
			log.info("Failed getting url");
		}
		scenario.attach(("Scenario: " + scenario.getName()+"-"+scenario.getId()).getBytes(), "text/plain", "Details");
		scenario.attach(("Scenario: " + scenario.getName()+"-"+scenario.getId()).getBytes().toString()
				+ " Thread Id: " + Thread.currentThread().getId(), "text/plain", "Thread");
		webDriver.quit();
	}
	
	@Before
	public void beforeScenario(Scenario scenario) {
		log.info("Start of scenario: "+scenario.getId()+" Thread Id: " + Thread.currentThread().getId());
		this.scenario = scenario;
	}
	
}