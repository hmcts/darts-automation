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
import io.cucumber.java.AfterAll;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import uk.gov.hmcts.darts.automation.utils.DateUtils;
import uk.gov.hmcts.darts.automation.utils.JsonApi;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
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
		if (scenario.isFailed()) {	
			log.fatal("End of Scenario - Scenario Failed: " + scenario.getId() + " Thread Id: " + Thread.currentThread().getId());
			log.fatal("URL: " + webDriver.getCurrentUrl(), "text/plain", "Current url");
			try {
				JavascriptExecutor jse = (JavascriptExecutor)webDriver;
			    jse.executeScript("document.body.style.zoom = '50%';");
				byte[] screenshot = ((TakesScreenshot)webDriver).getScreenshotAs(OutputType.BYTES);
				scenario.attach(screenshot, "image/png", "Screenshot");
			} catch (Exception e) {
				log.info("Failed getting screenshot");
			}			
		} else {
			log.info("End of Scenario - Scenario Passed: " + scenario.getId() + " Thread Id: " + Thread.currentThread().getId());
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
		if (webDriver != null) {
			log.info("closing browser");
			webDriver.close();
			if (webDriver != null && !ReadProperties.machine("usingDriver").equalsIgnoreCase("firefox")) {
				webDriver.quit();
			}
		}
	}
	
	@Before
	public void beforeScenario(Scenario scenario) {
		log.info("Start of scenario: {}, Thread Id: {}, Build: {}", scenario.getId(), Thread.currentThread().getId(), ReadProperties.buildNo);
		log.info("Name: {}, Tags: {} ", scenario.getName(), scenario.getSourceTagNames());
		this.scenario = scenario;
		String build = JsonApi.buildInfo();
		if (!ReadProperties.buildNo.equals(build)) {
			log.warn("Automation started with build {} but is now Build {}", ReadProperties.buildNo, build);
			scenario.attach("Warning - build number has changed since testing started, was Build: " + ReadProperties.buildNo 
					+ ", now: " + build, "text/plain", "Build-No_Changed");
		}
		scenario.attach("Environment: " + ReadProperties.environment + ", Build: " + ReadProperties.buildNo 
				+ ", seq: " + ReadProperties.seq
				+ ", " + DateUtils.timestamp(), "text/plain", "Run-details");
		testdata.setProperty("started", DateUtils.timestamp());
	}
	
	@BeforeAll
	public static void beforeAll() {
		log.info("Before all");
	}
	
	@AfterAll
	public static void afterAll() {
		log.info("After all");
	}
	
}