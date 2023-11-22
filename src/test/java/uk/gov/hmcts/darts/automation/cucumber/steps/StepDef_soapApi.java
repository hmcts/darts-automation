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
import uk.gov.hmcts.darts.automation.utils.XmlUtils;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;

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
	
	String getValue(Map<String, String> map, String column) {
		if (map.containsKey(column)) {
			String value = map.get(column);
			if (value == null) {
				value = "";
			}
			return value;
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
				return tableValue;
			}
		} else {
			return defaultValue;
		}
	}
	
/*
 * Save value from xml response in testdata object
 */
	@Then("^I find (\\S*) in the xml response at \"([^\"]*)\"$")
	public void extractStringFromXmlResponse(String name, String path) {
		String value = XmlUtils.extractXmlValue(testdata.responseString, path);
		testdata.setProperty(name, value);
	}

	@Then("^I see \"([^\"]*)\" in the xml response is \"([^\"]*)\"$")
	public void verifyStringInXmlResponse(String path, String expectedValue) {
		String value = XmlUtils.extractXmlValue(testdata.responseString, path);
		Assertions.assertEquals(expectedValue, value, "XML value not as expected");
	}
	
// sample cucumber:
// When I add a case using soap
// |courthouse|case_number|defendants|judges|prosecutors|defenders|
	@When("^I add a case using soap$")
	public void createAddCaseXml(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildAddCaseXml(
					getValue(map, "courthouse"),
					getValue(map, "case_number"),
					getValue(map, "defendants"),
					getValue(map, "judges"),
					getValue(map, "prosecutors"),
					getValue(map, "defenders"));
			ApiResponse apiResponse = soapApi.postSoap("", "addCase", xml, true);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertEquals("200", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
		}
	}
	
	@When("I call POST SOAP API using soap body:")
	public void callPostApiWithXmlBody(String docString) {
		ApiResponse apiResponse = soapApi.postSoap("", docString);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using soap action {word} and body:")
	public void callPostSoapActionApiWithBody(String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, docString, true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using SOAPAction {word} and encoded body:")
	public void callPostSoapActionApiWithEncodedBody(String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, docString, true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using SOAPAction {word} and body:")
	public void callPostSoapActionApiWithUnencodedBody(String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, docString, false);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap body:")
	public void callPostApiWithBody(String endPoint, String docString) {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, docString);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap action {word} and body:")
	public void callPostSoapActionApiWithBody(String endPoint, String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, docString, true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using SOAPAction {word} and encoded body:")
	public void callPostSoapActionApiWithEncodedBody(String endPoint, String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, docString, true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using SOAPAction {word} and body:")
	public void callPostSoapActionApiWithNotEncodedBody(String endPoint, String soapAction, String docString) {
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, docString, false);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@Then("^the SOAP response contains:$")
	public void verifyApiResponse(String docString) {
		Assertions.assertTrue(testdata.responseString.replaceAll(">\\R|\\s<", "><").contains(docString.replaceAll(">\\R|\\s<", "><")), "Response contents not matched:\r" + testdata.responseString);
	}
	

	
}