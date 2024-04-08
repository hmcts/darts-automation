package uk.gov.hmcts.darts.automation.utils;

import io.restassured.builder.MultiPartSpecBuilder;
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
import static org.hamcrest.Matchers.*;

import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.time.Duration;
import java.util.List;

import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;


public class SoapApi {
	private static Logger log = LogManager.getLogger("SoapApi");
    static Response response;
	String authorizationToken;
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
	static final String CONTENT_TRANSFER_ENCODING = "Content-Transfer-Encoding";
	static final String CONTENT_ID = "Content-ID";
	String username = "";
	String soapPassword = "";
	String tokenPassword = "";
	String defaultSource = "XHIBIT";
	String suppliedSource = "";
	boolean useToken;


	public SoapApi() {
		this("XHIBIT");
	}
	
	public SoapApi(String defaultSource) {
		this.defaultSource = defaultSource;
	}

    public RequestSpecification requestLogLevel(LogDetail loggingLevel){
        RequestSpecification requestSpec = new RequestSpecBuilder().log(loggingLevel).build();
        return requestSpec;
    }

    public ResponseSpecification responseLogLevel(LogDetail loggingLevel){
        ResponseSpecification loglevel = new ResponseSpecBuilder().log(loggingLevel).build();
        return loglevel;
    }
    
    public void setDefaultSource(String source) {
    	if (!this.defaultSource.equalsIgnoreCase(source)) {
    		this.defaultSource = source;
    		authorizationToken = "";
    	}
    }

// it is possible that all but XHIBIT, CPP & VIQ are invalid
    public void authenticate(String source) {
    	useToken = false;
        switch (source.toUpperCase()) {
        case "EXTERNAL":
        	useToken = true;
        	externalAuthenticate(ReadProperties.apiGlobalUserName, ReadProperties.apiGlobalPassword);
        	break;
        case "XHIBIT":
        	useToken = true;
        	externalAuthenticate(ReadProperties.xhibitExternalUserName, ReadProperties.xhibitInternalPassword, ReadProperties.xhibitExternalPassword);
        	break;
        case "CP":
        case "CPP":
        	useToken = true;
        	externalAuthenticate(ReadProperties.cpExternalUserName, ReadProperties.cpInternalPassword, ReadProperties.cpExternalPassword);
        	break;
        case "DARMIDTIER":
        	externalAuthenticate(ReadProperties.darMidTierUserName, ReadProperties.darMidTierPassword);
        	break;
        case "DARPCMIDTIER":
        	externalAuthenticate(ReadProperties.darPCMidTierUsername, ReadProperties.darPCMidTierPassword);
        	break;
        case "DARPC":
        	externalAuthenticate(ReadProperties.darPCUsername, ReadProperties.darPCPassword);
        	break;
        case "VIQ":
        	externalAuthenticate(ReadProperties.viqExternalUserName, ReadProperties.viqInternalPassword, ReadProperties.viqExternalPassword);
        	break;
        case "":
        	log.warn("Authentication - no role provided - using default");
        	externalAuthenticate();
        	break;
        default:
            log.fatal("Unknown user type - {}"+ source);
            authorizationToken = "";
        }
    }
    
    public void authenticateAsSource(String source) {
    	suppliedSource = source;
    	authenticate(source);
    }
    
    public void externalAuthenticate() {
    	authenticate(defaultSource);
    }
   
// unsure whether it is valid to use the ids with only 1 password or whether this should use soap or json
    public void externalAuthenticate(String username, String password) {
    	this.username = username;
    	this.tokenPassword = password;
    	this.soapPassword = password;
//    	authenticate(username, password);
    	registerUser(username, soapPassword);
    }
    
    public void externalAuthenticate(String username, String tokenPassword, String soapPassword) {
    	this.username = username;
    	this.tokenPassword = tokenPassword;
    	this.soapPassword = soapPassword;
//    	authenticate(username, tokenPassword);
    	if (useToken) {
    	  registerUser(username, soapPassword);
    	} else {
    		authorizationToken = "No token";
      }
    }
    
    public void authenticate() {
    	boolean alreadyAuthenticated = !(authorizationToken == null || authorizationToken.isBlank());
    	log.info(alreadyAuthenticated ? "already Authenticated" : "Not already Authenticated");
    	if (!alreadyAuthenticated) {
    		externalAuthenticate();
    	} else {
// always authenticate with default for this call unless explicitly authenticated
    		if (suppliedSource.isBlank()) {
    			externalAuthenticate();
    		}
    	}
    }
	
    public void registerUser(String username, String password) {
    	log.info("registerUser");
    	String authXml = "<S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    			+ "   <S:Header>\n"
    			+ "      <ServiceContext token=\"temporary/127.0.0.1-1700061962100--7690714146928305881\" xmlns=\"http://context.core.datamodel.fs.documentum.emc.com/\" xmlns:ns2=\"http://properties.core.datamodel.fs.documentum.emc.com/\" xmlns:ns3=\"http://profiles.core.datamodel.fs.documentum.emc.com/\" xmlns:ns4=\"http://query.core.datamodel.fs.documentum.emc.com/\" xmlns:ns5=\"http://content.core.datamodel.fs.documentum.emc.com/\" xmlns:ns6=\"http://core.datamodel.fs.documentum.emc.com/\">\n"
    			+ "         <Identities password=\"" + password + "\" repositoryName=\"moj_darts\" userName=\"" + username + "\" xsi:type=\"RepositoryIdentity\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"></Identities>\n"
    			+ "         <Profiles allowAsyncContentTransfer=\"false\" allowCachedContentTransfer=\"false\" isProcessOLELinks=\"false\" transferMode=\"MTOM\" xsi:type=\"ns3:ContentTransferProfile\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"></Profiles>\n"
    			+ "      </ServiceContext>\n"
    			+ "   </S:Header>\n"
    			+ "   <S:Body>\n"
    			+ "      <ns8:register xmlns:ns8=\"http://services.rt.fs.documentum.emc.com/\" xmlns:ns7=\"http://core.datamodel.fs.documentum.emc.com/\" xmlns:ns6=\"http://content.core.datamodel.fs.documentum.emc.com/\" xmlns:ns5=\"http://query.core.datamodel.fs.documentum.emc.com/\" xmlns:ns4=\"http://profiles.core.datamodel.fs.documentum.emc.com/\" xmlns:ns3=\"http://properties.core.datamodel.fs.documentum.emc.com/\" xmlns:ns2=\"http://context.core.datamodel.fs.documentum.emc.com/\">\n"
    			+ "         <context>\n"
    			+ "            <ns2:Identities xsi:type=\"ns2:RepositoryIdentity\" repositoryName=\"moj_darts\" password=\"" + password + "\" userName=\"" + username + "\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"></ns2:Identities>\n"
    			+ "            <ns2:Profiles xsi:type=\"ns4:ContentTransferProfile\" isProcessOLELinks=\"false\" allowAsyncContentTransfer=\"false\" allowCachedContentTransfer=\"false\" transferMode=\"MTOM\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"></ns2:Profiles>\n"
    			+ "         </context>\n"
    			+ "         <host>" + baseUri + "</host>\n"
    			+ "      </ns8:register>\n"
    			+ "   </S:Body>\n"
    			+ "</S:Envelope>\n";
    	response  = 
    		given()
				.spec(requestLogLevel(ReadProperties.authRequestLogLevel))
				.accept(ACCEPT_XML_STRING)
				.header(USER_AGENT, USER_AGENT_STRING) 
				.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
				.header(CONNECTION, CONNECTION_STRING)
				.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
    			.header("X-Requested-With", "XMLHttpRequest")
    			.header("Accept-Language", "en-GB,en;q=0.5")
    			.urlEncodingEnabled(true)
    			.baseUri(baseUri)
    			.body(authXml)
    		.when()
    			.post()
			.then()
				.spec(responseLogLevel(ReadProperties.authResponseLogLevel))
				.assertThat().statusCode(200)
				.extract().response()
    			;
    	String access_token = response.asString().split("<return>")[1].split("</return>")[0];
    	authorizationToken = access_token;
    }

// this is the previous method of generating a token and MAY be obsolete
    public void authenticate(String username, String password, Object preventCompile) {
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
    					"client_id", ReadProperties.apiExtClientId,
    					"client_secret", ReadProperties.apiExtClientSecret,
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
		authorizationToken = token_type + " " + access_token;
    }

    /*
     * Post soap message to endpoint without SOAPAction header
     * 
     * Authorisation header & body tags are added
     * 
     */
    public ApiResponse postSoap(String endpoint, String body) {

		log.info("post soap request: " + endpoint);
    	authenticate();
		response = 
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
//					.header(AUTHORIZATION, authorizationToken)
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

    /*
     * Post soap message to endpoint WITH SOAPAction header
     * 
     * Authorisation header body & document tags are added
     * 
     * Document can optionally be htmlEncoded
     * 
     */
	public ApiResponse postSoap(String endpoint, String soapAction, String body, boolean htmlEncoded) {

		log.info("post soap request - SOAPAction: " + soapAction);
    	authenticate();
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
//					.header(AUTHORIZATION, authorizationToken)
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


    /*
     * Post soap message to endpoint WITH SOAPAction header
     * 
     * Authorisation header & body tags are added but Document is NOT
     * 
     */
	public ApiResponse postSoap(String endpoint, String soapAction, String body) {

		log.info("post soap request - SOAPAction: " + soapAction);
    	authenticate();
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
	    			.header(CONTENT_TYPE, CONTENT_TYPE_TEXT_XML)
//					.header(AUTHORIZATION, authorizationToken)
					.header(SOAP_ACTION, soapAction)
					.baseUri(baseUri)
					.basePath("")
					.body(addSoapHeader(soapAction, body))
				.when()
					.post(endpoint)
				.then()
					.spec(responseLogLevel(ReadProperties.responseLogLevel))
					.assertThat().statusCode(200)
					.extract().response();
		return new ApiResponse(extractValue(response.asString(), "code"), response.asString());
	}

	public ApiResponse postSoapWithAudio(String endpoint, String soapAction, String body, String audioFileName) {

		log.info("post soap request - SOAPAction: " + soapAction);
    	authenticate();
		response =
				given()
					.spec(requestLogLevel(ReadProperties.requestLogLevel))
					.accept(ACCEPT_XML_STRING)
	    			.header(USER_AGENT, USER_AGENT_STRING) 
	    			.header(ACCEPT_ENCODING, ACCEPT_ENCODING_STRING)
	    			.header(CONNECTION, CONNECTION_STRING)
					.header("Content-Type", "multipart/related; type=\"application/xop+xml\"; start=\"document\"; start-info=\"text/xml\"")
					.header(SOAP_ACTION, soapAction)
					.baseUri(baseUri)
					.basePath("")
					.multiPart(new MultiPartSpecBuilder(addSoapHeader(body))
							.header(CONTENT_TYPE, "application/xop+xml; charset=UTF-8; type=\"text/xml\"")
							.header(CONTENT_TRANSFER_ENCODING, "8bit")
							.header(CONTENT_ID, "document")
							.controlName("document")
							.mimeType("text/xml")
							.build())
					.multiPart(new MultiPartSpecBuilder(new File(ReadProperties.main("audioFileLocation") + audioFileName + (audioFileName.endsWith(".mp2") ? "" : ".mp2")))
							.header(CONTENT_TYPE, "application/octet-stream")
							.header(CONTENT_TRANSFER_ENCODING, "binary")
							.header(CONTENT_ID, "<" + audioFileName + ">")
							.header("Content-Disposition", "attachment; name=\"" + audioFileName + "\"")
							.controlName("<" + audioFileName + ">")
							.mimeType("audio/mp2")
							.fileName(audioFileName)
							.build())
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
	
	String addSoapAuthHeader() {
		if (useToken) {
			return addSoapAuthHeaderToken();
		} else {
			return addSoapAuthHeaderUser();
		}
	}
	
	String addSoapAuthHeaderUser() {
		return  "  <soap:Header>\n"
				+ "    <ServiceContext token=\"temporary/127.0.0.1-1694086218480-789961425\" xmlns=\"http://context.core.datamodel.fs.documentum.emc.com/\">\n"
				+ "      <Identities xsi:type=\"RepositoryIdentity\" userName=\"" + username + "\" password=\"" + soapPassword + "\" repositoryName=\"moj_darts\" domain=\"\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"/>\n"
				+ "      <RuntimeProperties/>\n"
				+ "    </ServiceContext>\n"
				+ "  </soap:Header>";
	}
	
	String addSoapAuthHeaderToken() {
		return  "  <soap:Header>\n"
				+ "      <wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\"><wsse:BinarySecurityToken QualificationValueType=\"http://schemas.emc.com/documentum#ResourceAccessToken\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"RAD\">" + authorizationToken + "</wsse:BinarySecurityToken></wsse:Security>\n"
				+ "  </soap:Header>";
	}

	String addSoapHeader(String soapBody) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ addSoapAuthHeader()
				+ "    <soap:Body>"
				+ soapBody
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}

	String addSoapHeader(String soapAction, String soapBody) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ addSoapAuthHeader()
				+ "    <soap:Body>"
				+ "        <ns5:" + soapAction + " xmlns:ns5=\"http://com.synapps.mojdarts.service.com\">"
				+ soapBody
				+ "        </ns5:" + soapAction + ">"
				+ "    </soap:Body>"
				+ "</soap:Envelope>";
	}

	String addSoapHeader(String soapAction, String soapBody, boolean htmlEncoded) {
		return "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
				+ "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
				+ addSoapAuthHeader()
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
	
	public ApiResponse postSoapXmlFile(String endpoint, String soapAction, String filename) {
		return postSoap(endpoint, soapAction, TestData.readTextFile(filename));
	}
	
	public ApiResponse postSoapBinaryFile(String endpoint, String soapAction, String filename) {
//TODO replace file with contents
		return postSoap(endpoint, soapAction, filename, false);
	}
			

}