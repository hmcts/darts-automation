package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.java.en.Given;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;
import uk.gov.hmcts.darts.automation.utils.ReadProperties;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import uk.gov.hmcts.darts.automation.utils.Login;

public class StepDef_login extends StepDef_base{
    private static Logger log = LogManager.getLogger("StepDef_login");
    public Login login;
    private WaitUtils WAIT;

    public StepDef_login(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
        login = new Login(webDriver);
        WAIT = new WaitUtils(webDriver);
    }

    @Given("I am logged on to DARTS as an/a {word} user")
    public void logonInternal(String type) throws Exception {
        NAV.navigateToUrl(ReadProperties.main("portal_url"));
        NAV.waitForBrowserReadyState();
        WAIT.waitForTextOnPage("I have an account for DARTS through my organisation.");
        WAIT.waitForTextOnPage("except where otherwise stated");
        switch (type.toUpperCase()) {
            case "EXTERNAL":
                login.loginToPortal_ExternalUser(ReadProperties.automationUserId,ReadProperties.automationPassword);
                break;
            case "TRANSCRIBER":
                login.loginToPortal_ExternalUser(ReadProperties.automationTranscriberUserId, ReadProperties.automationExternalPassword);
                break;
            case "LANGUAGESHOP":
                login.loginToPortal_ExternalUser(ReadProperties.automationLanguageShopTestUserId, ReadProperties.automationExternalPassword);
                break;
            case "REQUESTER":
                login.loginToPortal_InternalUser(ReadProperties.automationRequesterTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "APPROVER":
                login.loginToPortal_InternalUser(ReadProperties.automationApproverTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "JUDGE":
                login.loginToPortal_InternalUser(ReadProperties.automationJudgeTestUserId, ReadProperties.automationInternalUserTestPassword);
                break;
            case "APPEALCOURT":
                login.loginToPortal_InternalUser(ReadProperties.automationAppealCourtTestUserId, ReadProperties.automationInternalUserTestPassword);
            default:
                log.fatal("Unknown user type - {}"+ type.toUpperCase());
        }

    }

}
