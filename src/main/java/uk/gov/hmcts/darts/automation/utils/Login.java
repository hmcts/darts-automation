package uk.gov.hmcts.darts.automation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;

public class Login {

    private static Logger log = LogManager.getLogger("login");
    private WebDriver webDriver;
    private NavigationShared NAV;

    public Login(WebDriver driver) {
        this.webDriver = driver;
        NAV = new NavigationShared(webDriver);
    }

    public void loginToPortal_ExternalUser(String username, String password) throws Exception {
        NAV.checkRadioButton("I work with the HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.set_valueTo("Enter your email", username);
        NAV.set_valueTo("Enter your password", password);
        NAV.press_buttonByName("Continue");
    }

    public void loginToPortal_InternalUser(String username, String password) throws Exception {
        NAV.checkRadioButton("I'm an employee of HM Courts and Tribunals Service");
        NAV.press_buttonByName("Continue");
        NAV.set_valueTo("Enter your email", username);
        NAV.set_valueTo("Enter your password", password);
        NAV.press_buttonByName("Continue");
    }
}
