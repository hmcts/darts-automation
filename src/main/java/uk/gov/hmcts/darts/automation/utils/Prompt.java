package uk.gov.hmcts.darts.automation.utils;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import javax.swing.JOptionPane;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;

public class Prompt {
	private static WebDriver driver;
	private static Logger log = LogManager.getLogger("Prompt");
	private WaitUtils wait;
	private NavigationShared NAV;


	public Prompt(WebDriver driver) {
		Prompt.driver = driver;
		wait = new WaitUtils(driver);
		NAV = new NavigationShared(driver);
		
	}
	
	public boolean isLocal() {
		return (ReadProperties.os.substring(0, 3).equalsIgnoreCase("MAC")
				|| ReadProperties.os.substring(0, 7).equalsIgnoreCase("WINDOWS"));
	}
	
	public void displayPopup(String message, String title) {
		if (isLocal()) { 
			log.info("Display Popup => " + title + " : " + message);
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.PLAIN_MESSAGE);
		}
	}
	
	public void displayPopup(String message) {
		displayPopup(message, "Automation message");
	}
	
	public void displayPopup() {
		displayPopup("Automation waiting", "Automation message");
	}
    
	public String inputDialog(String message) {
		String returnString = "";
		if (isLocal()) { 
	    	log.info("Going to get input =>"+message);
	    	returnString = JOptionPane.showInputDialog(message);
	    	log.info("Got input at =>"+message+"<= value =>"+returnString);
		}
    	return returnString;
	}
			

}