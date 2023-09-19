package uk.gov.hmcts.darts.automation.utils;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
//import org.openqa.selenium.Capabilities;
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
//import org.openqa.selenium.phantomjs.PhantomJSDriver;
//import org.openqa.selenium.phantomjs.PhantomJSDriverService;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.events.EventFiringWebDriver;
import org.openqa.selenium.support.events.EventFiringDecorator;
import org.openqa.selenium.support.events.WebDriverListener;


import uk.gov.hmcts.darts.automation.utils.ReadProperties;

@SuppressWarnings("deprecation")
public class SharedDriver extends EventFiringWebDriver {

	private static Logger log = LogManager.getLogger("SharedDriver");

	private static WebDriver REAL_DRIVER;
	private static Thread CLOSE_THREAD = new Thread() {
		@Override
		public void run() {
			REAL_DRIVER.quit();
		}
	};
	public static Capabilities capabilities;

	static {

		String usingDriver = ReadProperties.machine("usingDriver");
		String usingProxy = ReadProperties.machine("usingProxy");
		String headlessChrome = ReadProperties.machine("headlessChrome");
		log.info("browser =>" + usingDriver);
		String os = System.getProperty("os.name");
		log.info("OS =>" + os);
		switch (usingDriver.toLowerCase()) {
		case "firefox":
			FirefoxOptions firefoxOptions = new FirefoxOptions();
//			firefoxOptions.addArguments('-headless');
//			System.setProperty("webdriver.firefox.marionette", ReadProperties.machine("firefoxDriverLocation"));
//			System.setProperty("webdriver.gecko.driver", ReadProperties.machine("firefoxDriverLocation"));
			System.setProperty("webdriver.gecko.driver", ReadProperties.getHostProperty("firefoxDriverLocation"));
			FirefoxProfile firefoxProfile = new FirefoxProfile();
//			FirefoxProfile firefoxProfile = new FirefoxProfile(new File(ReadProperties.machine("firefoxDriverLocation")));
			if (usingProxy.equals("1")) {
				firefoxOptions.addPreference("network.proxy.type", 1);
				firefoxOptions.addPreference("network.proxy.socks", "127.0.0.1");
				firefoxOptions.addPreference("network.proxy.socks_port", 1337);
				firefoxOptions.addPreference("network.proxy.socks_version", 5);
			} else {
				// Assuming no proxy
			}
			firefoxOptions.setUnhandledPromptBehaviour(UnexpectedAlertBehaviour.IGNORE);
			REAL_DRIVER = new FirefoxDriver(firefoxOptions);
			REAL_DRIVER.manage().window().maximize();
			REAL_DRIVER.manage().window().setSize(new Dimension(1920, 1080));
			break;

		case "grid":
			log.fatal("Grid n/a");

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
			REAL_DRIVER = new InternetExplorerDriver(ieOptions);
			REAL_DRIVER.manage().window().maximize();
			REAL_DRIVER.manage().window().setSize(new Dimension(1920, 1080));
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
			edgeOptions.setCapability("unhandledPromptBehavior", UnexpectedAlertBehaviour.IGNORE);
			REAL_DRIVER = new EdgeDriver(edgeOptions);
			REAL_DRIVER.manage().window().maximize();
			REAL_DRIVER.manage().window().setSize(new Dimension(1920, 1080));
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

			if (headlessChrome.equalsIgnoreCase("true") 
					|| !ReadProperties.runLocal) {	
				chromeOptions.setHeadless(true);
			} else {
			}
			try {
				log.info("Starting chrome driver");
				REAL_DRIVER = new ChromeDriver(chromeOptions);
			} catch (Exception e) {
				log.info("Setting driver location and Starting chrome driver");
				System.setProperty("webdriver.chrome.driver", ReadProperties.getHostProperty("chromeDriverLocation"));
				REAL_DRIVER = new ChromeDriver(chromeOptions);
			}
			capabilities = ((ChromeDriver)((RemoteWebDriver)REAL_DRIVER)).getCapabilities();
			log.info(capabilities.toString());
			log.info(((ChromeDriver)((RemoteWebDriver)REAL_DRIVER)).getCapabilities().toString());
			break;
			
		default:      
			log.fatal("Invalid browser type specified" + usingDriver);
		}

		REAL_DRIVER.manage().timeouts().implicitlyWait(0, TimeUnit.SECONDS);

		Runtime.getRuntime().addShutdownHook(CLOSE_THREAD);
	}

	public SharedDriver() {
		super(REAL_DRIVER);

	}

	@Override
	public void close() {
		if (Thread.currentThread() != CLOSE_THREAD) {
			throw new UnsupportedOperationException(
					"You shouldn't close this WebDriver. It's shared and will close when the JVM exits.");
		}
		super.close();
	}

}
