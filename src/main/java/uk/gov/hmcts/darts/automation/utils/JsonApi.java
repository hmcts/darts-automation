package uk.gov.hmcts.darts.automation.utils;

import io.restassured.builder.RequestSpecBuilder;
import io.restassured.builder.ResponseSpecBuilder;
import io.restassured.filter.log.LogDetail;
import io.restassured.http.ContentType;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.http.Cookie;
import io.restassured.http.Cookies;
import io.restassured.response.*;
import io.restassured.specification.RequestSpecification;
import io.restassured.specification.ResponseSpecification;

import static io.restassured.RestAssured.*;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;



public class JsonApi {
	private static Logger log = LogManager.getLogger("JsonApi");
    static Response response;
    String authorization;
	static String baseUri = ReadProperties.main("jsonApiUri");


	public JsonApi() {
		
	}

    public static RequestSpecification requestLogLevel(LogDetail loggingLevel){
        RequestSpecification requestSpec = new RequestSpecBuilder().log(loggingLevel).build();
        return requestSpec;
    }

    public static ResponseSpecification responseLogLevel(LogDetail loggingLevel){
        ResponseSpecification loglevel = new ResponseSpecBuilder().log(loggingLevel).build();
        return loglevel;
    }
    
    public String authenticate() {
    	log.info("authentication");
    	response  = 
    		given()
    			.spec(requestLogLevel(ReadProperties.authRequestLogLevel))
    			.header("Content-Type","application/x-www-form-urlencoded")  
    			.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
    			.header("Accept", "application/json, text/plain, */*")
    			.header("Accept-Encoding", "gzip, deflate, br")
    			.header("X-Requested-With", "XMLHttpRequest")
    			.header("Accept-Language", "en-GB,en;q=0.5")
    			.header("Connection", "keep-alive")
    			.urlEncodingEnabled(true)
    			.formParams("grant_type", "password",
    					"username", ReadProperties.apiUserName,
    					"password", ReadProperties.apiPassword,
    					"client_id", ReadProperties.apiClientId,
    					"scope", "https://" + ReadProperties.main("apiAuthPath") + "/" + ReadProperties.apiClientId + "/Functional.Test")
    			.baseUri(ReadProperties.main("apiAuthUri"))
    			.basePath(ReadProperties.main("apiAuthPath"))
    		.when()
    			.post(ReadProperties.main("apiAuthEndpoint"))
			.then()
				.spec(responseLogLevel(ReadProperties.authResponseLogLevel))
				.assertThat().statusCode(200)
				.extract().response()
    			;
		String access_token = (response.jsonPath().getString("access_token"));
		String token_type  = (response.jsonPath().getString("token_type"));
    	return token_type + " " + access_token;
    	
    }
    
    

	public void getApi(String endpoint) {

    	authorization = authenticate();
		log.info("get: " + endpoint);
		response =
				given()
    				.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
				.body("1")
				.when()
					.get(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.log().everything()
					.assertThat().statusCode(200)
					.extract().response();
	}

	public Response getApiWithFormParams(String endpoint, Map<String, String> formParams) {

    	authorization = authenticate();
		log.info("get: " + endpoint);
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
					.formParams(formParams)
				.when()
					.get(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(200)
					.extract().response();
		return response;
	}

	public Response getApiWithQueryParams(String endpoint, Map<String, String> queryParams) {

    	authorization = authenticate();
		log.info("get: " + endpoint);
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
					.queryParams(queryParams)
				.when()
					.get(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(200)
					.extract().response();
		return response;
	}
    
    public Response postApi(String endpoint, String body) {

    	authorization = authenticate();
    	log.info("post: " + endpoint);
    	log.info(body);
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Content-Type", "application/json")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(body)
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(201)
					.extract().response();
		return response;
    }
    
    public Response putApi(String endpoint, String body) {

    	authorization = authenticate();
    	log.info("put: " + endpoint);
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Content-Type", "application/json")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(body)
				.when()
					.put(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(204)
					.extract().response();
		return response;
    }
    
    public Response deleteApi(String endpoint, String body) {

    	log.info("delete: " + endpoint);
    	authorization = authenticate();
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept("application/json, text/plain, */*")
					.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
					.header("Accept", "application/json, text/plain, */*")
					.header("Accept-Encoding", "gzip, deflate")
					.header("Content-Type", "application/json")
					.header("Connection", "keep-alive")
					.header("Authorization", authorization)
					.baseUri(baseUri)
					.basePath("")
				.when()
					.delete(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(204)
					.extract().response();
		return response;
    }
    

@Test
// Following code is for debugging purposes - data may have to be changed each time
// Tests may fail if underlying data is changed
// Commented out code is to allow tests to be run after changes have been made

	public void test() {
    	JsonApi jsonApi = new JsonApi();
//		System.out.println("post: courthouses");
//		api.postApi("courthouses", "{\n"
//    			+ "  \"courthouse_name\": \"Newcastle\",\n"
//    			+ "  \"code\": 400\n"
//    			+ "}");
		System.out.println("get: courthouses");
		jsonApi.getApi("courthouses");
//		System.out.println("put: courthouses");
//		api.putApi("courthouses/3", "{\n"
//    			+ "  \"courthouse_name\": \"Leeds\",\n"
//    			+ "  \"code\": 100\n"
//    			+ "}");
//		System.out.println("get2: courthouses");
//		api.getApi("courthouses");
//		System.out.println("delete: courthouses");
//		deleteApi("courthouses/2", "{\n"
//    			+ "  \"courthouse_name\": \"Leeds\",\n"
//    			+ "  \"code\": 100\n"
//    			+ "}");
//		System.out.println("get2: courthouses");
//    	getApi("courthouses");
		
		System.out.println("post: events");
		jsonApi.postApi("events", 	"{"
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
	}
}