package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.docstring.DocString;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.Api;
//import uk.gov.hmcts.darts.automation.pageObjects.Portal;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StepDef_api extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_api");
//	private final WebDriver webDriver;
//	private Portal portal;
	private Api api;
	
	
	public StepDef_api(SharedDriver driver, NavigationShared ns) {
		super(driver, ns);
		api = new Api();
	}
	
//	@Given("I call <string> API using json body:")
//	public void callApiWithJsonBody(String endpoint, DocString docString) throws Exception {
//		api.postApi(endpoint, docString.toString());
//	}
	
	@Given("I call POST {} API using json body:")
	public void callPostApiWithJsonBody(String endPoint, String docString) throws Exception {
		api.postApi(endPoint, docString);
	}
	
	@Given("I call GET {} API")
	public void callGetApiWithJsonBody(String endPoint) throws Exception {
		api.getApi(endPoint);
	}
	

	
}