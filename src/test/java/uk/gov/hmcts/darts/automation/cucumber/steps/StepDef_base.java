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
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;


public class StepDef_base {
	
	final WebDriver webDriver;
	NavigationShared NAV;
	searchCase SRCH;
	
	public StepDef_base(
			SharedDriver webDriver, 
			NavigationShared NAV
			) {
		this.webDriver = webDriver;
		this.NAV = NAV;
	}

	public StepDef_base(
			SharedDriver webDriver,
			searchCase SRCH
	) {
		this.webDriver = webDriver;
		this.SRCH = SRCH;
	}
	
}

