package uk.gov.hmcts.darts.automation.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Credentials {
	private static Logger log = LogManager.getLogger("Credentials");
	
	static public String userName(String type) {
	    switch (type.toUpperCase()) {
	    case "EXTERNAL":
	        return ReadProperties.automationUserId;
	    case "TRANSCRIBER":
	        return ReadProperties.automationTranscriberUserId;
	    case "LANGUAGESHOP":
	        return ReadProperties.automationLanguageShopTestUserId;
	    case "REQUESTER":
	        return ReadProperties.automationRequesterTestUserId;
	    case "APPROVER":
	        return ReadProperties.automationApproverTestUserId;
	    case "REQUESTERAPPROVER":
	        return ReadProperties.automationRequesterApproverTestUserId;
	    case "JUDGE":
	        return ReadProperties.automationJudgeTestUserId;
	    case "APPEALCOURT":
	        return ReadProperties.automationAppealCourtTestUserId;
	    case "ADMIN":
	        return ReadProperties.dartsAdminUserName;
	    case "SUPERUSER":
	        return ReadProperties.dartsSuperUserUserName;
	    default:
	        log.fatal("Unknown user type - {}" + type.toUpperCase());
	        return null;
	    }
	}
	
	static public String password(String type) {
	    switch (type.toUpperCase()) {
	    case "EXTERNAL":
	        return ReadProperties.automationPassword;
	    case "TRANSCRIBER":
	        return ReadProperties.automationExternalPassword;
	    case "LANGUAGESHOP":
	        return ReadProperties.automationExternalPassword;
	    case "REQUESTER":
	        return ReadProperties.automationInternalUserTestPassword;
	    case "APPROVER":
	        return ReadProperties.automationInternalUserTestPassword;
	    case "REQUESTERAPPROVER":
	        return ReadProperties.automationRequesterApproverTestPassword;
	    case "JUDGE":
	        return ReadProperties.automationInternalUserTestPassword;
	    case "APPEALCOURT":
	        return ReadProperties.automationInternalUserTestPassword;
	    case "ADMIN":
	        return ReadProperties.automationExternalPassword;
	    case "SUPERUSER":
	        return ReadProperties.automationExternalPassword;
	    default:
	        log.fatal("Unknown user type - {}" + type.toUpperCase());
	        return null;
	    }
	}
}
