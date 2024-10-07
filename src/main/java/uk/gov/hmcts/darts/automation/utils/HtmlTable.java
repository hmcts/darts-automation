package uk.gov.hmcts.darts.automation.utils;

import io.cucumber.datatable.DataTable;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

public class HtmlTable {

    private static Logger log = LogManager.getLogger("HtmlTable");
    private WebDriver webDriver;
    private WaitUtils wait;
    private NavigationShared NAV;
    int errorCount = 0;
    String errorText = "";

    public HtmlTable(WebDriver driver) {
        this.webDriver = driver;
        wait = new WaitUtils(driver);
        NAV = new NavigationShared(webDriver);
    }

    public void verifyHtmlTableData(DataTable dataTable, boolean isFirstRowHeader) {
        NAV.waitForPageLoad();
        WebElement htmlTableElement = webDriver.findElement(By.cssSelector(".govuk-table"));
		verifyHtmlTableData(dataTable, isFirstRowHeader, htmlTableElement);
    }

    public void verifyHtmlTableData(DataTable dataTable, boolean isFirstRowHeader, String tablename) {
        NAV.waitForPageLoad();
        WebElement htmlTableElement = webDriver.findElement(By.xpath("//*[text()=\""+tablename+"\"]/following::table[1]"));
		verifyHtmlTableData(dataTable, isFirstRowHeader, htmlTableElement);
	}

    public void verifyHtmlTableData(DataTable dataTable, boolean isFirstRowHeader, WebElement htmlTableElement) {
        List<WebElement> rowElements = htmlTableElement.findElements(By.tagName("tr"));
        List<List<String>> dataTableRows = dataTable.asLists(); //outer List<> is rows, inner List<> is cells

        // Check number of rows in Datatable and html table are equal
        Assert.assertEquals("Datatable rows should match the HtmlTable rows", dataTableRows.size(), rowElements.size());
        errorCount = 0;
        errorText = "";

        //Verify table header
        if (isFirstRowHeader) {
            List<WebElement> headerElements = rowElements.get(0).findElements(By.xpath(".//th")); //get all the headers from the row WebElement
            compareTableData(headerElements, dataTableRows.get(0), 0);
            rowElements.remove(0);
        }

        int startIndex = isFirstRowHeader ? 1 : 0; // Skip the first row if it's a header
        for (int i = startIndex; i <= rowElements.size(); i++) {
            List<String> dataTableColumns = dataTableRows.get(i);
            WebElement rowElem = rowElements.get(i - startIndex);
            List<WebElement> cellElements = rowElem.findElements(By.xpath(".//td"));
            compareTableData(cellElements, dataTableColumns, i);
        }
        Assert.assertEquals("Table error: " + errorText, 0, errorCount);
        log.error("Html Table and Datatable has {} error count", errorCount);
    }


    private void compareTableData(List<WebElement> cellElements, List<String> dataTableColumns, int rowIdx) {
        int htmlIndex = 0;
        for (int dataTableIndex = 0; dataTableIndex < dataTableColumns.size(); dataTableIndex++) { //loop through every cell in the current DataTable row
            String expectedCell = dataTableColumns.get(dataTableIndex);
            expectedCell = (expectedCell != null) ? Substitutions.substituteValue(expectedCell) : "";
            if (expectedCell.equalsIgnoreCase("*NO-CHECK*")) {
                htmlIndex++;
            } else if (!expectedCell.equalsIgnoreCase("*IGNORE*") && !expectedCell.equalsIgnoreCase("*SKIP*")) {
                String actualCell = cellElements.get(htmlIndex).getText().trim();
                actualCell = (actualCell != null) ? actualCell : "";

                if (!expectedCell.equals(actualCell)) {
                    log.error("Value mismatch at Row: {} Column: {}. Expected: '{}', Actual: '{}'", rowIdx, dataTableIndex, expectedCell, actualCell);
                    errorText = errorText + (errorText.isBlank() ? "" : ", ")
                        + ( "Expected: '" + expectedCell + "' to equal '" + actualCell + "'");
                    errorCount++;
                } else {
                    log.info("Values match at Row: {} Column: {}. Expected: '{}', Actual: '{}'", rowIdx, dataTableIndex, expectedCell, actualCell);
                }
                htmlIndex++;
            }
        }
    }
    public void clickOnTableHeaderWithTablename(String tableheaderText, String tablename) {
        log.info("Attempting to click on Table header => " + tableheaderText + " in table => " + tablename);

        String xpathForTableHeader = String.format("//*[text()=\"%s\"]/following::table[1]//th[normalize-space()=\"%s\"]", tablename, tableheaderText);
        WebElement tableHeaderElement = webDriver.findElement(By.xpath(xpathForTableHeader));
        try {
            NAV.click_onElement(tableHeaderElement);
            log.info("Clicked on the Table header => " + tableheaderText + " <= within table => " + tablename + " successfully");
        } catch (TimeoutException e) {
            log.error("Table header element with text '" + tableheaderText + "' within table '" + tablename + "' was not clickable within the specified time");
        }
        NAV.waitForBrowserReadyState();

    }

    public void clickOnTableHeader(String tableheaderText) {
        log.info("Going to click on Table header =>" + tableheaderText);

        String xpathForTableHeader = "//table//th//button[normalize-space()='" + tableheaderText + "']";
        WebElement tableHeaderElement = webDriver.findElement(By.xpath(xpathForTableHeader));

        try {
            NAV.click_onElement(tableHeaderElement);
            log.info("Clicked on the Table header =>" + tableheaderText + "<= successfully");
        } catch (TimeoutException e) {
            log.error("Table header element with text '" + tableheaderText + "' was not clickable within the specified time");
        }
        NAV.waitForBrowserReadyState();
        log.info("Clicked on the Table header =>" + tableheaderText + "<= successfully");
    }

    public void hasSortIcon(String tableheaderText, String sortOrder_attribute) {
        String tableHeaderPath = "//table//th[normalize-space()='" + tableheaderText + "']";
        try {
            WebElement element = new WebDriverWait(webDriver, Duration.ofSeconds(3))
                    .until(ExpectedConditions.elementToBeClickable(By.xpath(tableHeaderPath)));
            Assertions.assertEquals(sortOrder_attribute, element.getAttribute("aria-sort"));
            log.info("Table header element with text '" + tableheaderText + "' have " + sortOrder_attribute);
        } catch (TimeoutException e) {
            log.error("Table header element with text '" + tableheaderText + "' does not have " + sortOrder_attribute);
        }
    }
}
