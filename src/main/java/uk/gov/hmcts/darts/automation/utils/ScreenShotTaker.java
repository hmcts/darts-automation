package uk.gov.hmcts.darts.automation.utils;

import java.io.File;
import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import org.apache.commons.io.FileUtils;

public class ScreenShotTaker {
	private static Logger log = LogManager.getLogger("ScreenShotTaker");
	private WebDriver driver;
	
	public ScreenShotTaker(WebDriver webDriver) {
		this.driver = webDriver;
	}

	
	public ScreenShotTaker captureScreenShot() {
		File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
		try {
			
			FileUtils.copyFile(src,	new File("ScreenShot/" + System.currentTimeMillis()	+ ".png"));
			log.info("Took Screenshot as called");
			
		} catch (IOException e) {
			
			log.info(e.getMessage());
			
		}
		
		return this;
	}
}
