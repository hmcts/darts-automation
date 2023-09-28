package uk.gov.hmcts.darts.automation.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.concurrent.TimeUnit;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.Capabilities;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.remote.RemoteWebDriver;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;

public class GenUtils {
	private static WebDriver driver;
	private static int TIME_IN_SECONDS = 60;
	private static Logger log = LogManager.getLogger("GenUtils");

	public GenUtils(WebDriver driver) {
		this.driver = driver;
	}
	
	public WebElement lookupWebElement_byPlaceholder(String lookup) {		
		log.info("Looking for element with placeholder =>"+lookup);
		return driver.findElement(By.xpath(".//*[contains(@placeholder, '"
									+ lookup
									+ "')]"));		
	}
	
	public String runReturn_JS(String jsCode) {
		
		JavascriptExecutor js =(JavascriptExecutor)driver;
		String out = js.executeScript(jsCode).toString();
		
		log.info("Ran jscode =>"+jsCode);
		log.info("Saw =>"+out);
		
		return out;
	}
	
	public void exec_JS(String jsCode) {
		((JavascriptExecutor) driver).executeScript(jsCode);
		log.info("Ran jscode =>"+jsCode);
	}
	
	public void exec_JS(String jsCode, WebElement webElement) {
		((JavascriptExecutor) driver).executeScript(jsCode, webElement);
		log.info("Ran jscode =>"+jsCode);
	}
	
	public void setAttributeValue(WebElement elem, String param, String value) {
	    JavascriptExecutor js = (JavascriptExecutor) driver; 
	    String scriptSetAttrValue = "arguments[0].setAttribute(arguments[1],arguments[2])";
	    js.executeScript(scriptSetAttrValue, elem, param, value);
	    log.info("For element, set =>"+param+"<= to =>"+value);
	}

	public static String runCommand(String command) throws IOException, InterruptedException {
		log.info("Going to execute command: >"+command);
		ProcessBuilder pb;
		Process pr = null;
		try {
			pb = new ProcessBuilder();
			pb.command("bash", "-c", command);		
			pb.redirectErrorStream(true);
			pr = pb.start();
			log.info("Started command: >"+command);
			BufferedReader in = new BufferedReader(new InputStreamReader(pr.getInputStream()));
			String line1 = in.readLine();
			log.info("command output: >"+line1);
			String line;
			while ((line = in.readLine()) != null) {
				log.info("command output: >"+line);
			}
			int exitVal = pr.waitFor();

			in.close();

			log.info("Command ran "+exitVal);
			return line1;

		} catch (Exception e) {
			log.warn("Process Failed >" + command );

		}
		return "Version not available";
	}
	
	public String browserVersion() {
		String version = "Not available";
		try {
			String usingDriver = ReadProperties.machine("usingDriver");
			log.info("browser =>" + usingDriver);
			String os = System.getProperty("os.name");
			log.info("OS =>" + os);
			switch (usingDriver.toLowerCase()) {
			case "firefox":
				version = SeleniumWebDriver.capabilities.getBrowserVersion();
				log.info("Browser Version: " + version);
				break;
			case "grid":
				break;
			case "ie":
			case "internet explorer":
				break;
			case "edge":
				break;
			case "chrome":
				try {
					version = runCommand("google-chrome --version");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String caps = SeleniumWebDriver.capabilities.toString();
				int pos1 = caps.indexOf("browserVersion: ")+16;
				int pos2 = caps.indexOf(",", pos1);
				version = caps.substring(pos1, pos2) ;
				log.info("Browser Version: " + version);
				break;
				
			default:      
			}
		} finally {
		}
		return version;
	}
	
	public String browserVersion1() throws Exception {
		String version = browserVersion();
		int pos1 = version.indexOf(".");
		String version1 = version.substring(0,pos1);
		log.info("version1: >"+version1+">");
		return version1;
	}
	
	public String seleniumVersion() {
		String version = "?";
		try {
			version = driver.toString();
			log.info("Chrome info: "+version);
		} finally {
			
		}
		return version;
	}
	
}
