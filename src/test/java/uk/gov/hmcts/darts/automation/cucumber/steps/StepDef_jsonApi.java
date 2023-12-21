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
import uk.gov.hmcts.darts.automation.utils.Substitutions;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.JsonApi;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

import static org.junit.jupiter.api.Assertions.*;

public class StepDef_jsonApi extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_jsonApi");
	private static String eventFields = "|message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|";
	private JsonApi jsonApi;
	
	
	public StepDef_jsonApi(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
		jsonApi = new JsonApi();
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
	
	@Given("I authenticate as a/an {word} user") 
	public void authenticateAsUser(String role) {
		jsonApi.authenticateAsUser(role);
	}
	
/*
 * Save value from json response in testdata object
 */
	@Then("^I find (\\S*) in the json response at \"([^\"]*)\"$")
	public void extractStringFromJsonResponse(String name, String path) {
		String value = JsonUtils.extractJsonValue(testdata.responseString, path);
		testdata.setProperty(name, value);
	}

	@Then("^I see \"([^\"]*)\" in the json response is \"([^\"]*)\"$")
	public void verifyStringInJsonResponse(String path, String expectedValue) {
		String value = JsonUtils.extractJsonValue(testdata.responseString, path);
		Assertions.assertTrue(Substitutions.substituteValue(expectedValue).equals(value), "Actual value not as Expected: " + value + ", Expected: " + expectedValue);
	}

	@When("^I call POST events API for id (\\S*) type (\\S*) (\\S*) with \"([^\"]*)\"$")
	public void callPostEventApi(String id, String type, String subType, String args) {
		testdata.setProperty("message_id", id);
		testdata.setProperty("type", type);
		testdata.setProperty("sub_type", subType);
		testdata.parseArgument(args, eventFields);
		String json = JsonUtils.buildAddEventJson(testdata.getProperty("message_id"),
				testdata.getProperty("type"),
				testdata.getProperty("sub_type"),
				testdata.getProperty("event_id"),
				testdata.getProperty("courthouse"),
				testdata.getProperty("courtroom"),
				testdata.getProperty("case_numbers"),
				testdata.getProperty("event_text"),
				testdata.getProperty("date_time"),
				testdata.getProperty("case_retention_fixed_policy"),
				testdata.getProperty("case_total_sentence"),
				testdata.getProperty("start_time"),
				testdata.getProperty("end_time"));
		ApiResponse apiResponse = jsonApi.postApi("events", json);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
// sample cucumber:
// When I load an audio file
// |courthouse|courtroom|case_numbers|audioFile|
	@When("^I load an audio file$")
	public void loadAudioFile(List<Map<String,String>> dataTable) {
//TODO add code to load a file
	}
	
// sample cucumber:
// When I create event using json
// |message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|
	@When("^I create an event$")
	public void createEventJson(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String json = JsonUtils.buildAddEventJson(
					getValue(map, "message_id", testdata.getProperty("message_id")),
					getValue(map, "type", testdata.getProperty("type")),
					getValue(map, "sub_type", testdata.getProperty("sub_type")),
					getValue(map, "event_id", testdata.getProperty("event_id")),
					getValue(map, "courthouse", testdata.getProperty("courthouse")),
					getValue(map, "courtroom", testdata.getProperty("courtroom")),
					getValue(map, "case_numbers", testdata.getProperty("case_numbers")),
					getValue(map, "event_text", testdata.getProperty("event_text")),
					getValue(map, "date_time", testdata.getProperty("date_time")),
					getValue(map, "case_retention_fixed_policy", testdata.getProperty("case_retention_fixed_policy")),
					getValue(map, "case_total_sentence", testdata.getProperty("case_total_sentence")),
					getValue(map, "start_time", testdata.getProperty("start_time")),
					getValue(map, "end_time", testdata.getProperty("end_time")));
			ApiResponse apiResponse = jsonApi.postApi("events", json);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertEquals("201", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
		}
	}
	
	// sample cucumber:
	// When I create a case
	// |courthouse|case_number|defendants|judges|prosecutors|defenders|
	@When("^I create a case using json$")
	public void createCaseJson(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String json = JsonUtils.buildAddCaseJson(
					getValue(map, "courthouse"),
					getValue(map, "case_number"),
					getValue(map, "defendants"),
					getValue(map, "judges"),
					getValue(map, "prosecutors"),
					getValue(map, "defenders"));
			ApiResponse apiResponse = jsonApi.postApi("cases", json);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertEquals("201", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
		}
	}

/* Create courthouse n.b. display name defaults to courthouse if blank
 * 
 * sample cucumber:
 * When I create a courthouse
 * |courthouse|code|display_name|
 * 
 */
	@When("^I create a courthouse$")
	public void createCourthouseJson(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String json = JsonUtils.buildAddCourthouseJson(
					getValue(map, "courthouse"),
					getValue(map, "code"),
					getValue(map, "display_name"));
			ApiResponse apiResponse = jsonApi.postApi("courthouses", json);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
			Assertions.assertEquals("201", apiResponse.statusCode, "Invalid API response " + apiResponse.statusCode);
		}
	}
	
	@When("^I call POST cases for courthouse \"([^\"]*)\" case_number \"([^\"]*)\"$")
	public void callPostCases(String courthouse, String caseNumber) {
		String json = JsonUtils.buildAddCaseJson(courthouse, caseNumber, "", "", "", "");
		ApiResponse apiResponse = jsonApi.postApi("cases", json);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} API using json body:")
	public void callPostApiWithJsonBody(String endPoint, String docString) {
		ApiResponse apiResponse = jsonApi.postApi(endPoint, Substitutions.substituteValue(docString));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call GET {word} API")
	public void callGetApiWithJsonBody(String endPoint) {
		ApiResponse apiResponse = jsonApi.getApi(Substitutions.substituteValue(endPoint));
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}

// sample cucumber: - - in endpoint is replaced by /, 
//	When I call GET case-search API with query params:
//	| case_number  | courthouse  | courtroom  | judge_name | defendant_name | date_from | date_to | event_text_contains |
//	|              | Leeds		 |            |            |                |           |         |                     |

	@When("^I call GET ([^\"]*) API with query params:$")
	public void callGetApiWithQueryParams(String endpoint, List<Map<String, String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			ApiResponse apiResponse = jsonApi.getApiWithQueryParams(endpoint, map);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
		}
	}

	@When("^I call GET ([^\"]*) API with header \"([^\"]*)\" and query params \"([^\"]*)\"$")
	public void callGetCaseApiWithHeaderAndQueryParams(String endpoint, String headers, String queryParams) {
		ApiResponse apiResponse = jsonApi.getApiWithParams(endpoint, headers, queryParams, "");
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@Then("the API status code is {int}")
	public void verifyStatusCode(int expected) {
		Assertions.assertEquals(String.valueOf(expected), testdata.statusCode, "Invalid status code");
	}
	
	@Then("^the API response contains:$")
	public void verifyApiResponse(String docString) {
		Assertions.assertTrue(testdata.responseString.replaceAll("\\R|\\s", "").contains(docString.replaceAll("\\R|\\s", "")), "Response contents not matched:\r" + testdata.responseString);
	}
	

	
}