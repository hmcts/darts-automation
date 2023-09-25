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


public class Soap {
	private static Logger log = LogManager.getLogger("Soap");
    static Response response;
    String authorization;
	String baseUri = ReadProperties.main("soapApiUri");


	public Soap() {
		
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
    					"scope", "https://" + ReadProperties.main("apiAuthPath") + "/" + ReadProperties.apiClientId + "/Functional.Test")
    			.baseUri(ReadProperties.main("apiAuthUri"))
    			.basePath(ReadProperties.main("apiAuthPath"))
    			.log().everything()
    		.when()
    			.post(ReadProperties.main("apiAutEndpoint"))
			.then()
				.log().everything()
				.assertThat().statusCode(200)
				.extract().response()
    			;
		String access_token = (response.jsonPath().getString("access_token"));
		String token_type  = (response.jsonPath().getString("token_type"));
    	return token_type + " " + access_token;
    }
    
    public void postSoap(String endpoint, String body) {

		log.info("post soap request: " + endpoint);
    	authorization = authenticate();
		response = 
				given()
				.accept("text/xml, text/plain, */*")
				.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
				.header("Accept", "application/json, text/plain, */*")
				.header("Accept-Encoding", "gzip, deflate")
				.header("Content-Type", "text/xml")
				.header("Connection", "keep-alive")
				.header("Authorization", authorization)
				.baseUri(baseUri)
				.basePath("")
				.body(addSoapHeader(body))
				.log().everything()
				.when()
				.post(endpoint)
			.then()
				.log().everything()
				.assertThat().statusCode(200)
				.extract().response();
    }

	public void postSoap(String endpoint, String soapAction, String body) {

		log.info("post soap request - SOAPAction: " + soapAction);
    	authorization = authenticate();
		response =
				given()
						.accept("text/xml, text/plain, */*")
						.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0")
						.header("Accept", "application/json, text/plain, */*")
						.header("Accept-Encoding", "gzip, deflate")
						.header("Content-Type", "text/xml")
						.header("Connection", "keep-alive")
						.header("Authorization", authorization)
						.header("SOAPAction", soapAction)
						.baseUri(baseUri)
						.basePath("")
						.body(addSoapHeader(soapAction, body))
						.log().everything()
						.when()
						.post()
						.then()
						.log().everything()
						.assertThat().statusCode(200)
						.extract().response();
	}

	String addSoapHeader(String soapBody) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ "    <soap:Body>"
				+ soapBody
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}

	String addSoapHeader(String soapAction, String soapBody) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ "    <soap:Body>"
				+ "        <" + soapAction + " xmlns=\"http://com.synapps.mojdarts.service.com\">"
				+ "            <document xmlns=\"\">"
				+ soapBody
				+ "            </document>"
				+ "        </" + soapAction + ">"
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}

@Test
// Following code is for debugging & may fail if data changes
	public void test() {
    	Soap soap = new Soap();

		log.info("post: courtlogs");
    	soap.postSoap("courtlogs", "        <getCourtLog xmlns=\"http://com.synapps.mojdarts.service.com\">"
				+ "            <courthouse xmlns=\"\">DMP-467-LIVERPOOL</courthouse>"
				+ "            <caseNumber xmlns=\"\">DMP-467-Case001</caseNumber>"
				+ "            <startTime xmlns=\"\">20230811160000</startTime>"
				+ "            <endTime xmlns=\"\">20230930170000</endTime>"
				+ "        </getCourtLog>");
    	

 
	}
			

}