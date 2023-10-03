package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.junit.jupiter.api.Assertions;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.TestData;


public class StepDef_base {
	
	public WebDriver webDriver;
	public NavigationShared NAV;
	public TestData testdata;
	
	public StepDef_base(
			SeleniumWebDriver webDriver,
			TestData testdata
			) {
		this.webDriver = webDriver.webDriver;
		this.testdata = testdata;
		NAV = new NavigationShared(this.webDriver);
	}	
	
	
}

