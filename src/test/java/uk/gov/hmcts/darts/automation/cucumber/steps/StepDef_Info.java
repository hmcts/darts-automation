package uk.gov.hmcts.darts.automation.cucumber.steps;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.Info;

import org.openqa.selenium.WebDriver;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;

public class StepDef_Info extends StepDef_base {
	
	private Info INF;
	
	public StepDef_Info(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		INF = new Info(webDriver);
	}
	
	@When("^I want to try something$")
	public void doTrySomething() throws Exception {
		INF.tryInput();
	}
	
	@When("^I want to try something \"([^\"]*)\"$")
	public void doSomething(String whatever) throws Exception {
		INF.doSomething(whatever);
	}
	
	@When("^I want to examine the page structure$")
	public void doDebug() throws Exception {
		INF.tryInput();
	}
	
	@When("^I want to display a dialog$")
	public void displayPopup() throws Exception {
		INF.displayPopup();
	}
	
	@When("^I want to display a dialog \"([^\"]*)\"$")
	public void displayPopup(String message) throws Exception {
		INF.displayPopup(message);
	}
	
	@When("^I want to prompt for input$")
	public void promptForInput() throws Exception {
		INF.displayPopup(INF.inputDialog("message"));
	}

}
