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
import uk.gov.hmcts.darts.automation.model.responses.Info;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.time.Duration;
import java.util.List;

import java.util.HashMap;
import java.util.Map;

import java.io.File;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;



public class JsonApi {
	private static Logger log = LogManager.getLogger("JsonApi");
    static Response response;
    String authorization;
	static String baseUri = ReadProperties.main("jsonApiUri");
	
	static final String ACCEPT_JSON_STRING = "application/json, text/plain, */*";
	static final String CONTENT_TYPE = "Content-Type";
	static final String CONTENT_TYPE_APPLICATION_JSON = "application/json";
	static final String CONTENT_TYPE_MULTIPART_FORM_DATA = "multipart/form-data";
	static final String USER_AGENT = "User-Agent";
	static final String USER_AGENT_STRING = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0";
	static final String ACCEPT_ENCODING = "Accept-Encoding";
	static final String ACCEPT_ENCODING_STRING = "gzip, deflate, br";
	static final String CONNECTION = "Connection";
	static final String CONNECTION_STRING = "keep-alive";
	static final String AUTHORIZATION = "Authorization";
	static Map<String, String> emptyMap = new HashMap<String, String>(); 


	public JsonApi() {
		authorization = "";
	}

    static public RequestSpecification requestLogLevel(LogDetail loggingLevel){
        RequestSpecification requestSpec = new RequestSpecBuilder().log(loggingLevel).build();
        return requestSpec;
    }

    static public ResponseSpecification responseLogLevel(LogDetail loggingLevel){
        ResponseSpecification loglevel = new ResponseSpecBuilder().log(loggingLevel).build();
        return loglevel;
    }
    
    public void authenticateAsUser(String role) {
        switch (role.toUpperCase()) {
        case "EXTERNAL":
        	externalAuthenticate();
        	break;
        case "TRANSCRIBER":
        	externalAuthenticate(ReadProperties.automationTranscriberUserId, ReadProperties.automationExternalPassword);
        	break;
        case "LANGUAGESHOP":
        	externalAuthenticate(ReadProperties.automationLanguageShopTestUserId, ReadProperties.automationExternalPassword);
        	break;
        case "REQUESTER":
        	internalAuthenticate(ReadProperties.automationRequesterTestUserId, ReadProperties.automationInternalUserTestPassword);
        	break;
        case "APPROVER":
        	internalAuthenticate(ReadProperties.automationApproverTestUserId, ReadProperties.automationInternalUserTestPassword);
        	break;
        case "REQUESTERAPPROVER":
        	internalAuthenticate(ReadProperties.automationRequesterApproverTestUserId, ReadProperties.automationRequesterApproverTestPassword);
        	break;
        case "JUDGE":
        	internalAuthenticate(ReadProperties.automationJudgeTestUserId, ReadProperties.automationInternalUserTestPassword);
        	break;
        case "APPEALCOURT":
        	internalAuthenticate(ReadProperties.automationAppealCourtTestUserId, ReadProperties.automationInternalUserTestPassword);
        	break;
        case "ADMIN":
        	externalAuthenticate(ReadProperties.dartsAdminUserName, ReadProperties.automationExternalPassword);
        	break;
        case "ADMIN2":
        	externalAuthenticate(ReadProperties.dartsAdmin2UserName, ReadProperties.automationExternalPassword);
        	break;
        case "SUPERUSER":
        case "SUPER-USER":
        	externalAuthenticate(ReadProperties.dartsSuperUserUserName, ReadProperties.automationExternalPassword);
        	break;
        case "INTERNAL":
        	internalAuthenticate();
        	break;
        case "VIQ":
        	internalAuthenticate(ReadProperties.viqExternalUserName, ReadProperties.viqExternalPassword);
        	break;
        case "XHIBIT":
        	internalAuthenticate(ReadProperties.xhibitExternalUserName, ReadProperties.xhibitExternalPassword);
        	break;
        case "CP":
        case "CPP":
        	internalAuthenticate(ReadProperties.cpExternalUserName, ReadProperties.cpExternalPassword);
        	break;
        case "":
        	log.warn("Authentication - no role provided - using external");
        	externalAuthenticate();
        	break;
        default:
            log.fatal("Unknown user type - {}"+ role.toUpperCase());
            authorization = "";
        }
    }
    
    public void internalAuthenticate() {
    	internalAuthenticate(ReadProperties.apiUserName, ReadProperties.apiPassword);
    }

    public void internalAuthenticate(String username, String password) {
    	authenticate(username, password, 
    			ReadProperties.apiIntClientId, ReadProperties.apiIntClientSecret, 
    			"api://" + ReadProperties.apiIntClientId + "/Functional.Test",
    			ReadProperties.main("apiIntAuthUri"), ReadProperties.apiIntTenantId);
    }
    
    public void externalAuthenticate() {
    	externalAuthenticate(ReadProperties.apiGlobalUserName, ReadProperties.apiGlobalPassword);
    }
    
    public void externalAuthenticate(String username, String password) {
    	authenticate(username, password, 
    			ReadProperties.apiExtClientId, ReadProperties.apiExtClientSecret, 
    			"https://" + ReadProperties.main("apiExtAuthPath") + "/" + ReadProperties.apiExtClientId + "/Functional.Test",
    			ReadProperties.main("apiExtAuthUri"), ReadProperties.main("apiExtAuthPath") + ReadProperties.main("apiExtAuthPath2"));
    }
    
    public void authenticate() {
    	boolean alreadyAuthenticated = !(authorization == null || authorization.isBlank());
    	log.info(alreadyAuthenticated ? "already Authenticated" : "Not already Authenticated");
    	if (!alreadyAuthenticated) {
    		externalAuthenticate();
    	}
    }
    
    public void authenticate(String username, String password,
    		String clientId, String clientSecret, 
    		String scope, 
    		String baseUri, String basePath) {
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
    					"username", username,
    					"password", password,
    					"client_id", clientId,
    					"client_secret", clientSecret,
						"scope", scope)
    			.baseUri(baseUri)
    			.basePath(basePath)
    		.when()
    			.post(ReadProperties.main("apiAuthEndpoint"))
			.then()
				.spec(responseLogLevel(ReadProperties.authResponseLogLevel))
				.assertThat().statusCode(200)
				.extract().response()
    			;
		String access_token = (response.jsonPath().getString("access_token"));
		String token_type  = (response.jsonPath().getString("token_type"));
		authorization = token_type + " " + access_token;
    	
    }
    
    static public String buildInfo() {
		log.info("get: info");
		try {
			String buildString =
					given()
	    				.spec(requestLogLevel(ReadProperties.requestLogLevel))
						.accept(ACCEPT_JSON_STRING)
		    			.header(USER_AGENT, USER_AGENT_STRING) 
		    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
		    			.header(CONNECTION, CONNECTION_STRING)
						.baseUri(baseUri)
						.basePath("")
					.when()
						.get("info")
					.then()
						.spec(responseLogLevel(ReadProperties.responseLogLevel))
						.assertThat().statusCode(200)
						.extract().response()
						.getBody().as(Info.class)
						.build.number;
	    	return buildString;
		} catch(Exception e) {
			log.warn("Info API Failed");
			return "";
		}
    }

	public ApiResponse getApi(String endpoint) {
		return getApiWithParams(endpoint, emptyMap, emptyMap, emptyMap);
	}

	public ApiResponse getApiWithParams(String endpoint, String headers, String queryParams, String formParams) {
		return getApiWithParams(endpoint, stringToMap(headers), stringToMap(queryParams), stringToMap(formParams));
	}

	public ApiResponse getApiWithParams(String endpoint, Map<String, String> headers, Map<String, String> queryParams, Map<String, String> formParams) {

    	authenticate();
		log.info("get: " + endpoint);
		response =
				given()
    				.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
					.header(AUTHORIZATION, authorization)
					.headers(headers)
					.queryParams(queryParams)
					.formParams(formParams)
					.baseUri(baseUri)
					.basePath("")
				.when()
					.get(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		
		return new ApiResponse(response.statusCode(), response.asString());
	}
	
	Map<String, String> stringToMap(String string) {
		Map<String, String> map = new HashMap<String, String>();
		if (string != null && !string.isBlank()) {
			String[] pairs = string.split(",");
			for (String pair : pairs) {
				try {
					String [] values = pair.split("=");
					if (values.length == 2) {
						map.put(values[0], values[1]);
					} else {
						map.put(values[0], "");
						log.info("Empty value in pair {}", pair);
					}
				} catch (Exception e) {
					Assertions.fail("Invalid parameter pair in string to map: " + pair);
				}
			}
		}
		return map;
	}

	public ApiResponse getApiWithQueryParams(String endpoint, Map<String, String> queryParams) {
		return getApiWithParams(endpoint, emptyMap, queryParams, emptyMap);
	}

	public ApiResponse getApiWithFormParams(String endpoint, Map<String, String> formParams) {
		return getApiWithParams(endpoint, emptyMap, emptyMap, formParams);
	}
    
	public ApiResponse postApi(String endpoint, String body) {

    	authenticate();
    	log.info("post: " + endpoint);
    	log.info(body);
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(body)
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
    }


	public ApiResponse postApiWithQueryParams (String endpoint, String queryParams){
			return postApiWithQueryParams(endpoint, stringToMap(queryParams));
		}


	public ApiResponse postApiWithQueryParams(String endpoint, Map<String, String> queryParams) {
		authenticate();
		log.info("post: " + endpoint);
		response =
				given()
						.spec(requestLogLevel(ReadProperties.requestLogLevel))
						.accept(ACCEPT_JSON_STRING)
						.header(USER_AGENT, USER_AGENT_STRING)
						.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
						.header(CONNECTION, CONNECTION_STRING)
						.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
						.header(AUTHORIZATION, authorization)
						.queryParams(queryParams)
						.baseUri(baseUri)
						.basePath("")
						.when()
						.post(endpoint)
						.then()
						.spec(responseLogLevel(ReadProperties.responseLogLevel))
						.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
	}
    
	public ApiResponse putApi(String endpoint, String body) {

    	authenticate();
    	log.info("put: " + endpoint);
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(body)
				.when()
					.put(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
    }

	public ApiResponse patchApi(String endpoint, String body) {

		authenticate();
		log.info("Patch: " + endpoint);
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
					.header(USER_AGENT, USER_AGENT_STRING)
					.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
					.header(CONNECTION, CONNECTION_STRING)
					.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
					.body(body)
					.when()
					.patch(endpoint)
					.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
	}
    
	public ApiResponse deleteApi(String endpoint, String body) {

    	log.info("delete: " + endpoint);
    	authenticate();
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
				.when()
					.delete(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
    }
    
	public ApiResponse postMultipartAudioApi(String endpoint, String body, String filename) {

    	authenticate();
    	log.info("post audio file: " + endpoint + " filename: " + filename);
    	log.info(body);
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_JSON_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
					.header(CONTENT_TYPE, CONTENT_TYPE_MULTIPART_FORM_DATA)
					.header(AUTHORIZATION, authorization)
					.baseUri(baseUri)
					.basePath("")
					.multiPart("file", new File(filename))
					.multiPart("metadata", body, CONTENT_TYPE_APPLICATION_JSON)
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
    }
	
}