package uk.gov.hmcts.darts.automation.tests;

import uk.gov.hmcts.darts.automation.utils.JsonApi;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TestJsonApi {
	private static Logger log = LogManager.getLogger("TestJsonApi");
//	static public Response response;
	
// Following code is for debugging purposes - data may have to be changed each time
// Tests may fail if underlying data is changed
// Commented out code is to allow tests to be run after changes have been made

@Test
	public void test1() {
		System.out.println("Build: " + JsonApi.buildInfo());
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse;
		System.out.println("post: courthouses");
		apiResponse = jsonApi.postApi("courthouses", "{\n"
    			+ "  \"courthouse_name\": \"Auto-test\",\n"
    			+ "  \"code\": 14001\n"
    			+ "}");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
@Test
	public void test2() {
		System.out.println("get: courthouses");
    	JsonApi jsonApi = new JsonApi();
//    	jsonApi.authenticateAsUser("judge");
    	ApiResponse apiResponse = jsonApi.getApi("courthouses");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
@Test
	public void test3() {
		
		System.out.println("put: courthouses");

    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.putApi("courthouses/3", "{\n"
    			+ "  \"courthouse_name\": \"Leeds\",\n"
    			+ "  \"code\": 100\n"
    			+ "}");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
}
@Test
public void test4() {
		System.out.println("get2: courthouses");
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.getApi("courthouses");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
@Test
	public void test5() {

		System.out.println("delete: courthouses");
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.deleteApi("courthouses/2", "{\n"
    			+ "  \"courthouse_name\": \"Leeds\",\n"
    			+ "  \"code\": 100\n"
    			+ "}");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
@Test
	public void test6() {
		System.out.println("get2: courthouses");
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.getApi("courthouses");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
@Test
	public void test7() {
		
		System.out.println("post: events");
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.postApi("events", 	"{"
				+	  "\"message_id\": \"18422\","
				+	  "\"event_id\": \"1\","
				+	  "\"type\": \"1000\","
				+	  "\"sub_type\": \"1002\","
				+	  "\"courthouse\": \"LEEDS\","
				+	  "\"courtroom\": \"ROOM1_LEEDS461\","
				+	  "\"case_numbers\": ["
				+	    "\"174\""
				+	  "],"
				+	  "\"date_time\": \"2023-06-18T08:37:30.945Z\","
				+	  "\"event_text\": \"some event text\""
				+	"}");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("200", apiResponse.statusCode);
	}

@Test
public void test8() {
		System.out.println("get8: audio");
    	JsonApi jsonApi = new JsonApi();
    	ApiResponse apiResponse = jsonApi.getApiWithParams("audio-requests/v2", "user_id=-37", "expired=false", "");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
	}
}