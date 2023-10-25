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

	@When("^I call POST events API for id (\\S*) type (\\S*) (\\S*) with \"([^\"]*)\"$")
	public void callPostEventApi(String id, String type, String subType, String args) throws Exception {
		testdata.setProperty("message_id", id);
		testdata.setProperty("type", type);
		testdata.setProperty("sub_type", subType);
		testdata.parseArgument(args, eventFields);
		String json = JsonUtils.buildEventJson(testdata.getProperty("message_id"),
				testdata.getProperty("type"),
				testdata.getProperty("sub_type"),
				testdata.getProperty("event_id"),
				testdata.getProperty("courthouse"),
				testdata.getProperty("courtroom"),
				testdata.getProperty("case_numbers"),
				testdata.getProperty("event_text"),
				testdata.getProperty("date_time"),
				testdata.getProperty("case_retention_fixed_policy"),
				testdata.getProperty("case_total_sentence"));
		ApiResponse apiResponse = jsonApi.postApi("events", json);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
// sample cucumber:
// When I create event
// |message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|
	@When("^I create an event$")
	public void createEventJson(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String json = JsonUtils.buildEventJson(
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
					getValue(map, "case_total_sentence", testdata.getProperty("case_total_sentence")));
			ApiResponse apiResponse = jsonApi.postApi("events", json);
			Assertions.assertEquals(apiResponse.statusCode, "201", "Invalid API response " + apiResponse.statusCode);
		}
	}
	
// sample cucumber:
// When I create a case
// |courthouse|case_number|defendants|judges|prosecutors|defenders|
	@When("^I create a case$")
	public void createCaseJson(List<Map<String,String>> dataTable) {
		for (Map<String, String> map : dataTable) {
			String json = JsonUtils.buildCaseJson(
					getValue(map, "courthouse"),
					getValue(map, "case_number"),
					getValue(map, "defendants"),
					getValue(map, "judges"),
					getValue(map, "prosecutors"),
					getValue(map, "defenders"));
			ApiResponse apiResponse = jsonApi.postApi("cases", json);
			Assertions.assertEquals(apiResponse.statusCode, "201", "Invalid API response " + apiResponse.statusCode);
		}
	}
	
	@When("^I call POST cases for courthouse \"([^\"]*)\" case_number \"([^\"]*)\"$")
	public void callPostCases(String courthouse, String caseNumber) {
		String json = JsonUtils.buildCaseJson(courthouse, caseNumber, "", "", "", "");
		ApiResponse apiResponse = jsonApi.postApi("cases", json);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call POST {word} API using json body:")
	public void callPostApiWithJsonBody(String endPoint, String docString) throws Exception {
		ApiResponse apiResponse = jsonApi.postApi(endPoint, docString);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}
	
	@When("I call GET {word} API")
	public void callGetApiWithJsonBody(String endPoint) throws Exception {
		ApiResponse apiResponse = jsonApi.getApi(endPoint);
		testdata.statusCode = apiResponse.statusCode;
		testdata.responseString = apiResponse.responseString;
	}

// sample cucumber:
//	When I call GET case-hearings API with terms:
//	| case_number  | courthouse  | courtroom  | judge_name | defendant_name | date_from | date_to | event_text_contains |
//	|              | Leeds		 |            |            |                |           |         |                     |

	@When("^I call GET case-hearings API with terms:$")
	public void callGetCaseHearingsApi(List<Map<String, String>> dataTable) throws Exception {
		for (Map<String, String> map : dataTable) {
			map.get("case_number");
			ApiResponse apiResponse = jsonApi.getApiWithQueryParams("cases/search", map);
			testdata.statusCode = apiResponse.statusCode;
			testdata.responseString = apiResponse.responseString;
		}
	}
	
	@Then("the API status code is {int}")
	public void verifyStatusCode(int expected) {
		Assertions.assertEquals(String.valueOf(expected), testdata.statusCode, "Invalid status code");
	}
	
	@Then("^the API response contains:$")
	public void verifyApiResponse(String docString) {
		Assertions.assertTrue(testdata.responseString.contains(docString), "Response contents not matched:\r" + testdata.responseString);
	}
	

	
}