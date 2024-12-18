package uk.gov.hmcts.darts.automation.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;
import java.net.InetAddress;

import io.restassured.specification.RequestLogSpecification;
import io.restassured.specification.ResponseLogSpecification;
import io.restassured.filter.log.LogDetail;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ReadProperties {
	static String getSystemValue(String name) {
		String value = System.getenv(name);
		if (value != null && !value.equals(name)) {
			return value;
		}
		return System.getProperty(name);
	}
	
	static String emptyIfNull(String string) {
		return string == null ? "" : string;
	}
	
	private static Logger log = LogManager.getLogger("ReadProperties");


	public static String isRunLocal = getSystemValue("RUN_LOCAL");
	
	public static boolean runLocal = isRunLocal != null && isRunLocal.equalsIgnoreCase("true");    
	
	private static String workstationPropertiesParameterFileName = "src/test/resources/workstation.properties";
	private static String environmentPropertiesParameterFileName = "src/test/resources/environment.properties";
	private static String translationPropertiesParameterFileName = "src/test/resources/translation.properties";
	static Properties workstationProperties = getProperties(workstationPropertiesParameterFileName);
	static Properties environmentProperties = getProperties(environmentPropertiesParameterFileName);
	static Properties translationProperties = getProperties(translationPropertiesParameterFileName);
	public static String os = System.getProperty("os.name").replace(" ", "_"); // .toUpperCase();
	public static String systemEnv = getSystemValue("environment");
	public static String environment = systemEnv == null ? environmentProperties.getProperty("defaultEnv") : systemEnv;

// get azure secrets as environment vars
	public static String apiUserName = getSystemValue("FUNC_TEST_ROPC_USERNAME");
	public static String apiPassword = getSystemValue("FUNC_TEST_ROPC_PASSWORD");
	public static String apiGlobalUserName = getSystemValue("FUNC_TEST_ROPC_GLOBAL_USERNAME");
	public static String apiGlobalPassword = getSystemValue("FUNC_TEST_ROPC_GLOBAL_PASSWORD");
	public static String apiExtClientId = getSystemValue("AAD_B2C_ROPC_CLIENT_ID");
//	public static String apiExtClientIdKey = getSystemValue("AAD_B2C_ROPC_CLIENT_ID_KEY");
//	public static String apiExtClientSecret = getSystemValue("AAD_B2C_ROPC_CLIENT_SECRET_KEY");
	public static String apiExtClientSecret = getSystemValue("AAD_B2C_ROPC_CLIENT_SECRET");
	public static String apiIntClientId = getSystemValue("AAD_CLIENT_ID");
	public static String apiIntTenantId = getSystemValue("AAD_TENANT_ID");
	public static String apiIntClientSecret = getSystemValue("AAD_CLIENT_SECRET");

	public static String apiDbSchema = getSystemValue("DARTS_API_DB_SCHEMA");
//	n.b.  System.getProperty("AZURE_STORAGE_CONNECTION_STRING"); defined but not used
	public static String apiDbUserName = getSystemValue("DARTS_API_DB_USERNAME");
	public static String apiDbPassword = runLocal ? getSystemValue(main("DB_PASSWORD_KEY")) : getSystemValue("DARTS_API_DB_PASSWORD");
	public static String apiDbPort = getSystemValue("DARTS_API_DB_PORT");
	public static String apiDbHost = runLocal ? getSystemValue(main("DB_HOST_KEY")) : getSystemValue("DARTS_API_DB_HOST");
	public static String apiDbDatabase = getSystemValue("DARTS_API_DB_DATABASE");
	public static String automationUserId = getSystemValue("AUTOMATION_USERNAME");
	public static String automationPassword = getSystemValue("AUTOMATION_PASSWORD");

	public static String automationTranscriberUserId = getSystemValue("AUTOMATION_TRANSCRIBER_USERNAME");
	public static String automationTranscriber2UserId = getSystemValue("AUTOMATION_TRANSCRIBER2_USERNAME");
	public static String automationLanguageShopTestUserId = getSystemValue("AUTOMATION_LANGUAGE_SHOP_TEST_USERNAME");
	public static String automationExternalPassword = getSystemValue("AUTOMATION_EXTERNAL_PASSWORD");
	public static String automationJudgeTestUserId = getSystemValue("AUTOMATION_JUDGE_TEST_USERNAME");
	public static String automationRequesterTestUserId = getSystemValue("AUTOMATION_REQUESTER_TEST_USERNAME");
	public static String automationApproverTestUserId = getSystemValue("AUTOMATION_APPROVER_TEST_USERNAME");
	public static String automationAppealCourtTestUserId = getSystemValue("AUTOMATION_APPEAL_COURT_TEST_USERNAME");
	public static String automationInternalUserTestPassword = getSystemValue("AUTOMATION_INTERNAL_PASSWORD");
	public static String automationRequesterApproverTestPassword = getSystemValue("AUTOMATION_REQUESTER_APPROVER_PASSWORD");
	public static String automationRequesterApproverTestUserId = getSystemValue("AUTOMATION_REQUESTER_APPROVER_USERNAME");
	public static String dartsAdminUserName = getSystemValue("DARTS_ADMIN_USERNAME");
	public static String dartsAdmin2UserName = getSystemValue("DARTS_ADMIN2_USERNAME");
	public static String dartsSuperUserUserName = getSystemValue("AUTOMATION_SUPER_USER_USERNAME");

	public static String xhibitUserName = getSystemValue("XHIBIT_USERNAME");
	public static String xhibitPassword = getSystemValue("XHIBIT_PASSWORD");
	public static String cppUserName = getSystemValue("CPP_USERNAME");
	public static String cppPassword = getSystemValue("CPP_PASSWORD");
	public static String darMidTierUserName = getSystemValue("DAR_MID_TIER_USERNAME");
	public static String darMidTierPassword = getSystemValue("DAR_MID_TIER_PASSWORD");
	public static String darPCMidTierUsername = getSystemValue("DAR_PC_MID_TIER_USERNAME");
	public static String darPCMidTierPassword = getSystemValue("DAR_PC_MID_TIER_PASSWORD");
	public static String darPCUsername = getSystemValue("DAR_PC_USERNAME");
	public static String darPCPassword = getSystemValue("DAR_PC_PASSWORD");
// new credentials 2024-02-26
	public static String cpExternalUserName = getSystemValue("CP_EXTERNAL_USERNAME");
	public static String cpExternalPassword = getSystemValue("CP_EXTERNAL_PASSWORD");
	public static String cpInternalPassword = getSystemValue("CP_INTERNAL_PASSWORD");
	public static String viqExternalUserName = getSystemValue("VIQ_EXTERNAL_USERNAME");
	public static String viqExternalPassword = getSystemValue("VIQ_EXTERNAL_PASSWORD");
	public static String viqInternalPassword = getSystemValue("VIQ_INTERNAL_PASSWORD");
	public static String xhibitExternalUserName = getSystemValue("XHIBIT_EXTERNAL_USERNAME");
	public static String xhibitExternalPassword = getSystemValue("XHIBIT_EXTERNAL_PASSWORD");
	public static String xhibitInternalPassword = getSystemValue("XHIBIT_INTERNAL_PASSWORD");
	
	public static LogDetail setupRequestLogLevel = runLocal ? LogDetail.ALL : LogDetail.URI;
	public static LogDetail setupResponseLogLevel = runLocal ? LogDetail.ALL : LogDetail.STATUS;
	public static LogDetail authRequestLogLevel = runLocal ? LogDetail.ALL : LogDetail.URI;
	public static LogDetail authResponseLogLevel = runLocal ? LogDetail.ALL : LogDetail.STATUS;
	public static LogDetail requestLogLevel = runLocal ? LogDetail.ALL : LogDetail.URI;
	public static LogDetail responseLogLevel = runLocal ? LogDetail.ALL : LogDetail.STATUS;
	
	public static String buildNo = JsonApi.buildInfo();
	
// generate sequence number for dynamic data {{seq}}
// if runLocal, if seq is set in system parameters, use that, otherwise use seq from testdata.properties prefixed by seq_prefix
// if not run_local, use build no from build info prefixed by remote_prefix from environment.properties
	
//	public static String seq = runLocal ? ((getSystemValue("seq") == null) ? emptyIfNull(getSystemValue("seq_prefix")) + TestData.getNextSeqNo() : getSystemValue("seq")) : main("remote_prefix") + buildNo.substring(buildNo.length() - 4);
	public static String seq = runLocal ? ((getSystemValue("seq") == null) ? emptyIfNull(getSystemValue("seq_prefix")) + TestData.getNextSeqNo() : getSystemValue("seq")) : main("remote_prefix") + DateUtils.runNoFromDate();
			 
	private static int instanceCount = 0;
    
	static {
		log.info("OS =>" + os);
		if (systemEnv == null) {
			log.info("Using default environment >"+environment);
		} else {
			log.info("Using system environment >"+systemEnv);
		}
		log.info("Instance count: " + ++instanceCount);
	}
	
	static Properties getProperties(String parameterFileName) {
		Properties prop = new Properties();
		
		File file = new File(parameterFileName);
		FileInputStream inStream = null;
		
		try {
			inStream = new FileInputStream(file);
			try {
				prop.load(inStream);
				inStream.close();
				return prop;
			} catch (IOException e) {
				log.fatal("Error loading properties >"+parameterFileName);
				e.printStackTrace();
				return null;
			}
		} catch (FileNotFoundException e) {
			log.fatal("Error loading properties file >"+parameterFileName);
			e.printStackTrace();
			return null;
		}
		
	}
	
	static String getProperty(String property, Properties properties, String parameterFileName) {
		try {
			String returnValue = properties.getProperty(property);
			log.info("Returned property >"+property+"< value >"+returnValue);
			return returnValue;
		} catch (Exception e) {
			log.fatal("Error accessing properties >"+parameterFileName+"< for property >"+property);
			e.printStackTrace();
			return null;
		}
	}
	
// Where we have a version we will only have it for a particular OS
	public static String machine(String property, String version) {
		try {
			String returnValue = workstationProperties.getProperty(os+"_"+property+"_"+version);
			if (returnValue != null) {
				log.info("Returned OS >"+os+"< property >"+property+"< version >"+version+"< value >"+returnValue);
				return returnValue;
			} else {
				log.info("Property >"+property+"< NOT FOUND (null) for OS >"+os+"< version >"+version);
				return getProperty(os+"_"+property, workstationProperties, workstationPropertiesParameterFileName);
			}
		} catch (Exception e) {
			log.info("Property >"+property+"< NOT FOUND (exception) for OS >"+os+"< version >"+version);
			return getProperty(os+"_"+property, workstationProperties, workstationPropertiesParameterFileName);
		}
	}
	
	public static String machine(String property) {
		log.info("Accessing property: " + property + ", OS =>" + os);
		String returnValue = getSystemValue(property);
		if (returnValue != null) {
			log.info("Override value provided for property " + property + ": " + returnValue);
			return returnValue;
		} else {
			try {
				returnValue = workstationProperties.getProperty(os+"_"+property);
				if (returnValue != null) {
					log.info("Returned OS >"+os+"< property >"+property+"< value >"+returnValue);
					return returnValue;
				} else {
					log.info("Property >"+property+"< NOT FOUND (null) for OS >"+os);
					return getProperty(property, workstationProperties, workstationPropertiesParameterFileName);
				}
			} catch (Exception e) {
				log.info("Property >"+property+"< NOT FOUND (exception) for OS >"+os);
				return getProperty(property, workstationProperties, workstationPropertiesParameterFileName);
			}
		}
	}
	
	public static String main(String property) {
		log.info("Accessing property: " + property + " environment: " + environment);
		String returnValue = getSystemValue(property);
		if (returnValue != null) {
			log.info("Override value provided for property " + property + ": " + returnValue);
			return returnValue;
		} else {
			try {
				returnValue = environmentProperties.getProperty(property+"_"+environment);
				if (returnValue != null) {
					log.info("Returned environment >"+environment+"< property >"+property+"< value >"+returnValue);
					return returnValue;
				} else {
					log.info("Property >"+property+"< NOT FOUND (null) for environment >"+environment);
					return getProperty(property, environmentProperties, environmentPropertiesParameterFileName);
				}
			} catch (Exception e) {
				log.info("Property >"+property+"< NOT FOUND (exception) for environment >"+environment);
				return getProperty(property, environmentProperties, environmentPropertiesParameterFileName);
			}
		}
	}
	
	public static boolean feature(String property) {
		try {
			String returnValue = environmentProperties.getProperty(environment+"_feature_"+property);
			if (returnValue != null) {
				log.info("Returned environment >"+environment+"< property >"+property+"< value >"+returnValue);
				return returnValue.equals("1") || returnValue.equalsIgnoreCase("Y");
			} else {
				log.info("Property >"+environmentProperties+"< NOT FOUND (null) for environment >"+environment);
				try {
					returnValue = getProperty("feature_" + property, environmentProperties, environmentPropertiesParameterFileName);
					log.info("Returned property >"+property+"< value >"+returnValue);
					return returnValue.equals("1") || returnValue.equalsIgnoreCase("Y");
				} catch (Exception e1) {
					return false;
				}
			}
		} catch (Exception e) {
			log.info("Property >"+property+"< NOT FOUND (exception) for environment >"+environment);
			try {
				String returnValue =  getProperty("feature_" + property, environmentProperties, environmentPropertiesParameterFileName);
				log.info("Returned property >"+property+"< value >"+returnValue);
				return returnValue.equals("1") || returnValue.equalsIgnoreCase("Y");
			} catch (Exception e1) {
				return false;
			}
		}
	}
	
	public static String translation(String input) {
		try {
			String returnValue = translationProperties.getProperty(environment+"_"+input.trim());
			if (returnValue != null) {
				log.info("Returned environment >"+environment+"< Translation for input >"+input+"< value >"+returnValue);
				return returnValue;
			} else {
				log.info("Translation for input >"+input+"< NOT FOUND (null) for environment >"+environment);
				returnValue = getProperty(input, translationProperties, translationPropertiesParameterFileName);
				if (returnValue != null) {
					return returnValue;
				} else {
					return "";
				}
			}
		} catch (Exception e) {
			log.info("Translation for input >"+input+"< NOT FOUND (exception) for environment >"+environment);
			try {
				String returnValue = getProperty(input, translationProperties, translationPropertiesParameterFileName);
				if (returnValue != null) {
					return returnValue;
				} else {
					return "";
				}
			} catch (Exception e1) {
				return "";
			}
		}
	}
	
	public static String env() {
		if (systemEnv != null) {
			log.info("Using system environment >"+systemEnv);
			return systemEnv;
		}
		String defEnv = main("defaultEnv");
		log.info("Using default environment >"+defEnv);
		return defEnv;
	}
	
	/**
	 * Late addition - This checks to make sure we are returning the IP appropriate to the env under test by System Env
	 * @param default_env
	 * @return
	 */
	public static String getEnvIP() {
		return main("IP");
	}
	
	public static String getHostProperty(String property) {
		try {
			String returnValue = workstationProperties.getProperty(os+"_"+getHostname()+"_"+property);
			if (returnValue != null) {
				log.info("Returned OS >"+os+"< Host >"+getHostname()+"< property >"+property+"< value >"+returnValue);
				return returnValue;
			} else {
				log.info("host specific property not found - continuing with OS"+os+"< Host >"+getHostname()+"< property >"+property);
				try {
					return machine(property);
				} catch (Exception e) {
					return null;
				}
			}
		} catch (Exception e) {
			log.info("Property >"+property+"< NOT FOUND (exception) for OS >"+os+" Host "+getHostname());
			return machine(property);
		}
	}
	
	public static String getHostname() {
		//      NOTE -- InetAddress.getLocalHost().getHostName() will not work in certain environments.
		String host = null;
		try {
		    host = InetAddress.getLocalHost().getHostName();
		} catch (Exception e) {
			// try environment properties.
			host = System.getenv("COMPUTERNAME");
			if (host == null)
				host = System.getenv("HOSTNAME");
		}
		if (host != null) {
		    log.info("hostname: =>"+host);
		    host = host.toUpperCase();
		}
		return host;
		
	}

	public static String getDownloadFilepath() {
		String current_directory = System.getProperty("user.dir");
		
		if (current_directory.contains("/"))
			return current_directory+"/resources/download";
		
		return current_directory+"\\resources\\download";
	}

	public static String getUploadFilepath() {
		String current_directory = System.getProperty("user.dir");

		if (current_directory.contains("/"))
			return current_directory+"/src/test/resources/testdata/";

		return current_directory+"\\src\\test\\resources\\testdata\\";
	}
	
}