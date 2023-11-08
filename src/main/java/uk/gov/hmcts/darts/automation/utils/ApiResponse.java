package uk.gov.hmcts.darts.automation.utils;

public class ApiResponse {
	public String statusCode = "";
	public String responseString = "";
	
	public ApiResponse(int statusCode, String responseString) {
		this.responseString = responseString;
		this.statusCode = String.valueOf(statusCode);
	}
	
	public ApiResponse(String statusCode, String responseString) {
		this.responseString = responseString;
		this.statusCode = statusCode;
	}

	public ApiResponse(int statusCode) {
		this.responseString = "";
		this.statusCode = String.valueOf(statusCode);
	}

	public ApiResponse() {
		this.responseString = "";
		this.statusCode = "";
	}
}
