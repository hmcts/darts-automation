package uk.gov.hmcts.darts.automation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.GenUtils;

public class Login {

    private static Logger log = LogManager.getLogger("login");
    private WebDriver webDriver;
    private NavigationShared NAV;
    private WaitUtils WAIT;
    private GenUtils GEN;

    public Login(WebDriver driver) {
        this.webDriver = driver;
        NAV = new NavigationShared(webDriver);
        WAIT = new WaitUtils(webDriver);
        GEN = new GenUtils(webDriver);
    }

    public void loginToPortal_ExternalUser(String username, String password) throws Exception {
        NAV.waitForPageLoad();
        NAV.checkRadioButton("I work with the HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("This sign in page is for users who do not work for HMCTS.");
        NAV.set_valueTo("Enter your email", username);
        NAV.set_valueTo("Enter your password", password);
        NAV.press_buttonByName("Continue");
    }

    public void loginToPortal_InternalUser(String username, String password) throws Exception {
        NAV.waitForPageLoad();
        NAV.checkRadioButton("I'm an employee of HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.waitForBrowserReadyState();
        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Email address, phone number or Skype"), username);
        NAV.press_buttonByName("Next");
        NAV.setElementValueTo(GEN.lookupWebElement_byPlaceholder("Password"), password);
        NAV.press_buttonByName("Sign in");
        NAV.press_buttonByName("No");
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("except where otherwise stated");
    }
}
