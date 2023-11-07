Feature: Language Shop User

  Background:
    Given I am logged on to DARTS as an LANGUAGESHOP user

  @DMP-770
  Scenario Outline: Verify download playback file
    When I click on the "Your Audio" link
    When I click on "View" in the same row as "<CaseID>"
    Then I see "<CaseID>" on the page
    And I see "<Courthouse>" on the page
    And I see "<Defendants>" on the page
    And I see "<HearingDate>" on the page
    And I see "<StartTime>" on the page
    And I see "<EndTime>" on the page
    And I press the "Download audio file" button
    And I see "There is a problem" on the page
    And I see "You do not have permission to view this file" on the page
    And I see "Email crownITsupport@justice.gov.uk to request access" on the page

    Examples:
      | CaseID        | Courthouse    | Defendants | HearingDate | StartTime | EndTime  |
      | Case1_DMP1398 | LEEDS_DMP1398 |            | 2 Nov 2023  | 15:20:23  | 15:21:23 |