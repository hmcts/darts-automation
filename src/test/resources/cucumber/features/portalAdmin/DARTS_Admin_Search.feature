@admin @admin_search
Feature: Admin Search

  @DMP-3129
  Scenario: Search Results - Cases
    When I am logged on to the admin portal as an ADMIN user
      #Filter by courthouse
    Then I set "Filter by courthouse" to "Swansea"
    Then I press the "Search" button
    Then I see "There are more than 1000 results. Refine your search." on the page
    Then I click on the "Hearings" link
    Then I see "There are more than 1000 results. Refine your search." on the page
    Then I click on the "Cases" link
    Then I see "There are more than 1000 results. Refine your search." on the page
    Then I click on the "Clear search" link
      #Case ID
    Then I set "Case ID" to "CASE1009"
    Then I press the "Search" button
    Then I click on the "Hearings" link
    Then I click on the "Cases" link
    Then I click on the "Clear search" link
      #Courtroom
    Then I set "Courtroom" to "ROOM_A"
    Then I press the "Search" button
    Then I click on the "Hearings" link
    Then I click on the "Cases" link
    Then I click on the "Clear search" link
      #Hearing Date-Specific Date
    Then I select the "Specific date" radio button
    Then I set "Enter a date" to "03/07/2024"
    Then I press the "Search" button
    Then I click on the "Hearings" link
    Then I click on the "Cases" link
    Then I click on the "Clear search" link
      #Hearing Date-Date Range
    Then I select the "Date range" radio button
    Then I set "Date from" to "02/07/2024"
    Then I set "Date to" to "03/07/2024"
    Then I press the "Search" button
    Then I click on the "Hearings" link
    Then I click on the "Cases" link

  @DMP-2728
  Scenario: Associated Audio files for deletion/hidden
    When I am logged on to the admin portal as an ADMIN user
    When I set "Case ID" to "CASE1009"
    Then I press the "Search" button
    Then I click on the "Audio" link
    Then I click on "Audio ID" in the table header
    Then I click on the "1313" link
    Then I press the "Hide or delete" button
    Then I select the "Other reason to hide only" radio button
    Then I set "Enter ticket reference" to "Test"
    Then I set "Comments" to "Test"
    Then I press the "Hide or delete" button
    Then I see "There are other audio files associated with the file you are hiding and/or deleting" on the page
    Then I press the "Continue" button
    Then I see an error message "Choose if you want to include associated files or not"


    @DMP-3315
    Scenario: Hearings search results
      When I am logged on to the admin portal as an ADMIN user
      Then I see "Search" on the page
 	    When I set "Courtroom" to "ROOM_A"
      And I select the "Hearings" radio button
      And I press the "Search" button
      Then I see "Hearings" on the page
      And I click on the pagination link "2"
      And I see "Next" on the page
      And I see "Previous" on the page
      And I click on the pagination link "Previous"
      And I click on the pagination link "Next"

      And I select the "Date range" radio button
      And I set "Date from" to "20/06/2024"
      And I set "Date to" to "24/06/2024"
      And I press the "Search" button
      And I see "Showing 1-3 of 3" on the page
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |

      And I click on "Case ID" in the table header
      And "Case ID" has sort "descending" icon
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |

      And I click on "Hearing date" in the table header
      Then "Hearing date" has sort "descending" icon

      And I click on "Courthouse" in the table header
      Then "Courthouse" has sort "descending" icon

      And I click on "Courtroom" in the table header
      And "Courtroom" has sort "descending" icon
      Then I verify the HTML table contains the following values
        | Case ID         | Hearing date | Courthouse | Courtroom      |
        | DMP-2799-Case6  | 20/06/2024   | Swansea    | Room6-DMP-2799 |
        | DMP-2799-AC3    | 20/06/2024   | Swansea    | DMP-2799-AC3   |
        | DMP-2747        | 20/06/2024   | Swansea    | 1              |

  @DMP-2709 @DMP-3384
  Scenario: Audio file-Details page
    When I am logged on to the admin portal as a SUPERUSER user
    And I see "Search" on the page
    And I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
  #Back
    Then I click on the "Back" link
    And I see "Search" on the page
    And I click on the "52849" link
    And I see "Audio file" on the page
    And I see "52849" on the page
    And I do not see " Hide or delete " on the page

  @DMP-2709 @DMP-3384 @DMP-4210-AC3 @DMP-4240
  Scenario: Audio file-Details page
    When I am logged on to the admin portal as an ADMIN user
    And I see "Search" on the page
    And I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
  #Back
    Then I click on the "Back" link
    And I see "Search" on the page
    And I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    And I click on the "52849" link
    And I see "Audio file" on the page
    And I see "52849" on the page
    And I see " Hide or delete " on the page
  #Basic details
    And I see "Basic details" on the page
    And I see "Courthouse" in the same row as "DMP-3438_Courthouse"
    And I see "Courtroom" in the same row as "Room1_DMP-3438"
    And I see "Start time" in the same row as "28 Jun 2024 at 1:00:00AM"
    And I see "End time" in the same row as "28 Jun 2024 at 11:59:59PM"
    And I see "Channel number" in the same row as "1"
    And I see "Total channels" in the same row as "4"
    And I see "Media type" in the same row as "A"
    And I see "File type" in the same row as "mp2"
    And I see "File size" in the same row as "0.94KB"
    And I see "Filename" in the same row as "DMP-3438-file1"
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Associated cases" on the page
    Then I verify the HTML table contains the following values
      | Case ID        | Hearing date| Defendants(s) | Judges(s) |
      | DMP-3438_case1 | 28 Jun 2024 |               |           |
    When I Sign out
  #Super Admin
    And I am logged on to the admin portal as an ADMIN user
    Then I see "Search" on the page
    When I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    When I click on the "52849" link
  #Back
    And I click on the "Back" link
    Then I see "Search" on the page
    When I set "Filter by courthouse" to "DMP-3438_Courthouse"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I see "Showing 1-2 of 2" on the page
    When I click on the "52849" link
    Then I see "Audio file" on the page
    And I see "52849" on the page
    And I see " Hide or delete " on the page
  #Basic details
    And I see "Basic details" on the page
    And I see "Courthouse" in the same row as "DMP-3438_Courthouse"
    And I see "Courtroom" in the same row as "Room1_DMP-3438"
    And I see "Start time" in the same row as "28 Jun 2024 at 1:00:00AM"
    And I see "End time" in the same row as "28 Jun 2024 at 11:59:59PM"
    And I see "Channel number" in the same row as "1"
    And I see "Total channels" in the same row as "4"
    And I see "Media type" in the same row as "A"
    And I see "File type" in the same row as "mp2"
    And I see "File size" in the same row as "0.94KB"
    And I see "Filename" in the same row as "DMP-3438-file1"
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Associated cases" on the page
    Then I verify the HTML table contains the following values
      | Case ID        | Hearing date| Defendants(s) | Judges(s) |
      | DMP-3438_case1 | 28 Jun 2024 |               |           |
  #Advanced details
    When I click on the "Advanced details" link
    Then I see "Advanced details" on the page
    And I see "Media object ID" in the same row as ""
    And I see "Content object ID" in the same row as ""
    And I see "Clip ID" in the same row as ""
    And I see "Checksum" in the same row as "d6df4486865e46f60d6bcebda3950760"
    And I see "Media status" in the same row as ""
    And I see "Is current?" in the same row as "Yes"
    And I see "Audio hidden?" in the same row as "No"
    And I see "Audio deleted?" in the same row as "No"

    And I see "Version data" on the page
    And I see "Version" in the same row as ""
    And I see "Chronicle ID" in the same row as "52849"
    And I see "Antecedent ID" in the same row as ""
    And I see "Retain until" in the same row as ""
    And I see "Date created" in the same row as "28 Jun 2024 at 1:40:41PM"
    And I see "Created by" in the same row as ""
    And I see "Date last modified" in the same row as "11 Jul 2024 at 5:16:20PM"
    And I see "Last modified by" in the same row as ""
  #Hide audio file
    When I press the " Hide or delete " button
    And I select the "Other reason to hide only" radio button
    And I set "Enter ticket reference" to "DMP-2709"
    And I set "Comments" to "Testing DMP-2709 AC-3" and click away
    Then I see "You have 235 characters remaining" on the page
    When I press the "Hide or delete" button

    Then I see "Files successfully hidden or marked for deletion" on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    And I press the "Continue" button
    And I see "Important" on the page
    And I see "This file is hidden in DARTS" on the page
    And I see "DARTS users cannot view this file. You can unhide the file." on the page
    And I see "Hidden by - Darts Admin" on the page
    And I see "Reason - Other reason to hide only" on the page
    And I see "Testing DMP-2709 AC-3" on the page
    And I see "Unhide" on the page
  #Unhide audio file
    When I click on the "unhide" link
    Then I do not see "Important" on the page
    When I click on the "Advanced details" link
    Then I see "Audio hidden?" in the same row as "No"
    And I see " Hide or delete " on the page

  @DMP-3317
  Scenario: Audio search results
    Given I am logged on to the admin portal as an ADMIN user
    Then I see "Search" on the page
    When I set "Filter by courthouse" to "Bristol"
    And I select the "Audio" radio button
    And I press the "Search" button
    Then I see "Audio" on the page
    And I click on the pagination link "2"
    And I see "Next" on the page
    And I see "Previous" on the page
    And I click on the pagination link "Previous"
    And I click on the pagination link "Next"

    When I click on "Audio ID" in the table header
    Then "Audio ID" has sort "descending" icon

    And I click on "Courthouse" in the table header
    Then "Courthouse" has sort "descending" icon

    And I click on "Courtroom" in the table header
    Then "Courtroom" has sort "descending" icon

    And I click on "Start Time" in the table header
    Then "Start Time" has sort "descending" icon

    And I click on "End Time" in the table header
    Then "End Time" has sort "descending" icon

    And I click on "Channel" in the table header
    Then "Channel" has sort "descending" icon

    And I click on "Hidden" in the table header
    Then "Hidden" has sort "descending" icon



  @3309
  Scenario:Event_ID Screen
    When I am logged on to the admin portal as an ADMIN user
    And I see "Search" on the page
    And I select the "Specific date" radio button
    And I set "Enter a date" to "01/01/2024"
    And I select the "Events" radio button
    And I press the "Search" button
    Then I see "Events" on the page
    #Back Link
    And I click on "490225" in the same row as "01 Jan 2024 at 06:00:00	"
    And I see link with text "Back"
    Then I click on the "Back" link
    And I see "Events" on the page
    #Basic details
    Then I click on "490225" in the same row as "22 Aug 2024 at 04:16:55"
    And I see "Event" on the page
    And I see "490225" on the page
    And I see "Basic details" on the page
    And I see "Name" in the same row as "Proceedings in chambers"
    And I see "Text" in the same row as "some text for the event"
    And I see "Courthouse" in the same row as "Harrow Crown Court"
    And I see "Courtroom" in the same row as "132311"
    And I see "Time stamp" in the same row as "01 Jan 2024 at 06:00:00"
    #Advanced details
    Then I click on the "Advanced details" link
    And I see "Documentum ID" in the same row as ""
    And I see "Source event ID" in the same row as "12345"
    And I see "Message ID" in the same row as "100"
    And I see "Type" in the same row as "1000"
    And I see "Subtype" in the same row as "1002"
    And I see "Event Handler" in the same row as "StandardEventHandler"
    And I see "Reporting restriction?" in the same row as "No"
    And I see "Log entry?" in the same row as "No"

    And I see "Version data" on the page
    And I see "Version" in the same row as ""
    And I see "Chronicle ID" in the same row as ""
    And I see "Antecedent ID" in the same row as ""
    And I see "Date created" in the same row as "22 Aug 2024 at 16:16:55"
    And I see "Created by" in the same row as "System"
    And I see "Date last modified" in the same row as "07 Nov 2024 at 10:23:48"
    And I see "Last modified by" in the same row as "System"
