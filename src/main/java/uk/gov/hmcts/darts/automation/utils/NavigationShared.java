package uk.gov.hmcts.darts.automation.utils;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import io.cucumber.datatable.DataTable;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.UnhandledAlertException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

import uk.gov.hmcts.darts.automation.utils.GenUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.DateUtils;

public class NavigationShared {
	private WebDriver driver;
	private static Logger log = LogManager.getLogger("NavigationShared");
	private WaitUtils wait;
	private String LOADING_ICON_LOCATION = "div.govuk-spinner";
	private GenUtils GU;
	private static int instanceCount = 0;

	public NavigationShared(WebDriver driver) {
		this.driver = driver;
		wait = new WaitUtils(driver);
		GU = new GenUtils(driver);
		log.info("Instance count: " + ++instanceCount);
	}

	public void navigateToUrl(String url) throws Exception {
		driver.navigate().to(url);
		waitForBrowserReadyState();
		log.info("Navigated to =>" + url);
	}

	/**
	 * JM - Checks whether expected_text is presented anywhere on the page within
	 * the body tag If it exists, continues else fails the test with "Text not
	 * found!" appearing in the console
	 * 
	 * @param expected_text
	 * @return
	 * @throws Exception
	 */
	public boolean textIsPresentOnPage(String expected_text) throws Exception {
		log.info("About to look for Expected Text =>" + expected_text);
		waitForLoadingIcon();
		String substitutedValue = Substitutions.substituteValue(expected_text);
		String bodyText = driver.findElement(By.tagName("body")).getText();
		boolean found = bodyText.contains(substitutedValue);
		if (found) 
			log.info("Saw Expected Text =>" + substitutedValue);
		else
			log.info("Did not see Expected Text =>" + substitutedValue);

		return found;
	}

	/**
	 * JM - Checks whether expected_text is presented anywhere on the page within
	 * the body tag If it exists, continues else fails the test with "Text not
	 * found!" appearing in the console
	 * 
	 * @param expected_text
	 * @return
	 * @throws Exception 
	 */
	public NavigationShared textPresentOnPage(String expected_text) throws Exception {
		log.info("About to look for Expected Text =>" + expected_text);
		waitForLoadingIcon();
		String substitutedValue = Substitutions.substituteValue(expected_text);
		int textCount = driver.findElements(By.xpath("//body[contains(normalize-space(.),\"" + substitutedValue +  "\")]")).size();
		try {
			Assertions.assertTrue(textCount > 0, "Text not found!");
		} catch (AssertionError e) { // Refactor this
			log.info("Did not find text in initial run, waiting for up to 10 seconds for text to appear");
			try {
				wait.waitForTextOnPage(substitutedValue);
			} catch (Exception eb) {
				log.info("Exception on wait for page... Trying to continue to get caught by Assertions.");
			}
			String bodyText = driver.findElement(By.tagName("body")).getText();
			Assertions.assertTrue(bodyText.contains(expected_text), "Text not found! Expected =>" + substitutedValue);
		}

		log.info("Saw Expected Text =>" + substitutedValue);

		return this;
	}

	public NavigationShared textNotPresentOnPage(String not_expected) throws Exception {
		log.info("About to look for unexpected Text =>" + not_expected); 
		waitForLoadingIcon();
		String substitutedValue = Substitutions.substituteValue(not_expected);

		String bodyText = driver.findElement(By.tagName("body")).getText();
		try {
			Assertions.assertFalse(bodyText.contains(substitutedValue), "Text Found when not expected!");
		} catch (AssertionError e) { // Refactor this
			log.info("Found text in initial run, waiting additional 2 seconds incase it disappears");
			wait.waitForTextInvisibility(substitutedValue, 2);

			bodyText = driver.findElement(By.tagName("body")).getText();
			Assertions.assertFalse(bodyText.contains(substitutedValue), "Text found when not expected!");
		}

		log.info("Did not see unexpected Text =>" + substitutedValue);

		return this;

	}

	public NavigationShared press_navigationButton(String button) throws Exception {

		switch (button) {
		case "forward":
			log.info("Pressing the browser forward button");
			driver.navigate().forward();
			waitForBrowserReadyState();
			break;
		case "backward":
			log.info("Pressing the browser back button");
			driver.navigate().back();
			waitForBrowserReadyState();
			break;
		case "back":
			log.info("Pressing back button on browser");
			driver.navigate().back();
			waitForBrowserReadyState();
			break;
		case "refresh":
			log.info("Refreshing the browser");
			driver.navigate().refresh();
			waitForBrowserReadyState();
			break;
		default:
			throw new Error("You did not give me an expected value. I received =>" + button);
		}

		return this;
	}

	/**
	 * JM - This needs reworking - finding by name is not appropriate. Needs to be
	 * by exact text description
	 * 
	 * @param location_name
	 * @return
	 */
	public WebElement find_locationParent(String location_name) {
		WebElement parentLocation; // Refactor the below to have both selects in one xpath - Could not do ti
									// quickly
		wait.deactivateImplicitWait();
		try {
			parentLocation = driver.findElement(By.xpath(
					"//*[./label[text()[contains(., '" + location_name + "')]]]"));
			wait.activateImplicitWait();
			log.info("element found - try 1");
		} catch (Exception e) {
			log.info("element not found - try 2");
			wait.activateImplicitWait();
			parentLocation = driver
					.findElement(By.xpath("//*[./label[contains(normalize-space(text()), '" + location_name + "')]]"));
			log.info("element found - try 2");
		}
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
		wait.pollingEvery(Duration.ofMillis(200))
			.until(ExpectedConditions.visibilityOf(parentLocation));

		return parentLocation;
	}
	
	public String getCheckboxState(WebElement webElement) {
		if (webElement.isSelected()) {
			return "checked";
		} else {
			return "unchecked";
		}
	}
	
	public String getCheckboxState(String labelText) throws Exception {
		return getCheckboxState(findInputFieldByLabelText(labelText));
	}
	
	public void verifyCheckboxState(String labelText, String expected) throws Exception {
		String checkboxState = getCheckboxState(findInputFieldByLabelText(labelText));
		if (checkboxState.equalsIgnoreCase(expected)) {
			log.info("checkbox >"+labelText+"< is >"+expected+"< as expected");
		} else {
			log.fatal("checkbox >"+labelText+"< is NOT the expected>"+expected+"< but is >"+checkboxState);
			throw new Exception("checkbox >"+labelText+"< is NOT the expected>"+expected+"< but is >"+checkboxState);
		}
	}
	
	public String getCheckboxState(String labelText, String header) throws Exception {
		return getCheckboxState(findInputByLabelName(labelText, header));
	}
	
	public void verifyCheckboxState(String labelText, String header, String expected) throws Exception {
		String checkboxState = getCheckboxState(findInputByLabelName(labelText, header));
		if (checkboxState.equalsIgnoreCase(expected)) {
			log.info("checkbox >"+labelText+"< in header >"+header+"< is >"+expected+"< as expected");
		} else {
			log.fatal("checkbox >"+labelText+"< in header >"+header+"< is NOT the expected>"+expected+"< but is >"+checkboxState);
			throw new Exception("checkbox >"+labelText+"< in header >"+header+"< is NOT the expected>"+expected+"< but is >"+checkboxState);
		}
	}
	

	public boolean getElemementVisibility(List<WebElement> webElements) throws Exception {
		int count = 0;
		int warn  = 0;
	
		for (WebElement webElement : webElements) {
			try {
				if (webElement.isDisplayed() 
						|| (webElement.getTagName().equalsIgnoreCase("input")
								&& (webElement.getAttribute("type").equalsIgnoreCase("radio") 
										|| webElement.getAttribute("type").equalsIgnoreCase("checkbox"))
								&& !webElement.getCssValue("display").equalsIgnoreCase("none"))) {
					count += 1;
				}
			} catch (Exception e) {
				log.warn("Received error when checking whether element was displayed");
				log.warn(e);
				warn += 1;
			}
		}
		if (warn > 0) {
			log.fatal("Errors checking whether elements are displayed >"+warn);
			throw new Exception("Errors checking whether elements are displayed >"+warn);
		}
		if (count > 1) {
			log.fatal("More than 1 element is displayed when looking for max 1 element >"+count);
			throw new Exception("More than 1 element is displayed when looking for max 1 element >"+count);
		}
		return (count == 1);
	}
	
	public void verifyElemementVisibility(List<WebElement> webElements, boolean expected) throws Exception {
		if (getElemementVisibility(webElements) == expected) {
			log.info("Element visibility as expected >"+expected);
		} else {
			log.error("Element visibility  >"+getElemementVisibility(webElements)+"< NOT THE EXPECTED VALUE OF >"+expected);
			throw new Exception("Element visibility  >"+getElemementVisibility(webElements)+"< NOT THE EXPECTED VALUE OF >"+expected);
		}
	}
	
	public void verifyElemementVisibility(String labelText, String header, boolean expected) throws Exception {
		log.info("About to look for element with label >"+labelText+"< under header >"+header);	
		verifyElemementVisibility(driver.findElements(By.xpath("//*[@id=(//fieldset[.//*[normalize-space(text())=\""+header+"\"]]//label[normalize-space(text())=\""+labelText+"\"]/@for)]")), expected);
	}
	
	public boolean getElementEnabled(WebElement webElement) throws Exception {
		if (webElement.isDisplayed() 
				|| (webElement.getTagName().equalsIgnoreCase("input")
						&& (webElement.getAttribute("type").equalsIgnoreCase("radio") 
								|| webElement.getAttribute("type").equalsIgnoreCase("checkbox"))
						&& !webElement.getCssValue("display").equalsIgnoreCase("none"))) {
			log.info("element is visible ... with enabled value of "+webElement.isEnabled());
			return (webElement.isEnabled());
		} else {
			log.fatal("element is NOT displayed when expected");
			throw new Exception("element is NOT displayed when expected");
		}
	}
	
	public boolean getElementEnabled(String labelText, String header) throws Exception {
		WebElement webElement = findInputByLabelName(labelText, header);
		return getElementEnabled(webElement);
	}
	
	public void verifyElementEnabledDisabled(WebElement webElement, String expected) throws Exception {
		Boolean isEnabled = getElementEnabled(webElement);
		switch (expected.toUpperCase()) {
		case "ENABLED":
			if (isEnabled) {
				log.info("element is visible and enabled as expected");
			} else {
				log.fatal("webElement is NOT enabled when expected");
				throw new Exception("webElement is NOT enabled when expected");
			}
			break;
		case "DISABLED":
			if (isEnabled) {
				log.fatal("webElement IS enabled when NOT expected");
				throw new Exception("webElement IS enabled when NOT expected");
			} else {
				log.info("webElement is visible and NOT enabled as expected");
			}
			break;
		default:
			log.fatal("invalid expected state >"+expected);
			throw new Exception("invalid expected state >"+expected);
		}
	}
	
	public void verifyElementEnabledDisabled(String labelText, String header, String expected) throws Exception {
		WebElement webElement = findInputByLabelName(labelText, header);
		verifyElementEnabledDisabled(webElement, expected);
	}
	
	public void verifyTextInTableRow(String text, String rowData1, String rowData2) throws Exception {
		String rowXpath = "(./td/descendant-or-self::*[normalize-space(.)=\"%s\"])";
		int findCount = driver.findElements(By.xpath(String.format("//table//tr[" + rowXpath + " and " + rowXpath + "]" + 
				"/td/descendant-or-self::*[normalize-space(.)=\"%s\"]",
				Substitutions.substituteValue(rowData1),
				Substitutions.substituteValue(rowData2),
				Substitutions.substituteValue(text)))).size();
		Assertions.assertTrue(findCount > 0, "String not found in table");
	}
	
	public void clickButtonInTableRow(String buttonText, String rowData1, String rowData2) throws Exception {
		String rowXpath = "(./td/descendant-or-self::*[normalize-space(.)=\"%s\"])";
		String buttonXpath ="/descendant-or-self::*[normalize-space(.) = \"%s\"]";
		driver.findElement(By.xpath(String.format("(//table//tr[" + rowXpath + " and " + rowXpath + "]" + 
				"//input[@type='button']" + buttonXpath + ")" +
				" | (//table//tr[" + rowXpath + " and " + rowXpath + "]//button" + buttonXpath + ")",
				Substitutions.substituteValue(rowData1),
				Substitutions.substituteValue(rowData2),
				buttonText,
				Substitutions.substituteValue(rowData1),
				Substitutions.substituteValue(rowData2),
				buttonText))).click();
	}
	
	public void checkUncheckCheckboxInTableRow(String rowData1, String rowData2, String action) throws Exception {
		String xpathBit = "(./td[text()=\"%s\"])";
		WebElement checkbox = driver.findElement(By.xpath(String.format("//table//tr[" + xpathBit + " and " + xpathBit + "]//input[@type='checkbox']",
				Substitutions.substituteValue(rowData1),
				Substitutions.substituteValue(rowData2))));
		set_unset_checkbox(checkbox, action);
	}
	
	public void checkUncheckCheckboxInTable(String rowData, String header, String action) throws Exception {
		WebElement checkbox = returnCellFromColumnByValue(findTableContainingText(rowData), rowData, header).findElement(By.xpath("./descendant::input[@type='checkbox']"));
		set_unset_checkbox(checkbox, action);
	}
	
	public void verifyCheckboxStateInTable(String rowData, String header, String expected) throws Exception {
		WebElement checkbox = returnCellFromColumnByValue(findTableContainingText(rowData), rowData, header).findElement(By.xpath("./descendant::input[@type='checkbox']"));
		String checkboxState = getCheckboxState(checkbox);
		if (checkboxState.equalsIgnoreCase(expected)) {
			log.info(header + "checkbox for >"+rowData+"< is >"+expected+"< as expected");
		} else {
			log.fatal(header + "checkbox for >"+rowData+"< is NOT the expected >"+expected+"< but is >"+checkboxState);
			throw new Exception(header + "checkbox for >"+rowData+"< is NOT the expected >"+expected+"< but is >"+checkboxState);
		}
	}
	
	public void clickAway(WebElement webElement) {
		if (webElement != null) {
			try {
				webElement.sendKeys(Keys.TAB);
			} catch (Exception e1) {
				try {
					driver.findElement(By.tagName("body")).click();
				} catch (Exception e2) {
					try {
						driver.findElement(By.tagName("body")).click();
					} catch (Exception e3) {
						log.info("could not click out of element");
					}
				}
			}
		} else {
			try {
				driver.findElement(By.tagName("body")).click();
			} catch (Exception e2) {
				try {
					driver.findElement(By.tagName("body")).click();
				} catch (Exception e3) {
					log.info("could not click out of element");
				}
			}
		}
	}
	
	public void checkRadioButton(String label) throws Exception {
		log.info("About to Check radio button with label =>" + label);
		WebElement webElement = findInputFieldByLabelText(label);
		set_unset_checkbox(webElement, "CHECK");
		waitForPageLoad();
	}
	
	public void set_unset_checkbox(WebElement webElement, String action) throws Exception {
		boolean isChecked = webElement.isSelected();
		switch (action.toUpperCase()) {
		case "CHECK":
			if (isChecked) {
				log.info("already checked - no action");
			} else {
				log.info("about to check checkbox");
				webElement.click();
				clickAway(webElement);
				waitForBrowserReadyState();
				if (!webElement.isSelected()) {
					log.fatal("Web element was clicked but is unchanged");
					throw new Exception("Web element was clicked but is unchanged");
				}
			}
			break;
		case "UNCHECK":
			if (isChecked) {
				log.info("about to uncheck checkbox");
				webElement.click();
				webElement.sendKeys(Keys.TAB);
				waitForBrowserReadyState();
				if (webElement.isSelected()) {
					log.fatal("Web element was clicked but is unchanged");
					throw new Exception("Web element was clicked but is unchanged");
				}
			} else {
				log.info("already unchecked - no action");
			}
			break;
		default:
			log.fatal("invalid action passed to check-uncheck "+action);
			throw new Exception("invalid action passed to check-uncheck "+action);
		}
	}
	
	public void set_unset_checkbox(String labelText, String header, String action) throws Exception {
		log.info("about to "+action+" checkbox with label >"+labelText+"< under header >"+header);
		set_unset_checkbox(findInputByLabelName(labelText, header), action);
	}

	public WebElement findInputByLabelName(String labelText, String header) throws Exception {
		WebElement targetElement = null;
		try {
			log.info("About to look for element with label >"+labelText+"< under header >"+header);
			targetElement = return_oneVisibleFromList(
					driver.findElements(By.xpath("//*[@id=(//fieldset[.//*[normalize-space(text())=\""+header+"\"]]//label[normalize-space(text())=\""+labelText+"\"]/@for)]")));
			log.info("found element  with label >"+labelText+"< under header >"+header);
		} catch (Exception e) {
			log.error("element not found");
			throw e;
		}
		return targetElement;
	}			

	public NavigationShared set_valueTo(String location_name1, String location_name2, String value) throws Exception {
		log.info("About to Set input field with labels =>" + location_name1 + "<=>"+ location_name2 + "<= to =>" + value);
		waitForLoadingIcon();
		WebElement inputField = null;
		try {
			String xpathBit = "./descendant-or-self::*[text()[(normalize-space(.)=\"%s\")]]";
			inputField = driver.findElement(
					By.xpath(String.format("//*[@id=(" + "//label[" + xpathBit + " and " + xpathBit + "]" + "/@for)]",
					location_name1,
					location_name2)));
			log.info("element found");
		} catch (Exception e2) {
			log.error("label not found =>"+location_name1 + "<=>"+ location_name2);
			throw(e2);
		}

		String substitutedValue = setElementValueTo(inputField, value);
		log.info("Set input field with label =>" + location_name1 + "<=>"+ location_name2 + "<= to =>" + substitutedValue);
		return this;
	}

	public WebElement find_inputBy_labelName(String label_name) throws Exception {
		WebElement targetElement = null;
		wait.deactivateImplicitWait();
		log.info("about to look for element by label text >"+label_name);
		try {
			targetElement = driver.findElement(
					By.xpath("//*[@id=(" + "//label[text()[(normalize-space(.)=\"" + label_name + "\")]]" + "/@for)]"));
			log.info("element found on try 1");
		} catch (Exception e) {
			try {
				log.debug("element not found - try 2");
				targetElement = driver.findElement(
						By.xpath("//*[@id=(" + "//label[text()[contains(.,\"" + label_name + "\")]]" + "/@for)]"));
				log.info("element found - try 2");
			} catch (Exception e2) {
				log.debug("element not found - try 3");
				targetElement = return_oneVisibleFromList(driver.findElements(
						By.xpath("//label[contains(text(),\"" + label_name + "\")]/input"
								+ " | //label[contains(text(),\"" + label_name + "\")]/select"
								+ " | //label[contains(text(),\"" + label_name + "\")]/button")));
				log.info("element found - try 3");
			}
		}
		return targetElement;

	}

	public WebElement findInputFieldByLabelText(String labelText) throws Exception {
		WebElement targetElement = null;
		waitForLoadingIcon();
		try {
			targetElement = find_inputBy_labelName(labelText);
		} catch (Exception e) {
			try {
				log.warn("label containing for not found - continuing with label followed by field");
				targetElement = return_oneVisibleFromList(
						driver.findElements(By.xpath("//label[text()[contains(., \"" + labelText + "\")]]" + "//input")));
			} catch (Exception e1) {
				try {
				log.warn("label not found - continuing with any element containing text followed by field");
				targetElement = return_oneVisibleFromList(
						driver.findElements(By.xpath("//*[text()[contains(., \"" + labelText + "\")]]" + "//input")));
				} catch (Exception e2) {
					log.error("label not found =>"+labelText);
					throw(e2);
				}
			}
		}
		return targetElement;
	}
	

	public WebElement set_valueTo(String location_name, String value) throws Exception {
		log.info("About to Set input field with label =>" + location_name + "<= to =>" + value);
		WebElement targetElement = findInputFieldByLabelText(location_name);
		String substitutedValue = setElementValueTo(targetElement, value);
		log.info("Set input field with label =>" + location_name + "<= to =>" + substitutedValue);

		return targetElement;
	}
	
	public String setElementValueTo(WebElement webElement, String value) throws Exception {
		webElement.clear();
		String substitutedValue = Substitutions.substituteValue(value);
		webElement.sendKeys(substitutedValue);

		log.info("Set input field =>" + webElement.toString() + "<= to =>" + substitutedValue);
		waitForBrowserReadyState();
		return substitutedValue;
	}

	public NavigationShared set_select_valueTo(String location_name, String value) throws Exception {

		waitForLoadingIcon();
		WebElement childField;
		try {
			childField = find_inputBy_labelName(location_name);
			log.info("element found on try 1");
		} catch (Exception e) {
			log.info("element not found - try 2");
			childField = return_oneVisibleFromList(
					driver.findElements(By.xpath("//label[text()[contains(., '" + location_name + "')]]" + "//input")));
			log.info("element found - try 2");
		}
		log.info("About to click on element");
		childField.click();
		log.info("About to type contents");
		childField.findElement(By.tagName("input")).sendKeys(value);
		childField.findElement(By.tagName("input")).sendKeys(Keys.RETURN);
		childField.findElement(By.tagName("input")).sendKeys(Keys.TAB);

		log.info("Set input field with label =>" + location_name + "<= to =>" + value);
		waitForBrowserReadyState();

		return this;
	}

	public void compare_valueTo(String location_name, String expected_value) throws Exception {		// WebElement parentLocation = find_locationParent(location_name);
		// This assumes we are checking inputs - May need to amend
		String current_value;
		try {
			current_value = find_inputBy_labelName(location_name).getAttribute("value");
			log.info("element found on try 1");
		} catch (Exception e) {
			log.info("element not found - try 2");
			log.info("Unable to find current_value the new way. Trying the old way");
			current_value = find_locationParent(location_name).findElement(By.cssSelector("input"))
					.getAttribute("value");
			log.info("element found - try 2");
		}

		log.info("Current value =>" + current_value);

		String substitutedValue = Substitutions.substituteValue(expected_value);
		assertEquals(current_value, expected_value);
		log.info("Saw Expected Value =>" + current_value);

	}

	public WebElement press_buttonByName(String button_name) throws Exception {
		log.info("About to click on button =>" + button_name);
		waitForLoadingIcon();
		WebElement button = null;
		
		List<WebElement> buttons = driver.findElements(By.xpath(
				"//button/descendant-or-self::*[normalize-space(.) = \"" + button_name + "\"]" ));

		try {
			button = return_oneVisibleFromList(buttons);
			wait.waitForClickableElement(button, 10);
			log.info("element found - try 1");
		} catch (Error | Exception e) {
			try {
				log.info("element not found - try 2");
				buttons = driver.findElements(By.xpath(
						"//button/descendant-or-self::*[text()[contains(., \"" + button_name + "\")]]" ));
				button = return_oneVisibleFromList(buttons);
				log.info("element found - try 2");
			} catch (Error | Exception e2) {
				log.info("element not found - try 3");
				buttons = driver.findElements(By.xpath(
						"//input[(@type='button' and contains(@value,\"" + button_name + "\")) or " +
						"(@type='submit' and contains(@value,\"" + button_name + "\"))]"));
				button = return_oneVisibleFromList(buttons);
				log.info("element found - try 3");
				
			}
		}

		try {
			button.click();
		} catch (Exception e) {
			log.warn(e);
			log.info("Could not do initial click on element - Going to move to element then try again");

			Actions action = new Actions(driver);
			action.moveToElement(button).click().perform();

			log.info("Move to element action successful");
		}

		log.info("Clicked on button with name =>" + button_name);

		waitForPageLoad();
		
		return button;
	}

	public boolean buttonVisible(String button_name) throws Exception {
		int visibleCount = 0;

		List<WebElement> buttons = driver.findElements(By.xpath(
				"//button[text()[contains(., '" + button_name + "')]]" + "|" + "//button//span[text()[contains(., '"
						+ button_name + "')]]"));

		if (buttons.size() == 0) {
			log.info("element not found - try 2");
			buttons = driver.findElements(By.xpath("//button[text()[contains(., '" + button_name + "')]]" + "|"
					+ "//button//span[text()[contains(., '" + button_name + "')]]"));
			log.info("element found - try 2");
		}
		for (int btnIndex = 0; btnIndex < buttons.size(); btnIndex++) {
			if (buttons.get(btnIndex).isDisplayed()) {
				visibleCount++;
			}
		}
		if (visibleCount > 1) {
			log.info("Found more than one visible button with this name - We dont know which one to use");
			throw new Error("More than 1 visible button");
		}

		return (visibleCount == 1);
	}

	public NavigationShared refreshPage() {

		driver.navigate().refresh();
		log.info("Refreshed the page");
		waitForBrowserReadyState();

		return this;
	}
	
	public WebElement uncheck_checkbox(String checkbox_name) throws Exception {
		log.info("About to uncheck checkbox if already checked");
		WebElement checkbox = find_inputBy_labelName(checkbox_name);
		if (checkbox.isSelected()) {
			checkbox.click();
		}
		waitForBrowserReadyState();
		log.info("Clicked on checkbox with for, checking if unchecked");	
		if (checkbox.isSelected()) {
			Assertions.fail("Checkbox is not really unchecked");
		} else {
			log.info("Checkbox really is unchecked ok when verified afterwards");
		}
		return checkbox;
	}

	public WebElement check_checkbox(String location_name) {
		log.info("About to check checkbox if already not checked");
		WebElement checkbox = null;
		waitForLoadingIcon();
		try {
			checkbox = find_inputBy_labelName(location_name);
			checkbox.click();
			log.info("Clicked on checkbox with for, checking if checked");
			if (checkbox.isSelected()) {
				log.info("Checkbox is already set - nothing to do");
				return null;
			}
		} catch (Exception e) {
			log.info("element not found - continuing .....");

		}
		WebElement parentLocation = find_locationParent(location_name);

		WebElement checkbox_location = parentLocation.findElement(By.cssSelector("input")); // Not an appropriate way of
																							// finding the checkbox -
																							// Rework

		Boolean selectedCheck = checkbox_location.isSelected(); // Does this prove it is a checkbox?

		wait.waitForClickableElement(checkbox_location, 10);

		try {
			checkbox_location.click();
		} catch (Exception e) {
			try {
				log.info("Unable to click on checkbox - Trying to do via action builder");

				((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", checkbox_location);

				checkbox_location.click();

				log.info("Checked the checkbox by action successfully");
			} catch (Exception ea) {
				log.info(ea);
				log.info("Exception on checkbox click - Going to use JS to attempt the click");

				GU.setAttributeValue(checkbox_location, "id", "tempIDForCheckbox");

				String execScript = "$(\"#tempIDForCheckbox\").click()";
				((JavascriptExecutor) driver).executeScript(execScript);

				try {
					GU.setAttributeValue(checkbox_location, "id", "x");
				} catch (Exception eb) {
					log.info("Unable to reset ID - Continuing as does not affect test");
				}

				log.info("Executed JS Script to click on the button instead"
						+ " - We will be checking with selenium to see whether it was actually clicked"
						+ ". Thise line provides some 'stability' to the script");
			}
		}

		if (selectedCheck != checkbox_location.isSelected())
			log.info("Checkbox selected for =>" + location_name);
		else
			throw new Error("Did not change the checkbox value as expected");
		waitForBrowserReadyState();

		return checkbox;
	}

	public void waitForPageLoad() {
		waitForPageLoad(2, 120);
	}

	public void waitForPageLoad(int waitTime) {
		waitForPageLoad(1, waitTime);
	}

	/**
	 * Overloading with wait time passed - For increased waiting when required
	 * 
	# * @param waitTime
	 */
	public void waitForPageLoad(int initialWait, int postWait) {
		log.info("Waiting for Loading Icon to become visible");
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(initialWait));
		try {
			wait.ignoring(UnhandledAlertException.class)
				.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions.or
					(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(LOADING_ICON_LOCATION)),
							ExpectedConditions.alertIsPresent()));
			log.info("Saw Loading Icon");
		} catch (Exception e) {
			log.warn("Did not catch the loading icon as expected - Continuing without error. Expected?");
			waitForBrowserReadyState();
			return;
		}
		if(true) {
			log.info("Waiting for Loading Icon to become hidden");
			try {
			wait = new WebDriverWait(driver, Duration.ofSeconds(postWait));
				wait.ignoring(UnhandledAlertException.class)
					.pollingEvery(Duration.ofMillis(200))
					.until(ExpectedConditions.or
						(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(LOADING_ICON_LOCATION)),
								ExpectedConditions.alertIsPresent()));
				log.info("Loading icon now gone - Continuing");
			} catch (Exception e) {
				log.error("Loading icon still here? After " + postWait
						+ " seconds - Something has gone wrong, but going to continue");
			}
			waitForBrowserReadyState();
		}
	}

	public void invisibilityOfElement(By by, WebDriverWait wait) {
		log.info("Waiting for element to be hidden "+by.toString());
		wait.pollingEvery(Duration.ofMillis(200))
			.ignoring(UnhandledAlertException.class)
			.until(ExpectedConditions.invisibilityOfElementLocated(by));
	}

	public void waitForLoadingIcon() {
		// Assumed spinner
		waitForLoadingIcon(120);
	}

	public void waitForLoadingIcon(int waitTime) {
		// Assumed spinner
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(waitTime));
		invisibilityOfElement(By.cssSelector(LOADING_ICON_LOCATION), wait);
		waitForBrowserReadyState();
	}

/*
 * Wait for browser ready state to be complete - call when button / checkbox / radio button selected
 * 
 * TODO consider waiting for not complete first (1 sec)
 * TODO Add gap between checks say 2000 to 
 */
	public void waitForBrowserReadyState() {
		log.info("Wait for document.readyState");
		log.info("Waiting for NOT ready state");
//	Wait for browser NOT to be ready - not too long because it may be ready again already
		try {
//	reduced wait from 1000 to 250 mS 2023-05-24
		    new WebDriverWait(driver, Duration.ofMillis(250), Duration.ofMillis(50))
		    	.until((ExpectedCondition<Boolean>) wd ->
		            !((JavascriptExecutor) wd).executeScript("return document.readyState").equals("complete"));
			log.info("Finished waiting for NOT ready state");
		} catch (Exception e) {
			log.warn("Timed out waiting for NOT ready state");
		}
		try {
			log.info("Waiting for ready state");
		    new WebDriverWait(driver, Duration.ofSeconds(30), Duration.ofMillis(200)).until((ExpectedCondition<Boolean>) wd ->
		            ((JavascriptExecutor) wd).executeScript("return document.readyState").equals("complete"));
			log.info("Finished waiting for ready state");
		} catch (Exception e) {
			log.warn("Timed out waiting for ready state");
		}
	}
	
	public WebElement clickLink(WebElement link, String label) {
		wait.waitForClickableElement(link);
		try {
			link.click();
			log.info("link clicked");
		} catch (Exception e1) {
			try {
			log.info("Failed to click on element, even though it is clickable - Going to try click using javascript");
			JavascriptExecutor executor = (JavascriptExecutor) driver;
			executor.executeScript("arguments[0].click();", link);
			} catch (Exception e2) {
				log.info("javascript click failed, try action click");
				Actions action = new Actions(driver);
				action.moveToElement(link).click().perform();
			}
		}
		waitForPageLoad();

		log.info("Clicked on URL with link text =>" + label);
		return link;
	}
	
	public void clickOnNavigationLink(String linkText) throws Exception {
		log.info("About to clicked on link in Navigation with link text =>" + linkText);
		WebElement link;
		try {
		link = driver.findElement(By.xpath("//nav//a[normalize-space(text())=\"" + linkText + "\"]"));
		clickLink(link, 
				linkText);
		} catch (Exception e) {log.error("Navigation Link not found " + linkText);
			throw(e);
		}
	}
	
	public void click_link_by_text(String arg1) throws Exception {
		log.info("About to clicked on link with link text =>" + arg1);
		arg1 = Substitutions.substituteValue(arg1);
		waitForLoadingIcon(15);
		WebElement linkText;
		try {
			log.info("try 1 - linkText");
			linkText = return_oneVisibleFromList(driver.findElements(By.linkText(arg1)));
			log.info("link found on try 1");
			clickLink(linkText, arg1);
		} catch (Exception e1) {
			try {
				log.info("element not found on try 1 so try 2 - xpath =text or xpath = lower case text");
				linkText = return_oneVisibleFromList(driver.findElements(By.xpath("//*[text()[(normalize-space(.)=\"" + arg1
						+ "\")]]" + "|" + "//*[text()[(normalize-space(.)=\"" + arg1.toLowerCase() + "\")]]")));
				log.info("element found on try 2");
				clickLink(linkText, arg1);
			} catch (Exception e2) {
				try {
				log.info("element not found on try 2 so try 3 - partialLinkText");
				wait.activateImplicitWait();
				linkText = return_oneVisibleFromList(driver.findElements(By.partialLinkText(arg1)));
				log.info("element found on try 3");
				clickLink(linkText, arg1);
				} catch (Exception e3) {
					log.info("element not found on try 3 so try4 - xpath contains text");
					linkText = return_oneVisibleFromList(driver.findElements(By.xpath("//*[text()[contains(., '" + arg1 + "')]]")));
					clickLink(linkText, arg1);
					log.info("element found on try 4");
				}
			}
		}
	}


	public void select_radioButtonWithLabel(String caption, String label) {

		log.info("About to click on radio button for =>"+caption+ "<= label =>" + label);
		WebElement radioButton = driver.findElement(By.xpath(String.format(
				"//*[//*[contains(normalize-space(text()),'%s')]]//*[@id=(//label[text()[contains(.,'%s')]]/@for)]"
				,caption, label
				)));
		radioButton.click();
		log.info("Clicked on radio button for =>"+caption+ "<= label =>" + label);
	}

	public boolean linkText_visible(String arg1) {
		log.info("Going to check whether link text =>" + arg1 + "<= is present on the page");
		wait.deactivateImplicitWait();
		waitForLoadingIcon();
		boolean isVisible;
		WebElement link;
		try {
			link = driver.findElement(By.partialLinkText(arg1));
			isVisible = link.isDisplayed();
		} catch (Exception e) {
			try {
				link = driver.findElement(By.xpath(String.format("//*[text()[(normalize-space(.)=\"%s\")]]", arg1)));
				isVisible = link.isDisplayed();
			} catch (Exception e2) {
				isVisible = false;
			}
		}
		return isVisible;
	}

	public void linkText_visible(String arg1, boolean isExpected) {
		boolean isVisible = linkText_visible(arg1);
		if (isExpected == isVisible) {
			log.info("Link text present =>" + isExpected + "<= which is expected");
		} else {
			throw new Error("Link text present =>" + isVisible + "<= when expected =>" + isExpected);
		}
		wait.activateImplicitWait();
	}

/*
 * 		search for text in any column in a row 
 * 			and return td element from a given column in the same row
 */
	public WebElement returnCellFromColumnByValue(WebElement table, String searchText, String targetHeader) throws Exception {
		String targetColumn = returnColumnNumber_againColumnHeader(table, targetHeader, "");
		if (!targetColumn.isEmpty()) {
			String tdXpath = String.format("./tbody/tr[.//*[contains(text(),\"%s\")]]//td[%s]", searchText, targetColumn);
			return table.findElement(By.xpath(tdXpath));
			
		}
		return null;
	}

/*
 * 		search for text in a specific column 
 * 			and return td element from another column in the same row
 */
	public WebElement returnCellFromColumnByHeaderTextAndValue(WebElement table, String idHeader, String searchText, String targetHeader) throws Exception {
		List<WebElement> header = returnHeaderCellsOfTable(table);
		String idColumn = findTextCellInHeader(header, idHeader);
		String targetColumn = findTextCellInHeader(header, targetHeader);
		if (!idColumn.isEmpty() && !targetColumn.isEmpty()) {
			String tdXpath = String.format("./tbody/tr[.//td[%s]/descendant-or-self::*[contains(text(),\"%s\")]]//td[%s]", idColumn, searchText, targetColumn);
			return table.findElement(By.xpath(tdXpath));
			
		}
		return null;
	}
	
	public void clickLinkInElement(WebElement webElement) {
		log.info("About to attempt to click on link inside WebElement provided");
		try {
			webElement.findElement(By.xpath(".//a")).click();
		} catch (Exception e) {
			log.info("try 1 failed - About to attempt to click on last sub-element inside WebElement provided");
			webElement.findElement(By.xpath("./descendant-or-self::*[last()]")).click();
		}
		log.info("Clicked on link inside WebElement provided - ok");
	}
	
	public String findTextCellInHeader(List<WebElement> headerCells, String text, String defaultColumn) throws Exception {
		log.info("called findTextCellInHeader for =>" + text+"<= with default column =>"+defaultColumn);
		int count = 0;
		String cellText = "";
		for (WebElement cell : headerCells) {
			cellText = cell.getText().trim();
			log.info(cellText);
// ignore headers with no text - sorting
			if (!cellText.isEmpty()) {
				count++;
				if (cellText.equalsIgnoreCase(text)) {
					log.info("returning value found =>"+count);
					return String.valueOf(count);
				}
			}
		}
		log.info("could not find cell in table row =>"+text+"<= returning default column =>"+defaultColumn );
		return defaultColumn;
	}
	
	public String findTextCellInHeader(List<WebElement> headerCells, String text) throws Exception {
		log.info("called findTextCellInHeader for =>" + text);
		String column = findTextCellInHeader(headerCells, text, "noDefault");
		if (column.equals("noDefault")) {
			log.info("could not find cell in table row =>"+text);
			throw new Exception("could not find cell in table row =>"+text);
		}
		return column;
	}

	public String returnColumnNumber_againColumnHeader(WebElement table, String text) throws Exception {
		List<WebElement> header = returnHeaderCellsOfTable(table);
		return findTextCellInHeader(header, text);
	}

	public String returnColumnNumber_againColumnHeader(WebElement table, String text, String defaultColumn) throws Exception {
		List<WebElement> header = returnHeaderCellsOfTable(table);
		return findTextCellInHeader(header, text, defaultColumn);
	}


	public List<WebElement> returnHeaderCellsOfTable(WebElement table, String text) throws Exception {
		log.info("called returnHeaderCellsOfTable for =>" + text);
		List<WebElement> tableHeaders = table.findElements(By.xpath("./thead/tr[1]/th"));
		if (tableHeaders.size() == 0) {
			tableHeaders = table.findElements(By.xpath("./thead/tr[1]/td"));
			if (tableHeaders.size() == 0) {
				tableHeaders = table.findElements(By.xpath("./tbody/tr[1]/th"));
				if (tableHeaders.size() == 0) {
					tableHeaders = table.findElements(By.xpath("./tbody/tr[1]/td"));
					if (tableHeaders.size() == 0) {
						log.fatal("table header row not found!");
						throw new Exception("table header row not found!");
					}
				}
			}
		}
		return tableHeaders;
	}
	
// n.b. text is not used in called version
	public List<WebElement> returnHeaderCellsOfTable(WebElement table) throws Exception {
		return returnHeaderCellsOfTable(table, "");
	}
	
	public WebElement findTableContainingText(String text) {

		// Looking for tables - Hoping for 1 per screen

		List<WebElement> tables = driver.findElements(By.cssSelector("table"));

		if (tables.size() > 1) {
			tables = driver.findElements(
					By.xpath("//table[.//*[text()[(normalize-space(.)=\"" + text + "\")]]]"));
			if (tables.size() > 1) {
				log.info("Found more than one table with this data - We dont know which one to use: " + tables.size());
				throw new Error("Which table do you want me to use? " + tables.size());
			}
		}
		
		if (tables.size() == 1) {						// can be 0 or 1 table
			log.info("found 1 table");
		} else {
			log.info("Did not find a (matching) table");
			throw new Error("Table not found");
		}

		return tables.get(0);
	}

// column names to be updated as required
	public String columnColumnName_groupsManager(String expectedColumnName, String defaultColumn, String columnName,
			WebElement table) throws Exception {
		switch (expectedColumnName.toUpperCase()) {
		case "CL":
		case "COURT LISTS":
			defaultColumn = "0";
			columnName = "Court Lists";
			break;
		case "CR":
		case "COURT REGISTERS":
			defaultColumn = "0";
			columnName = "Court Registers";
			break;
		case "ON":
		case "O&N":
		case "ORDERS & NOTICES":
			defaultColumn = "0";
			columnName = "Orders & Notices";
			break;
		case "DESTINATIONS":
			defaultColumn = "2";
			columnName = "Destinations";
			return "2";
//			break;
		case "STATUS":
			defaultColumn = "6";
			columnName = "Status";
			break;
		default:
			columnName = expectedColumnName;
			defaultColumn = "0";
		}
		return returnColumnNumber_againColumnHeader(table, columnName, defaultColumn);
	}
	
/*
 * 
 *  Verify state of checkbox under column containing expectedColumnName in row 1 in same row as value expectedColumnValue in col 1
 * 
 *  expected values of expectedState are "checked", "unchecked" or "omitted"
 * 
 */

	public void tableRow_isChecked_byColumn(String expectedColumnValue, String expectedColumnName, String expectedState) throws Exception {
		waitForLoadingIcon();
		log.info("Going to check row =>" + expectedColumnValue + "<= column =>" + expectedColumnName
				+ "<= to see whether there is something inside - expected =>" + expectedState);

		WebElement table = findTableContainingText(expectedColumnValue);

		String column = "1";
		String columnName = "";
		column = columnColumnName_groupsManager(expectedColumnName, column, columnName, table);
		if (column == "0") {
			switch (expectedState.toLowerCase()) {
			case "checked":
			case "unchecked":
				log.error("Column not found when expected to be =>" + expectedState);
				throw new Error("Column not found when expected to be =>" + expectedState);
			default:
				log.info("Column not found as expected");
				return;
			}
		}

		WebElement row = table.findElement(By.xpath("//tr[./td/descendant-or-self::*[contains(text(),\"" + expectedColumnValue + "\")]]"));
		log.info("Found row with text  =>" + expectedColumnValue);

		WebElement cell = row.findElement(By.cssSelector("td:nth-child(" + column + ")"));

		log.info("Found Cell at position =>" + expectedColumnName);
		wait.deactivateImplicitWait();

		switch (expectedState.toLowerCase()) {
		case "checked":
			log.info("Going to check whether there checked checkbox in the cell");
			try {
				if (cell.findElement(By.cssSelector("input")).isSelected()) {
					log.info("cell found and is checked as expected");
				} else {
					throw new AssertionError("Cell found but is not checked when expected to be checked");
				}
			} catch (Exception e) {
				log.info(
						"Did not find input field or it was not selected - Going to check if instead we have a favicon check");
				cell.findElement(By.xpath("//span[contains(@class, 'fa-check-circle')]"
						+ "| //img[contains(@src, 'check-circle.svg')]"));
				log.info("Saw that we have a favicon with a check - Assuming we are on a read-only view and this is expected, continuing");
			}
			break;
		case "unchecked":
			try {
				if (!cell.findElement(By.cssSelector("input")).isSelected()) {
					log.info("Checkbox is unchecked as expected - Continuing");
				} else {
					throw new AssertionError("Checkbox is checked when expected it to be unchecked");
				}
			} catch (Exception e) {
				log.info("Did not find input field - Going to check if instead we have a favicon cross");
				cell.findElement(By.xpath("//span[contains(@class, 'fa-times-circle')]"
						+ "| //img[contains(@src, 'times-circle.svg')]"));
				log.info("Saw that we have a favicon with a cross - Assuming we are on a read-only view and this is expected, continuing");
			}
			break;
		case "omitted":
			throw new AssertionError("column exists when not expected");
// 			break; would cause an error cos of throw
		default: {
			throw new Error("Not currently handing anything other than checked/unchecked");
			}
		}
		log.info("As Expected - Icon visibility");
		return;
	}

	public void tableRowsAreChecked_byColumn(String expectedColumnValues, String expectedColumnName) throws Exception {
		waitForLoadingIcon();
		String [] expectedColumnValueArray = expectedColumnValues.split(",");
		if (expectedColumnValueArray.length == 0) 
			return;
		log.info("Going to check row =>" + expectedColumnValueArray[0] + "<= column =>" + expectedColumnName
				+ "<= to see whether there is something inside - expected checked");

		WebElement table = findTableContainingText(expectedColumnValueArray[0]);

		String column = "1";
		String columnName = "";
		column = columnColumnName_groupsManager(expectedColumnName, column, columnName, table);
		if (column == "0") {
				log.error("Column not found when expected to be =>" + expectedColumnName);
				throw new Error("Column not found when expected to be =>" + expectedColumnName);
		}
		for (String expectedColumnValue : expectedColumnValueArray) {
			WebElement row = table.findElement(By.xpath("//tr[./td/descendant-or-self::*[contains(text(),\"" + expectedColumnValue + "\")]]"));
			log.info("Found row with text  =>" + expectedColumnValue);
	
			WebElement cell = row.findElement(By.cssSelector("td:nth-child(" + column + ")"));
	
			log.info("Found Cell at position =>" + expectedColumnName);
			wait.deactivateImplicitWait();

			log.info("Going to check whether there checked checkbox in the cell");
			try {
				if (cell.findElement(By.cssSelector("input")).isSelected()) {
					log.info("cell found and is checked as expected");
				} else {
					throw new AssertionError("Cell found but is not checked when expected to be checked");
				}
			} catch (Exception e) {
				log.info(
						"Did not find input field or it was not selected - Going to check if instead we have a favicon check");
				cell.findElement(By.xpath("//span[contains(@class, 'fa-check-circle')]"
						+ " | //img[contains(@src, 'check-circle.svg')]"));
				log.info("Saw that we have a favicon with a check - Assuming we are on a read-only view and this is expected, continuing");
			}
		}
		log.info("As Expected - Icon visibility");
		return;
	}

	public Boolean contain_icon(WebElement element) {
		wait.deactivateImplicitWait();
		try {
			element.findElement(By.cssSelector("span"));
			log.info("Found an element with 'span' in the element passed");
			return true;
		} catch (Exception e) {
			log.info("Did not find an element with 'span' in the element passed");
			return false;
		}
	}

	public void select_fromDropdown(String option_value, String dropdown_name) throws Exception {
		WebElement selectElement = find_inputBy_labelName(dropdown_name);
		String elementType = selectElement.getTagName(); 
		log.info("select element type is >"+elementType);
		if (elementType.equalsIgnoreCase("select")) {
	
			log.info("Found dropdown with name =>" + dropdown_name);
			Select select = new Select(selectElement);
			select.selectByVisibleText(option_value);
			log.info("Selected =>" + option_value + "<= from the dropdown with name =>" + dropdown_name);
		} else {
			try {
				set_select_valueTo(dropdown_name, option_value);
			} catch (Exception | AssertionError e) {
				log.error("error setting input-select >"+elementType+"< >+dropdown_name");
				throw new AssertionError("error selecting from dropdown type "+ elementType);
			}
		}
		waitForBrowserReadyState();

	}
/*
 * 
 * Generic FILTER for users / organisations (so not a search)
 *        ========
 * 
 */
	public void generic_searchForText(String searchText) {
		WebElement searchInput;
		Keys endKey;
		try {
			searchInput = driver.findElement(By.xpath("//*[@id='userSearch']  | //*[@id='orgSummaryTable'] | //div[@id='orgSummaryTable_filter']//input | //*[@placeholder='Filter users...'] | //*[@id='alphabetSearch']"));
			log.info("filter field found");
			endKey = Keys.TAB;
		} catch (Exception e) {
			log.info("filter not found - try search");
			searchInput = driver.findElement(By.xpath("//*[@id='searchBox'] | //*[@placeholder='Search case...']"));
			log.info("search found");
			endKey = Keys.ENTER;
		}

		searchInput.clear();
		searchInput.sendKeys(searchText);
		searchInput.sendKeys(endKey);
		log.info("Found filter field and sent it =>" + searchText);
		waitForPageLoad();

	}

	public void generic_filterResults(String filterText) {
		WebElement filterInput;
		try {
			filterInput = find_inputBy_labelName("Filter:");
			log.info("filter field found - try 1");
		} catch (Exception e) {
			log.info("filter field not found - try 2");
			filterInput = driver.findElement(By.xpath("//*[@placeholder='Filter...'] | //*[@placeholder='Filter users...']"));
			log.info("search found - try 2");
		}

		filterInput.clear();
// TODO - remove hack for @ sign not working in automation
		filterInput.sendKeys(filterText.split("@")[0]);
		filterInput.sendKeys(Keys.TAB);
		log.info("Found filter field and sent it =>" + filterText);
		waitForPageLoad();

	}

	public void click_onElement(WebElement element) {
		wait.toBeClickAble(element);

		try {
			element.click();
			log.info("Clicked on element as normal - Continuing");
			waitForBrowserReadyState();
			return;
		} catch (Exception e) {
			log.info("Unable ot click on element using Selenium, trying via Javascript");
			((JavascriptExecutor) driver).executeScript("arguments[0].click();", element);
			log.info("Clicked on element using javascript - Continuing");
		}
	}

	public void selectCheckbox_forRowWithText(String column, String rowText) {

		String checkboxId = null;
		if (column.equalsIgnoreCase("suspend")) {
			checkboxId = "//input[starts-with(@id, 'suspendCheckbox')]";
		} else if (column.equalsIgnoreCase("delete")) {
			checkboxId = "//input[starts-with(@id, 'deleteCheckbox')]";
		} else if (column.equalsIgnoreCase("deleted")) {
			checkboxId = "//input[starts-with(@id, 'deleteCheckbox')]";
		} else {
			throw new Error(
					"Did not get a checkbox lookup that we were expecting. Currently expecting either suspend or deleted");
		}

		log.info("Looking for checkbox called =>" + column + "<= for row with text =>" + rowText);

		List<WebElement> textMatches = driver.findElements(By.xpath("//a[text()[contains(., '" + rowText + "')]]"));

		if (textMatches.size() > 1) {
			log.info("Found more than one element with this text - We dont know which one to use: " + textMatches.size());
			throw new Error("Which checkbox do you want me to use? " + textMatches.size());
		}

		checkboxId = "//a[text()[contains(., '" + rowText + "')]]/../../.." + checkboxId;
		log.info(checkboxId);
		WebElement checkbox = driver.findElement(By.xpath(checkboxId));
		click_onElement(checkbox);

		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(2));
		try {
			wait.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions.elementToBeSelected(checkbox));
		} catch (Exception e) {
			log.info("Exception waiting for element to be selected - Going to continue anyway to be caught downstream");
		}

		log.info("Checked the =>" + column + "<= checkbox for row with text =>" + rowText);
		waitForBrowserReadyState();

	}

	public void selectRadioButton_forRowWithText(String column, String rowText) {

		String radioButtonId = null;
		if (column.equalsIgnoreCase("approve")) {
			radioButtonId = "//input[starts-with(@id, 'approveRadio')]";
		} else if (column.equalsIgnoreCase("reject")) {
			radioButtonId = "//input[starts-with(@id, 'rejectRadio')]";
		} else {
			throw new Error(
					"Did not get a radio button lookup that we were expecting. Currently expecting either approve or reject");
		}

		log.info("Looking for radioButton called =>" + column + "<= for row with text =>" + rowText);

		List<WebElement> textMatches = driver.findElements(By.xpath("//td[text()[contains(., '" + rowText + "')]]"));

		if (textMatches.size() > 1) {
			log.info("Found more than one element with this text - We dont know which one to use: " + textMatches.size());
			throw new Error("Which radioButton do you want me to press?" + textMatches.size());
		}

		radioButtonId = "//tr[./td[text()[contains(., '" + rowText + "')]]]" + radioButtonId;
		log.info(radioButtonId);
		WebElement checkbox = driver.findElement(By.xpath(radioButtonId));
		click_onElement(checkbox);

		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(2));
		try {
			wait.pollingEvery(Duration.ofMillis(200))
				.until(ExpectedConditions.elementToBeSelected(checkbox));
		} catch (Exception e) {
			log.info("Exception waiting for element to be selected - Going to continue anyway to be caught downstream");
		}

		log.info("Checked the =>" + column + "<= radio button for row with text =>" + rowText);
		waitForBrowserReadyState();

	}

	public void confirmCheckbox_forRowWithText(String column, String rowText, String checkedUnchecked) {

		String checkboxId = null;
		if (column.equalsIgnoreCase("suspend")) {
			checkboxId = "//input[starts-with(@id, 'suspendCheckbox')]";
		} else if (column.equalsIgnoreCase("delete")) {
			checkboxId = "//input[starts-with(@id, 'deleteCheckbox')]";
		} else if (column.equalsIgnoreCase("deleted")) {
			checkboxId = "//input[starts-with(@id, 'deleteCheckbox')]";
		} else {
			throw new Error(
					"Did not get a checkbox lookup that we were expecting. Currently expecting either suspend or deleted");
		}

		log.info("Looking for checkbox called =>" + column + "<= for row with text =>" + rowText);

		List<WebElement> textMatches = driver.findElements(By.xpath("//a[text()[contains(., '" + rowText + "')]]"));

		if (textMatches.size() > 1) {
			log.info("Found more than one element with this text - We dont know which one to use: " + textMatches.size());
			throw new Error("Which checkbox do you want me to verify? " + textMatches.size());
		}
		checkboxId = "//a[text()[contains(., '" + rowText + "')]]/../../.." + checkboxId;

		WebElement checkbox = driver.findElement(By.xpath(checkboxId));

		if (checkbox.isSelected() && checkedUnchecked.equalsIgnoreCase("checked")) {

		} else if (!checkbox.isSelected() && !checkedUnchecked.equalsIgnoreCase("checked")) {

		} else {
			throw new Error("Seems that the checkbox isn't set as expected! Failing");
		}
	}

	public void select_fromDropdown(String option) throws Exception {
		waitForLoadingIcon();
		List<WebElement> dropdowns = driver.findElements(By.cssSelector("select"));
		WebElement dropdown = return_oneVisibleFromList(dropdowns);

		Select selector = new Select(dropdown);
		selector.selectByVisibleText(option);
		log.info("Selected =>" + option + "<= from the dropdown");
		waitForBrowserReadyState();
	}

	public WebElement return_oneVisibleFromList(List<WebElement> webElements) throws Exception {
		log.info("Received =>" + webElements.size() + "<= elements to check and returned one visible element");
		int count = 0;
		WebElement uniqueWebElement = null;

		for (WebElement webElement : webElements) {
			try {
				log.info("element " + webElement.getTagName() + " " + webElement.getAttribute("type") + ", displayed: " + webElement.isDisplayed() + ", css-display:" + webElement.getCssValue("display"));
				if (webElement.isDisplayed() 
						|| (webElement.getTagName().equalsIgnoreCase("input")
								&& (webElement.getAttribute("type").equalsIgnoreCase("radio") 
										|| webElement.getAttribute("type").equalsIgnoreCase("checkbox"))
								&& !webElement.getCssValue("display").equalsIgnoreCase("none"))) {
					if (uniqueWebElement == null) {
						count += 1;
						uniqueWebElement = webElement;
					} else {
						if (!(uniqueWebElement == webElement)) {
							log.info("duplicate element pointing to original");
						} else {
							count += 1;
						}
					}
				}
			} catch (Exception e) {
				log.info("Received error when checking whether element was displayed");
				log.info(e.getStackTrace());
			}
		}

		if (count == 0) {
			log.error("Did not get any elements from list when expected to return 1 visible element");
			throw new Exception("Did not get any elements from list when expected to return 1 visible element");
		} else {
			if (count > 1) {
				log.error("Got more than 1 displayed element - Which one do you want me to use? " + count);
				throw new Exception("Got more than 1 displayed element - Which one do you want me to use? " + count);
			}
		}
		log.info("Received =>" + webElements.size() + "<=: 1 visible element returned");
		return uniqueWebElement;

	}

	public void element_byText_hasClass(String text, String containsClass) throws Exception {
		log.info("Going to check whether =>" + text + "<= has class =>" + containsClass);
		return_oneVisibleFromList(driver.findElements(By.xpath(
				"//*[text()[(normalize-space(.)='" + text + "')] and contains(@class ,\"" + containsClass + "\")]")));
	}

	public void elementByLabelHasClass(String labelText, String containsClass) throws Exception {
		log.info("Going to check whether =>" + labelText + "<= has class =>" + containsClass);
		String elementClass = findInputFieldByLabelText(labelText).getAttribute("className");
		log.info("Field has class =>" + elementClass);
		Assertions.assertTrue(elementClass.toLowerCase().contains(containsClass.toLowerCase()),
				"Class does not contain the class expected " + containsClass + " in " + elementClass);
		log.info("Class found ok for element");
	}

	public void confirmButtonByText_isDisabled(String arg1) throws Exception {
		WebElement button = driver.findElement(By.xpath("//button[text()[(normalize-space(.)='" + arg1 + "')]]"));
		
		if (button.isDisplayed()) {
			if (!button.isEnabled()) {
				log.info("Button with text =>" + arg1 + "<= is disabled & displayed");
				return;
			} else {
				log.info("button is displayed but not disabled =>" + arg1);
				if (button.getAttribute("class").contains("disabled")) {
					log.info("Button with text =>" + arg1 + "<= is displayed and class contains 'disabled'");
					return;
				}
			}
			throw new Exception("Button is displayed with text =>" + arg1 + " BUT NOT disabled");
		}
		throw new Exception("Button is not displayed with text =>" + arg1);
	}

	public void confirmElementByLabelIsDisabled(String label) throws Exception {
		log.info("about to verify that field accessed by lable text is displayed but not enabled >"+label);
		WebElement webElement = find_inputBy_labelName(label);
		if (!webElement.isEnabled() 
				&& (webElement.isDisplayed() 
						|| (webElement.getTagName().equalsIgnoreCase("input")
								&& (webElement.getAttribute("type").equalsIgnoreCase("radio") 
										|| webElement.getAttribute("type").equalsIgnoreCase("checkbox"))
								&& !webElement.getCssValue("display").equalsIgnoreCase("none")))) {
			log.info("webElement with label =>" + label + "<= is disabled & displayed");
			return;
		}
		throw new Exception("webElement is enabled or not displayed with label =>" + label);
	}

	public void confirmElementByLabelIsEnabled(String label) throws Exception {
		WebElement webElement = find_inputBy_labelName(label);
		if (webElement.isEnabled() 
				&& (webElement.isDisplayed() 
						|| (webElement.getTagName().equalsIgnoreCase("input")
								&& (webElement.getAttribute("type").equalsIgnoreCase("radio") 
										|| webElement.getAttribute("type").equalsIgnoreCase("checkbox"))
								&& !webElement.getCssValue("display").equalsIgnoreCase("none")))) {
			log.info("webElement with label =>" + label + "<= is enabled & displayed");
			return;
		}
		throw new Exception("webElement is not enabled or not displayed with label =>" + label);
	}

	public void textHas_HTMLAttribute_as(String text, String attribute, String attribute_value) throws Exception {
		WebElement element = find_inputBy_labelName(text);
		Assertions.assertEquals(attribute_value, element.getAttribute(attribute));

		log.info("Element with text =>" + text + "<= has attribute =>" + attribute + "<= with value =>"
				+ attribute_value + "<= as expected");

	}

	public void hoverOverText_seeText(String hoverOverText, String hoverText) {
		WebElement findText = driver.findElement(By.xpath("//*[text()[(normalize-space(.)='" + hoverOverText + "')]]"));

		Actions builder = new Actions(driver);
		builder.moveToElement(findText).build().perform();
		log.info("Hovered over element with text =>" + hoverOverText);

		String actualTooltipText = driver.findElement(By.xpath("//mat-tooltip-component//div")).getText();

		Assertions.assertTrue(hoverText.equals(actualTooltipText), "Expected: " + hoverText + " but actual: " + actualTooltipText);
		log.info("Tool tip text matched =>" + hoverText + "<= for element =>" + hoverOverText);
	}
	
	public int getNumberShowing() {
		try {
			String pagesText = driver.findElement(By.xpath("//*[starts-with(normalize-space(text()),'Showing 1 to ')]")).getText();
			log.info("Found: " + pagesText);
			int maxCount = getCount(pagesText, "of", "entries");
				return maxCount;
		} catch (Exception e) {
			if (driver.findElements(By.xpath("//*[contains(normalize-space(text()), 'Showing 0 to 0 of 0 entries')]")).isEmpty())
				return 0;
		}
		Assertions.fail("No text showing number found");
		return 0;
	}
	
	public int getNumberOfPagesShowing() throws Exception {
		try {
			String pagesText = driver.findElement(By.xpath("//*[starts-with(normalize-space(text()),'Showing 1 to ')]")).getText();
			log.info("Found: " + pagesText);
			int firstCount = getCount(pagesText, "Showing 1 to", "of");
			int maxCount = getCount(pagesText, "of", "entries");
			int pages = (firstCount + maxCount - 1) / firstCount;
			log.info("Number of pages in " + firstCount + " to " + maxCount + " =>" + pages);
				return pages;
					
		} catch (Exception e) {
			if (driver.findElements(By.xpath("//*[contains(normalize-space(text()), 'Showing 0 to 0 of 0 entries')]")).isEmpty())
				return 0;
		}
		log.error("No text showing number found");
		throw new Exception("No text showing number found");
	}

	public int getCount(String text) {
		return getCount(text, "(", ")");
	}
	
	public int getCount(String text, String delim1, String delim2) {
		int count = Integer.parseInt(getTextBetweenDelimiter(text, delim1, delim2).trim());
		return count;
	}

	public String getTextBetweenDelimiter(String text, String delim1, String delim2) {
		log.info("about to extract text delimited by =>" + delim1 + "<= and =>" + delim2 + "<= from text =>" + text);
		String extract = "";
		try {
			String [] text1 = text.split(delim1);
			if (text1.length > 1) {
				String [] text2 = text1[1].trim().split(delim2);
				if (text2.length > 0) {
					extract = text2[0].trim();
				} else {
					log.warn("no data when removing second delimiter" + delim2 + " from " + text1[1]);
				}
			} else {
				log.warn("no data when removing first delimiter" + delim1 + " from " + text);
			}
		} catch (Exception e1) {
			log.error("Error extracting count from text");
		};
		log.info("extracted string =>"+extract);
		return extract;
	}

	public int click_tabByText(String string) {
		log.info("about to click on tab by text =>"+string);
		int count = 0;
		WebElement tab = null;
		String label = "";
		By by = By.xpath("//li//*[contains(text(),'"+string+"')]");
		try { 
			tab = driver.findElement(by);
			label = tab.getText();
			tab.click();
			count = getCount(label);
		} catch (Exception e2) {
			log.warn("Required second try to click on tab");
			waitForPageLoad();
			tab = driver.findElement(by);
			label = tab.getText();
			tab.click();
		}
		log.info("clicked on tab by text; count =>"+count); 
		waitForBrowserReadyState();
		return count;
	}

	public void seeText_inSameRow_asText(String searchText, String nextToText) throws Exception {
		log.info("About to look for text =>"+searchText+"<= in the same row as =>"+nextToText);
		String substitutedValue = Substitutions.substituteValue(searchText);
		nextToText = Substitutions.substituteValue(nextToText);
		driver.findElement(
				By.xpath(
						"//table//tr[.//*[contains(normalize-space(text()),\""+substitutedValue+"\")]]//*[text()[contains(normalize-space(.), \""+nextToText+"\")]]"
						+ " | "
						+ "//table//tr[.//*[contains(text(),\""+nextToText+"\")]]//*[text()[contains(., \""+substitutedValue+"\")]]"
						+ " | "
						+ "//dl//div//*[contains(text(),\""+nextToText+"\")]//ancestor::div[@class='govuk-summary-list__row']//*[text()[contains(., \""+substitutedValue+"\")]]"
						+ " | "
						+ String.format(
							"//*[.//*[contains(normalize-space(text()),\"%s\")]]//*[contains(normalize-space(text()),\"%s\")]",
							nextToText, substitutedValue)
						+ " | "
						+ String.format(
							"//*[.//*[text()[contains(normalize-space(.),\"%s\")]]]//*[text()[contains(normalize-space(.),\"%s\")]]",
							nextToText, substitutedValue)
					));
		log.info("Found text =>"+substitutedValue+"<= in the same row as =>"+nextToText);		
	}
	
	public void clickText_inSameRow_asText(String clickText, String nextToText) throws Exception {
		log.info("Going to click on text =>"+clickText+"<= in a row that contains text =>"+nextToText);
		clickText = Substitutions.substituteValue(clickText);
		nextToText = Substitutions.substituteValue(nextToText);
		wait.activateImplicitWait();
		/**
		 * 
		 * TODO - Refactor this block
		 */
		WebElement click_text = driver.findElement(
				By.xpath(
						"//table//tr//td[contains(text(),\""+nextToText+"\")]//ancestor::tr//td[text()[contains(., \""+clickText+"\")]]"
								+ "|"
						+ "//table//tr//td//a[contains(text(),\""+nextToText+"\")]//ancestor::tr//td//a[text()[contains(., \""+clickText+"\")]]"
								+ "|"
						+ "//table//tr//td[contains(text(),\""+nextToText+"\")]//ancestor::tr//td//a[text()[contains(., \""+clickText+"\")]]"
								+ "|"
						+ "//table//tr//*[contains(text(),\""+nextToText+"\")]//ancestor::tr//a[text()[contains(., \""+clickText+"\")]]"
								+ "|"
						+ "//dl//div//*[contains(text(),\""+nextToText+"\")]//ancestor::div[@class='govuk-summary-list__row']//a[text()[contains(., \""+clickText+"\")]]"
				+ ""));
		
		wait.waitForClickableElement(click_text);
		click_onElement(click_text);
		waitForBrowserReadyState();
		log.info("Clicked on =>"+clickText+"<= successfully");
	}

	public void clickOnElementWithId(String id) {

		WebElement element = driver.findElement(By.id(id));
		wait.waitForClickableElement(element);
		click_onElement(element);
		waitForBrowserReadyState();
		log.info("Clicked on element with id =>"+id+"<= successfully");
	}
	
	public void clickOnLink_forLabel(String linkText, String text) {
		log.info("On label with text =>"+text+"<= about to click on link =>"+linkText);
		wait.activateImplicitWait();
		WebElement summary = driver.findElement(By.xpath(String.format(
				"//div[./dl//dd/descendant-or-self::*[text()[normalize-space(.)=\"%s\"]]]//a[text()[normalize-space(.)=\"%s\"]]"
				, text, linkText)));
		log.info("Found text =>"+text);
		summary.click();
		waitForBrowserReadyState();
		log.info("Under text =>"+text+"<= clicked on link =>"+linkText);
	    
	}

	public void verifyErrorMessage (String message) {
		try {
			driver.findElement(By.xpath(String.format(
					"//div[./h2[text()[contains(., \"There is a problem\")]]]//li/*[text()[contains(., \"%s\")]]",
					message
					)));
			log.info("Found error message =>"+message);
		} catch (Exception e) {
			Assertions.fail("Expected Error message DOES NOT exist =>"+message);
		}
	};

	public void verifyNoErrorMessage (String message) {
		if (message.equals("")) {
			Assertions.assertTrue(driver.findElements(By.xpath("//div[./h2[text()[contains(., \"There is a problem\")]]]")).size()==0,
					"Error message exists when not expected");
		} else {
			Assertions.assertTrue(driver.findElements(By.xpath(String.format(
							"//div[./h2[text()[contains(., \"There is a problem\")]]]//li/*[text()[contains(., \"%s\")]]",
							message))).size()==0,
							"Error message exists when not expected =>"+message);
		}
		log.info("Error message does not exist - as expected =>"+message);
	};
	
	public void clearInputField(WebElement webElement) {
		webElement.click(); 
		log.info("About to clear field");
		if (webElement.getAttribute("value").length() == 0) {
			try {
				webElement.sendKeys(Keys.SPACE);
			} catch (Exception e1) {
				try {
					webElement.sendKeys("1");
				} catch (Exception e2) {
					webElement.sendKeys("a");
				}
			}
		}
		webElement.sendKeys(Keys.END);
		while (webElement.getAttribute("value").length() > 0) {
			webElement.sendKeys(Keys.BACK_SPACE);
		}
		waitForBrowserReadyState();
	}
	
	public void clearInputFieldByLabelText(String labelText) throws Exception {
		log.info("About to clear field with label =>" + labelText);
		WebElement targetElement = findInputFieldByLabelText(labelText);
		clearInputField(targetElement);
		log.info("field cleared =>" + labelText);
	}
	
	public WebElement findFieldByLabelInLocation(String location, String labelText) throws Exception {
		log.info("About to find field in =>" + location + "<= with label =>" + labelText + "<=");

		WebElement targetElement = driver.findElement(By.xpath(String.format(
				"//input[@id=(//*[./*[normalize-space(.)=\"%s\"]]//*[normalize-space(.)=\"%s\"]/@for)]",
				location, labelText)));
		log.info("Located field in =>" + location + "<= with label =>" + labelText + "<=");
		return targetElement;
	}
	
	public WebElement clearInputFieldByLabelTextInLocation(String location, String labelText) throws Exception {
		log.info("About to Clear input field in =>" + location + "<= with label =>" + labelText + "<=");
		WebElement targetElement = findFieldByLabelInLocation(location, labelText);
		clearInputField(targetElement);
		log.info("Cleared input field in =>" + location + "<= with label =>" + labelText + "<=");
		return targetElement;
	}

	public WebElement setValueByLabelInLocationTo(String location, String labelText, String value) throws Exception {
		log.info("About to Set input field in =>" + location + "<= with label =>" + labelText + "<= to =>" + value);
		WebElement targetElement = findFieldByLabelInLocation(location, labelText);
		String substitutedValue = setElementValueTo(targetElement, value);
		log.info("Set input field in =>" + location + "<= with label =>" + labelText + "<= to =>" + substitutedValue);

		return targetElement;
	}

	public String getValueByLabelInLocationTo(String location, String labelText) throws Exception {
		String value = "";
		log.info("About to Get input field in =>" + location + "<= with label =>" + labelText + "<=");
		WebElement targetElement = findFieldByLabelInLocation(location, labelText);

		value = targetElement.getAttribute("value");
		log.info("Value of field in =>" + location + "<= with label =>" + labelText + "<= is =>" + value);

		return value;
	}

	public void verifyValueByLabelInLocation(String location, String labelText, String expected) throws Exception {
		log.info("About to verify input field in =>" + location + "<= with label =>" + labelText + "<= is =>" + expected);
		String value = getValueByLabelInLocationTo(location, labelText);

		log.info("Value of field in =>" + location + "<= with label =>" + labelText + "<= is =>" + value);
		Assertions.assertTrue(Substitutions.substituteValue(expected).equals(value), "Text value =>"+value+"<= does not match expected =>");
	}
	
	public WebElement findFieldByFirstLabelFollowingText(String location, String labelText) throws Exception {
		log.info("About to find first field following =>" + location + "<= with label =>" + labelText + "<=");

		WebElement targetElement = driver.findElement(By.xpath(String.format(
				"//input[@id=(//*[normalize-space(.)=\"%s\"]/following::label[normalize-space(.)=\"%s\"][1]/@for)]",
				location, labelText)));
		log.info("Located first for field following =>" + location + "<= with label =>" + labelText + "<=");
		return targetElement;
	}

	public WebElement setValueByFirstLabelFollowingText(String location, String labelText, String value) throws Exception {
		log.info("About to Set input first field following =>" + location + "<= with label =>" + labelText + "<= to =>" + value);
		WebElement targetElement = findFieldByFirstLabelFollowingText(location, labelText);
		String substitutedValue = setElementValueTo(targetElement, value);
		log.info("Set first input field following =>" + location + "<= with label =>" + labelText + "<= to =>" + substitutedValue);
		return targetElement;
	}

	public void VerifyDropdownValue(String expectedOptionValue, String labelText) throws Exception {
		String elementType = find_inputBy_labelName(labelText).getTagName(); 
		log.info("select element type is >"+elementType);
		if (elementType.equalsIgnoreCase("select")) {
			WebElement child = find_locationParent(labelText).findElement(By.cssSelector("select"));
	
			log.info("Found dropdown with name =>" + labelText);
			log.info("Expected Value =>"+expectedOptionValue+"<=");
	
			Select select = new Select(child);
	
			String selectedValue = select.getFirstSelectedOption().getText().trim();
			log.info("Actual Value   =>"+selectedValue+"<=");
			Assertions.assertTrue(expectedOptionValue.equals(selectedValue), "Dropdown value not as expected "+labelText);
			log.info("Selected dropdown=>" + labelText + "<= has correct value selected =>" + expectedOptionValue);
		} else {
			compare_valueTo(labelText, expectedOptionValue);
		}
		
	}


	public void text_hasClass(String text, String className) {
		driver.findElement(By.xpath("//*[text()[contains(.,'"+text+"')] and contains(@class, '"+className+"')]"));

		log.info("Found li element which has text =>"+text+"<= with class =>"+className);
	}

	public void compareDropdownData(String label_Name, List<String> dropdownList) throws Exception {
		int errorCount = 0;
		List<WebElement> options = new ArrayList<WebElement>();
		WebElement dropdown =  find_inputBy_labelName(label_Name);
		if (dropdown.getTagName().equalsIgnoreCase("select")) {
			log.info("Found dropdown with name =>" + label_Name);
			Select select = new Select(dropdown);
			options = dropdown.findElements(By.tagName("option"));
		} else {
			log.error("Select element cannot be found with label {} ",label_Name);
		}

		for (int dropdownIndex = 0; dropdownIndex < dropdownList.size(); dropdownIndex++) {
			String actualText = options.get(dropdownIndex).getText();
			String expectedText = dropdownList.get(dropdownIndex);

			if (!expectedText.equals(actualText)) {
				log.error("Value mismatch at index {}:: Expected: '{}', Actual: '{}'", dropdownIndex, expectedText, actualText);
				errorCount++;
			} else {
				log.info("Values match at index {}:: Expected: '{}', Actual: '{}'", dropdownIndex, expectedText, actualText);
			}
		}
		log.info("Dropdown has {} error count", errorCount);
		Assertions.assertEquals(0, errorCount);
	}

}
