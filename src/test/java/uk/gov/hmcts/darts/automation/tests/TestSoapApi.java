package uk.gov.hmcts.darts.automation.tests;

import uk.gov.hmcts.darts.automation.utils.XmlUtils;
import uk.gov.hmcts.darts.automation.utils.SoapApi;
import uk.gov.hmcts.darts.automation.utils.ApiResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TestSoapApi {
	private static Logger log = LogManager.getLogger("TestSoapApi");
	
// Following code is for debugging purposes - data may have to be changed each time
// Tests may fail if underlying data is changed
// Commented out code is to allow tests to be run after changes have been made

@Test
	public void test1() {
		System.out.println("courtlogs: getCourtLog");
    	SoapApi soapApi = new SoapApi();
    	soapApi.authenticateAsSource("XHIBIT");
		ApiResponse apiResponse = soapApi.postSoap("courtlogs", "        <getCourtLog xmlns=\"http://com.synapps.mojdarts.service.com\">"
				+ "            <courthouse xmlns=\"\">DMP-467-LIVERPOOL</courthouse>"
				+ "            <caseNumber xmlns=\"\">DMP-467-Case001</caseNumber>"
				+ "            <startTime xmlns=\"\">20230811160000</startTime>"
				+ "            <endTime xmlns=\"\">20230930170000</endTime>"
				+ "        </getCourtLog>");
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("200", apiResponse.statusCode);
	}

@Test
	public void test2() {
		System.out.println("addCase");
    	SoapApi soapApi = new SoapApi();
    	soapApi.authenticateAsSource("VIQ");
    	ApiResponse apiResponse = soapApi.postSoap("", "addCase", "        <case type=\"\" id=\"TS-723-AC1-Trial006-TS\">"
				+ "                    <courthouse>DMP-723-LIVERPOOL</courthouse>"
				+ "                    <courtroom>DMP-723-LIVERPOOL-ROOM_A</courtroom>"
				+ "                    <defendants>"
				+ "                        <defendant>DMP-723-AC1-D001</defendant>"
				+ "                        <defendant>DMP-723-AC1-D002</defendant>"
				+ "                    </defendants>"
				+ "                    <judges>"
				+ "                        <judge>DMP-723-AC1-J001</judge>"
				+ "                    </judges>"
				+ "                    <prosecutors>"
				+ "                        <prosecutor>DMP-723-AC1-P001</prosecutor>"
				+ "                    </prosecutors>"
				+ "                </case>", true);
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("200", apiResponse.statusCode);
	}

@Test
	public void test3A() {
		System.out.println("addDocument: addLogEntry 1");
    	SoapApi soapApi = new SoapApi();
    	soapApi.authenticateAsSource("VIQ");

		ApiResponse apiResponse = soapApi.postSoap("", "addLogEntry", "                <log_entry Y=\"2024\" M=\"01\" D=\"09\" H=\"10\" MIN=\"01\" S=\"02\">\r\n"
				+ "                        <courthouse>DMP-467-LIVERPOOL</courthouse>\r\n"
				+ "                        <courtroom>DMP-467-LIVERPOOL-ROOM_A</courtroom>\r\n"
				+ "                        <case_numbers>\r\n"
				+ "                            <case_number>DMP-467-Case011</case_number>\r\n"
				+ "                        </case_numbers>\r\n"
				+ "                        <text>abcdefgh1234567890abcdefgh1234567890abcdefgh1234567890abcdefgh12</text>\r\n"
				+ "                </log_entry>", true);
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("201", apiResponse.statusCode);
	}

@Test
	public void test3B() {
		System.out.println("log_entry: addLogEntry 2");
		SoapApi soapApi = new SoapApi();
		soapApi.authenticateAsSource("VIQ");
	
		ApiResponse apiResponse = soapApi.postSoap("", "addLogEntry", "                &lt;log_entry Y=&quot;2024&quot; M=&quot;01&quot; D=&quot;09&quot; H=&quot;10&quot; MIN=&quot;00&quot; S=&quot;00&quot;&gt;\r\n"
				+ "                        &lt;courthouse&gt;DMP-467-LIVERPOOL&lt;/courthouse&gt;\r\n"
				+ "                        &lt;courtroom&gt;DMP-467-LIVERPOOL-ROOM_A&lt;/courtroom&gt;\r\n"
				+ "                        &lt;case_numbers&gt;\r\n"
				+ "                            &lt;case_number&gt;DMP-467-Case011&lt;/case_number&gt;\r\n"
				+ "                        &lt;/case_numbers&gt;\r\n"
				+ "                        &lt;text&gt;abcdefgh1234567890abcdefgh1234567890abcdefgh1234567890abcdefgh12&lt;/text&gt;\r\n"
				+ "                &lt;/log_entry&gt;", false);
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("201", apiResponse.statusCode);
	}

@Test
	public void test4() {
		System.out.println("addDocument: addDailyList");
		SoapApi soapApi = new SoapApi();
		soapApi.authenticateAsSource("CPP");
	
		ApiResponse apiResponse = soapApi.postSoap("", 
				"addDocument", 
				XmlUtils.buildAddDailyListXml("DARTS_E2E_2024-01-30_auto", 
						"DL", 
						"DL",
						"DL 30/01/24 FINAL v1",
						"xx",
						"room2",
						"T2024009",
						"2024-03-12",
						"10:00:00",
						"2024-03-10",
						"2024-03-10T12:34:45Z",
						"def name",
						"62AA1010646"));
		System.out.println(apiResponse.statusCode + " " + apiResponse.responseString);
		Assertions.assertEquals("200", apiResponse.statusCode);
	}


}