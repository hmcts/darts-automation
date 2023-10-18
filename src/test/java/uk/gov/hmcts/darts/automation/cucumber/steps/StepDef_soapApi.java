package uk.gov.hmcts.darts.automation.cucumber.steps;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.docstring.DocString;

import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.SoapApi;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

import static org.junit.jupiter.api.Assertions.*;

public class StepDef_soapApi extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_soapApi");
	private SoapApi soapApi;
	
	
	public StepDef_soapApi(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		soapApi = new SoapApi();
	}
	
	@When("I call POST {word} SOAP API using soap body:")
	public void callPostApiWithJsonBody(String endPoint, String docString) throws Exception {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, docString);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap body:")
	public void callGetApiWithJsonBody(String endPoint, String soapAction, String docString) throws Exception {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, docString);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@Then("^the SOAP response contains:$")
	public void verifyApiResponse(String docString) {
		Assertions.assertTrue(testdata.responseString.contains(docString), "Response contents not matched:\r" + testdata.responseString);
	}
	

	
}