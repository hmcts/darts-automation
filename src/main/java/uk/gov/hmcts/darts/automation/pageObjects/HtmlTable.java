package uk.gov.hmcts.darts.automation.pageObjects;

import io.cucumber.datatable.DataTable;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.Objects;

public class HtmlTable {

    private static Logger log = LogManager.getLogger("HTML Table");
    private WebDriver webDriver;

    public HtmlTable(WebDriver driver) {
        this.webDriver = driver;
    }

    public void verifyHtmlTableData(DataTable dataTable) {
        WebElement htmlTableElement = webDriver.findElement(By.xpath("//table[@class='govuk-table']"));
        List<WebElement> rowElements = htmlTableElement.findElements(By.tagName("tr"));
        rowElements.remove(0);

        List<List<String>> dataTableRows = dataTable.asLists(); //outer List<> is rows, inner List<> is cells
        for (List<String> row : dataTableRows) { //loop through every row in the DataTable input
            int rowIdx = dataTableRows.indexOf(row);
            System.out.println("rowIdx:"+rowIdx);
            WebElement rowElem = rowElements.get(rowIdx); //get the row WebElement based on the index of the current row in the DataTable
            List<WebElement> cellElements = rowElem.findElements(By.xpath(".//td")); //get all the cells from the row WebElement

            for (String expectedCell : row) { //loop through every cell in the current DataTable row
                int cellIdx = row.indexOf(expectedCell);
                String actualCell = cellElements.get(cellIdx).getText();

                if(expectedCell==null){
                    expectedCell=   nullToString(expectedCell);
                    System.out.println("expectedCell::"+expectedCell);
                }


                System.out.println("DataTable row " + rowIdx + ", cell " + cellIdx + ": " + expectedCell);
                System.out.println("Actual value on the page: " + actualCell);

                Assert.assertEquals("Expected value of cell should match actual value of cell", expectedCell, actualCell);
            }
        }
    }

    public String nullToString(String cell) {
        return Objects.isNull(cell) ? StringUtils.EMPTY : cell;
    }


}
