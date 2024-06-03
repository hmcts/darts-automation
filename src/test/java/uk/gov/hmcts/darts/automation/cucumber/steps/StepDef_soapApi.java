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
import uk.gov.hmcts.darts.automation.utils.Substitutions;
import uk.gov.hmcts.darts.automation.utils.XmlUtils;
import uk.gov.hmcts.darts.automation.pageObjects.DbUtils;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;
import uk.gov.hmcts.darts.automation.utils.DateUtils;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

import static org.junit.jupiter.api.Assertions.*;

public class StepDef_soapApi extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_soapApi");
	private SoapApi soapApi;
	private static String SOURCE_XHIBIT = "XHIBIT";
	private static String SOURCE_CPP = "CPP";
	private static String SOURCE_VIQ = "VIQ";
	
	
	public StepDef_soapApi(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		soapApi = new SoapApi();
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
	
	@Given("I authenticate from (the) {word} source system") 
	public void authenticateAsSource(String source) {
		soapApi.overrideSource(source);
	}
	
// sample cucumber:
// When I add a case
// |courthouse|courtroom|case_number|defendants|judges|prosecutors|defenders|
	@When("^I create a case$")
	public void createAddCaseXml(List<Map<String,String>> dataTable) {
		soapApi.setDefaultSource(SOURCE_VIQ);
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildAddCaseXml(
					getValue(map, "courthouse"),
					getValue(map, "courtroom"),
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
	
// sample cucumber:
// When I create an event
// |message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|
	@When("^I create an event$")
	public void createEventXml(List<Map<String,String>> dataTable) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildAddEventXml(
					getValue(map, "message_id"),
					getValue(map, "type"),
					getValue(map, "sub_type"),
					getValue(map, "event_id"),
					getValue(map, "courthouse"),
					getValue(map, "courtroom"),
					getValue(map, "case_numbers"),
					getValue(map, "event_text"),
					DateUtils.makeTimestamp(getValue(map, "date_time"), getValue(map, "date"), getValue(map, "time")),			// start time
					getValue(map, "case_retention_fixed_policy"),
					getValue(map, "case_total_sentence"));
// Following field is in the json version - not seen in soap xml
//					 "end_time"
			ApiResponse apiResponse = soapApi.postSoap("", "addDocument", xml);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertEquals("200", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
		}
	}
	
// sample cucumber:
// When I add courtlogs
// |courthouse|courtroom|case_numbers|text|dateTime|
	@When("^I add courtlogs$")
	public void addLogsXml(List<Map<String,String>> dataTable) {
		soapApi.setDefaultSource(SOURCE_VIQ);
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildAddLogXml(
					getValue(map, "courthouse"),
					getValue(map, "courtroom"),
					getValue(map, "case_numbers"),
					getValue(map, "text"),
					DateUtils.makeTimestamp(getValue(map, "dateTime"), getValue(map, "date"), getValue(map, "time")));
			ApiResponse apiResponse = soapApi.postSoap("", "addLogEntry", xml, true);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertTrue(apiResponse.statusCode.equals("200")||apiResponse.statusCode.equals("201"), "Invalid API response " + apiResponse.statusCode);
		}
	}

	// sample cucumber:
	// When I get courtlogs
	// | courthouse | case_number | start | end |
	@When("^I get courtlogs$")
	public void getLogsXml(List<Map<String,String>> dataTable) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildGetLogXml(
					getValue(map, "courthouse"),
					getValue(map, "case_number"),
					DateUtils.makeTimestamp(getValue(map, "startDateTime"), getValue(map, "startDate"), getValue(map, "startTime")),
					DateUtils.makeTimestamp(getValue(map, "endDateTime"), getValue(map, "endDate"), getValue(map, "endTime")));
			ApiResponse apiResponse = soapApi.postSoap("", xml);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertTrue(apiResponse.statusCode.equals("200")||apiResponse.statusCode.equals("201"), "Invalid API response " + apiResponse.statusCode);
		}
	}
		
// sample cucumber:
// When I add a daily list
// | ... | datatable follows
//
// n.b. for CPP, case number is held in the URN field
//
	@When("I add (a) daily list(s)")
	public void createAddDailyListXml(List<Map<String,String>> dataTable) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		for (Map<String, String> map : dataTable) {
			String xml = XmlUtils.buildAddDailyListXml(
					getValue(map, "messageId"),
					getValue(map, "type"),
					getValue(map, "subType"),
					getValue(map, "documentName"),
					getValue(map, "courthouse"),
					getValue(map, "courtroom"),
					getValue(map, "caseNumber"),
					getValue(map, "startDate"),
					getValue(map, "startTime"),
					getValue(map, "endDate"),
					getValue(map, "timeStamp", DateUtils.timestamp()),
					getValue(map, "defendant", "Franz KAFKA"),
					getValue(map, "urn", getValue(map, "caseNumber")),
					getValue(map, "judge", "Judge Name"),
					getValue(map, "prosecution", "Prosecutor Name"),
					getValue(map, "defence", "Defence Name")
					);
			ApiResponse apiResponse = soapApi.postSoap("", "addDocument", xml);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertTrue(apiResponse.statusCode.equals("200")||apiResponse.statusCode.equals("201"), "Invalid API response " + apiResponse.statusCode);
		}
	}
	
	// sample cucumber:
	// When I load an audio file
	// |courthouse|courtroom|case_numbers|date|startTime|endTime|audioFile|channel|
		@When("^I load an audio file$")
		public void loadAudioFile(List<Map<String,String>> dataTable) {
			soapApi.setDefaultSource(SOURCE_VIQ);
			for (Map<String, String> map : dataTable) {
				String date = getValue(map, "date");
				String audioFile = getValue(map, "audioFile");
				String xml = XmlUtils.buildAddAudioXml(
						getValue(map, "courthouse"),
						getValue(map, "courtroom"),
						getValue(map, "case_numbers"),
						DateUtils.makeTimestamp(getValue(map, "startDateTime"), getValue(map, "date"), getValue(map, "startTime")),
						DateUtils.makeTimestamp(getValue(map, "endDateTime"), getValue(map, "date"), getValue(map, "endTime")),
						audioFile,
						getValue(map, "channel", "1"));
//				audioFile = ReadProperties.main("audioFileLocation") + audioFile + (audioFile.endsWith(".mp2") ? "" : ".mp2");
				ApiResponse apiResponse = soapApi.postSoapWithAudio("", "addAudio", xml, audioFile);
				testdata.statusCode = apiResponse.statusCode;
				testdata.responseString = apiResponse.responseString;
				Assertions.assertEquals("200", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
			}
		}
	
	@When("I call POST SOAP API using soap body:")
	public void callPostApiWithXmlBody(String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap("", Substitutions.substituteValue(docString));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using soap action {word} and body:")
	public void callPostSoapActionApiWithBody(String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, Substitutions.substituteValue(docString));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using SOAPAction {word} and encoded body:")
	public void callPostSoapActionApiWithEncodedBody(String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, Substitutions.substituteValue(docString), true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST SOAP API using SOAPAction {word} and unencoded body:")
	public void callPostSoapActionApiWithUnencodedBody(String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap("", soapAction, Substitutions.substituteValue(docString), false);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap body:")
	public void callPostApiWithBody(String endPoint, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap(endPoint, Substitutions.substituteValue(docString));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap action {word} and body:")
	public void callPostSoapActionApiWithBody(String endPoint, String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, Substitutions.substituteValue(docString));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using SOAPAction {word} and encoded body:")
	public void callPostSoapActionApiWithEncodedBody(String endPoint, String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, Substitutions.substituteValue(docString), true);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using SOAPAction {word} and body:")
	public void callPostSoapActionApiWithNotEncodedBody(String endPoint, String soapAction, String docString) {
		soapApi.setDefaultSource(SOURCE_XHIBIT);
		ApiResponse apiResponse = soapApi.postSoap(endPoint, soapAction, Substitutions.substituteValue(docString), false);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@Then("^the SOAP response contains:$")
	public void verifyApiResponse(String docString) {
		Assertions.assertTrue(testdata.responseString.replaceAll(">\\R|\\s<", "><").contains(Substitutions.substituteValue(docString).replaceAll(">\\R|\\s<", "><")), "Response contents not matched:\r" + testdata.responseString);
	}
	
	@When("I call POST {word} SOAP API using soap action {word} and body file {string}")
	public void callPostSoapActionApiWithBodyFile(String endPoint, String soapAction, String filename) {
		soapApi.setDefaultSource(SOURCE_VIQ);
		ApiResponse apiResponse = soapApi.postSoapXmlFile(endPoint, soapAction, filename);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} SOAP API using soap action {word} and audio file {string}")
	public void callPostSoapActionApiWithAudioFile(String endPoint, String soapAction, String filename) {
		soapApi.setDefaultSource(SOURCE_VIQ);
		ApiResponse apiResponse = soapApi.postSoapBinaryFile(endPoint, soapAction, filename);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@Then("I wait for courtroom {string} courthouse {string} case {string} to be ready")
	public void waitForCaseCreation(String courthouse, String courtroom, String caseNumber)  throws Exception {
		DbUtils dbUtils = new DbUtils(webDriver, testdata);
		dbUtils.waitForCaseCreation(courthouse, courtroom, caseNumber);
	}
	

	
}