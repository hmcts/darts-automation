package uk.gov.hmcts.darts.automation.pageObjects;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Search {

    private static WebDriver webDriver;

    public Search(WebDriver driver) {
        Search.webDriver = driver;

    }

    public enum SearchResultsEnum {
        CASEID,
        COURTHOUSE,
        COURTROOM,
        JUDGES,
        DEFENDANTS,
        INVALID
    }

    public Table<Integer, Integer, String> scrapeTableData(WebElement table)
    {
        Table<Integer, Integer, String> tableObject = HashBasedTable.create();

        List<WebElement> rows = table.findElements(By.tagName("tr"));

        int rowIndex = 0;
        int colIndex = 0;
        for (WebElement row : rows) {
            List<WebElement> cols = row.findElements(By.tagName("td"));
            for (WebElement col : cols) {
                tableObject.put(rowIndex, colIndex++, col.getText());
            }
            rowIndex++;
            colIndex = 0;
        }

        return tableObject;
    }

    public void validateExactSearchResults(List<Map<String, String>> expectedSearchResults) {

        WebElement searchResultsTable = getSearchResultsTable();

        Table<Integer, Integer, String> searchTable = scrapeTableData(searchResultsTable);

        List<List<String>> expectedSearchRowList = new ArrayList<>();
        expectedSearchResults.forEach(
                expectedTableRow -> {
                    List<String> cellsList = new ArrayList<>();
                    String caseId = expectedTableRow.get("CaseID");
                    cellsList.add(caseId);
                    String courthouse = expectedTableRow.get("Courthouse");
                    cellsList.add(courthouse);
                    String courtRoom = expectedTableRow.get("Courtroom");
                    cellsList.add(courtRoom);
                    String judges = expectedTableRow.get("Judges");
                    cellsList.add(judges);
                    String defendants = expectedTableRow.get("Defendants");
                    cellsList.add(defendants);

                    expectedSearchRowList.add(cellsList);
                });

        for (int rowCounter = 0; rowCounter < expectedSearchRowList.size(); rowCounter++) {
            int actualRowCounter = rowCounter+1;
            String actualCaseId = searchTable.get(actualRowCounter, SearchResultsEnum.CASEID.ordinal());
            String expectedCaseId = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.CASEID.ordinal());

            Assert.assertEquals("Case Id is incorrect in row " + rowCounter, expectedCaseId,actualCaseId);
            String actualCourthouse = searchTable.get(actualRowCounter, SearchResultsEnum.COURTHOUSE.ordinal());
            String expectedCourthouse = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.COURTHOUSE.ordinal());
            Assert.assertEquals("Courthouse is incorrect in row " + rowCounter, expectedCourthouse, actualCourthouse);

            String actualCourtRoom = searchTable.get(actualRowCounter, SearchResultsEnum.COURTROOM.ordinal());
            String expectedCourtRoom = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.COURTROOM.ordinal());
            Assert.assertEquals("CourtRoom is incorrect in row " + rowCounter, expectedCourtRoom,actualCourtRoom);

            String actualJudges = searchTable.get(actualRowCounter, SearchResultsEnum.JUDGES.ordinal());
            String expectedJudges = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.JUDGES.ordinal());
            if(expectedJudges == null)
            {
                Assert.assertEquals("Judges is incorrect in row " + rowCounter, "", actualJudges);
            }
            else {
                Assert.assertEquals("Judges is incorrect in row " + rowCounter, expectedJudges, actualJudges);
            }
            String actualDefendants = searchTable.get(actualRowCounter, SearchResultsEnum.DEFENDANTS.ordinal());
            String expectedDefendants = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.DEFENDANTS.ordinal());
            if(expectedJudges == null)
            {
                Assert.assertEquals("Defendants is incorrect in row " + rowCounter, "", actualDefendants);
            }
            else {
                Assert.assertEquals("Defendants is incorrect in row " + rowCounter, expectedDefendants, actualDefendants);
            }

        }


    }

    public void validateSearchField(String searchField, String searchString) {
        WebElement searchResultsTable = getSearchResultsTable();
        Table<Integer, Integer, String> searchTable = scrapeTableData(searchResultsTable);

        SearchResultsEnum field;

        if(searchField.toUpperCase().contains(SearchResultsEnum.CASEID.name()))
        {
            field = SearchResultsEnum.CASEID;
        }
        else if(searchTable.get(0, SearchResultsEnum.COURTHOUSE.ordinal()) == searchField)
        {
            field = SearchResultsEnum.COURTHOUSE;
        }
        else if(searchTable.get(0, SearchResultsEnum.COURTROOM.ordinal()) == searchField)
        {
            field = SearchResultsEnum.COURTROOM;
        }
        else if(searchTable.get(0, SearchResultsEnum.JUDGES.ordinal()) == searchField)
        {
            field = SearchResultsEnum.JUDGES;
        }
        else if(searchTable.get(0, SearchResultsEnum.DEFENDANTS.ordinal()) == searchField)
        {
            field = SearchResultsEnum.DEFENDANTS;
        } else{
            field = SearchResultsEnum.INVALID;
        }

        Assert.assertNotEquals("Search field id invalid: " + searchField, SearchResultsEnum.INVALID,field);

        int rowsCountExcludingHeaders = searchTable.rowMap().size()-1;
        for (int rowCounter = 0; rowCounter < rowsCountExcludingHeaders; rowCounter++) {
            int actualRowCounter = rowCounter+1;
            String actualField = searchTable.get(actualRowCounter, field.ordinal());
            Assert.assertTrue(searchField + " is incorrect in row " + rowCounter + "; actual field: " + actualField, actualField.contains(searchString));

        }

    }

    //Only first row is validated - TODO
    public void validateSearchResultsContainsOneRow(List<Map<String, String>> expectedSearchResults) {

        WebElement searchResultsTable = getSearchResultsTable();
        Table<Integer, Integer, String> searchTable = scrapeTableData(searchResultsTable);

        List<List<String>> expectedSearchRowList = new ArrayList<>();
        expectedSearchResults.forEach(
                expectedTableRow -> {
                    List<String> cellsList = new ArrayList<>();
                    String caseId = expectedTableRow.get("CaseID");
                    cellsList.add(caseId);
                    String courthouse = expectedTableRow.get("Courthouse");
                    cellsList.add(courthouse);
                    String courtRoom = expectedTableRow.get("Courtroom");
                    cellsList.add(courtRoom);
                    String judges = expectedTableRow.get("Judges");
                    cellsList.add(judges);
                    String defendants = expectedTableRow.get("Defendants");
                    cellsList.add(defendants);
                    expectedSearchRowList.add(cellsList);
                });

        Assert.assertTrue("Only one row should be provided for validation, but was " + expectedSearchRowList.size(), expectedSearchRowList.size() == 1);

        int rowsCountExcludingHeaders = searchTable.rowMap().size()-1;
        for (int i = 1; i < rowsCountExcludingHeaders; i++) {
            int rowCounter = 0;
            int actualRowCounter = rowCounter+1;
            String actualCaseId = searchTable.get(actualRowCounter, SearchResultsEnum.CASEID.ordinal());
            String expectedCaseId = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.CASEID.ordinal());

            Assert.assertEquals("Case Id is incorrect in row " + rowCounter, expectedCaseId,actualCaseId);
            String actualCourthouse = searchTable.get(actualRowCounter, SearchResultsEnum.COURTHOUSE.ordinal());
            String expectedCourthouse = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.COURTHOUSE.ordinal());
            Assert.assertEquals("Courthouse is incorrect in row " + rowCounter, expectedCourthouse, actualCourthouse);

            String actualCourtRoom = searchTable.get(actualRowCounter, SearchResultsEnum.COURTROOM.ordinal());
            String expectedCourtRoom = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.COURTROOM.ordinal());
            Assert.assertEquals("CourtRoom is incorrect in row " + rowCounter, expectedCourtRoom,actualCourtRoom);

            String actualJudges = searchTable.get(actualRowCounter, SearchResultsEnum.JUDGES.ordinal());
            String expectedJudges = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.JUDGES.ordinal());
            if(expectedJudges == null)
            {
                Assert.assertEquals("Judges is incorrect in row " + rowCounter, "", actualJudges);
            }
            else {
                Assert.assertEquals("Judges is incorrect in row " + rowCounter, expectedJudges, actualJudges);
            }
            String actualDefendants = searchTable.get(actualRowCounter, SearchResultsEnum.DEFENDANTS.ordinal());
            String expectedDefendants = expectedSearchRowList.get(rowCounter).get(SearchResultsEnum.DEFENDANTS.ordinal());
            if(expectedJudges == null)
            {
                Assert.assertEquals("Defendants is incorrect in row " + rowCounter, "", actualDefendants);
            }
            else {
                Assert.assertEquals("Defendants is incorrect in row " + rowCounter, expectedDefendants, actualDefendants);
            }
        }





    }

    private static WebElement getSearchResultsTable() {
        WebElement searchResultsTable = webDriver.findElement(By.className("govuk-table"));
        return searchResultsTable;
    }

}