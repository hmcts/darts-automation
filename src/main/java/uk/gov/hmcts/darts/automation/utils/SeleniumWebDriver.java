package uk.gov.hmcts.darts.automation.utils;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.UnexpectedAlertBehaviour;
import org.openqa.selenium.Capabilities;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.ie.InternetExplorerOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;



import uk.gov.hmcts.darts.automation.utils.ReadProperties;

@SuppressWarnings("deprecation")
public class SeleniumWebDriver {

	private static Logger log = LogManager.getLogger("SeleniumWebDriver");

	public WebDriver webDriver;

	public static Capabilities capabilities;

	public SeleniumWebDriver() {
		log.info("started");
		String usingDriver = ReadProperties.machine("usingDriver");
		String usingProxy = ReadProperties.machine("usingProxy");
		String runHeadless = ReadProperties.machine("run_Headless");
		log.info("browser =>" + usingDriver);
		String os = System.getProperty("os.name");
		log.info("OS =>" + os);
		switch (usingDriver.toLowerCase()) {
		case "firefox":
			FirefoxOptions firefoxOptions = new FirefoxOptions();
			System.setProperty("webdriver.gecko.driver", ReadProperties.getHostProperty("firefoxDriverLocation"));
			FirefoxProfile firefoxProfile = new FirefoxProfile();
			if (usingProxy.equals("1")) {
				firefoxOptions.addPreference("network.proxy.type", 1);
				firefoxOptions.addPreference("network.proxy.socks", "127.0.0.1");
				firefoxOptions.addPreference("network.proxy.socks_port", 1337);
				firefoxOptions.addPreference("network.proxy.socks_version", 5);
			} else {
				// Assuming no proxy
			}

			if (runHeadless.equalsIgnoreCase("true") || !ReadProperties.runLocal) {	
				firefoxOptions.addArguments("-headless");
			}
			firefoxOptions.setUnhandledPromptBehaviour(UnexpectedAlertBehaviour.IGNORE);
			webDriver = new FirefoxDriver(firefoxOptions);
			webDriver.manage().window().maximize();
			webDriver.manage().window().setSize(new Dimension(1920, 1080));
			break;
		case "ie":
		case "internet explorer":
			InternetExplorerOptions ieOptions = new InternetExplorerOptions();
			System.setProperty("webdriver.ie.driver", ReadProperties.getHostProperty("ieDriverLocation"));
			if (usingProxy.equals("1")) {
				ieOptions.setCapability("network.proxy.type", 1);
				ieOptions.setCapability("network.proxy.socks", "127.0.0.1");
				ieOptions.setCapability("network.proxy.socks_port", 1337);
				ieOptions.setCapability("network.proxy.socks_version", 5);
			} else {
				// Assuming no proxy
			}
			ieOptions.setUnhandledPromptBehaviour(UnexpectedAlertBehaviour.IGNORE);
			webDriver = new InternetExplorerDriver(ieOptions);
			webDriver.manage().window().maximize();
			webDriver.manage().window().setSize(new Dimension(1920, 1080));
			break;
		case "edge":
			EdgeOptions edgeOptions = new EdgeOptions();
			System.setProperty("webdriver.edge.driver", ReadProperties.getHostProperty("edgeDriverLocation"));
			if (usingProxy.equals("1")) {
				edgeOptions.setCapability("network.proxy.type", 1);
				edgeOptions.setCapability("network.proxy.socks", "127.0.0.1");
				edgeOptions.setCapability("network.proxy.socks_port", 1337);
				edgeOptions.setCapability("network.proxy.socks_version", 5);
			} else {
				// Assuming no proxy
			}

			if (runHeadless.equalsIgnoreCase("true") || !ReadProperties.runLocal) {	
				edgeOptions.addArguments("-headless");
			}
			edgeOptions.setCapability("unhandledPromptBehavior", UnexpectedAlertBehaviour.IGNORE);
			webDriver = new EdgeDriver(edgeOptions);
			webDriver.manage().window().maximize();
			webDriver.manage().window().setSize(new Dimension(1920, 1080));
			break;

		case "chrome":

			String downloadFilepath = ReadProperties.getDownloadFilepath();
			log.info("Download File Path being set to =>"+downloadFilepath);

			HashMap<String, Object> chromePrefs = new HashMap<String, Object>();
			chromePrefs.put("profile.default_content_settings.popups", 0);
			chromePrefs.put("download.default_directory", downloadFilepath);



			ChromeOptions chromeOptions = new ChromeOptions();
			chromeOptions.setUnhandledPromptBehaviour(UnexpectedAlertBehaviour.IGNORE);
			chromeOptions.addArguments("--start-maximized");
			chromeOptions.addArguments("--no-proxy-server");
			chromeOptions.addArguments("--window-size=1920,1080");
			chromeOptions.setExperimentalOption("prefs", chromePrefs);

			if (runHeadless.equalsIgnoreCase("true") || !ReadProperties.runLocal) {	
				chromeOptions.addArguments("--headless");
			}
			try {
				log.info("Starting chrome driver");
				webDriver = new ChromeDriver(chromeOptions);
			} catch (Exception e) {
				log.info("Setting driver location and Starting chrome driver");
				System.setProperty("webdriver.chrome.driver", ReadProperties.getHostProperty("chromeDriverLocation"));
				webDriver = new ChromeDriver(chromeOptions);
			}
			capabilities = ((ChromeDriver)webDriver).getCapabilities();
			log.info(capabilities.toString());
			log.info(((ChromeDriver)webDriver).getCapabilities().toString());
			break;
			
		default:      
			log.fatal("Invalid browser type specified" + usingDriver);
		}

		webDriver.manage().timeouts().implicitlyWait(0, TimeUnit.SECONDS);
	}

}
