package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Assertions;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StepDef_navigation extends StepDef_base {

	private static Logger log = LogManager.getLogger("StepDef_navigation");
	
	
	public StepDef_navigation(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
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
	
	@Then("^I see header \"([^\"]*)\"$")
	public void headerExists(String text) {
		NAV.elementWithTextExists(text, "h1");
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
	    NAV.waitForPageLoad(10);
	}
	
	@When("^I expand the \"([^\"]*)\" accordion$")
	public void expandAccordian(String arg1) throws Exception {
//TODO Check on icon following this before & after click
        try {
            NAV.press_buttonByName(arg1);
        } catch (Exception e) {
            NAV.click_link_by_text(arg1);
        }
        NAV.waitForPageLoad(5);
    }

    @When("^I click on the \"([^\"]*)\" accordion$")
    public void clickAccordian(String arg1) throws Exception {
//TODO Check on icon following this before & after click

      try {
	    	NAV.press_buttonByName(arg1);
	    } catch (Exception e) {
			NAV.click_link_by_text(arg1);
	    }
	    NAV.waitForPageLoad(5);
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
	
	@Then("^I see links with text:$")
	public void seeLinksWithText(List<List<String>> dataTable) {
		Assertions.assertTrue(dataTable.size() > 1);
		int errorCount = 0;
		String errorLinks = "";
		for (int rowNum = 1; rowNum < dataTable.size(); rowNum++) {
			for (int colNum = 0; colNum < dataTable.get(0).size(); colNum++) {
				String linkText = dataTable.get(0).get(colNum);
				String linkTest = (dataTable.get(rowNum).get(colNum) == null) ? "" : dataTable.get(rowNum).get(colNum).substring(0, 1);
				boolean linkExists = NAV.linkText_visible(linkText);
				if (linkTest.equalsIgnoreCase("Y")) {
					if (!linkExists) {
						log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
						errorCount++;
						errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
					}
				} else {
					if (linkTest.equalsIgnoreCase("N")) {
						if (linkExists) {
							log.error("Error in links for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
							errorCount++;
							errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
						}
					} else {
						if (linkTest.isBlank()) {
							log.info("Links for {} in row {} not checked, link exists={}", linkText, rowNum, linkExists);
						} else {
							log.error("Unexpected value for {} in row {}: {}, link exists={}", linkText, rowNum, linkTest, linkExists);
							errorCount++;
							errorLinks = errorLinks + (errorLinks.isBlank() ? "" : ", ") + linkText;
						}
					}
				}
			}
		}
		Assertions.assertEquals(0, errorCount, "Errors found verifying links: " + errorLinks);
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
	}
	
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
	    	NAV.waitForPageLoad(1000,60);
	    	NAV.select_fromDropdown(option);
	    } catch (Exception e) {
	    	NAV.waitForPageLoad(1000,60);
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
	
	@When("^I uncheck the checkbox for \"([^\"]*)\"$")
	public void uncheck_checkbox(String checkbox_name) throws Exception {
		try {
	    	NAV.uncheck_checkbox(checkbox_name);
			
	    } catch (Exception e) {
	    	NAV.waitForPageLoad();
	    	NAV.uncheck_checkbox(checkbox_name);
	    }
		
	}

	@When ("^I see \"([^\"]*)\" in the same row as \"([^\"]*)\" \"([^\"]*)\"$")
	public void verifyTextInTableRow(String text, String rowData1, String rowData2) throws Exception {
		NAV.verifyTextInTableRow(text, rowData1, rowData2);
	}

	@When ("^I press the \"([^\"]*)\" button in the same row as \"([^\"]*)\" \"([^\"]*)\"$")
	public void clickButtonInTableRow(String buttonText, String rowData1, String rowData2) throws Exception {
		NAV.clickButtonInTableRow(buttonText, rowData1, rowData2);
	}
	
// Check / uncheck a checkbox in an html table in the same row as other data

    @When("^I ([^\"]*) the checkbox in the same row as \"([^\"]*)\" \"([^\"]*)\"$")
    public void checkUncheckCheckboxInTableRowContainingString(String action, String rowData1, String rowData2) throws Exception {
        NAV.checkUncheckCheckboxInTableRow(rowData1, rowData2, action);
    }

    @When("^I ([^\"]*) the checkbox in the same row as \"([^\"]*)\"$")
    public void checkUncheckCheckboxInTableRowContainingString(String action, String rowData1) throws Exception {
        NAV.checkUncheckCheckboxInTableRow(rowData1, action);
    }


// Check / uncheck a checkbox in a specified column of an html table in the same row as other data

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

	@Then("the dropdown \"([^\"]*)\" contains the options \"([^\"]*)\"$")
	public void theDropdownContainsTheOptions(String label_name, String dropdown_values) throws Exception {
		List<String> dropdownList = Stream.of(dropdown_values.split(",", -1)).collect(Collectors.toList());
		NAV.compareDropdownData(label_name, dropdownList);
	}

	@Then("the dropdown \"([^\"]*)\" contains the options$")
	public void theDropdownContainsTheOptions(String label_name, DataTable dataTable) throws Exception {
		List<String> dropdownList = dataTable.asList();
		NAV.compareDropdownData(label_name, dropdownList);
	}

	@When("I set {string} to {string} and click away")
	public void i_set_to_and_click_away(String location_name, String value) throws Exception {
		NAV.clickAway(NAV.set_valueTo(location_name, value));
	}

	@When("I select the checkbox by name {string}")
	public void SelectTheCheckboxByName(String checkboxName) {
		NAV.selectCheckboxByName(checkboxName);
	}

	@And("checkbox with name {string} is checked")
	public void checkboxWithNameIsChecked(String checkboxName) {
		NAV.assertCheckboxStatus(checkboxName, true);
	}

	@And("checkbox with name {string} is unchecked")
	public void checkboxWithNameIsUnchecked(String checkboxName) {
		NAV.assertCheckboxStatus(checkboxName, false);
	}

}

