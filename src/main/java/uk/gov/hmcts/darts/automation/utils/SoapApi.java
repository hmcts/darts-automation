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

import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;


public class SoapApi {
	private static Logger log = LogManager.getLogger("SoapApi");
    static Response response;
	static String authorization;
	static String baseUri = ReadProperties.main("soapApiUri");
	
	static final String ACCEPT_JSON_STRING = "application/json, text/plain, */*";
	static final String ACCEPT_XML_STRING = "application/xml, text/xml, text/plain, */*";
	static final String CONTENT_TYPE = "Content-Type";
	static final String CONTENT_TYPE_TEXT_XML = "text/xml";
	static final String USER_AGENT = "User-Agent";
	static final String USER_AGENT_STRING = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0";
	static final String ACCEPT_ENCODING = "Accept-Encoding";
	static final String ACCEPT_ENCODING_STRING = "gzip, deflate";
	static final String CONNECTION = "Connection";
	static final String CONNECTION_STRING = "keep-alive";
	static final String AUTHORIZATION = "Authorization";
	static final String SOAP_ACTION = "SOAPAction";


	public SoapApi() {
		
	}

    public RequestSpecification requestLogLevel(LogDetail loggingLevel){
        RequestSpecification requestSpec = new RequestSpecBuilder().log(loggingLevel).build();
        return requestSpec;
    }

    public ResponseSpecification responseLogLevel(LogDetail loggingLevel){
        ResponseSpecification loglevel = new ResponseSpecBuilder().log(loggingLevel).build();
        return loglevel;
    }
    
    public String authenticate() {
    	log.info("authentication");
    	response  = 
    		given()
    			.spec(requestLogLevel(ReadProperties.authRequestLogLevel))
				.accept(ACCEPT_JSON_STRING)
				.contentType("application/x-www-form-urlencoded") 
    			.header(USER_AGENT, USER_AGENT_STRING) 
    			.header(ACCEPT_ENCODING, "gzip, deflate, br")
    			.header("X-Requested-With", "XMLHttpRequest")
    			.header("Accept-Language", "en-GB,en;q=0.5")
	    		.header(CONNECTION, CONNECTION_STRING)
    			.urlEncodingEnabled(true)
    			.formParams("grant_type", "password",
    					"username", ReadProperties.apiGlobalUserName,
    					"password", ReadProperties.apiGlobalPassword,
    					"client_id", ReadProperties.apiExtClientId,
						"scope", "https://" + ReadProperties.main("apiExtAuthPath") + "/" + ReadProperties.apiExtClientId + "/Functional.Test")
    			.baseUri(ReadProperties.main("apiExtAuthUri"))
    			.basePath(ReadProperties.main("apiExtAuthPath") + ReadProperties.main("apiExtAuthPath2"))
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
    
    public ApiResponse postSoap(String endpoint, String body) {

		log.info("post soap request: " + endpoint);
    	authorization = authenticate();
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(addSoapHeader(body))
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(200)
					.extract().response();
		return new ApiResponse(extractValue(response.asString(), "code"), response.asString());
    }

	public ApiResponse postSoap(String endpoint, String soapAction, String body, boolean htmlEncoded) {

		log.info("post soap request - SOAPAction: " + soapAction);
    	authorization = authenticate();
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
					.header(AUTHORIZATION, authorization)
					.header(SOAP_ACTION, soapAction)
					.baseUri(baseUri)
					.basePath("")
					.body(addSoapHeader(soapAction, body, htmlEncoded))
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(200)
					.extract().response();
		return new ApiResponse(extractValue(response.asString(), "code"), response.asString());
	}
	
	String extractValue(String xml, String tag) {
		String result = "";
		String[] split1 = xml.split("<" + tag + ">");
		if (split1.length > 0) {
			String[] split2 = split1[1].split("</" + tag + ">");
			if (split2.length > 0) {
				result = split2[0];
			}
		}
		return result;
	}

	String addSoapHeader(String soapBody) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ "    <soap:Body>"
				+ soapBody
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}

	String addSoapHeader(String soapAction, String soapBody, boolean htmlEncoded) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ "    <soap:Body>"
				+ "        <" + soapAction + " xmlns=\"http://com.synapps.mojdarts.service.com\">"
				+ "            <document xmlns=\"\">"
				+ ((htmlEncoded) ? encodeEntities(soapBody) : soapBody)
				+ "            </document>"
				+ "        </" + soapAction + ">"
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}
	
	String encodeEntities(String xml) {
		String result;
		if (xml.contains("&lt;")) {
			result = xml;
		} else {
			result = xml.replace("&", "&amp").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apost;");
		}
		return result;	
	}

// Following code is for debugging & may fail if data changes
@Test
	public void test() {
    	SoapApi soapApi = new SoapApi();

		log.info("post: courtlogs");
    	soapApi.postSoap("courtlogs", "        <getCourtLog xmlns=\"http://com.synapps.mojdarts.service.com\">"
				+ "            <courthouse xmlns=\"\">DMP-467-LIVERPOOL</courthouse>"
				+ "            <caseNumber xmlns=\"\">DMP-467-Case001</caseNumber>"
				+ "            <startTime xmlns=\"\">20230811160000</startTime>"
				+ "            <endTime xmlns=\"\">20230930170000</endTime>"
				+ "        </getCourtLog>");
    	

 
	}
			

}