package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import java.util.Map;

import org.junit.jupiter.api.Assertions;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.Substitutions;
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
	
	String getValue(Map<String, String> map, String column) {
		if (map.containsKey(column)) {
			String value = map.get(column);
			if (value == null) {
				value = "";
			}
			return Substitutions.substituteValue(value);
		} else {
			return "";
		}
	}
	
	String getValue(Map<String, String> map, String column, String defaultValue) {
		if (map.containsKey(column)) {
			String tableValue = map.get(column);
			if (tableValue == null || tableValue.isEmpty()) {
				return defaultValue;
			} else {
				return Substitutions.substituteValue(tableValue);
			}
		} else {
			return defaultValue;
		}
	}
	
	
}

