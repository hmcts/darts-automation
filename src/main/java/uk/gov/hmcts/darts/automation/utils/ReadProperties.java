package uk.gov.hmcts.darts.automation.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;
import java.net.InetAddress;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ReadProperties {
	private static Logger log = LogManager.getLogger("ReadProperties");
	private static String workstationPropertiesParameterFileName = "src/test/resources/workstation.properties";
	private static String environmentPropertiesParameterFileName = "src/test/resources/environment.properties";
	private static String translationPropertiesParameterFileName = "src/test/resources/translation.properties";
	static Properties workstationProperties = getProperties(workstationPropertiesParameterFileName);
	static Properties environmentProperties = getProperties(environmentPropertiesParameterFileName);
	static Properties translationProperties = getProperties(translationPropertiesParameterFileName);
	static String os = System.getProperty("os.name").replace(" ", "_");
	static String systemEnv = System.getProperty("envName");
	static String environment = systemEnv;
	static {
		log.info("OS =>" + os);
		if (systemEnv == null) {
			environment = environmentProperties.getProperty("defaultEnv");
			log.info("Using default environment >"+environment);
		} else {
			log.info("Using system environment >"+systemEnv);
		}
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
//				throw(e);
				return null;
			}
		} catch (FileNotFoundException e) {
			log.fatal("Error loading properties file >"+parameterFileName);
			e.printStackTrace();
//			throw(e);
			return null;
		}
		
	}
	
	static String getProperty(String property, Properties properties, String parameterFileName) {
		try {
			String returnValue = properties.getProperty(property);
			log.info("Returned property >"+property+"< value >"+returnValue);
			return returnValue;
		} catch (Exception e) {
			log.fatal("Error loading properties >"+parameterFileName+"< for property >"+property);
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
		log.info("OS =>" + os);
		try {
			String returnValue = workstationProperties.getProperty(os+"_"+property);
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
	
	public static String main(String property) {
		log.info("environment: " + environment);
		try {
			String returnValue = environmentProperties.getProperty(environment+"_"+property);
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
				return getProperty("feature_" + property, environmentProperties, environmentPropertiesParameterFileName).equals("1");
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
	
}