package uk.gov.hmcts.darts.automation.utils;

import io.restassured.http.ContentType;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.http.Cookie;
import io.restassured.http.Cookies;
import io.restassured.response.*;
import static io.restassured.RestAssured.*;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;



public class Api {
	private static Logger log = LogManager.getLogger("Api");
    static Response response;
    String authorization;
	String baseUri = "https://darts-api.staging.platform.hmcts.net/";


	public Api() {
		
	}

    
    public String authenticate() {
    	log.info("authentication");
    	response  = 
    		given()
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
    					"scope", "https://" + ReadProperties.apiAuthPath + "/" + ReadProperties.apiClientId + "/Functional.Test")
    			.baseUri(ReadProperties.apiAuthUri)
    			.basePath(ReadProperties.apiAuthPath)
    			.log().everything()
    		.when()
    			.post("/B2C_1_ropc_darts_signin/oauth2/v2.0/token")
			.then()
				.log().everything()
				.assertThat().statusCode(200)
				.extract().response()
    			;
		String access_token = (response.jsonPath().getString("access_token"));
		String token_type  = (response.jsonPath().getString("token_type"));

//    	System.out.println("post authentication response:");
//    	System.out.println("access_token: " + access_token);
//    	System.out.println("token_type:   " + token_type);
    	return token_type + " " + access_token;
    	
    }

	public void getApi(String endpoint) {

		log.info("get: " + endpoint);
    	authorization = authenticate();
		response =
				given()
						.accept("application/json, text/plain, */*")
						.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
						.header("Accept", "application/json, text/plain, */*")
						.header("Accept-Encoding", "gzip, deflate")
						.header("Connection", "keep-alive")
						.header("Authorization", authorization)
						.baseUri(baseUri)
						.basePath("")
//				.body("1")
						.log().everything()
						.when()
						.get(endpoint)
						.then()
						.log().everything()
						.assertThat().statusCode(200)
						.extract().response();
	}

	public void getApi(String endpoint, Map<String, String> formParams) {

		log.info("get: " + endpoint);
    	authorization = authenticate();
		response =
				given()
						.accept("application/json, text/plain, */*")
						.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
						.header("Accept", "application/json, text/plain, */*")
						.header("Accept-Encoding", "gzip, deflate")
						.header("Connection", "keep-alive")
						.header("Authorization", authorization)
						.baseUri(baseUri)
						.basePath("")
						.formParams(formParams)
						.log().everything()
						.when()
						.get(endpoint)
						.then()
						.log().everything()
						.assertThat().statusCode(200)
						.extract().response();
	}
    
    public void postApi(String endpoint, String body) {

    	log.info("post: " + endpoint);
    	log.info(body);
    	authorization = authenticate();
		response = 
				given()
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
				.log().everything()
				.when()
				.post(endpoint)
			.then()
				.log().everything()
				.assertThat().statusCode(201)
				.extract().response();
    }
    
    public void putApi(String endpoint, String body) {

    	log.info("put: " + endpoint);
    	authorization = authenticate();
		response = 
				given()
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
				.log().everything()
				.when()
				.put(endpoint)
			.then()
				.log().everything()
				.assertThat().statusCode(204)
				.extract().response();
    }
    
    public void deleteApi(String endpoint, String body) {

    	log.info("delete: " + endpoint);
    	authorization = authenticate();
		response = 
				given()
				.accept("application/json, text/plain, */*")
				.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
				.header("Accept", "application/json, text/plain, */*")
				.header("Accept-Encoding", "gzip, deflate")
				.header("Content-Type", "application/json")
				.header("Connection", "keep-alive")
				.header("Authorization", authorization)
				.baseUri(baseUri)
				.basePath("")
				.log().everything()
				.when()
				.delete(endpoint)
			.then()
				.log().everything()
				.assertThat().statusCode(204)
				.extract().response();
    }
    

@Test
	public void test() {
    	Api api = new Api();
//		System.out.println("post: courthouses");
//		api.postApi("courthouses", "{\n"
//    			+ "  \"courthouse_name\": \"Newcastle\",\n"
//    			+ "  \"code\": 400\n"
//    			+ "}");
		System.out.println("get: courthouses");
		api.getApi("courthouses");
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
		api.postApi("events", 	"{"
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