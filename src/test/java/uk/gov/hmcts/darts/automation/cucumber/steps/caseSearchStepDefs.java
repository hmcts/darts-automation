package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.java.en.Then;
import uk.gov.hmcts.darts.automation.utils.SharedDriver;
import java.util.List;
import java.util.Map;

public class caseSearchStepDefs extends StepDef_base{
    public caseSearchStepDefs(SharedDriver driver, searchCase sc) {
    super(driver, sc);
    }

    @Then("I can see search results table")
    public void i_can_see_search_results_table(List<Map<String,String>> expectedSearchResults) {

        SRCH.validateExactSearchResults(expectedSearchResults);
    }

    @Then("Search results should contain {string} containing {string}")
    public void search_results_should_contain_containing(String searchField, String searchResultValue) {
        SRCH.validateSearchField(searchField, searchResultValue);
    }

    @Then("I can see search results table row")
    public void i_can_see_search_results_table_row(List<Map<String,String>> expectedSearchResults) {
        SRCH.validateSearchResultsContainsOneRow(expectedSearchResults);
    }
}
