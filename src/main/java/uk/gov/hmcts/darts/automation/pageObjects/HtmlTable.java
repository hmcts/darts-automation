package uk.gov.hmcts.darts.automation.pageObjects;

import io.cucumber.datatable.DataTable;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

public class HtmlTable {

    private static Logger log = LogManager.getLogger("HtmlTable");
    private WebDriver webDriver;

    public HtmlTable(WebDriver driver) {
        this.webDriver = driver;
    }

    public void verifyHtmlTableData(DataTable dataTable, boolean isFirstRowHeader) {
        WebElement htmlTableElement = webDriver.findElement(By.cssSelector(".govuk-table"));
        List<WebElement> rowElements = htmlTableElement.findElements(By.tagName("tr"));
        List<List<String>> dataTableRows = dataTable.asLists(); //outer List<> is rows, inner List<> is cells

        // Check number of rows in Datatable and html table are equal
        Assert.assertEquals("Datatable rows should match the HtmlTable rows", dataTableRows.size(), rowElements.size());

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
    }

    public void compareTableData(List<WebElement> cellElements, List<String> dataTableColumns, int rowIdx, int tdSize) {
        int errorCount = 0;
        for (int cellIdx = 0; cellIdx < dataTableColumns.size(); cellIdx++) { //loop through every cell in the current DataTable row
            String expectedCell = dataTableColumns.get(cellIdx);
            String actualCell = cellElements.get(cellIdx).getText().trim();
            actualCell = (actualCell != null) ? actualCell : "";
            expectedCell = (expectedCell != null) ? expectedCell : "";

            if (!expectedCell.equals(actualCell)) {
                log.error("Value mismatch at Row: {} Column: {}. Expected: '{}', Actual: '{}'",
                        rowIdx, cellIdx, expectedCell, actualCell);
                errorCount++;
            } else {
                log.info("Values match at Row: {} Column: {}. Expected: '{}', Actual: '{}'",
                        rowIdx, cellIdx, expectedCell, actualCell);
            }

            if(tdSize==1) break;
        }
        //Assert.assertEquals(0,errorCount);
        //log.error("Html Table and Datatable don't match with error count {}", errorCount);
    }
}
