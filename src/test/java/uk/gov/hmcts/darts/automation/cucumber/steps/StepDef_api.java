package uk.gov.hmcts.darts.automation.cucumber.steps;

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
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.Api;
import uk.gov.hmcts.darts.automation.utils.JsonUtils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static org.junit.jupiter.api.Assertions.*;

public class StepDef_api extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_api");
	private static String eventFields = "|message_id|type|sub_type|event_id|courthouse|courtroom|case_numbers|event_text|date_time|case_retention_fixed_policy|case_total_sentence|";
	private Api api;
	
	
	public StepDef_api(SharedDriver driver, TestData testdata, NavigationShared ns) {
		super(driver, testdata, ns);
		api = new Api();
	}
	
	String getValue(Map<String, String> map, String column) {
		if (map.containsKey(column)) {
			return map.get(column);
		} else {
			return "";
		}
	}
	
	String getValue(Map<String, String> map, String column, String defaultValue) {
		if (map.containsKey(column)) {
			String tableValue = map.get(column);
			if (tableValue.isEmpty()) {
				return defaultValue;
			} else {
				return tableValue;
			}
		} else {
			return defaultValue;
		}
	}

	@When("^I call POST events API for id (\\S*) type (\\S*) (\\S*) with \"([^\"]*)\"$")
	public void callEventApi(String id, String type, String subType, String args) throws Exception {
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
		api.postApi("events", json);
	}
	
//	@When("I call POST event API for type {word}")
//	public void callEventApi(String type, List<Map<String, String>> dataTable) {
//		callEventApi(type, "", dataTable);
//	}
	
	@When("I call POST {word} API using json body:")
	public void callPostApiWithJsonBody(String endPoint, String docString) throws Exception {
		api.postApi(endPoint, docString);
	}
	
	@When("I call GET {word} API")
	public void callGetApiWithJsonBody(String endPoint) throws Exception {
		api.getApi(endPoint);
	}
	

	
}