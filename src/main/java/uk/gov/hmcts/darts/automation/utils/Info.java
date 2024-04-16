package uk.gov.hmcts.darts.automation.utils;

import java.util.Iterator;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.JOptionPane;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Action;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.Select;

	class PromptForInput {
		private static class StaticPrompt {
			private static BufferedReader br = null;
	//		private boolean needInit = true;

			public StaticPrompt() {
				br = new BufferedReader(new InputStreamReader(System.in));	
			}
	//		public void init() {
	//			br = new BufferedReader(new InputStreamReader(System.in));	
	//		}

			public String getInput(String caption) {
				String inString;
	//			if (needInit) {init();};
				System.out.println(caption);
				try {
					inString = br.readLine();
				} catch (IOException e) {
					inString = "?";
					e.printStackTrace();
				} finally {
				}
				System.out.println("input: " + inString);
				return inString;
			}

			public void close() {
				try { 
					br.close(); 
				} catch (IOException e) { 
					e.printStackTrace(); 
				}
			}

		}
		private static StaticPrompt staticPrompt; 
		public PromptForInput() {
			staticPrompt = new StaticPrompt();
		}

		public String getInput(String caption) {
			return staticPrompt.getInput(caption);
		}

		public void close() {
			staticPrompt.close();
		}
	}

public class Info {
	protected PromptForInput prompt;
	private WebDriver driver;
	private static Logger log = LogManager.getLogger("Info");
	
	public Info(WebDriver driver) {
		this.driver = driver;
		prompt = new PromptForInput();
	}
	
	void showText(String caption, String text) {
		if (!text.equals("") && !text.equals("null")) {
			System.out.println(caption + ":" + "            >".substring(caption.length()) + text + "<");
		}
	}
	
	void showAttribute(WebElement webElement, String attribute) {
		showText(attribute, ""+webElement.getAttribute(attribute));
	}
	
	private void printDetails(WebElement webElement) {
		showText("tag", webElement.getTagName());
		showText("displayed", ""+webElement.isDisplayed());
		showText("enabled", ""+webElement.isEnabled());
		showAttribute(webElement, "id");
		showAttribute(webElement, "name");
		showAttribute(webElement, "type");
		showAttribute(webElement, "text");
		showText("text", webElement.getText());
		showAttribute(webElement, "for");
		if (webElement.getTagName().equalsIgnoreCase("img")) {
			showAttribute(webElement, "src");
		}
		if (webElement.getTagName().equalsIgnoreCase("input") 
				&& (webElement.getAttribute("type").equalsIgnoreCase("checkbox") 
						|| webElement.getAttribute("type").equalsIgnoreCase("radio"))) {
			showAttribute(webElement, "selected");
		}
		showAttribute(webElement, "class");
		showAttribute(webElement, "style");
		showAttribute(webElement, "css");
	}
	
	public void actionClick(WebElement webElement) {
		if (webElement != null) {
			Actions actions = new Actions(driver);
			actions.click(webElement).perform();
		} else {
			System.out.println("element not found for click using action ");
		}
	}
	
	public void hoverOver(WebElement webElement) {
		if (webElement != null) {
			try {
				Actions actions = new Actions(driver);
				actions.moveToElement(webElement, 0, 0).perform();
			} finally {
				
			}
		} else {
			System.out.println("element not found for hover ");
		}
	}
	
	private void doAction(By by) {
		System.out.println(by.toString());
		List<WebElement> webElements = driver.findElements(by);
		actionResults(webElements, by);
	}
	
	private void doNextAction(WebElement webElement, By by) {
		System.out.println(by.toString());
		List<WebElement> webElements = webElement.findElements(by);
		actionResults(webElements, by);
	}
		
	private void actionResults(List<WebElement> webElements, By by) {
		WebElement webElement = null;
		int i = webElements.size();
		if (i == 0) {
			System.out.println("not found");
		} else {
			if (i==1) {
				webElement = driver.findElement(by);
			} else {
				webElement = 	displayList(webElements);
			}
			if (webElement == null) {
				System.out.println("no visible elements");
				webElement = webElements.get(0);
			} // else {
			try {
				Actions actions = new Actions(driver);
				Action mouseOver = actions
						.moveToElement(webElement, 0, 0)
						.build();
				mouseOver.perform();
			} catch (Exception e) {
				System.out.println("Exception moving to element");
			}
			printDetails(webElement);
			String action = prompt.getInput("action?");
			while (!action.equals("")) {
				try {
					switch (action.toLowerCase().trim()) {
					case "click":
					case "c":
						String currentSelection = "" + webElement.isSelected();
						webElement.click();
						System.out.println("IsSelected: " + currentSelection + " -> " + webElement.isSelected());
						break;
					case "ac":
						actionClick(webElement);
						System.out.println("IsSelected: " + webElement.isSelected());
						break;
					case "text":
					case "t":
					case "value":
					case "v":
					case "input":
					case "i":
		//				webElement.click();
						webElement.sendKeys(prompt.getInput("value?"));
						break;
					case "h":
					case "hover":
						hoverOver(webElement);
						break;
					case "":
						System.out.println("No action ");
						break;
					case "s":
						Select select = new Select(webElement);
						select.selectByVisibleText(prompt.getInput("value?"));
						break;
					case "a":
					case "attribute":
						System.out.println(webElement.getAttribute(prompt.getInput("value?")));
						break;
					case "css":
						System.out.println(webElement.getCssValue(prompt.getInput("css attribute?")));
						break;
					case "js":
						executeJavaScript(prompt.getInput("javascript code:"), webElement);
						break;
					case "hi":
					case "highlight":
					case "hilite":
						executeJavaScript("arguments[0].setAttribute('style', 'background: yellow; border: 2px solid red;');", webElement);
						break;
					case "clear":
						webElement.clear();
					case "x":
					case "xpath":
						doNextAction(webElement, By.xpath(prompt.getInput("xpath")));
						break;
					default:
						System.out.println("unknown action " + action);
					}
				} catch (Exception e) {
					System.out.println("exception carrying out action " + action);
					e.printStackTrace();
				}
				action = prompt.getInput("action?");
			}
//			}
		}
	}

	
	private void doList(String inputData) {
		List<WebElement> webElements = driver.findElements(By.tagName(inputData));
		displayList(webElements);
	}
	
	private WebElement displayList(List<WebElement> webElements) {
		int i = webElements.size();
		WebElement returnElement = null;
        if (i > 0) {
//	        Iterator<WebElement> it = webElements.iterator();
	        System.out.println("No of elements: " + i);
	        i = 0;
//	        while(it.hasNext()) {
	        for (WebElement webElement : webElements) {
//	            WebElement e = it.next();
	            System.out.println("Element " + ++i + ":");
				printDetails(webElement);
				if (returnElement == null && webElement.isDisplayed() && webElement.isEnabled()) {
					returnElement = webElement;
				}
	        }
		} else {
			System.out.println("Element not found: ");
		}
        return returnElement;
	}
	
	private void switchToWindow(String window) {
		if (window.isEmpty()) {
			driver.switchTo().defaultContent();
		} else {
			driver.switchTo().window(window);
		}
	}
	
	private void switchToFrame(String frame) {
		if (frame.isEmpty()) {
			driver.switchTo().defaultContent();
		} else {
			if (frame.length() == 1) {
				driver.switchTo().frame(Integer.getInteger(frame));
			} else {
				driver.switchTo().frame(frame);
			}
		}
	}
	
	private void executeJavaScript(String javascript) {
		JavascriptExecutor jse= (JavascriptExecutor) driver;
		String jsVal = (String) jse.executeScript(javascript);
		System.out.println(jsVal);
	}
	
	private void executeJavaScript(String javascript, WebElement webElement) {
		JavascriptExecutor jse= (JavascriptExecutor) driver;
		String jsVal = (String) jse.executeScript(javascript, webElement);
		System.out.println(jsVal);
	}

	public void tryInput() {
		String choice = prompt.getInput("?");
		while (!choice.equalsIgnoreCase("End") && !choice.equalsIgnoreCase("Exit")) {
			try {
				switch(choice.trim().toLowerCase()) { 
				case "x":
				case "xpath":
					doAction(By.xpath(prompt.getInput("xpath")));
					break;
				case "i":
				case "id":
					doAction(By.id(prompt.getInput("id")));
					break;
				case "c":
				case "css":
					doAction(By.cssSelector(prompt.getInput("css")));
					break;
				case "n":
				case "name":
					doAction(By.name(prompt.getInput("name")));
					break;
				case "lt":
				case "linktext":
					doAction(By.linkText(prompt.getInput("link text")));
					break;
				case "plt":
				case "partiallinktext":
					doAction(By.partialLinkText(prompt.getInput("partial link text")));
					break;
				case "l":
				case "list":
				case "tag":
					doList(prompt.getInput("Element type"));
					break;
				case "f":
				case "frame":
					switchToFrame(prompt.getInput("Frame name/Id"));
					break;
				case "w":
				case "window":
					switchToWindow(prompt.getInput("Window name/Id"));
					break;
				case "wh":
				case "winhandles":
					for(String winHandle : driver.getWindowHandles()) {
						System.out.println("winhandle: " + winHandle);
					}
					break;
				case "js":
					executeJavaScript(prompt.getInput("javascript code:"));
					break;
				default:
					System.out.println(choice + " not recognised");
				}
			} catch (Exception e) {
				System.out.println("failed");
				e.printStackTrace();
			} finally {

			}
			choice = prompt.getInput("?");
		}
	}
	
	public void displayPopup(String message, String title) {
		JOptionPane.showMessageDialog(null, message, title, JOptionPane.PLAIN_MESSAGE);
	}
	
	public void displayPopup(String message) {
		displayPopup(message, "Automation message");
	}
	
	public void displayPopup() {
		log.info("Display Popup =>");
		displayPopup("Automation waiting", "Automation message");
	}
    
	public void doSomething() {
		log.info("Going to do something");
		log.info("windows =>"+driver.getWindowHandles());
//		if (ReadProperties.main("Debug").toUpperCase().equals("Y")) {
			JOptionPane.showMessageDialog(null, "Do actions", "Manual intervention required", JOptionPane.PLAIN_MESSAGE);
//		}
	}
    
	public void doSomething(String whatever) {
    	log.info("Going to do something =>"+whatever);
		log.info("windows =>"+driver.getWindowHandles());
//		if (ReadProperties.main("Debug").toUpperCase().equals("Y")) {
			JOptionPane.showMessageDialog(null, whatever, "Manual intervention required", JOptionPane.PLAIN_MESSAGE);
//		}
	}
    
	public String inputDialog(String message) {
		String returnString = "";
    	log.info("Going to get input =>"+message);
    	returnString = JOptionPane.showInputDialog(message);
    	log.info("Got input at =>"+message+"<= value =>"+returnString);
    	return returnString;
	}
}
