package uk.gov.hmcts.darts.automation.utils;

import io.cucumber.datatable.DataTable;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import uk.gov.hmcts.darts.automation.utils.NavigationShared;
import uk.gov.hmcts.darts.automation.utils.WaitUtils;

import java.time.Duration;
import java.util.List;

public class HtmlTable {

    private static Logger log = LogManager.getLogger("HtmlTable");
    private WebDriver webDriver;
    private WaitUtils wait;
    private NavigationShared NAV;
    int errorCount = 0;

    public HtmlTable(WebDriver driver) {
        this.webDriver = driver;
        wait = new WaitUtils(driver);
        NAV = new NavigationShared(webDriver);
    }

    public void verifyHtmlTableData(DataTable dataTable, boolean isFirstRowHeader) {
        NAV.waitForPageLoad();
        WebElement htmlTableElement = webDriver.findElement(By.cssSelector(".govuk-table"));
        List<WebElement> rowElements = htmlTableElement.findElements(By.tagName("tr"));
        List<List<String>> dataTableRows = dataTable.asLists(); //outer List<> is rows, inner List<> is cells

        // Check number of rows in Datatable and html table are equal
        Assert.assertEquals("Datatable rows should match the HtmlTable rows", dataTableRows.size(), rowElements.size());
        errorCount = 0;

        //Verify table header
        if (isFirstRowHeader) {
            List<WebElement> headerElements = rowElements.get(0).findElements(By.xpath(".//th")); //get all the headers from the row WebElement
            compareTableData(headerElements, dataTableRows.get(0), 0, rowElements.get(0).findElements(By.xpath(".//th")).size());
            rowElements.remove(0);
        }

        int startIndex = isFirstRowHeader ? 1 : 0; // Skip the first row if it's a header
        for (int i = startIndex; i <= rowElements.size(); i++) {
            List<String> dataTableColumns = dataTableRows.get(i);
            WebElement rowElem = rowElements.get(i - startIndex);
            List<WebElement> cellElements = rowElem.findElements(By.xpath(".//td"));
            compareTableData(cellElements, dataTableColumns, i, rowElem.findElements(By.xpath(".//td")).size());
        }
        Assert.assertEquals(0, errorCount);
        log.error("Html Table and Datatable has {} error count", errorCount);
    }

    private void compareTableData(List<WebElement> cellElements, List<String> dataTableColumns, int rowIdx, int tdSize) {
        int htmlIndex = 0;
        for (int dataTableIndex = 0; dataTableIndex < dataTableColumns.size(); dataTableIndex++) { //loop through every cell in the current DataTable row
            String expectedCell = dataTableColumns.get(dataTableIndex);
            expectedCell = (expectedCell != null) ? expectedCell : "";
            if (expectedCell.equalsIgnoreCase("*NO-CHECK*")) {
                htmlIndex++;
            } else if (!expectedCell.equalsIgnoreCase("*IGNORE*") && !expectedCell.equalsIgnoreCase("*SKIP*")) {
                String actualCell = cellElements.get(htmlIndex).getText().trim();
                actualCell = (actualCell != null) ? actualCell : "";

                if (!expectedCell.equals(actualCell)) {
                    log.error("Value mismatch at Row: {} Column: {}. Expected: '{}', Actual: '{}'",
                            rowIdx, dataTableIndex, expectedCell, actualCell);
                    errorCount++;
                } else {
                    log.info("Values match at Row: {} Column: {}. Expected: '{}', Actual: '{}'",
                            rowIdx, dataTableIndex, expectedCell, actualCell);
                }
                htmlIndex++;
            }
        }
    }

    public void clickOnTableHeader(String tableHeaderText){
        log.info("Going to click on Table header =>"+tableHeaderText);
        if (tableHeaderText == null || tableHeaderText.isEmpty()) {
            log.error("Invalid table header text provided");
            throw new IllegalArgumentException("Invalid table header text");
        }

        String tableHeaderPath = "//button[normalize-space()='"+tableHeaderText+"']";
        try {
            WebElement element = new WebDriverWait(webDriver, Duration.ofSeconds(3))
                    .until(ExpectedConditions.elementToBeClickable(By.xpath(tableHeaderPath)));
            NAV.click_onElement(element);
        } catch (TimeoutException e) {
            log.error("Table header element with text '" + tableHeaderText + "' was not clickable within the specified time");

        }
        NAV.waitForBrowserReadyState();

        log.info("Clicked on the Table header =>"+tableHeaderText+"<= successfully");
    }
}
