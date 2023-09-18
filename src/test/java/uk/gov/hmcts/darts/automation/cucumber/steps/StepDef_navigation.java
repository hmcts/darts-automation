package uk.gov.hmcts.darts.automation.cucumber.steps;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

//import io.cucumber.PendingException;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDef_navigation extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_navigation");
//	private final WebDriver webDriver;
	
	
	public StepDef_navigation(SharedDriver driver, TestData testdata, NavigationShared ns) {
		super(driver, testdata, ns);
	}
	
	
	@When("^I see \"([^\"]*)\" on the page$")
	public void text_on_page_check(String arg1) throws Exception {
	    try {
	    	NAV.textPresentOnPage(arg1);
	    } catch (AssertionError | Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.textPresentOnPage(arg1);
	    }
	}
	
	@When("^I do not see \"([^\"]*)\" on the page$")
	public void text_not_on_page_check(String arg1) throws Exception{
		try {
			NAV.textNotPresentOnPage(arg1);
		} catch (Exception e) {
			NAV.textNotPresentOnPage(arg1);
		}
	}
	
	@When("^I press the \"([^\"]*)\" button on my browser$")
	public void forward_back_button(String arg1) throws Exception {
	    NAV.press_navigationButton(arg1);
	}
	
	@When("^I press the \"([^\"]*)\" button$")
	public void press_button(String arg1) throws Exception {
	    try {
	    	NAV.press_buttonByName(arg1);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.press_buttonByName(arg1);
	    }
	    NAV.waitForPageLoad(0, 5);
	}
	
	@When("^I expand the \"([^\"]*)\" accordion$")
	public void expandAccordian(String arg1) throws Exception {
//TODO Check on icon following this before & after click
	    try {
	    	NAV.press_buttonByName(arg1);
	    } catch (Exception e) {
			NAV.click_link_by_text(arg1);
	    }
	    NAV.waitForPageLoad(0, 5);
	}
	
	@When("^I click on the \"([^\"]*)\" accordion$")
	public void clickAccordian(String arg1) throws Exception {
//TODO Check on icon following this before & after click
	    try {
	    	NAV.press_buttonByName(arg1);
	    } catch (Exception e) {
			NAV.click_link_by_text(arg1);
	    }
	    NAV.waitForPageLoad(0, 5);
	}
	
	@When("^I set \"([^\"]*)\" to \"([^\"]*)\"$")
	public void set_value_to(String arg1, String arg2) throws Exception {
	    try {
	    	NAV.set_valueTo(arg1, arg2);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.set_valueTo(arg1, arg2);
	    }
	}
	
	@When("^I set \"([^\"]*)\" \"([^\"]*)\" to \"([^\"]*)\"$")
	public void set_value_to(String arg1, String arg2, String arg3) throws Exception {
    	NAV.set_valueTo(arg1, arg2, arg3);
	}
	
	@When("^I set \"([^\"]*)\" in \"([^\"]*)\" to \"([^\"]*)\"$")
	public void setValueByLabelInLocationTo(String label, String location, String value) throws Exception {
    	NAV.setValueByLabelInLocationTo(location, label, value);
	}
	
	@When("^I set select \"([^\"]*)\" to \"([^\"]*)\"$")
	public void set_select_value_to(String arg1, String arg2) throws Exception {
	    try {
	    	NAV.set_select_valueTo(arg1, arg2);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.set_select_valueTo(arg1, arg2);
	    }
	}
	
	@Then("^I can't set \"([^\"]*)\" to \"([^\"]*)\"$")
	public void set_value_to_Negative(String arg1, String arg2) throws Exception {
		// Performance Issue - To Review
	    try {
	    	NAV.set_valueTo(arg1, arg2);
	    	throw new AssertionError("I was able to set the value when not expected");
	    } catch (Exception e) {
	    }
	};
	
	@Then("^\"([^\"]*)\" is \"([^\"]*)\"$")
	public void compare_value_to(String label, String expected) throws Exception {
	    try {
	    	NAV.compare_valueTo(label, expected);
	    } catch (Exception e) {
	    	NAV.compare_valueTo(label, expected);
	    }
	}
	
	@When("^I refresh the page$")
	public void refreshPage() throws Exception {
	    NAV.refreshPage();
	}
	
	@When("^I check the \"([^\"]*)\" checkbox$")
	public void check_checkbox(String arg1) throws Exception {
	    try {
	    	NAV.check_checkbox(arg1);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.check_checkbox(arg1);
	    }
	}

	@When("^I click on the \"([^\"]*)\" navigation link$")
	public void clickOnNavigationLink(String linkText) throws Exception{
		NAV.clickOnNavigationLink(linkText);
	}
	
	@When("^I click on the \"([^\"]*)\" link$")
	public void click_link(String arg1) throws Exception{
		try {
			NAV.click_link_by_text(arg1);
		} catch (Exception e) {
			NAV.waitForPageLoad();
			NAV.click_link_by_text(arg1);
		}
	}
	
	@Then("^I do not see link with text \"([^\"]*)\"$")
	public void doNotSee_linkText(String arg1) {
		NAV.linkText_visible(arg1, false);
	}
	
	@Then("^I see link with text \"([^\"]*)\"$")
	public void doSee_linkText(String arg1) {
		NAV.linkText_visible(arg1, true);
	}
	
	@Then("^I see that \"([^\"]*)\" has \"([^\"]*)\" \"([^\"]*)\"$")
	public  void tableRow_isChecked_byColumn (String arg1, String arg2, String arg3) throws Exception {
		try {
			NAV.tableRow_isChecked_byColumn(arg1, arg2, arg3);
		} catch (Exception | AssertionError e) {
			NAV.waitForPageLoad();
			NAV.tableRow_isChecked_byColumn(arg1, arg2, arg3);
		}
	}
	
	@When("^I select \"([^\"]*)\" from the \"([^\"]*)\" dropdown$")
	public void select_fromDropdown(String option_value, String dropdown_name) throws Exception {
		try {
			NAV.select_fromDropdown(option_value, dropdown_name);
		} catch (Exception e) {
			NAV.waitForPageLoad();
			NAV.select_fromDropdown(option_value, dropdown_name);
		}
	}
	
	@Then("^I can't select \"([^\"]*)\" from the \"([^\"]*)\" dropdown$")
	public void select_fromDropdownNegative(String arg1, String arg2) {
		// Performance Issue - To Review
		try {
	    	NAV.select_fromDropdown(arg1, arg2);
	    	throw new AssertionError("I was able to select from the dropdown when not expected");	    	
	    } catch (Exception e) {}
	};
	
	@Then("^the \"([^\"]*)\" text has class \"([^\"]*)\"$")
	public void text_hasClass(String text, String className) {
	    NAV.text_hasClass(text, className);
	};
	
	@When("^I search for \"([^\"]*)\"$")
	public void searchFor(String arg1) {
	    try {
	    	NAV.generic_searchForText(arg1);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.generic_searchForText(arg1);
	    }
	};
	
	@When("^I filter results for \"([^\"]*)\"$")
	public void filterFor(String arg1) {
	    NAV.generic_filterResults(arg1);
	};

	@Then("^I see the \"([^\"]*)\" ([^\"]*) in \"([^\"]*)\" area is ([^\"]*)$")
	public void verifyCheckboxState(String labelText, String element, String header, String expected) throws Exception {
	    NAV.verifyCheckboxState(labelText, header, expected);
	};
	
	@When("^I ([^\"]*) the \"([^\"]*)\" ([^\"]*) in the \"([^\"]*)\" area$") 
	public void actOnElementInArea(String action, String labelText, String element, String header) throws Exception {
	    switch (action.toLowerCase()) {
	    case "check":
	    case "uncheck":
	    	if (element.equalsIgnoreCase("checkbox")) {
	    		NAV.set_unset_checkbox(labelText, header, action);
	    	} else {
	    		log.fatal("Attempting to check or uncheck invalid when not a checkbox >"+element);
	    		throw new Exception("Attempting to check or uncheck invalid when not a checkbox >"+element);
	    	}
	    	break;
	    case "see":
		    NAV.verifyElemementVisibility(labelText, header, true);
	    	break;
	    case "do not see":
		    NAV.verifyElemementVisibility(labelText, header, false);
		    break;
	    default:
	    	log.fatal("Invalid action for actOnElementInArea >"+action);
	    	throw new Exception("Invalid action for actOnElementInArea >"+action);
	    	// break; // not allowed because of throw
	    }
	};
	
	
	@When("^I select the \"([^\"]*)\" checkbox for \"([^\"]*)\"$")
	public void selectCheckbox_forRowWithText(String column, String rowText) {
	    NAV.selectCheckbox_forRowWithText(column, rowText);
	};
	
	@When("^I select the \"([^\"]*)\" radio button$")
	public void selectRadioButton(String label) throws Exception {
	    NAV.checkRadioButton(label);
	};
	
	@When("^I select the \"([^\"]*)\" radio button for \"([^\"]*)\"$")
	public void selectRadioButton_forRowWithText(String column, String rowText) {
	    NAV.selectRadioButton_forRowWithText(column, rowText);
	};
	
	@When("^I select the \"([^\"]*)\" radio button with label \"([^\"]*)\"$")
	public void select_radioButtonWithLabel(String caption, String label) {
	    NAV.select_radioButtonWithLabel(caption, label);
	};
	
	@Then("^the \"([^\"]*)\" checkbox for \"([^\"]*)\" is \"([^\"]*)\"$")
	public void confirmCheckbox_forRowWithText (String column, String rowText, String checkedUnchecked) {
	    NAV.confirmCheckbox_forRowWithText(column, rowText, checkedUnchecked);
	};
	
	@Then("^I can't press the \"([^\"]*)\" button$")
	public void canNot_pressButton(String arg1) throws Exception{
		try {
			NAV.press_buttonByName(arg1);
			throw new Error("Able to press button when not expected");
			// Improve this for wait issue
		} catch (Exception e) {
		}
	};
	
	@When("^I select \"([^\"]*)\" from the dropdown$")
	public void select_fromDropdown (String option) throws Exception  {
	    try {
	    	NAV.select_fromDropdown(option);
	    } catch (Error e) {
	    	NAV.waitForPageLoad(10,60);
	    	NAV.select_fromDropdown(option);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad(10,60);
	    	NAV.select_fromDropdown(option);
	    }
	};
	
	@Then("^I see \"([^\"]*)\" has class \"([^\"]*)\"$")
	public void seeElement_byText_hasClass(String text, String containsClass) throws Exception{
	    try {
	    	NAV.element_byText_hasClass(text, containsClass);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.element_byText_hasClass(text, containsClass);
	    }
	};
	
	@Then("^I see field \"([^\"]*)\" has class \"([^\"]*)\"$")
	public void seeFieldElement_byText_hasClass(String text, String containsClass) throws Exception{
	    NAV.elementByLabelHasClass(text, containsClass);
	};
	
	@Then("^the \"([^\"]*)\" ([^\"]*) is disabled$")
	public void confirmElementByLabelIsDisabled (String label, String element) throws Exception{
		if (element.equalsIgnoreCase("button")) {
//			NAV.confirmElementByLabelIsDisabled(label);
			NAV.confirmButtonByText_isDisabled(label);
		} else {
			NAV.confirmElementByLabelIsDisabled(label);
		}
	};
	
	@Then("^the \"([^\"]*)\" element is enabled$")
	public void confirmElementByLabelIsEnabled (String arg1) throws Exception{
	    NAV.confirmElementByLabelIsEnabled(arg1);
	};
	
	@When("^I hover over \"([^\"]*)\" then I see \"([^\"]*)\"$")
	public void hoverOverText_seeText(String hoverOverText, String hoverText) {
	    NAV.hoverOverText_seeText(hoverOverText, hoverText);
	};
	
	//KC Code
	@When("^I uncheck the checkbox for \"([^\"]*)\"$")
	public void uncheck_checkbox(String checkbox_name) throws Exception {
		try {
	    	NAV.uncheck_checkbox(checkbox_name);
			
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.uncheck_checkbox(checkbox_name);
	    }
		
	}
	
	@When ("^I ([^\"]*) the \"([^\"]*)\" checkbox in the same row as \"([^\"]*)\"$")
	public void checkUncheckCheckboxInTable(String action, String header, String rowData) throws Exception {
		NAV.checkUncheckCheckboxInTable(rowData, header, action);
	}
	
	@Then ("^I see the \"([^\"]*)\" checkbox in the same row as \"([^\"]*)\" is ([^\"]*)$")
	public void verifyCheckboxStateInTable(String header, String rowData, String expected) throws Exception {
		NAV.verifyCheckboxStateInTable(rowData, header, expected);
	}
	
	@Then("^I see \"([^\"]*)\" in the same row as \"([^\"]*)\"$")
	public void seeText_inSameRow_asText(String searchText, String nextToText) throws Exception {
	   try {
		   NAV.seeText_inSameRow_asText(searchText, nextToText);
	   } catch (Exception e) {
		   NAV.waitForPageLoad();
		   NAV.seeText_inSameRow_asText(searchText, nextToText);
	   }
	};
	
	@When("^I click on \"([^\"]*)\" in the same row as \"([^\"]*)\"$")
	public void clickText_inSameRow_asText (String clickText, String nextToText) throws Exception {
		try {
			NAV.clickText_inSameRow_asText(clickText, nextToText);
		} catch (Exception e) {
			NAV.waitForPageLoad();
			NAV.clickText_inSameRow_asText(clickText, nextToText);
		}
	};
	
	@Then("^I see the \"([^\"]*)\" button$")
	public void buttonVisible(String arg1) throws Exception {
	    if (NAV.buttonVisible(arg1)) {
			log.info("Able to see button - correct");
	    } else {
			throw new Error("NOT Able to see button when expected");
	    }
	}
	
	@Then("^I do not see the \"([^\"]*)\" button$")
	public void buttonNotVisible(String arg1) throws Exception {
	    if (NAV.buttonVisible(arg1)) {
			throw new Error("Able to see button when not expected");
	    } else {
			log.info("Not able to see button - correct");
	    }
	}
	
	@Then("^\"([^\"]*)\" has \"([^\"]*)\" html attribute as \"([^\"]*)\"$")
	public void textHas_HTMLAttribute_as(String text, String attribute, String attribute_value) throws Exception {
	    NAV.textHas_HTMLAttribute_as(text, attribute, attribute_value);
	};
	
	@When("^I click on the \"([^\"]*)\" link for \"([^\"]*)\"$") 
	public void clickLinkFor(String linkText, String text) {
	   NAV.clickOnLink_forLabel(linkText, text);
	};
	
	@Then("^I see an error message \"([^\"]*)\"$")
	public void verifyErrorMessage(String message) {
	   NAV.verifyErrorMessage(message);
	};
	
	@Then("^I do not see an error message \"([^\"]*)\"$")
	public void verifyNoErrorMessage(String message) {
	   NAV.verifyNoErrorMessage(message);
	};
	
	@Then("^I do not see an error message$")
	public void verifyNoErrorMessage() {
	   NAV.verifyNoErrorMessage("");
	};
	
	@When("^I clear the \"([^\"]*)\" field$")
	public void clearField(String label) throws Exception {
//	   NAV.set_valueTo(label, Keys.chord(Keys.CONTROL, "a") + Keys.BACK_SPACE);
	   NAV.clearInputFieldByLabelText(label);
	};
	
	@When("^I clear the \"([^\"]*)\" field in \"([^\"]*)\"$")
	public void clearFieldInLocation(String label, String location) throws Exception {
	   NAV.clearInputFieldByLabelTextInLocation(location, label);
	};
	
	@Then("^\"([^\"]*)\" in \"([^\"]*)\" is \"([^\"]*)\"$")
	public void compareValueByLabelInLocation(String label, String location, String expected) throws Exception {
		NAV.verifyValueByLabelInLocation(location, label, expected);
	}
	
	@Then("^\"([^\"]*)\" has been selected from the \"([^\"]*)\" dropdown$")
	public void VerifyDropdownValue(String expectedOptionValue, String labelText) throws Exception {
		NAV.VerifyDropdownValue(expectedOptionValue, labelText);
	}
	
	
	
}