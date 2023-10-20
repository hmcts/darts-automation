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


public class StepDef_base {
	
	public WebDriver webDriver;
	public NavigationShared NAV;
	
	public StepDef_base(SeleniumWebDriver webDriver) {
		this.webDriver = webDriver.webDriver;
		NAV = new NavigationShared(this.webDriver);
	}	
	
	
}

