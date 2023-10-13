package uk.gov.hmcts.darts.automation.cucumber.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import uk.gov.hmcts.darts.automation.pageObjects.HtmlTable;
import uk.gov.hmcts.darts.automation.utils.SeleniumWebDriver;

public class StepDef_htmlTable  extends StepDef_base {
    private static Logger log = LogManager.getLogger("StepDef_htmlTable");

    public StepDef_htmlTable(SeleniumWebDriver driver) {
        super(driver);
    }

    @Then("I verify the HTML table contains the following values")
    public void i_verify_the_html_table_contains_the_following_values(DataTable dataTable) {
        HtmlTable htmlTable = new HtmlTable(webDriver);
        htmlTable.verifyHtmlTableData(dataTable);
    }
}
