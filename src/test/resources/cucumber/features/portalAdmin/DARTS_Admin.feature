Feature: Admin portal


  @DMP-2714 @obsolete
  Scenario: Update admin portal navigation
    When I am logged on to the admin portal as an ADMIN user
  #AC1 - Updated nav
    And I see "Users" on the page
    And I see "Groups" on the page
    And I see "Courthouses" on the page
    And I see "Events" on the page
    And I see "Audio cache" on the page
    And I see "Transcripts" on the page
    And I see "File deletion" on the page
    And I see "System configuration" on the page
  #AC2 - File deletion tabs
    And I click on the "File deletion" navigation link
    And I see "File deletion" on the page
    And I see "Audio files" on the page
    And I see "Transcripts" on the page
  #AC3 - System configuration tabs
    And I click on the "System configuration" navigation link
    And I see "System configuration" on the page
    And I see "Retention policies" on the page
    And I see "Event mapping" on the page
    And I see "Automated tasks" on the page

  @DMP-2959 @review
  Scenario: Add error messaging to Search Transcripts screen
    Given I am logged on to the admin portal as an ADMIN user
    When I click on the "System configuration" link
    Then I see "Retention policies" on the page
    Then I click on "Create new version" in the same row as "DMP-2474-4 retention policy type."
    And I clear the "Display name" field
    And I set "Display name" to "DMP-2471-Display name-1" and click away
    Then I see "Enter a unique display name" on the page

    And  I clear the "Display name" field
    When I set "Display name" to "" and click away
    Then I see "Enter a display name" on the page

    And I clear the "Name" field
    When I set "Name" to "Test" and click away
    Then I see "Enter a unique name" on the page

    And I clear the "Name" field
    When I set "Name" to "" and click away
    Then I see "Enter a name" on the page

    And I clear the "Description" field
    When I set "Description" to "q3TCS3L1WznoYgzZzrvuJf28lTuxaq5cckBrVlT0xuPN4seDgzWaX0RMuF6cAYKaZMxrQpJBzHmUzLGh32RbglWr6OOZA2b0zzTp1rKCtOKAYlVcyocDyp4yOLv1PSuFtOR73f7k2cT5vJPcQSXqdGxzlbviKj6JhQr7lSz6IpW2rxyAjV0TwpAYiJIgvK9se05x02yL6BrZUVTm0JJuuvKpjkXQrPKB8AUujfQPpRfUuLAdL8r16XolnERhgb3A" and click away
    Then I see "Enter a description shorter than 256 characters" on the page

    And I clear the "Description" field
    When I set "Years" to "00" and click away
    Then I see "Enter a duration of at least 1 day" on the page
    And I set "Months" to "01"
    When I set "Start date" to "{{date-10/}}"
    And I set "Hour" to "14"
    And I set "Minutes" to "20" and click away

    And I click on the "Create" link
    Then I see "Enter a policy start date in the future" on the page
    And I see "Enter a policy start time in the future" on the page

    Then I set "Display name" to "DMP-2474-Automation-1"
    And I set "Name" to "DMP-2474-Automation-1"
    And I set "Start date" to "{{date+0/}}"
    And I click on the "Create" link
    Then I see "Retention policy version created" on the page

  @DMP-1662 @review
  Scenario: Deletion Reasons
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Transcripts" link
    Then I click on the "Completed transcripts" link
    And I set "Case ID" to "DMP1600-case1"
    And I press the "Search" button
    Then I click on "761" in the same row as "Manual"
    And I see " Hide or delete " on the page
    And I press the " Hide or delete " button
    Then I press the "Hide or delete" button
      #Error Message
    And I see "Select a reason for hiding and/or deleting the file" on the page
    And I see "Enter a ticket reference" on the page
    And I see "Provide details relating to this action" on the page
      #Cancel
    And I see "Select a reason" on the page
    And I see " Other reason to hide only " on the page
    And I see " File will be hidden only " on the page
    And I check the " Other reason to hide only " checkbox
    And I set "Enter ticket reference" to "DMP1600"
    And I set "Comments" to "Test"
    And I click on the "Cancel" link
      #Hide file
    And I press the " Hide or delete " button
    And I see "Select a reason" on the page
    And I see " Other reason to hide only " on the page
    And I see " File will be hidden only " on the page
    And I select the "Other reason to hide only" radio button
    And I set "Enter ticket reference" to "DMP1600"
    And I set "Comments" to "Test" and click away
    Then I see "You have 252 characters remaining" on the page
    And I press the "Hide or delete" button
    Then I see " File(s) successfully hidden or marked for deletion " on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    Then I press the "Continue" button
    And I see "Important" on the page
    And I see "This file is hidden in DARTS" on the page

  @DMP-3247 @DMP-3382 @review
  Scenario: Transcription File Details Page
    When I am logged on to the admin portal as an ADMIN user
    And I click on the "Transcripts" link
    Then I click on the "Completed transcripts" link
    And I set "Case ID" to "C1216002"
    And I press the "Search" button
        #Basic details
    Then I click on the "Back" link
    And I see "Transcripts" on the page
    And I click on the "Completed transcripts" link
    And I set "Case ID" to "C1216002"
    And I press the "Search" button

    Then I see "Transcript file" on the page
    And I see "Basic details" on the page
    And I see "C1216002" in the same row as "Case ID"
    And I see "02 Apr 2024" in the same row as "Hearing date"
    And I see "Harrow Crown Court" in the same row as "Courthouse"
    And I see "1216-9" in the same row as "Courtroom"
    And I see "DefC 1216-9" in the same row as "Defendant(s)"
    And I see "Defendant(s)" in the same row as "Judge(s)"

    And I see "Request details" on the page
    And I see "Specified Times" in the same row as "Request type"
    And I see "23345" in the same row as "Request ID"
    And I see "Overnight" in the same row as "Urgency"
    And I see "Requestor" in the same row as "Requested by"
    And I see "Requesting transcript Specified Times for one minute of audio selected via event checkboxes." in the same row as "Instructions"
    And I see "Yes" in the same row as "Judge approval"
        #Advanced details
    Then I click on the "Advanced details" link
    And I see "Advanced details" on the page
    And I see "Transcription object ID" on the page
    And I see "Content object ID" on the page
    And I see "Clip ID" on the page
    And I see "cDc5hZaR35EMEvnA3XJDyQ==" in the same row as "Checksum"
    And I see "0.98MB" in the same row as "File size"
    And I see "application/msword" in the same row as "File type"
    And I see "file-sample_1MB.doc" in the same row as "Filename"
    And I see "02 Apr 2024 at 9:49:55AM" in the same row as "Date uploaded"
    And I see "Transcriber" in the same row as "Uploaded by"
    And I see "Transcriber" in the same row as "Last modified by"
    And I see "No" in the same row as "Transcription hidden?"
    And I see "" in the same row as "Hidden by"
    And I see "" in the same row as "Date hidden"
    And I see "" in the same row as "Retain until"
    And I see " Hide or delete " on the page
    And I press the " Hide or delete " button
    Then I press the "Hide or delete" button
      #Error Message
    And I see "Select a reason for hiding and/or deleting the file" on the page
    And I see "Enter a ticket reference" on the page
    And I see "Provide details relating to this action" on the page
      #Cancel
    And I see "Select a reason" on the page
    And I see " Other reason to hide only " on the page
    And I see " File will be hidden only " on the page
    And I check the " Other reason to hide only " checkbox
    And I set "Enter ticket reference" to "DMP1600"
    And I set "Comments" to "Test"
    And I click on the "Cancel" link
        #Hide file
    Then I press the " Hide or delete " button
    And I select the "Other reason to hide only" radio button
    And I set "Enter ticket reference" to "DMP1600"
    And I set "Comments" to "Test" and click away
    Then I see "You have 252 characters remaining" on the page
    And I press the "Hide or delete" button

    Then I see " File(s) successfully hidden or marked for deletion " on the page
    And I see "Check for associated files" on the page
    And I see "There may be other associated audio or transcript files that also need hiding or deleting." on the page
    And I press the "Continue" button
    And I see "Important" on the page
    And I see "This file is hidden in DARTS" on the page
    And I see "DARTS users cannot view this file. You can unhide the file" on the page
    And I see "Hidden by - Darts Admin" on the page
    And I see "Reason - Other reason to hide only" on the page
    And I see "Test" on the page
    And I click on the "Advanced details" link
    And I see "Yes" in the same row as "Transcription hidden?"
    And I see "Unhide" on the page
        #Unhide file
    Then I press the "Unhide" button
    And I do not see "Important" on the page
    And I click on the "Advanced details" link
    And I see "No" in the same row as "Transcription hidden?"
    And I see " Hide or delete " on the page

  @DMP-3234
  Scenario: Add a link to "user portal" link to each admin portal screen
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "Users" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "Groups" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "Courthouses" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "Transformed media" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "Transcripts" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "File deletion" link
    Then I click on the "User portal" link
    And I press the "back" button on my browser
    And I click on the "System configuration" link
    Then I click on the "User portal" link

  @DMP-3235
  Scenario: Add a link to "Admin portal" to each DARTS portal screen
    When I am logged on to the admin portal as an ADMIN user
    Then I click on the "User portal" link
    Then I click on the "Admin portal" link
    Then I click on the "User portal" link
    Then I click on the "Your audio" link
    Then I click on the "Admin portal" link
    Then I click on the "User portal" link
    Then I click on the "Your transcripts" link
    Then I click on the "Admin portal" link

    @DMP-4210-AC1-AC2
    Scenario: File deletion back link
      Given I am logged on to the admin portal as an ADMIN user
      When I click on the "File deletion" link
      And I see "Files marked for deletion" on the page
      #AC1
      Then I click on the "Audio files" link
      And I see "94034" in the same row as "21 Oct 2024" "B911266-7"
      And I click on the "94034" link
      And I see link with text "Back"
      And I see "Important" on the page
      And I see "This file is hidden in DARTS and is marked for manual deletion" on the page
      And I click on the "Back" link
      Then I see "Files marked for deletion" on the page
      And I see link with text "Audio files"
      And I see "94034" in the same row as "21 Oct 2024" "B911266-7"
      #AC2
      And I see "Files marked for deletion" on the page
      And I see "Transcripts" in the same row as "Audio files"
      Then I click on the "Transcripts" sub-menu link
      And I see "Transcripts" on the page
      And I see "13821" in the same row as "C400481006" "Harrow Crown Court"
      Then I click on the "13821" link
      And I see link with text "Back"
      And I see "Important" on the page
      And I see "This file is hidden in DARTS and is marked for manual deletion" on the page
      And I click on the "Back" link
      Then I see "Files marked for deletion" on the page
      And I see link with text "Transcripts"
      And I see "13821" in the same row as "C400481006" "Harrow Crown Court"
