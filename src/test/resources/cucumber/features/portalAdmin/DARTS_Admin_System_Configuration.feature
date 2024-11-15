@admin @admin_system_config
Feature: Admin System configuration


  @DMP-2669 @DMP2668
  Scenario: Automated tasks- primary & details page
      #DMP-2668-AC1-AC2
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "System configuration" link
    And I click on the "Automated tasks" link
    And I see "Automated tasks" on the page
    And I see "ID" on the page
    And I see "Name" on the page
    And I see "Description" on the page
    And I see "Cron expression" on the page
    And I see "Status" on the page
    And I see "Run task" on the page
    And I press the "Run task" button in the same row as "ApplyRetention" "11"
    And I see "Task start request sent" on the page
      #DMP2669 AC1  View Automated tasks
    Then I click on the "1" link
    And I see "Automated task" on the page
    And I see "ProcessDailyList" on the page
    And I see "ID" on the page
    And I see "Name" on the page
    And I see "Description" on the page
    And I see "Cron expression" on the page
    And I see "Cron editable" on the page
    And I see "Date created" on the page
    And I see "Created by" on the page
    And I see "Date modified" on the page
    And I see "Modified by" on the page
    And I see "Run task" on the page
    And I see "Make inactive" on the page
    And I see "Active" on the page
      #AC2 Run task
    Then I press the "Run task" button
    And I see "Task start request sent" on the page
      #AC3 Disable task
    Then I press the "Make inactive" button
    And I see "Task 1 is inactive" on the page
    And I click on the "System configuration" link
    And I click on the "Automated tasks" link
    And I see "Inactive" in the same row as "ProcessDailyList" "1"
      #AC4 Reenable task
    And I click on the "1" link
    Then I press the "Make active" button
    And I see "Task 1 is active" on the page
    And I click on the "System configuration" link
    And I click on the "Automated tasks" link
    And I see "Active" in the same row as "ProcessDailyList" "1"

    Then I click on the "Transcripts" navigation link
    And I click on the "Advanced search" link
    Then I set "Hearing date" to "{{date+7/}}"
    And I set "Courthouse" to "Test"
    Then I see "You have selected a date in the future. Hearing date must be in the past" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "{{date+7/}}"
    And I set "Courthouse" to "Placeholder"
    Then I see "You have selected a date in the future. Requested date must be in the past" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "{{date+7/}}"
    And I set "Date to" to "{{date+7/}}"
    And I set "Courthouse" to "Test"
    Then I see "You have selected a date in the future. Requested start date must be in the past" on the page
    And I see "You have selected a date in the future. Requested end date must be in the past" on the page
    Then I set "Hearing date" to "ddd"
    And I set "Courthouse" to "Placeholder"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "ddd"
    And I set "Hearing date" to ""
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "ddd"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I set "Date to" to "ddd"
    Then I see "You have not entered a recognised date in the correct format (for example 31/01/2023)" on the page
    Then I set "Hearing date" to "30/02/2024"
    And I set "Courthouse" to "Test"
    Then I see "Enter a real date" on the page
    Then I click on the "Specific date" link
    Then I set "Enter a date" to "30/02/2024"
    And I set "Hearing date" to ""
    Then I see "Enter a real date" on the page
    Then I click on the "Date range" link
    Then I set "Date from" to "30/02/2024"
    Then I see "Enter a real date" on the page
    Then I set "Date to" to "30/02/2024"
    Then I see "Enter a real date" on the page
    Then I set "Date from" to "30/03/2029"
    And I set "Date to" to "30/01/2029"
    Then I see "The start date must be before the end date" on the page
    And I see "The end date must be after the start date" on the page

  @DMP-2746 @DMP-2674 @regression
  Scenario: Add event mapping
    Given I am logged on to the admin portal as an ADMIN user
    And I see "You can search for cases, hearings, events and audio." on the page
    When I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    #DMP-2746-AC1 Create event mapping
    And I press the "Add event mapping" button
    And I set "Type" to "DMP-2746-Automation-Type {{seq}}"
    And I set "Event name" to "DMP-2746-Automation-Event-Name {{seq}}"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I check the "Tick if this event mapping has reporting restrictions" checkbox
    And I press the "Add mapping" button
    Then I see "Event mapping added" on the page

    #Cancel

    When I press the "Add event mapping" button
    And I set "Type" to "DMP-2746-Automation-Type-1"
    And I set "Event name" to "DMP-2746-Automation-Event-Name-1"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I click on the "Tick if this event mapping has reporting restrictions" link
    And I click on the "Cancel" link
    Then I see "Filter by type, subtype, or name" on the page
    And I see "Event mappings" on the page

    #DMP-2646-AC2 Error handling

    When I press the "Add event mapping" button
    And I set "Type" to "" and click away
    Then I see an error message "Enter the event type"

    When I set "Event name" to "" and click away
    Then I see an error message "Enter the event name"

    When I click on the "Tick if this event mapping has reporting restrictions" link
    And I press the "Add mapping" button
    Then I see an error message "Select an event handler to map to"

    #DMP-2674-AC1 Delete created event mapping for next run

    When I click on the "Cancel" link
    When I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type {{seq}}"
    And I click on "Change" in the same row as "DMP-2746-Automation-Type {{seq}}"
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I see "DMP-2746-Automation-Type {{seq}}" in the same row as "DMP-2746-Automation-Event-Name {{seq}}"

    When I press the "Yes - delete" button
    Then I see "Event mapping deleted" on the page

    When I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type {{seq}}"
    Then I see "There are no matching results." on the page

  @DMP-754 @regression
  Scenario: View event mapping
    Given I am logged on to the admin portal as an ADMIN user
    When I see "You can search for cases, hearings, events and audio." on the page
    And I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    And I see "Event mappings" on the page
    And I see "Add event mapping" on the page
    And I see "Filter by type, subtype, or name" on the page
    And I see "Filter by event handler" on the page
    And I select "Stop And Close Handler" from the "Filter by event handler" dropdown
    Then I see "Active only" on the page
    And I see "Active and inactive" on the page
    And I see "With restrictions" on the page
    And I see "Without restrictions" on the page
     And I verify the HTML table contains the following values
      | Type                   | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | 3000                   |          | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-3913               | ttt      | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 30300                  |          | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 1000                   | 999      | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-2764-Accessibility | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When  I select the "Active and inactive" radio button
    And I click on the "With restrictions" link
    Then I verify the HTML table contains the following values
      | Type                   | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | DMP-3913               | ttt      | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 3000                   | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-3913               | ttt      | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | 30300                  | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |
      | DMP-2764-Accessibility | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When I click on the "With restrictions" link
    And I click on the "Without restrictions" link
    Then I verify the HTML table contains the following values
      | Type | Subtype  | Event name | Event handler | Restrictions | Date created | Status   | *SKIP* |
      | 1000 | *IGNORE* | *IGNORE*   | *IGNORE*      | *IGNORE*     | *IGNORE*     | *IGNORE* | *SKIP* |

    When I select "All" from the "Filter by event handler" dropdown
    And I click on the "Without restrictions" link
    And I see "Next" on the page
    And I click on the pagination link "Next"
    And I click on the pagination link "3"
    And I see "Next" on the page
    And I see "Previous" on the page
    And I click on the pagination link "Previous"
    And I click on the pagination link "1"
    And I set "Filter by type, subtype, or name" to "DMP-2746-Automation-Type2"
    And I select "Stop And Close Handler" from the "Filter by event handler" dropdown
    Then I see "There are no matching results." on the page

  @DMP-3028 @regression
  Scenario: Testing attempt to add identical event mapping
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    And I press the "Add event mapping" button
    And I click on the "Cancel" link
    Then I see "Filter by type, subtype, or name" on the page

    #DMP-3028-AC1 Type and subtype already in use (using already existing from DMP-2746 testing)

    When I press the "Add event mapping" button
    And I set "Type" to "DMP-2746_Type"
    And I set "Subtype (optional)" to "DMP-2746_Subtype"
    And I set "Event name" to "DMP3028TEST"
    And I select "Standard Event Handler" from the dropdown
    And I press the "Add mapping" button
    Then I see "Type and subtype already in use" on the page
    And I see "The combination of type and subtype you entered are already in use." on the page
    And I see "Choose a different combination or make changes to the existing mapping." on the page

    #DMP-3028-AC2 Go back link

    When I click on the "Go back" link
    Then I see "Tick if this event mapping has reporting restrictions" on the page

  @DMP-2763
  Scenario: Edit event mapping
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "System configuration" link
    And I click on the "Event mappings" navigation link
    #Error handling
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    Then I see "Event mapping" on the page
    And I see "AC2-DMP-2764-Deletion-Test-2" on the page
    And I see "AC2-DMP-2764-Deletion-Test-2" on the page
    And I see "AC1-DMP-2763" on the page
    And I clear the "Event name" field
    And I see "Map to event handler" on the page
    And I select "Dar Stop Handler" from the "Map to event handler" dropdown
    Then I see "Event name" on the page
    And I click on the "Cancel" link
    #Cancel
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    And I clear the "Event name" field
    And I set "Event name" to "AC1-DMP-2763"
    And I see "Map to event handler" on the page
    And I see "Dar Start Handler" on the page
    And I see "Yes" on the page
    #And I see "07 Jun 2024" on the page
    And I see "Save as new version" on the page
    And I see "Cancel" on the page
    And I click on the "Cancel" link
    Then I see "System configuration" on the page
    #Create new version
    And I set "Filter by type, subtype, or name" to "AC2-DMP-2764-Deletion-Test-2"
    And I click on the "Change" link
    And I set "Event name" to "AC1-DMP-2763"
    And I see "Dar Start Handler" on the page
    And I select "Dar Stop Handler" from the dropdown
    And I see "Yes" on the page
    #And I see "07 Jun 2024" on the page
    And I press the "Save as new version" button
    Then I see "Saved new version of event mapping" on the page
    And I see "System configuration" on the page

  @DMP-2764
  Scenario: Delete event mapping
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "System configuration" link
    Then I click on the "Event mappings" navigation link
    And I click on the "Add event mapping" link
    Then I set "Type" to "DMP-2764-Automation-Type-3"
    And I set "Event name" to "DMP-2764-Automation-Event-Name"
    And I see "Map to event handler" on the page
    And I select "Dar Start Handler" from the "Map to event handler" dropdown
    And I click on the "Tick if this event mapping has reporting restrictions" link
    And I click on the "Add mapping" link
    Then I see "Event mapping added " on the page
    And I set "Filter by type, subtype, or name" to "DMP-2764-Automation-Type-3"
    And I click on the "Change" link
    Then I see "Event mapping" on the page
    And I see "DMP-2764-Automation-Event-Name" on the page
    And I see "DMP-2764-Automation-Type-3" on the page
    And I see "DMP-2764-Automation-Event-Name" on the page
    And I see "Dar Start Handler" on the page
    And I see "Yes" on the page
    When I select dt_created from table darts.event_handler where event_type = "" and event_sub_type = "" and active = "true"
    #And I see "06 Jun 2024" on the page
    And I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I click on the "No - cancel" link
    Then I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "Are you sure want to delete this event mapping?" on the page
    And I press the "Yes - delete" button
    Then I see "Event mapping deleted" on the page
    And I see "System configuration" on the page
    #AC2
    And I set "Filter by type, subtype, or name" to "Offences put to defendant"
    And I click on the "Change" link
    And I see "Offences put to defendant" on the page
    And I see "1000" on the page
    And I see "1001" on the page
    And I see "Offences put to defendant" on the page
    And I see "Standard Event Handler" on the page
    And I see "No" on the page
    And I see "02 Nov 2023" on the page
    And I see "Delete event mapping" on the page
    And I click on the "Delete event mapping" link
    Then I see "You cannot delete this event mapping" on the page
    And I see "This event mapping has been used and can no longer be deleted." on the page
    And I see "You can make changes and create a new version, or you can select the event handler 'No mapping'." on the page
    And I see "Go back" on the page
    And I click on the "Go back" link
    Then I see "Offences put to defendant" on the page

    @DMP-2471 @DMP-2475
    Scenario: Create and Edit new retention policy
      When I am logged on to the admin portal as an ADMIN user
      Then I click on the "System configuration" link
      And I click on the "Create policy" link
      And I see "Create new policy" on the page
      And I set "Display name" to "DMP-2471-AC1"
      And I set "Name" to "AC1-2471"
      And I set "Description" to ""
      And I set "Fixed policy key" to "99"
      And I set "Years" to "05"
      And I set "Months" to "04"
      And I set "Days" to "02"
      And I see "Policy start" on the page
      And I see "Start date" on the page
      And I set "Start date" to "04/10/2025"
      And I set "Hour" to "00"
      And I set "Minutes" to "59"
      And I click on the "Create" link
      Then I see "Retention policy created" on the page
      And I see "Retention policies" on the page
      And I see "Active" on the page
      And I see "Inactive" on the page
    #Cancel Policy.
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to "PMTest11"
      And I set "Name" to "PMTest11"
      And I set "Description" to ""
      And I set "Fixed policy key" to "TestPM11"
      And I set "Years" to "05"
      And I set "Months" to "05"
      And I set "Days" to "05"
      And I set "Start date" to "04/10/2025"
      And I set "Hour" to "05"
      And I set "Minutes" to "05"
      And I click on the "Cancel" link
      Then I see "Retention policies" on the page
      And I see "Active" on the page
      And I see "Inactive" on the page
   #Error
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to ""
      And I set "Name" to ""
      And I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A"
      And I set "Fixed policy key" to ""
      And I set "Years" to ""
      And I set "Months" to ""
      And I set "Days" to ""
      And I set "Start date" to ""
      And I set "Hour" to ""
      And I set "Minutes" to ""
      And I click on the "Create" link
      Then I see "There is a problem" on the page
      And I see "Enter a display name" on the page
      And I see "Enter a name" on the page
      And I see "Enter a description shorter than 256 characters" on the page
      And I see "Enter a fixed policy key" on the page
      And I see "Enter a duration of at least 1 day" on the page
      And I see "Enter a policy start date" on the page
      And I see "Enter a start time" on the page
    # All fields are already exist
      And I click on the "Cancel" link
      Then I see "Retention policies" on the page
      When I click on the "Create policy" link
      Then I see "Create new policy" on the page
      And I set "Display name" to "PM-Test"
      And I set "Name" to "PM-Test1"
      And I set "Description" to ""
      And I set "Fixed policy key" to "Test-PM"
      And I set "Years" to "00"
      And I set "Months" to "01"
      And I set "Days" to "02"
      And I set "Start date" to "01/01/2025"
      And I set "Hour" to "01"
      And I set "Minutes" to "00"
      And I click on the "Create" link
    	Then I see an error message "Enter a unique display name"
      And I see "Enter a unique name" on the page
      And I see "The fixed policy key entered already exists in the database. Fixed policy keys must be unique" on the page
      Then I click on the "Cancel" link
      #Edit policy @DMP-2475
    And I click on "Edit Policy" in the same row as "DMP-2471-AC1"
    And I set "Display name" to "DMP-2475-AC1-Edit"
    And I set "Name" to "AC1-2475-Edit"
    And I set "Description" to "Editing DMP-2471"
    And I set "Fixed policy key" to "92"
    And I set "Years" to "02"
    And I set "Months" to "12"
    And I set "Days" to "31"
    And I see "Policy start" on the page
    And I see "Start date" on the page
    And I set "Start date" to "29/04/2026"
    And I set "Hour" to "10"
    And I set "Minutes" to "30"
    And I click on the "Save" link
    Then I see "Retention policy updated" on the page
  #Cancel policy
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I click on the "Cancel" link
    Then I see "Retention policies" on the page
  #AC3
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I see "Retention policy" on the page
    And I clear the "Display name" field
    And I set "Display name" to ""
    And I clear the "Name" field
    And I set "Name" to ""
    And I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A"
    And I clear the "Fixed policy key" field
    And I set "Fixed policy key" to ""
    And I clear the "Years" field
    And I set "Years" to ""
    And I clear the "Months" field
    And I set "Months" to ""
    And I clear the "Days" field
    And I set "Days" to ""
    And I clear the "Start date" field
    And I set "Start date" to ""
    And I clear the "Hour" field
    And I set "Hour" to ""
    And I clear the "Minutes" field
    And I set "Minutes" to ""
    And I click on the "Save" link
    Then I see "There is a problem" on the page
    And I see "Enter a display name" on the page
    And I see "Enter a name" on the page
    And I see "Enter a description shorter than 256 characters" on the page
    And I see "Enter a fixed policy key" on the page
    And I see "Enter a duration of at least 1 day" on the page
    And I see "Enter a policy start date" on the page
    And I see "Enter a start time" on the page
  #fields are already exist
    And I click on the "Cancel" link
    Then I see "Retention policies" on the page
    And I click on "Edit Policy" in the same row as "DMP-2475-AC1"
    And I set "Display name" to "Custodial"
    And I set "Name" to "DMP-2532 AC3"
    And I set "Description" to ""
    And I clear the "Fixed policy key" field
    And I set "Fixed policy key" to ""
    And I set "Years" to "00"
    And I set "Months" to "12"
    And I set "Days" to "31"
    And I set "Start date" to "01/01/2024"
    And I set "Hour" to "11"
    And I set "Minutes" to "30"
    And I click on the "Save" link
    Then I see an error message "Enter a unique display name"
    And I see "Enter a unique name" on the page
    And I see "Enter a fixed policy key" on the page
    And I see "Enter a policy start date in the future" on the page
    And I see "Enter a policy start time in the future" on the page

