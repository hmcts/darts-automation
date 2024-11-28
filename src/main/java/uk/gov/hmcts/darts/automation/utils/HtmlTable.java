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
        int startIndex = 0;

        //Verify table header
        if (isFirstRowHeader) {
            List<WebElement> headerElements = rowElements.get(0).findElements(By.xpath(".//th | .//td")); //get all the headers from the row WebElement
            compareTableRowData(headerElements, dataTableRows.get(0), 0);
            startIndex = 1;
        }

        for (int i = startIndex; i < rowElements.size(); i++) {
            List<String> dataTableColumns = dataTableRows.get(i);
            WebElement rowElem = rowElements.get(i);
            List<WebElement> cellElements = rowElem.findElements(By.xpath(".//td"));
            compareTableRowData(cellElements, dataTableColumns, i);
        }
        Assert.assertEquals("Table error: " + errorText, 0, errorCount);
        log.error("Html Table and Datatable has {} error count", errorCount);
    }

    private void compareTableRowData(List<WebElement> cellElements, List<String> dataTableColumns, int rowIdx) {
        int htmlIndex = 0;
// loop through every cell in the current DataTable row ignoring data table *IGNORE* & *SKIP* (eg containing checkboxes only)
// and not comparing those with *NO-CHECK*
        for (int dataTableIndex = 0; dataTableIndex < dataTableColumns.size(); dataTableIndex++) {
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
                        + ( "Expected: >" + expectedCell + "<, actual: >" + actualCell + "<");
                    errorCount++;
                } else {
                    log.info("Values match at Row: {} Column: {}. Expected: '{}', Actual: '{}'", rowIdx, dataTableIndex, expectedCell, actualCell);
                }
                htmlIndex++;
            }
        }
    }

/*
 *  Verify that html table includes matching rows in data table but may include other rows
 */
    public void verifyHtmlTableIncludesRows(DataTable dataTable, boolean isFirstRowHeader) {
        NAV.waitForPageLoad();
        WebElement htmlTableElement = webDriver.findElement(By.cssSelector(".govuk-table"));
        verifyHtmlTableIncludesRows(dataTable, isFirstRowHeader, htmlTableElement);
    }

    public void verifyHtmlTableIncludesRows(DataTable dataTable, boolean isFirstRowHeader, String tablename) {
        NAV.waitForPageLoad();
        WebElement htmlTableElement = webDriver.findElement(By.xpath("//*[text()=\""+tablename+"\"]/following::table[1]"));
        verifyHtmlTableIncludesRows(dataTable, isFirstRowHeader, htmlTableElement);
	}

    public void verifyHtmlTableIncludesRows(DataTable dataTable, boolean isFirstRowHeader, WebElement htmlTableElement) {
        List<WebElement> rowElements = htmlTableElement.findElements(By.tagName("tr"));
        List<List<String>> dataTableRows = dataTable.asLists(); //outer List<> is rows, inner List<> is cells

        errorCount = 0;
        errorText = "";
        int startIndex = 0;
        int htmlPage = 1;

        //Verify table header
        if (isFirstRowHeader) {
            List<WebElement> headerElements = rowElements.get(0).findElements(By.xpath(".//th | .//td"));
            compareTableRowData(headerElements, dataTableRows.get(0), 0);
            startIndex = 1;
        }
        
        int htmlIndex = startIndex;
        int dataIndex = startIndex;
//        for (int dataIndex = startIndex; dataIndex <= dataTableRows.size(); dataIndex++) {
        while (dataIndex < dataTableRows.size() 
        		&& htmlIndex < rowElements.size()) {
        	log.info("Data table row {}", dataIndex);
            List<String> dataTableColumns = dataTableRows.get(dataIndex);
            boolean rowsMatch = false;
            while (!rowsMatch
            		&& htmlIndex <= rowElements.size()) {
            	log.info("HTML table row {}", htmlIndex);
	            WebElement rowElem = rowElements.get(htmlIndex);
	            List<WebElement> cellElements = rowElem.findElements(By.xpath(".//td"));
	            if (TableDataRowsMatch(cellElements, dataTableColumns)) {
	            	rowsMatch = true;
	            	log.info("Data table row {} matches html row {}", dataIndex, htmlIndex);
	            }
	            
	            htmlIndex++;
	            	
            } ;
            
            dataIndex++;
            
        } 
        if (dataTableRows.size() == dataIndex && errorCount == 0) {
        	log.info("All data table rows found in HTML table - {} rows", dataTableRows.size());
        } else {
            if (dataTableRows.size() != dataIndex) {
            	log.error("Table error: only {} rows found from {}", dataTableRows.size(), dataIndex);
                if (errorCount == 0) {
        	        Assert.assertEquals("Table error: only " + dataIndex + " rows found from " + dataTableRows.size(), 
        	        		dataTableRows.size(), dataIndex);
                } else {
                	log.error("Table header error {} cols", errorCount);
                	log.error("Table header error: {}", errorText);
        	        Assert.assertEquals("Header error: " + errorText + " & Table error: only " + dataIndex + " rows found from " + dataTableRows.size(), 
        	        		dataTableRows.size(), dataIndex);
                }
            } else {
            	log.info("All data table rows found in HTML table - {} rows", dataTableRows.size());
            	log.error("Table header error {} cols", errorCount);
            	log.error("Table header error: {}", errorText);
    	        Assert.fail("Header error: " + errorText);
            }
        }
    }

    private boolean TableDataRowsMatch(List<WebElement> cellElements, List<String> dataTableColumns) {
        int htmlIndex = 0;

        for (int dataTableIndex = 0; dataTableIndex < dataTableColumns.size(); dataTableIndex++) {
            String expectedCell = dataTableColumns.get(dataTableIndex);
            expectedCell = (expectedCell != null) ? Substitutions.substituteValue(expectedCell) : "";
            if (expectedCell.equalsIgnoreCase("*NO-CHECK*")) {
                htmlIndex++;
            } else if (!expectedCell.equalsIgnoreCase("*IGNORE*") && !expectedCell.equalsIgnoreCase("*SKIP*")) {
                String actualCell = cellElements.get(htmlIndex).getText().trim();
                actualCell = (actualCell != null) ? actualCell : "";

                if (expectedCell.equals(actualCell)) {
                	log.info("Data matches at column {} ({}): {}", dataTableIndex, htmlIndex, expectedCell);
                } else {
                	log.info("Mismatch at column {} ({}); Expected {}, Actual: {}", dataTableIndex, htmlIndex, expectedCell, actualCell);
                    return false;
                } 
                htmlIndex++;
            }
        }
        log.info("**** Rows match ****");
        return true;
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
