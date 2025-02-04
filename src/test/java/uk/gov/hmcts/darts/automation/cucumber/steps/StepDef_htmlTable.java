package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import uk.gov.hmcts.darts.automation.utils.HtmlTable;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;
import uk.gov.hmcts.darts.automation.utils.TestData;

public class StepDef_htmlTable extends StepDef_base {
    private static Logger log = LogManager.getLogger("StepDef_htmlTable");

    public StepDef_htmlTable(SeleniumWebDriver driver, TestData testdata) {
		super(driver, testdata);
    }

    HtmlTable htmlTable = new HtmlTable(webDriver);
    
/*
 *  Verify that ALL rows in html table match data table
 */
    @Then("I verify the HTML table contains the following values")
    public void verify_html_table_contains_the_following_values(DataTable dataTable) {
        htmlTable.verifyHtmlTableData(dataTable, true);
    }

    @Then("I verify the HTML table \"([^\"]*)\" contains the following values$")
    public void iVerifyTheHTMLTableContainsTheFollowingValues(String tableName, DataTable dataTable) {
        htmlTable.verifyHtmlTableData(dataTable, true, tableName);
    }

/*
 *  Verify that ALL rows in data table match html table though additional rows may exist in html table
 */
    @Then("I verify the HTML table includes the following values")
    public void verify_html_table_includes_the_following_values(DataTable dataTable) {
       htmlTable.verifyHtmlTableIncludesRowsOnAnyPage(dataTable);
    }

    @Then("I verify the HTML table \"([^\"]*)\" includes the following values$")
    public void iVerifyTheHTMLTableIncludesTheFollowingValues(String tableName, DataTable dataTable) {
        htmlTable.verifyHtmlTableIncludesRows(dataTable, true, tableName);
    }

    @Then("^I click on \"([^\"]*)\" in the table header$")
    public void i_click_on_in_the_table_header(String tableHeaderText) throws Exception {
        htmlTable.clickOnTableHeader(tableHeaderText);
    }
    @Then("I click on \"([^\"]*)\" in the \"([^\"]*)\" table header$")
    public void clickOnInTheTableHeader(String tableHeaderText, String tableName) {
        htmlTable.clickOnTableHeaderWithTablename(tableHeaderText, tableName);
    }

    @Then("\"([^\"]*)\" has sort \"([^\"]*)\" icon$")
    public void HasSortIcon(String tableheaderText, String sortOrder) {
        htmlTable.hasSortIcon(tableheaderText, sortOrder);
    }
}
