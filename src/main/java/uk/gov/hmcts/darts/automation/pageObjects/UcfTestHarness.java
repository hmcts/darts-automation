package uk.gov.hmcts.darts.automation.pageObjects;

import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import com.jayway.jsonpath.*;

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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import uk.gov.hmcts.darts.automation.utils.*;

public class UcfTestHarness {
    private static Logger log = LogManager.getLogger("UcfTestHarness");

    private JsonApi jsonApi;

	private static int AUDIO_WAIT_TIME_IN_SECONDS = 900;
    static Response response;

	String ucfTestHarnessUri = ReadProperties.main("ucfUri");
	String username = ReadProperties.viqExternalUserName;
	String password = ReadProperties.viqExternalPassword;
	String destinationUrl = ReadProperties.main("ucfDestinationUrl");;

    public UcfTestHarness() {
    	jsonApi = new JsonApi();
    }

    static public RequestSpecification requestLogLevel(LogDetail loggingLevel){
        RequestSpecification requestSpec = new RequestSpecBuilder().log(loggingLevel).build();
        return requestSpec;
    }

    static public ResponseSpecification responseLogLevel(LogDetail loggingLevel){
        ResponseSpecification loglevel = new ResponseSpecBuilder().log(loggingLevel).build();
        return loglevel;
    }
    
    public ApiResponse postUcfTestHarnessApi(String body) {

		log.info("post: ucfTestHarness");
		response = 
				given()
				.spec(requestLogLevel(ReadProperties.requestLogLevel))
				.accept("application/json, text/plain, */*")
				.header("User-Agent","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:89.0) Gecko/20100101 Firefox/89.0") 
				.header("Accept", "application/json, text/plain, */*")
				.header("Accept-Encoding", "gzip, deflate")
				.header("Content-Type", "application/json")
				.header("Connection", "keep-alive")
				.baseUri(ucfTestHarnessUri)
//				.basePath("")
				.body(body)
				.when()
				.post()
			.then()
				.spec(responseLogLevel(ReadProperties.authResponseLogLevel))
				.assertThat().statusCode(200)
				.extract().response();
		return new ApiResponse(response.statusCode(), response.asString());
    }
    
    public ApiResponse addAudioUsingUcfTestHarness(String courthouse,
		String courtroom,
		String caseNumbers,
		String startDateTime,
		String endDateTime)  {
    	log.info("Calling UCF Test harness for {} {} {} {} {}", courthouse, courtroom, caseNumbers, startDateTime, endDateTime);
		return postUcfTestHarnessApi("{\n"
				+ "  \"destinationUrl\": \"" + destinationUrl + "\",\n"
				+ "  \"username\": \"" + username + "\",\n"
				+ "  \"password\": \"" + password + "\",\n"
				+ "  \"transferFormat\": \"UCF\",\n"
				+ "  \"audioFiles\": [\n"
				+ "    {\n"
				+ "      \"startDate\": \"" + startDateTime + "\",\n"
				+ "      \"endDate\": \"" + endDateTime + "\",\n"
				+ "      \"channel\": \"1\",\n"
				+ "      \"maxChannels\": \"1\",\n"
				+ "      \"courthouse\": \"" + courthouse + "\",\n"
				+ "      \"courtroom\": \"" + courtroom + "\",\n"
				+ "      \"mediaFormat\": \"mp2\",\n"
				+ "      \"fileSizeMultiplier\": 1,\n"
				+ "      \"caseNumbers\": [\n"
				+ "        \"" + caseNumbers + "\"\n"
				+ "      ]\n"
				+ "    }\n"
				+ "  ]\n"
				+ "}");
	}
}