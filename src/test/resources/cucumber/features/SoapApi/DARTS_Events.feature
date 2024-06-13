@DMP-3060 @broken
Feature: Test operation of SOAP events

Based on spreadsheet "handler mapping colour coded - modernised - pre-updates - 19122023.xlsx"

@EVENT_API @SOAP_EVENT @STANDARD_EVENT @regression
Scenario Outline: Create a case
  Given I create a case
    | courthouse   | case_number   | defendants    | judges     | prosecutors     | defenders     |
    | <courthouse> | <caseNumbers> | defendant one | test judge | test prosecutor | test defender |
Examples:
  | courthouse         | caseNumbers  |
  | Harrow Crown Court | T{{seq}}201  | 


@EVENT_API @SOAP_EVENT @STANDARD_EVENT @regression
Scenario Outline: Create standard events
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "StandardEventHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type   | subType | eventText    | caseRetention | totalSentence | text                                                                                                                                   | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:00:00}} | {{seq}}001 | {{seq}}1001 | 1000   | 1001    | text {{seq}} |               |               | Offences put to defendant                                                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:00:20}} | {{seq}}002 | {{seq}}1002 | 1000   | 1002    | text {{seq}} |               |               | Proceedings in chambers                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:00:40}} | {{seq}}003 | {{seq}}1003 | 1000   | 1003    | text {{seq}} |               |               | Prosecution opened                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:01:00}} | {{seq}}004 | {{seq}}1004 | 1000   | 1004    | text {{seq}} |               |               | Voir dire                                                                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:01:20}} | {{seq}}005 | {{seq}}1005 | 1000   | 1005    | text {{seq}} |               |               | Prosecution closed case                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:01:40}} | {{seq}}006 | {{seq}}1006 | 1000   | 1006    | text {{seq}} |               |               | Prosecution gave closing speech                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:02:00}} | {{seq}}007 | {{seq}}1007 | 1000   | 1007    | text {{seq}} |               |               | Defence opened case                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:02:20}} | {{seq}}008 | {{seq}}1008 | 1000   | 1009    | text {{seq}} |               |               | Defence closed case                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:02:40}} | {{seq}}009 | {{seq}}1009 | 1000   | 1010    | text {{seq}} |               |               | Defence gave closing speech                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:03:00}} | {{seq}}010 | {{seq}}1010 | 1000   | 1011    | text {{seq}} |               |               | Discussion on directions to be given to the jury                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:03:20}} | {{seq}}011 | {{seq}}1011 | 1000   | 1012    | text {{seq}} |               |               | Discussion on juror irregularity                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:03:40}} | {{seq}}012 | {{seq}}1012 | 1000   | 1014    | text {{seq}} |               |               | Discussion on contempt of court issues                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:04:00}} | {{seq}}013 | {{seq}}1013 | 1000   | 1022    | text {{seq}} |               |               | Application: Goodyear indication                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:04:20}} | {{seq}}014 | {{seq}}1014 | 1000   | 1024    | text {{seq}} |               |               | Application: No case to answer                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:04:40}} | {{seq}}015 | {{seq}}1015 | 1000   | 1026    | text {{seq}} |               |               | Judge summing-up                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:05:00}} | {{seq}}016 | {{seq}}1016 | 1000   | 1027    | text {{seq}} |               |               | Judge directed defendant                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:05:20}} | {{seq}}017 | {{seq}}1017 | 1000   | 1028    | text {{seq}} |               |               | Judge directed jury                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:05:40}} | {{seq}}018 | {{seq}}1018 | 1000   | 1029    | text {{seq}} |               |               | Judge gave a majority direction                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:06:00}} | {{seq}}019 | {{seq}}1019 | 1000   | 1051    | text {{seq}} |               |               | Jury in                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:06:20}} | {{seq}}020 | {{seq}}1020 | 1000   | 1052    | text {{seq}} |               |               | Jury sworn-in                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:06:40}} | {{seq}}021 | {{seq}}1021 | 1000   | 1053    | text {{seq}} |               |               | Jury out                                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:07:00}} | {{seq}}022 | {{seq}}1022 | 1000   | 1054    | text {{seq}} |               |               | Jury retired                                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:07:20}} | {{seq}}023 | {{seq}}1023 | 1000   | 1056    | text {{seq}} |               |               | Jury gave verdict                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:07:40}} | {{seq}}024 | {{seq}}1024 | 1000   | 1057    | text {{seq}} |               |               | Juror discharged                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:08:00}} | {{seq}}025 | {{seq}}1025 | 1000   | 1058    | text {{seq}} |               |               | Jury discharged                                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:08:20}} | {{seq}}026 | {{seq}}1026 | 1000   | 1059    | text {{seq}} |               |               | Witness recalled                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:08:40}} | {{seq}}027 | {{seq}}1027 | 1000   | 1062    | text {{seq}} |               |               | Defendant sworn-in                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:09:00}} | {{seq}}028 | {{seq}}1028 | 1000   | 1063    | text {{seq}} |               |               | Defendant examination in-chief                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:09:20}} | {{seq}}029 | {{seq}}1029 | 1000   | 1064    | text {{seq}} |               |               | Defendant continued                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:09:40}} | {{seq}}030 | {{seq}}1030 | 1000   | 1065    | text {{seq}} |               |               | Defendant cross-examined by Prosecution                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:10:00}} | {{seq}}031 | {{seq}}1031 | 1000   | 1066    | text {{seq}} |               |               | Defendant cross-examined Defence                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:10:20}} | {{seq}}032 | {{seq}}1032 | 1000   | 1067    | text {{seq}} |               |               | Re-examination                                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:10:40}} | {{seq}}033 | {{seq}}1033 | 1000   | 1068    | text {{seq}} |               |               | Defendant released                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:11:00}} | {{seq}}034 | {{seq}}1034 | 1000   | 1069    | text {{seq}} |               |               | Defendant recalled                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:11:20}} | {{seq}}035 | {{seq}}1035 | 1000   | 1070    | text {{seq}} |               |               | Defendant questioned by Judge                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:11:40}} | {{seq}}036 | {{seq}}1036 | 2100   |         | text {{seq}} |               |               | Defendant identified                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:12:00}} | {{seq}}037 | {{seq}}1037 | 2198   | 3900    | text {{seq}} |               |               | Defendant arraigned                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:12:20}} | {{seq}}038 | {{seq}}1038 | 2198   | 3901    | text {{seq}} |               |               | Defendant rearraigned                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:12:40}} | {{seq}}039 | {{seq}}1039 | 2198   | 3903    | text {{seq}} |               |               | Prosecution responded                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:13:00}} | {{seq}}040 | {{seq}}1040 | 2198   | 3904    | text {{seq}} |               |               | Mitigation                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:13:20}} | {{seq}}041 | {{seq}}1041 | 2198   | 3905    | text {{seq}} |               |               | Defence responded                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:13:40}} | {{seq}}042 | {{seq}}1042 | 2198   | 3906    | text {{seq}} |               |               | Discussion on ground rules                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:14:00}} | {{seq}}043 | {{seq}}1043 | 2198   | 3907    | text {{seq}} |               |               | Discussion on basis of plea                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:14:20}} | {{seq}}044 | {{seq}}1044 | 2198   | 3918    | text {{seq}} |               |               | Point of law raised                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:14:40}} | {{seq}}045 | {{seq}}1045 | 2198   | 3921    | text {{seq}} |               |               | Prosecution application: Adjourn                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:15:00}} | {{seq}}046 | {{seq}}1046 | 2198   | 3931    | text {{seq}} |               |               | Prosecution application: Break fixture                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:15:20}} | {{seq}}047 | {{seq}}1047 | 2198   | 3932    | text {{seq}} |               |               | Defence application: Break fixture                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:25:00}} | {{seq}}251 | {{seq}}1251 | 2198   | 3934    | text {{seq}} | 4             | 26Y0M0D       | Judge passed sentence                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:15:40}} | {{seq}}048 | {{seq}}1048 | 2198   | 3935    | text {{seq}} |               |               | Judge directed Prosecution to obtain a report                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:16:00}} | {{seq}}049 | {{seq}}1049 | 2198   | 3936    | text {{seq}} |               |               | Judge directed Defence to obtain a medical report                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:16:20}} | {{seq}}050 | {{seq}}1050 | 2198   | 3937    | text {{seq}} |               |               | Judge directed Defence to obtain a psychiatric report                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:16:40}} | {{seq}}051 | {{seq}}1051 | 2198   | 3938    | text {{seq}} |               |               | Judge directed Defence counsel to obtain a report                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:17:00}} | {{seq}}052 | {{seq}}1052 | 2198   | 3940    | text {{seq}} |               |               | Judges ruling                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:17:20}} | {{seq}}053 | {{seq}}1053 | 2198   | 3986    | text {{seq}} |               |               | Defence application: Adjourn                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:17:40}} | {{seq}}054 | {{seq}}1054 | 2199   |         | text {{seq}} |               |               | Prosecution application                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:18:00}} | {{seq}}055 | {{seq}}1055 | 2201   |         | text {{seq}} |               |               | Defence application                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:18:20}} | {{seq}}056 | {{seq}}1056 | 2902   | 3964    | text {{seq}} |               |               | Application: Fitness to plead                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:18:40}} | {{seq}}057 | {{seq}}1057 | 2906   | 3968    | text {{seq}} |               |               | Witness gave pre-recorded evidence                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:19:00}} | {{seq}}058 | {{seq}}1058 | 2907   | 3969    | text {{seq}} |               |               | Witness read                                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:19:20}} | {{seq}}059 | {{seq}}1059 | 2908   | 3970    | text {{seq}} |               |               | Witness sworn-in                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:19:40}} | {{seq}}060 | {{seq}}1060 | 2909   | 3971    | text {{seq}} |               |               | Witness examination in-chief                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:20:00}} | {{seq}}061 | {{seq}}1061 | 2910   | 3972    | text {{seq}} |               |               | Witness continued                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:20:20}} | {{seq}}062 | {{seq}}1062 | 2912   | 3974    | text {{seq}} |               |               | Re-examination                                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:20:40}} | {{seq}}063 | {{seq}}1063 | 2913   | 3975    | text {{seq}} |               |               | Witness released                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:21:00}} | {{seq}}064 | {{seq}}1064 | 2914   | 3976    | text {{seq}} |               |               | Witness questioned by Judge                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:21:20}} | {{seq}}065 | {{seq}}1065 | 2918   | 3980    | text {{seq}} |               |               | Intermediatory sworn-in                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:21:40}} | {{seq}}066 | {{seq}}1066 | 2920   | 3981    | text {{seq}} |               |               | Probation gave oral PSR                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:22:00}} | {{seq}}067 | {{seq}}1067 | 2933   | 3982    | text {{seq}} |               |               | Victim Personal Statement(s) read                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:22:20}} | {{seq}}068 | {{seq}}1068 | 2934   | 3983    | text {{seq}} |               |               | Unspecified event                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:22:40}} | {{seq}}069 | {{seq}}1069 | 4101   |         | text {{seq}} |               |               | Witness cross-examined by Defence                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:23:00}} | {{seq}}070 | {{seq}}1070 | 4102   |         | text {{seq}} |               |               | Witness cross-examined by Prosecution                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:23:20}} | {{seq}}071 | {{seq}}1071 | 10200  |         | text {{seq}} |               |               | Defendant attendance                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:23:40}} | {{seq}}072 | {{seq}}1072 | 10300  |         | text {{seq}} |               |               | Prosecution addresses judge                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:24:00}} | {{seq}}073 | {{seq}}1073 | 10400  |         | text {{seq}} |               |               | Defence addresses judge                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:24:20}} | {{seq}}074 | {{seq}}1074 | 20100  |         | text {{seq}} |               |               | Bench Warrant Issued                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:24:40}} | {{seq}}075 | {{seq}}1075 | 20101  |         | text {{seq}} |               |               | Bench Warrant Executed                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:25:00}} | {{seq}}076 | {{seq}}1076 | 20198  | 13900   | text {{seq}} |               |               | Acceptable guilty plea(s) entered late to some or all charges / counts on the charge sheet, offered for the first time by the defence. |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:25:20}} | {{seq}}077 | {{seq}}1077 | 20198  | 13901   | text {{seq}} |               |               | Acceptable guilty plea(s) entered late to some or all charges / counts on the charge sheet, previously rejected by the prosecution.    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:25:40}} | {{seq}}078 | {{seq}}1078 | 20198  | 13902   | text {{seq}} |               |               | Acceptable guilty plea(s) to alternative new charge (not previously on the charge sheet), first offered by defence.                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:26:00}} | {{seq}}079 | {{seq}}1079 | 20198  | 13903   | text {{seq}} |               |               | Acceptable guilty plea(s) to alternative new charge (not previously on the charge sheet), previously rejected by the prosecution.      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:26:20}} | {{seq}}080 | {{seq}}1080 | 20198  | 13904   | text {{seq}} |               |               | Defendant bound over, acceptable to prosecution - offered for the first by the defence.                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:26:40}} | {{seq}}081 | {{seq}}1081 | 20198  | 13905   | text {{seq}} |               |               | Effective Trial.                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:27:00}} | {{seq}}082 | {{seq}}1082 | 20198  | 13906   | text {{seq}} |               |               | Defendant bound over, now acceptable to prosecution - previously rejected by the prosecution                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:27:20}} | {{seq}}083 | {{seq}}1083 | 20198  | 13907   | text {{seq}} |               |               | Unable to proceed with the trail because defendant incapable through alcohol/drugs                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:27:40}} | {{seq}}084 | {{seq}}1084 | 20198  | 13908   | text {{seq}} |               |               | Defendant deceased                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:28:00}} | {{seq}}085 | {{seq}}1085 | 20198  | 13909   | text {{seq}} |               |               | Prosecution end case: insufficient evidence                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:28:20}} | {{seq}}086 | {{seq}}1086 | 20198  | 13910   | text {{seq}} |               |               | Prosecution end case: witness absent / withdrawn                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:28:40}} | {{seq}}087 | {{seq}}1087 | 20198  | 13911   | text {{seq}} |               |               | Prosecution end case: public interest grounds                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:29:00}} | {{seq}}088 | {{seq}}1088 | 20198  | 13912   | text {{seq}} |               |               | Prosecution end case: adjournment refused                                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:29:20}} | {{seq}}089 | {{seq}}1089 | 20198  | 13913   | text {{seq}} |               |               | Prosecution not ready: served late notice of additional evidence on defence                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:29:40}} | {{seq}}090 | {{seq}}1090 | 20198  | 13914   | text {{seq}} |               |               | Prosecution not ready: specify in comments                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:30:00}} | {{seq}}091 | {{seq}}1091 | 20198  | 13915   | text {{seq}} |               |               | Prosecution failed to disclose unused material                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:30:20}} | {{seq}}092 | {{seq}}1092 | 20198  | 13916   | text {{seq}} |               |               | Prosecution witness absent: police                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:30:40}} | {{seq}}093 | {{seq}}1093 | 20198  | 13917   | text {{seq}} |               |               | Prosecution witness absent: professional / expert                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:31:00}} | {{seq}}094 | {{seq}}1094 | 20198  | 13918   | text {{seq}} |               |               | Prosecution witness absent: other                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:31:20}} | {{seq}}095 | {{seq}}1095 | 20198  | 13919   | text {{seq}} |               |               | Prosecution advocate engaged in another trial                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:31:40}} | {{seq}}096 | {{seq}}1096 | 20198  | 13920   | text {{seq}} |               |               | Prosecution advocate failed to attend                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:32:00}} | {{seq}}097 | {{seq}}1097 | 20198  | 13921   | text {{seq}} |               |               | Prosecution increased time estimate - insufficient time for trail to start                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:32:20}} | {{seq}}098 | {{seq}}1098 | 20198  | 13922   | text {{seq}} |               |               | Defence not ready: disclosure problems                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:32:40}} | {{seq}}099 | {{seq}}1099 | 20198  | 13923   | text {{seq}} |               |               | Defence not ready: specify in comments (inc. no instructions)                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:33:00}} | {{seq}}100 | {{seq}}1100 | 20198  | 13924   | text {{seq}} |               |               | Defence asked for additional prosecution witness toattend                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:33:20}} | {{seq}}101 | {{seq}}1101 | 20198  | 13925   | text {{seq}} |               |               | Defence witness absent                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:33:40}} | {{seq}}102 | {{seq}}1102 | 20198  | 13926   | text {{seq}} |               |               | Defendant absent - did not proceed in absence (judicial discretion)                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:34:00}} | {{seq}}103 | {{seq}}1103 | 20198  | 13927   | text {{seq}} |               |               | Defendant ill or otherwise unfit to proceed                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:34:20}} | {{seq}}104 | {{seq}}1104 | 20198  | 13928   | text {{seq}} |               |               | Defendant not produced by PECS                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:34:40}} | {{seq}}105 | {{seq}}1105 | 20198  | 13929   | text {{seq}} |               |               | Defendant absent - unable to proceed as defendant not notified of place and time of hearing                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:35:00}} | {{seq}}106 | {{seq}}1106 | 20198  | 13930   | text {{seq}} |               |               | Defence increased time estimate - insufficient time for trial to start                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:35:20}} | {{seq}}107 | {{seq}}1107 | 20198  | 13931   | text {{seq}} |               |               | Defence advocate engaged in other trial                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:35:40}} | {{seq}}108 | {{seq}}1108 | 20198  | 13932   | text {{seq}} |               |               | Defence advocate failed to attend                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:36:00}} | {{seq}}109 | {{seq}}1109 | 20198  | 13933   | text {{seq}} |               |               | Defence dismissed advocate                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:36:20}} | {{seq}}110 | {{seq}}1110 | 20198  | 13934   | text {{seq}} |               |               | Another case over-ran                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:36:40}} | {{seq}}111 | {{seq}}1111 | 20198  | 13935   | text {{seq}} |               |               | Judge / magistrate availability                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:37:00}} | {{seq}}112 | {{seq}}1112 | 20198  | 13936   | text {{seq}} |               |               | Case not reached / insufficient cases drop out / floater not reached                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:37:20}} | {{seq}}113 | {{seq}}1113 | 20198  | 13937   | text {{seq}} |               |               | Equipment / accommodation                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:37:40}} | {{seq}}114 | {{seq}}1114 | 20198  | 13938   | text {{seq}} |               |               | No interpreter available                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:38:00}} | {{seq}}115 | {{seq}}1115 | 20198  | 13939   | text {{seq}} |               |               | Insufficient jurors available                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:38:20}} | {{seq}}116 | {{seq}}1116 | 20198  | 13940   | text {{seq}} |               |               | Outstanding committals in a magistrates court                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:38:40}} | {{seq}}117 | {{seq}}1117 | 20198  | 13941   | text {{seq}} |               |               | Outstanding committals in a Crown Court centre                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:39:00}} | {{seq}}118 | {{seq}}1118 | 20200  |         | text {{seq}} |               |               | Bail and custody                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:39:20}} | {{seq}}119 | {{seq}}1119 | 20501  |         | text {{seq}} |               |               | Indictment to be filed                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:39:40}} | {{seq}}120 | {{seq}}1120 | 20502  |         | text {{seq}} |               |               | List from plea and direction hearing                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:40:00}} | {{seq}}121 | {{seq}}1121 | 20503  |         | text {{seq}} |               |               | Certify readiness for trial                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:40:20}} | {{seq}}122 | {{seq}}1122 | 20504  |         | text {{seq}} |               |               | Directions form completed                                                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:40:40}} | {{seq}}123 | {{seq}}1123 | 20601  |         | text {{seq}} |               |               | Appellant attendance                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:41:00}} | {{seq}}124 | {{seq}}1124 | 20602  |         | text {{seq}} |               |               | Respondant case opened                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:41:20}} | {{seq}}125 | {{seq}}1125 | 20603  |         | text {{seq}} |               |               | Appeal witness sworn in                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:41:40}} | {{seq}}126 | {{seq}}1126 | 20604  |         | text {{seq}} |               |               | Appeal witness released                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:42:00}} | {{seq}}127 | {{seq}}1127 | 20605  |         | text {{seq}} |               |               | Respondant case closed                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:42:20}} | {{seq}}128 | {{seq}}1128 | 20606  |         | text {{seq}} |               |               | Appellant case opened                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:42:40}} | {{seq}}129 | {{seq}}1129 | 20607  |         | text {{seq}} |               |               | Appellant submissions                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:43:00}} | {{seq}}130 | {{seq}}1130 | 20608  |         | text {{seq}} |               |               | Appellant case closed                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:43:20}} | {{seq}}131 | {{seq}}1131 | 20609  |         | text {{seq}} |               |               | Bench retires                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:43:40}} | {{seq}}132 | {{seq}}1132 | 20613  |         | text {{seq}} |               |               | Appeal witness continues                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:44:00}} | {{seq}}133 | {{seq}}1133 | 20701  |         | text {{seq}} |               |               | Application to stand out                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:44:20}} | {{seq}}134 | {{seq}}1134 | 20702  |         | text {{seq}} |               |               | Defence application                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:44:40}} | {{seq}}135 | {{seq}}1135 | 20703  |         | text {{seq}} |               |               | Judges ruling                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:45:00}} | {{seq}}136 | {{seq}}1136 | 20704  |         | text {{seq}} |               |               | Prosecution application                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:45:20}} | {{seq}}137 | {{seq}}1137 | 20705  |         | text {{seq}} |               |               | Other application                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:45:40}} | {{seq}}138 | {{seq}}1138 | 20901  |         | text {{seq}} |               |               | Time estimate                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:46:00}} | {{seq}}139 | {{seq}}1139 | 20902  |         | text {{seq}} |               |               | Jury sworn in                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:46:20}} | {{seq}}140 | {{seq}}1140 | 20903  |         | text {{seq}} |               |               | Prosecution opening                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:46:40}} | {{seq}}141 | {{seq}}1141 | 20904  |         | text {{seq}} |               |               | Witness sworn in                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:47:00}} | {{seq}}142 | {{seq}}1142 | 20905  |         | text {{seq}} |               |               | Witness released                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:47:20}} | {{seq}}143 | {{seq}}1143 | 20906  |         | text {{seq}} |               |               | Defence case opened                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:47:40}} | {{seq}}144 | {{seq}}1144 | 20907  |         | text {{seq}} |               |               | Prosecution closing speech                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:48:00}} | {{seq}}145 | {{seq}}1145 | 20908  |         | text {{seq}} |               |               | Prosecution case closed                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:48:20}} | {{seq}}146 | {{seq}}1146 | 20909  |         | text {{seq}} |               |               | Defence closing speech                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:48:40}} | {{seq}}147 | {{seq}}1147 | 20910  |         | text {{seq}} |               |               | Defence case closed                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:49:00}} | {{seq}}148 | {{seq}}1148 | 20911  |         | text {{seq}} |               |               | Summing up                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:49:20}} | {{seq}}149 | {{seq}}1149 | 20912  |         | text {{seq}} |               |               | Jury out                                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:49:40}} | {{seq}}150 | {{seq}}1150 | 20914  |         | text {{seq}} |               |               | Jury retire                                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:50:00}} | {{seq}}151 | {{seq}}1151 | 20915  |         | text {{seq}} |               |               | Jury/Juror discharged                                                                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:50:20}} | {{seq}}152 | {{seq}}1152 | 20916  |         | text {{seq}} |               |               | Judge addresses advocate                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:50:40}} | {{seq}}153 | {{seq}}1153 | 20918  |         | text {{seq}} |               |               | Cracked or ineffective trial                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:51:00}} | {{seq}}154 | {{seq}}1154 | 20920  |         | text {{seq}} |               |               | Witness continued                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:51:20}} | {{seq}}155 | {{seq}}1155 | 20933  | 10622   | text {{seq}} |               |               | Judge sentences                                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:51:40}} | {{seq}}156 | {{seq}}1156 | 20934  | 10623   | text {{seq}} |               |               | Special measures application                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:52:00}} | {{seq}}157 | {{seq}}1157 | 20935  | 10630   | text {{seq}} |               |               | Witness Read                                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:52:20}} | {{seq}}158 | {{seq}}1158 | 20935  | 10631   | text {{seq}} |               |               | Defendant Read                                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:52:40}} | {{seq}}159 | {{seq}}1159 | 20935  | 10632   | text {{seq}} |               |               | Interpreter Read                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:53:00}} | {{seq}}160 | {{seq}}1160 | 20935  | 10633   | text {{seq}} |               |               | Appellant Read                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:53:20}} | {{seq}}161 | {{seq}}1161 | 20936  | 10630   | text {{seq}} |               |               | Witness Read                                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:53:40}} | {{seq}}162 | {{seq}}1162 | 20936  | 10631   | text {{seq}} |               |               | Defendant Read                                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:54:00}} | {{seq}}163 | {{seq}}1163 | 20936  | 10632   | text {{seq}} |               |               | Interpreter Read                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:54:20}} | {{seq}}164 | {{seq}}1164 | 20936  | 10633   | text {{seq}} |               |               | Appellant Read                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:54:40}} | {{seq}}165 | {{seq}}1165 | 20937  | 10624   | text {{seq}} |               |               | <Sentence remarks filmed>                                                                                                              | new   |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:55:00}} | {{seq}}166 | {{seq}}1166 | 20937  | 10625   | text {{seq}} |               |               | <Sentence remarks not filmed>                                                                                                          | new   |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:55:20}} | {{seq}}167 | {{seq}}1167 | 21200  | 10311   | text {{seq}} |               |               | Bail Conditions Ceased - sentence deferred                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:55:40}} | {{seq}}168 | {{seq}}1168 | 21200  | 10312   | text {{seq}} |               |               | Bail Conditions Ceased - defendant deceased                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:56:00}} | {{seq}}169 | {{seq}}1169 | 21200  | 10313   | text {{seq}} |               |               | Bail Conditions Ceased - non-custodial sentence imposed                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:56:20}} | {{seq}}170 | {{seq}}1170 | 21300  |         | text {{seq}} |               |               | Freetext                                                                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:56:40}} | {{seq}}171 | {{seq}}1171 | 21400  | 12414   | text {{seq}} |               |               | Defendant disqualified from working with children for life (Defendant under 18)                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:57:00}} | {{seq}}172 | {{seq}}1172 | 21400  | 12415   | text {{seq}} |               |               | Defendant disqualified from working with children for life (Defendant over 18)                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:57:20}} | {{seq}}173 | {{seq}}1173 | 21500  | 13700   | text {{seq}} |               |               | Defendant ordered to be electronically monitored                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:57:40}} | {{seq}}174 | {{seq}}1174 | 21500  | 13701   | text {{seq}} |               |               | Electronic monitoring requirement amended                                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:58:00}} | {{seq}}175 | {{seq}}1175 | 21500  | 13702   | text {{seq}} |               |               | Electronic monitoring/tag to be removed                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:58:20}} | {{seq}}176 | {{seq}}1176 | 21500  | 13703   | text {{seq}} |               |               | Defendant subject to an electronically monitored curfew                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:58:40}} | {{seq}}177 | {{seq}}1177 | 21500  | 13704   | text {{seq}} |               |               | Terms of electronically monitored curfew amended                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:59:00}} | {{seq}}178 | {{seq}}1178 | 21500  | 13705   | text {{seq}} |               |               | Requirement for an electronically monitored curfew removed                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:59:20}} | {{seq}}179 | {{seq}}1179 | 21600  | 13600   | text {{seq}} |               |               | Sex Offenders Register - victim under 18 years of age - for an indefinite period                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-10:59:40}} | {{seq}}180 | {{seq}}1180 | 21600  | 13601   | text {{seq}} |               |               | Sex Offenders Register - victim under 18 years of age - for 10 years                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:00:00}} | {{seq}}181 | {{seq}}1181 | 21600  | 13602   | text {{seq}} |               |               | Sex Offenders Register - victim under 18 years of age - for 3-7 years                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:00:20}} | {{seq}}182 | {{seq}}1182 | 21600  | 13603   | text {{seq}} |               |               | Sex Offenders Register - victim under 18 years of age - period to be specified later                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:00:40}} | {{seq}}183 | {{seq}}1183 | 21600  | 13604   | text {{seq}} |               |               | Sex Offenders Register - victim under 18 years of age - for another period                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:01:00}} | {{seq}}184 | {{seq}}1184 | 21600  | 13605   | text {{seq}} |               |               | Sex Offenders Register - victim over 18 years of age - for an indefinite period                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:01:20}} | {{seq}}185 | {{seq}}1185 | 21600  | 13606   | text {{seq}} |               |               | Sex Offenders Register - victim over 18 years of age - for 10 years                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:01:40}} | {{seq}}186 | {{seq}}1186 | 21600  | 13607   | text {{seq}} |               |               | Sex Offenders Register - victim over 18 years of age - for 3-7 years                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:02:00}} | {{seq}}187 | {{seq}}1187 | 21600  | 13608   | text {{seq}} |               |               | Sex Offenders Register - victim over 18 years of age - for another period                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:02:20}} | {{seq}}188 | {{seq}}1188 | 21600  | 13609   | text {{seq}} |               |               | Sex Offenders Register - victim over 18 years of age - period to be specified later                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:02:40}} | {{seq}}189 | {{seq}}1189 | 21800  | 12310   | text {{seq}} |               |               | Disqualification from driving removed (3076)                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:03:00}} | {{seq}}190 | {{seq}}1190 | 30601  | 11113   | text {{seq}} |               |               | Delete end hearing                                                                                                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:03:20}} | {{seq}}191 | {{seq}}1191 | 40203  |         | text {{seq}} |               |               | Join indictments                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:03:40}} | {{seq}}192 | {{seq}}1192 | 40410  |         | text {{seq}} |               |               | Maintain charges                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:04:00}} | {{seq}}193 | {{seq}}1193 | 40601  |         | text {{seq}} |               |               | 7/14 day orders                                                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:04:20}} | {{seq}}194 | {{seq}}1194 | 40706  | 10305   | text {{seq}} |               |               | Remanded in Custody                                                                                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:04:40}} | {{seq}}195 | {{seq}}1195 | 40706  | 10308   | text {{seq}} |               |               | Bail as before                                                                                                                         |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:05:00}} | {{seq}}196 | {{seq}}1196 | 40706  | 10309   | text {{seq}} |               |               | Bail varied                                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:05:20}} | {{seq}}197 | {{seq}}1197 | 40711  |         | text {{seq}} |               |               | Time estimate supplied                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:05:40}} | {{seq}}198 | {{seq}}1198 | 40720  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:06:00}} | {{seq}}199 | {{seq}}1199 | 40721  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:06:20}} | {{seq}}200 | {{seq}}1200 | 40722  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:06:40}} | {{seq}}201 | {{seq}}1201 | 40725  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:07:00}} | {{seq}}202 | {{seq}}1202 | 40726  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:07:20}} | {{seq}}203 | {{seq}}1203 | 40727  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:07:40}} | {{seq}}204 | {{seq}}1204 | 40730  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:08:00}} | {{seq}}205 | {{seq}}1205 | 40731  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:08:20}} | {{seq}}206 | {{seq}}1206 | 40732  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:08:40}} | {{seq}}207 | {{seq}}1207 | 40733  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:09:00}} | {{seq}}208 | {{seq}}1208 | 40736  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:09:20}} | {{seq}}209 | {{seq}}1209 | 40737  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:09:40}} | {{seq}}210 | {{seq}}1210 | 40738  |         | text {{seq}} |               |               | Verdict                                                                                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:10:00}} | {{seq}}211 | {{seq}}1211 | 40750  | 12309   | text {{seq}} |               |               | Driving disqualification suspended pending appeal subsequent to imposition (3075)                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:10:20}} | {{seq}}212 | {{seq}}1212 | 40750  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:32:20}} | {{seq}}273 | {{seq}}1273 | 40750  | 12400   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - ADULTS                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:32:40}} | {{seq}}274 | {{seq}}1274 | 40750  | 12401   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - JUVENILES                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:10:40}} | {{seq}}213 | {{seq}}1213 | 40751  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:39:20}} | {{seq}}294 | {{seq}}1294 | 40751  | 12400   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - ADULTS                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:39:40}} | {{seq}}295 | {{seq}}1295 | 40751  | 12401   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - JUVENILES                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:11:00}} | {{seq}}214 | {{seq}}1214 | 40752  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:46:20}} | {{seq}}315 | {{seq}}1315 | 40752  | 12400   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - ADULTS                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:46:40}} | {{seq}}316 | {{seq}}1316 | 40752  | 12401   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - JUVENILES                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:11:20}} | {{seq}}215 | {{seq}}1215 | 40753  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:53:20}} | {{seq}}336 | {{seq}}1336 | 40753  | 12400   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - ADULTS                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:53:40}} | {{seq}}337 | {{seq}}1337 | 40753  | 12401   | text {{seq}} | 4             | 26Y0M0D       | Disqualification Order (from working with children) - JUVENILES                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:11:40}} | {{seq}}216 | {{seq}}1216 | 40754  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:12:00}} | {{seq}}217 | {{seq}}1217 | 40755  |         | text {{seq}} |               |               | Sentencing                                                                                                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:12:20}} | {{seq}}218 | {{seq}}1218 | 40756  |         | text {{seq}} |               |               | Guilty                                                                                                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:12:40}} | {{seq}}219 | {{seq}}1219 | 40791  |         | text {{seq}} |               |               | Recommended for Deportation                                                                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:13:00}} | {{seq}}220 | {{seq}}1220 | 60101  |         | text {{seq}} |               |               | Plea                                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:13:20}} | {{seq}}221 | {{seq}}1221 | 60102  |         | text {{seq}} |               |               | Plea                                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:13:40}} | {{seq}}222 | {{seq}}1222 | 60103  |         | text {{seq}} |               |               | Plea                                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:14:00}} | {{seq}}223 | {{seq}}1223 | 60104  |         | text {{seq}} |               |               | Plea                                                                                                                                   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:14:20}} | {{seq}}224 | {{seq}}1224 | 60106  | 11317   | text {{seq}} |               |               | Admitted ( Bail Act Offence)                                                                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:14:40}} | {{seq}}225 | {{seq}}1225 | 60106  | 11318   | text {{seq}} |               |               | Not Admitted ( Bail Act Offence)                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:15:00}} | {{seq}}226 | {{seq}}1226 | 302001 |         | text {{seq}} |               |               | Long adjournment                                                                                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:15:20}} | {{seq}}227 | {{seq}}1227 | 302002 |         | text {{seq}} |               |               | Adjourned for pre-sentence report                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:15:40}} | {{seq}}228 | {{seq}}1228 | 302003 |         | text {{seq}} |               |               | Case reserved                                                                                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:16:00}} | {{seq}}229 | {{seq}}1229 | 302004 |         | text {{seq}} |               |               | Case not reserved                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:16:20}} | {{seq}}230 | {{seq}}1230 | 407131 |         | text {{seq}} |               |               | Case to be listed                                                                                                                      |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:16:40}} | {{seq}}231 | {{seq}}1231 | 407132 |         | text {{seq}} |               |               | Case to be listed                                                                                                                      |       |


@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a LOG event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "StandardEventHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId       | eventId     | type   | subType | eventText    | caseRetention | totalSentence | text        | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:17:00}} | {{seq}}232  | {{seq}}1232 | LOG    |         | log text     |               |               | LOG         |       |

        
@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a SetReportingRestriction event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "SetReportingRestrictionEventHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text                                                                         | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:18:00}} | {{seq}}233 | {{seq}}1233 | 2198  | 3933    | text {{seq}} |               |               | Judge directed on reporting restrictions                                     |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:18:20}} | {{seq}}234 | {{seq}}1234 | 21200 | 11000   | text {{seq}} |               |               | Section 4(2) of the Contempt of Court Act 1981                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:18:40}} | {{seq}}235 | {{seq}}1235 | 21200 | 11001   | text {{seq}} |               |               | Section 11 of the Contempt of Court Act 1981                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:19:00}} | {{seq}}236 | {{seq}}1236 | 21200 | 11002   | text {{seq}} |               |               | Section 39 of the Children and Young Persons Act 1933                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:19:20}} | {{seq}}237 | {{seq}}1237 | 21200 | 11003   | text {{seq}} |               |               | Section 4 of the Sexual Offenders (Amendment) Act 1976                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:19:40}} | {{seq}}238 | {{seq}}1238 | 21200 | 11004   | text {{seq}} |               |               | Section 2 of the Sexual Offenders (Amendment) Act 1992                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:20:00}} | {{seq}}239 | {{seq}}1239 | 21200 | 11006   | text {{seq}} |               |               | An order made under s45 of the Youth Justice and Criminal Evidence Act 1999  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:20:20}} | {{seq}}240 | {{seq}}1240 | 21200 | 11007   | text {{seq}} |               |               | An order made under s45a of the Youth Justice and Criminal Evidence Act 1999 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:20:40}} | {{seq}}241 | {{seq}}1241 | 21200 | 11008   | text {{seq}} |               |               | An order made under s46 of the Youth Justice and Criminal Evidence Act 1999  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:21:00}} | {{seq}}242 | {{seq}}1242 | 21200 | 11009   | text {{seq}} |               |               | An order made under s49 of the Children and Young Persons Act 1933           |       |
#   Lift restrictions
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:21:20}} | {{seq}}243 | {{seq}}1243 | 21201 |         | text {{seq}} |               |               | Restrictions lifted                                                          |       |

@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a SetInterpreterUsed event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "InterpreterUsedHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text                        | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:22:00}} | {{seq}}244 | {{seq}}1244 | 2917  | 3979    | text {{seq}} |               |               | Interpreter sworn-in        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:22:20}} | {{seq}}245 | {{seq}}1244 | 20612 |         | text {{seq}} |               |               | Appeal interpreter sworn in |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:22:40}} | {{seq}}246 | {{seq}}1244 | 20917 |         | text {{seq}} |               |               | Interpretor sworn           |       |

@EVENT_API @SOAP_EVENT @regression @obsolete
Scenario Outline: Create a TranscriptionRequest event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "TranscriptionRequestHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text                            | notes |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:24:00}} | {{seq}}250 | {{seq}}1250 | 3010  |         | text {{seq}} |               |               | Sentence Transcription Required |       |

  
@EVENT_API @SOAP_EVENT @SENTENCING_EVENT @regression
Scenario Outline: Create a Sentencing event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "SentencingRemarksAndRetentionPolicyHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type    | subType | eventText                  | caseRetention | totalSentence | text                                                                                           | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:24:00}} | {{seq}}250 | {{seq}}1250 | 3010    |         | [Defendant: DEFENDANT ONE] |  4            |  26Y0M0D      | Sentence Transcription Required |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:25:20}} | {{seq}}252 | {{seq}}1252 | 40730   | 10808   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Case Level Criminal Appeal Result                                                              |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:25:40}} | {{seq}}253 | {{seq}}1253 | 40731   | 10808   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Offence Level Criminal Appeal Result                                                           |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:26:00}} | {{seq}}254 | {{seq}}1254 | 40732   | 10808   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Offence Level Criminal Appeal Result with alt offence                                          |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:26:20}} | {{seq}}255 | {{seq}}1255 | 40733   | 10808   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Case Level Misc Appeal Result                                                                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:26:40}} | {{seq}}256 | {{seq}}1256 | 40735   | 10808   | [Defendant: DEFENDANT ONE] | 0             | 26Y0M1D       | Delete Offence Level Appeal Result                                                             |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:27:00}} | {{seq}}257 | {{seq}}1257 | 40735   |         | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Verdict                                                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:27:20}} | {{seq}}258 | {{seq}}1258 | 40750   | 11504   | [Defendant: DEFENDANT ONE] | 1             | 26Y0M2D       | Life Imprisonment                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:27:40}} | {{seq}}259 | {{seq}}1259 | 40750   | 11505   | [Defendant: DEFENDANT ONE] | 2             | 26Y0M3D       | Life Imprisonment (with minimum period)                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:28:00}} | {{seq}}260 | {{seq}}1260 | 40750   | 11506   | [Defendant: DEFENDANT ONE] | 3             | 26Y0M4D       | Custody for Life                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:28:20}} | {{seq}}261 | {{seq}}1261 | 40750   | 11507   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M5D       | Mandatory Life Sentence for Second Serious Offence                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:28:40}} | {{seq}}262 | {{seq}}1262 | 40750   | 11508   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M6D       | Mandatory Life Sentence for Second Serious Offence (Young Offender)                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:29:00}} | {{seq}}263 | {{seq}}1263 | 40750   | 11509   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M7D       | Detained During Her Majestys Pleasure                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:29:20}} | {{seq}}264 | {{seq}}1264 | 40750   | 11521   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M8D       | INIMP: Indeterminate Sentence of Imprisonment for Public Protection                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:29:40}} | {{seq}}265 | {{seq}}1265 | 40750   | 11522   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M9D       | INDET: Indeterminate Sentence of Detention for Public Protection                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:30:00}} | {{seq}}266 | {{seq}}1266 | 40750   | 11523   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M10D      | Mandatory Life Sentence for Second Listed Offence                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:30:20}} | {{seq}}267 | {{seq}}1267 | 40750   | 11524   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M11D      | Mandatory Life Sentence for Second Listed Offence (Young Offender)                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:30:40}} | {{seq}}268 | {{seq}}1268 | 40750   | 11525   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M12D      | Imprisonment - Extended under s236A CJA2003                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:31:00}} | {{seq}}269 | {{seq}}1269 | 40750   | 11526   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M13D      | Imprisonment - Minimum Imposed after 3 strikes (Young Offender) - Extended under s236A CJA2003 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:31:20}} | {{seq}}270 | {{seq}}1270 | 40750   | 11527   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M14D      | Imprisonment - Minimum Imposed after 3 strikes - Extended under s236A CJA2003                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:31:40}} | {{seq}}271 | {{seq}}1271 | 40750   | 11528   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M15D      | Detention in Y.O.I. - Extended under s235A CJA2003                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:32:00}} | {{seq}}272 | {{seq}}1272 | 40750   | 11529   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M16D      | Detention for Life under s226 (u18)                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:33:00}} | {{seq}}275 | {{seq}}1275 | 40750   | 13503   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M17D      | S226a Extended Discretional for over 18                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:33:20}} | {{seq}}276 | {{seq}}1276 | 40750   | 13504   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M18D      | S226a Extended Automatic for over 18                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:33:40}} | {{seq}}277 | {{seq}}1277 | 40750   | 13505   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M19D      | S226b Extended Discretional for under 18                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:34:00}} | {{seq}}278 | {{seq}}1278 | 40750   | 13506   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M20D      | S226b Extended Automatic for under 18                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:34:20}} | {{seq}}279 | {{seq}}1279 | 40751   | 11504   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M21D      | Life Imprisonment                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:34:40}} | {{seq}}280 | {{seq}}1280 | 40751   | 11505   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M22D      | Life Imprisonment (with minimum period)                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:35:00}} | {{seq}}281 | {{seq}}1281 | 40751   | 11506   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M23D      | Custody for Life                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:35:20}} | {{seq}}282 | {{seq}}1282 | 40751   | 11507   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M24D      | Mandatory Life Sentence for Second Serious Offence                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:35:40}} | {{seq}}283 | {{seq}}1283 | 40751   | 11508   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M25D      | Mandatory Life Sentence for Second Serious Offence (Young Offender)                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:36:00}} | {{seq}}284 | {{seq}}1284 | 40751   | 11509   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M26D      | Detained During Her Majestys Pleasure                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:36:20}} | {{seq}}285 | {{seq}}1285 | 40751   | 11521   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M27D      | INIMP: Indeterminate Sentence of Imprisonment for Public Protection                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:36:40}} | {{seq}}286 | {{seq}}1286 | 40751   | 11522   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M28D      | INDET: Indeterminate Sentence of Detention for Public Protection                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:37:00}} | {{seq}}287 | {{seq}}1287 | 40751   | 11523   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M1D       | Mandatory Life Sentence for Second Listed Offence                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:37:20}} | {{seq}}288 | {{seq}}1288 | 40751   | 11524   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M2D       | Mandatory Life Sentence for Second Listed Offence (Young Offender)                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:37:40}} | {{seq}}289 | {{seq}}1289 | 40751   | 11525   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M3D       | Imprisonment - Extended under s236A CJA2003                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:38:00}} | {{seq}}290 | {{seq}}1290 | 40751   | 11526   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M4D       | Imprisonment - Minimum Imposed after 3 strikes (Young Offender) - Extended under s236A CJA2003 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:38:20}} | {{seq}}291 | {{seq}}1291 | 40751   | 11527   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M5D       | Imprisonment - Minimum Imposed after 3 strikes - Extended under s236A CJA2003                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:38:40}} | {{seq}}292 | {{seq}}1292 | 40751   | 11528   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M6D       | Detention in Y.O.I. - Extended under s235A CJA2003                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:39:00}} | {{seq}}293 | {{seq}}1293 | 40751   | 11529   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M7D       | Detention for Life under s226 (u18)                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:40:00}} | {{seq}}296 | {{seq}}1296 | 40751   | 13503   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M8D       | S226a Extended Discretional for over 18                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:40:20}} | {{seq}}297 | {{seq}}1297 | 40751   | 13504   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M9D       | S226a Extended Automatic for over 18                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:40:40}} | {{seq}}298 | {{seq}}1298 | 40751   | 13505   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M10D      | S226b Extended Discretional for under 18                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:41:00}} | {{seq}}299 | {{seq}}1299 | 40751   | 13506   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M11D      | S226b Extended Automatic for under 18                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:41:20}} | {{seq}}300 | {{seq}}1300 | 40752   | 11504   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M12D      | Life Imprisonment                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:41:40}} | {{seq}}301 | {{seq}}1301 | 40752   | 11505   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M13D      | Life Imprisonment (with minimum period)                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:42:00}} | {{seq}}302 | {{seq}}1302 | 40752   | 11506   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M14D      | Custody for Life                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:42:20}} | {{seq}}303 | {{seq}}1303 | 40752   | 11507   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M15D      | Mandatory Life Sentence for Second Serious Offence                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:42:40}} | {{seq}}304 | {{seq}}1304 | 40752   | 11508   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M16D      | Mandatory Life Sentence for Second Serious Offence (Young Offender)                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:43:00}} | {{seq}}305 | {{seq}}1305 | 40752   | 11509   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M17D      | Detained During Her Majestys Pleasure                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:43:20}} | {{seq}}306 | {{seq}}1306 | 40752   | 11521   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M18D      | INIMP: Indeterminate Sentence of Imprisonment for Public Protection                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:43:40}} | {{seq}}307 | {{seq}}1307 | 40752   | 11522   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M19D      | INDET: Indeterminate Sentence of Detention for Public Protection                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:44:00}} | {{seq}}308 | {{seq}}1308 | 40752   | 11523   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M20D      | Mandatory Life Sentence for Second Listed Offence                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:44:20}} | {{seq}}309 | {{seq}}1309 | 40752   | 11524   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M21D      | Mandatory Life Sentence for Second Listed Offence (Young Offender)                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:44:40}} | {{seq}}310 | {{seq}}1310 | 40752   | 11525   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M22D      | Imprisonment - Extended under s236A CJA2003                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:45:00}} | {{seq}}311 | {{seq}}1311 | 40752   | 11526   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M23D      | Imprisonment - Minimum Imposed after 3 strikes (Young Offender) - Extended under s236A CJA2003 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:45:20}} | {{seq}}312 | {{seq}}1312 | 40752   | 11527   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M24D      | Imprisonment - Minimum Imposed after 3 strikes - Extended under s236A CJA2003                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:45:40}} | {{seq}}313 | {{seq}}1313 | 40752   | 11528   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M25D      | Detention in Y.O.I. - Extended under s235A CJA2003                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:46:00}} | {{seq}}314 | {{seq}}1314 | 40752   | 11529   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M26D      | Detention for Life under s226 (u18)                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:47:00}} | {{seq}}317 | {{seq}}1317 | 40752   | 13503   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M27D      | S226a Extended Discretional for over 18                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:47:20}} | {{seq}}318 | {{seq}}1318 | 40752   | 13504   | [Defendant: DEFENDANT ONE] | 4             | 26Y1M28D      | S226a Extended Automatic for over 18                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:47:40}} | {{seq}}319 | {{seq}}1319 | 40752   | 13505   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M1D       | S226b Extended Discretional for under 18                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:48:00}} | {{seq}}320 | {{seq}}1320 | 40752   | 13506   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M2D       | S226b Extended Automatic for under 18                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:48:20}} | {{seq}}321 | {{seq}}1321 | 40753   | 11504   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M3D       | Life Imprisonment                                                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:48:40}} | {{seq}}322 | {{seq}}1322 | 40753   | 11505   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M4D       | Life Imprisonment (with minimum period)                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:49:00}} | {{seq}}323 | {{seq}}1323 | 40753   | 11506   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M5D       | Custody for Life                                                                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:49:20}} | {{seq}}324 | {{seq}}1324 | 40753   | 11507   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M6D       | Mandatory Life Sentence for Second Serious Offence                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:49:40}} | {{seq}}325 | {{seq}}1325 | 40753   | 11508   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M7D       | Mandatory Life Sentence for Second Serious Offence (Young Offender)                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:50:00}} | {{seq}}326 | {{seq}}1326 | 40753   | 11509   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M8D       | Detained During Her Majestys Pleasure                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:50:20}} | {{seq}}327 | {{seq}}1327 | 40753   | 11521   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M9D       | INIMP: Indeterminate Sentence of Imprisonment for Public Protection                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:50:40}} | {{seq}}328 | {{seq}}1328 | 40753   | 11522   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M10D      | INDET: Indeterminate Sentence of Detention for Public Protection                               |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:51:00}} | {{seq}}329 | {{seq}}1329 | 40753   | 11523   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M11D      | Mandatory Life Sentence for Second Listed Offence                                              |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:51:20}} | {{seq}}330 | {{seq}}1330 | 40753   | 11524   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M12D      | Mandatory Life Sentence for Second Listed Offence (Young Offender)                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:51:40}} | {{seq}}331 | {{seq}}1331 | 40753   | 11525   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M13D      | Imprisonment - Extended under s236A CJA2003                                                    |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:52:00}} | {{seq}}332 | {{seq}}1332 | 40753   | 11526   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M14D      | Imprisonment - Minimum Imposed after 3 strikes (Young Offender) - Extended under s236A CJA2003 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:52:20}} | {{seq}}333 | {{seq}}1333 | 40753   | 11527   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M15D      | Imprisonment - Minimum Imposed after 3 strikes - Extended under s236A CJA2003                  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:52:40}} | {{seq}}334 | {{seq}}1334 | 40753   | 11528   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M16D      | Detention in Y.O.I. - Extended under s235A CJA2003                                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:53:00}} | {{seq}}335 | {{seq}}1335 | 40753   | 11529   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M17D      | Detention for Life under s226 (u18)                                                            |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:54:00}} | {{seq}}338 | {{seq}}1338 | 40753   | 13503   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M18D      | S226a Extended Discretional for over 18                                                        |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:54:20}} | {{seq}}339 | {{seq}}1339 | 40753   | 13504   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M19D      | S226a Extended Automatic for over 18                                                           |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:54:40}} | {{seq}}340 | {{seq}}1340 | 40753   | 13505   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M20D      | S226b Extended Discretional for under 18                                                       |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:55:00}} | {{seq}}341 | {{seq}}1341 | 40753   | 13506   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M21D      | S226b Extended Automatic for under 18                                                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:55:20}} | {{seq}}342 | {{seq}}1342 | 40750   | 11533   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M22D      | Imprisonment for life (adult) for manslaughter of an emergency worker                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:55:40}} | {{seq}}343 | {{seq}}1343 | 40750   | 11534   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M23D      | Detention for life (youth) for manslaughter of an emergency worker                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:56:00}} | {{seq}}344 | {{seq}}1344 | 40750   | 13507   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M24D      | (Extended Discretional 18 to 20)   Section 266                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:56:20}} | {{seq}}345 | {{seq}}1345 | 40750   | 13508   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M25D      | (Extended Discretional over 21)                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:56:40}} | {{seq}}346 | {{seq}}1346 | 40751   | 11533   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M26D      | Imprisonment for life (adult) for manslaughter of an emergency worker                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:57:00}} | {{seq}}347 | {{seq}}1347 | 40751   | 11534   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M27D      | Detention for life (youth) for manslaughter of an emergency worker                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:57:20}} | {{seq}}348 | {{seq}}1348 | 40751   | 13507   | [Defendant: DEFENDANT ONE] | 4             | 26Y2M28D      | (Extended Discretional 18 to 20)   Section 266                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:57:40}} | {{seq}}349 | {{seq}}1349 | 40751   | 13508   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M1D       | (Extended Discretional over 21)                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:58:00}} | {{seq}}350 | {{seq}}1350 | 40752   | 11533   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M2D       | Imprisonment for life (adult) for manslaughter of an emergency worker                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:58:20}} | {{seq}}351 | {{seq}}1351 | 40752   | 11534   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M3D       | Detention for life (youth) for manslaughter of an emergency worker                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:58:40}} | {{seq}}352 | {{seq}}1352 | 40752   | 13507   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M4D       | (Extended Discretional 18 to 20)   Section 266                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:59:00}} | {{seq}}353 | {{seq}}1353 | 40752   | 13508   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M5D       | (Extended Discretional over 21)                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:59:20}} | {{seq}}354 | {{seq}}1354 | 40753   | 11533   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M6D       | Imprisonment for life (adult) for manslaughter of an emergency worker                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:59:40}} | {{seq}}355 | {{seq}}1355 | 40753   | 11534   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M7D       | Detention for life (youth) for manslaughter of an emergency worker                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:00:00}} | {{seq}}356 | {{seq}}1356 | 40753   | 13507   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M8D       | (Extended Discretional 18 to 20)   Section 266                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:00:20}} | {{seq}}357 | {{seq}}1357 | 40753   | 13508   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M9D       | (Extended Discretional over 21)                                                                |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:00:40}} | {{seq}}358 | {{seq}}1358 | 40754   | 11533   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M10D      | Imprisonment for life (adult) for manslaughter of an emergency worker                          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:01:00}} | {{seq}}359 | {{seq}}1359 | 40754   | 11534   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M11D      | Detention for life (youth) for manslaughter of an emergency worker                             |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:01:20}} | {{seq}}360 | {{seq}}1360 | 40754   | 13507   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M12D      | (Extended Discretional 18 to 20)   Section 266                                                 |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:01:40}} | {{seq}}361 | {{seq}}1361 | 40754   | 13508   | [Defendant: DEFENDANT ONE] | 4             | 26Y3M13D      | (Extended Discretional over 21)                                                                |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:02:00}} | {{seq}}362 | {{seq}}1362 | DETTO   | 11531   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D      | Special Sentence of Detention for Terrorist Offenders of Particular Concern                    |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:02:20}} | {{seq}}363 | {{seq}}1363 | STS     | 11530   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Serious Terrorism Sentence                                                                     |       |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:02:40}} | {{seq}}364 | {{seq}}1364 | STS1821 | 11532   | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       | Serious Terrorism Sentence 18 to 21                                                            |       |

  
@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a DarStart event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "DarStartHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text            | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:03:00}} | {{seq}}365 | {{seq}}1365 | 1000  | 1055    | text {{seq}} |               |               | Jury returned   |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:03:20}} | {{seq}}366 | {{seq}}1366 | 1100  |         | text {{seq}} |               |               | Hearing started |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:03:40}} | {{seq}}367 | {{seq}}1367 | 1500  |         | text {{seq}} |               |               | Hearing resumed |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:04:00}} | {{seq}}368 | {{seq}}1368 | 10100 |         | text {{seq}} |               |               | Case called on  |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:04:20}} | {{seq}}369 | {{seq}}1369 | 10500 |         | text {{seq}} |               |               | Resume          |       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:04:40}} | {{seq}}370 | {{seq}}1370 | 20913 |         | text {{seq}} |               |               | Jury returns    |       |
  
  
@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a DarStop event
  Given I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I set table darts.court_case column interpreter_used to "false" where cas_id = "{{cas.cas_id}}"
    And I set table darts.court_case column case_closed_ts to "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "DarStopHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I set table darts.hearing column hearing_is_actual to "false" where cas_id = "{{cas.cas_id}}"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text              | notes                  |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:06:00}} | {{seq}}372 | {{seq}}1372 | 1200  |         | text {{seq}} |               |               | Hearing ended     |                        |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:06:20}} | {{seq}}373 | {{seq}}1373 | 1400  |         | text {{seq}} |               |               | Hearing paused    |                        |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-12:06:40}} | {{seq}}374 | {{seq}}1374 | 30100 |         | text {{seq}} |               |               | Short adjournment |                        |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:23:20}} | {{seq}}248 | {{seq}}1248 | 30500 |         | text {{seq}} |               |               | Hearing ended     | ex StopAndCloseHandler |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}201 | {{timestamp-11:23:40}} | {{seq}}249 | {{seq}}1249 | 30600 |         | text {{seq}} |               |               | Hearing ended     | ex StopAndCloseHandler |

  
@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a StopAndClose event
													Only 1 stop & close event per case seems to work
													Creates a courtroom & hearing for each case
  Given I create a case
    | courthouse   | case_number   | defendants    | judges     | prosecutors     | defenders     |
    | <courthouse> | <caseNumbers> | defendant one | test judge | test prosecutor | test defender |
    And I authenticate from the XHIBIT source system
  Given I select column cas.cas_id from table COURTCASE where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>"
    And I see table darts.court_case column interpreter_used is "f" where cas_id = "{{cas.cas_id}}"
    And I see table darts.court_case column case_closed_ts is "null" where cas_id = "{{cas.cas_id}}"
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column event_name is "<text>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column handler is "StopAndCloseHandler" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column active is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column case_closed_ts is "not null" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column interpreter_used is "f" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"
   And I select column eve_id from table EVENT where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table CASE_MANAGEMENT_RETENTION column total_sentence is "<totalSentence>" where eve_id = "{{eve_id}}" 
   And I see table CASE_MANAGEMENT_RETENTION column fixed_policy_key is "<caseRetention>" where eve_id = "{{eve_id}}" 
   And I select column cmr_id from table CASE_MANAGEMENT_RETENTION where eve_id = "{{eve_id}}"
   And I see table CASE_RETENTION column total_sentence is "<totalSentence>" where cmr_id = "{{cmr_id}}" 
   And I see table CASE_RETENTION column fixed_policy_key is "<caseRetention>" where cmr_id = "{{cmr_id}}" 
Examples:
  | courthouse         | courtroom     | caseNumbers  | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text         | notes             |
#  | Harrow Crown Court | Room {{seq}}A | T{{seq}}201A | {{timestamp-11:23:00}} | {{seq}}601 | {{seq}}1601 | 3000  |         | text {{seq}} | 1             | 1Y1M1D        | Archive Case |                   |
#  | Harrow Crown Court | Room {{seq}}B | T{{seq}}201B | {{timestamp-11:23:00}} | {{seq}}602 | {{seq}}1602 | 3000  |         | text {{seq}} | 2             | 2Y2M2D        | Archive Case |                   |
  | Harrow Crown Court | Room {{seq}}C | T{{seq}}201C | {{timestamp-11:23:00}} | {{seq}}603 | {{seq}}1603 | 3000  |         | text {{seq}} | 3             | 3Y3M3D        | Archive Case |                   |
#  | Harrow Crown Court | Room {{seq}}D | T{{seq}}201D | {{timestamp-11:23:00}} | {{seq}}604 | {{seq}}1604 | 3000  |         | text {{seq}} | 4             | 4Y4M4D        | Archive Case |                   |
#  | Harrow Crown Court | Room {{seq}}E | T{{seq}}201E | {{timestamp-12:07:00}} | {{seq}}611 | {{seq}}1611 | 30300 |         | text {{seq}} | 1             | 1Y1M1D        | Case closed  |                   |
#  | Harrow Crown Court | Room {{seq}}F | T{{seq}}201F | {{timestamp-12:07:00}} | {{seq}}612 | {{seq}}1612 | 30300 |         | text {{seq}} | 2             | 2Y2M2D        | Case closed  |                   |
  | Harrow Crown Court | Room {{seq}}G | T{{seq}}201G | {{timestamp-12:07:00}} | {{seq}}613 | {{seq}}1613 | 30300 |         | text {{seq}} | 3             | 3Y3M3D        | Case closed  |                   |
#  | Harrow Crown Court | Room {{seq}}H | T{{seq}}201H | {{timestamp-12:07:00}} | {{seq}}614 | {{seq}}1614 | 30300 |         | text {{seq}} | 4             | 4Y4M4D        | Case closed  |                   |
  
  
@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create a Null event
# An event row is not created
  Given I authenticate from the XHIBIT source system
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumber> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
#  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
   And I see table EVENT column COUNT(eve_id) is "0" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | caseRetention | totalSentence | text    | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}202 | {{timestamp-12:08:00}} | {{seq}}376 | {{seq}}1376 | 40790 |         | text {{seq}} |               |               | Results |       |

@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Create case with an event
  Given I see table COURTCASE column COUNT(cas_id) is "0" where cas.case_number = "<caseNumber>Z" and courthouse_name = "<courthouse>"
  Given I authenticate from the CPP source system
  When  I create an event
    | message_id  | type   | sub_type  | event_id | courthouse   | courtroom   | case_numbers  | event_text     | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>1     | <type> | <subType> | <eventId>1        | <courthouse> | <courtroom> | <caseNumber>C | text {{seq}}C1 | <dateTime> | <caseRetention>             | <totalSentence>     |
    | <msgId>1     | <type> | <subType> | <eventId>1        | <courthouse> | <courtroom> | <caseNumber>C | text {{seq}}C1 | <dateTime> | <caseRetention>             | <totalSentence>     |
#    | <msgId>2     | <type> | <subType> | <eventId>2        | <courthouse> | <courtroom> | <caseNumber>D | text {{seq}}D1 | <dateTime> | <caseRetention>             | <totalSentence>     |
#    | <msgId>3     | <type> | <subType> | <eventId>3        | <courthouse> | <courtroom> | <caseNumber>C,<caseNumber>D | text {{seq}}CD | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table COURTCASE column COUNT(cas_id) is "1" where cas.case_number = "<caseNumber>C" and courthouse_name = "<courthouse>"
   And I see table EVENT column COUNT(eve_id) is "2" where cas.case_number = "<caseNumber>C" and courthouse_name = "<courthouse>"

Examples:
  | courthouse         | courtroom     | caseNumber  | dateTime               | msgId      | eventId     | type  | subType | eventText      | caseRetention | totalSentence | text                                                                                                                                   | notes |
  | Harrow Crown Court | Room {{seq}}Z | T{{seq}}203 | {{timestamp-12:04:00}} | {{seq}}401 | {{seq}}1401 | 10100 |         | text {{seq}}C1 |               |               | Case called on  |       |



@EVENT_API @SOAP_API @DMP-2835 @regression @TODO
Scenario: Event for 2 cases from CPP
  Given I authenticate from the CPP source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
      <messageId>{{seq}}4014</messageId>
      <type>10100</type>
      <document>
  <![CDATA[<be:DartsEvent xmlns:be="urn:integration-cjsonline-gov-uk:pilot:entities" ID="{{seq}}14014" Y="{{date-yyyy}}" M="{{date-mm}}" D="{{date-dd}}" H="12" MIN="04" S="10">
    <be:CourtHouse>Harrow Crown Court</be:CourtHouse>
    <be:CourtRoom>Room {{seq}}C</be:CourtRoom>
    <be:CaseNumbers>
      <be:CaseNumber>T{{seq}}204X,T{{seq}}204Y</be:CaseNumber>
    </be:CaseNumbers>
    <be:EventText>text {{seq}} CD1</be:EventText>
  </be:DartsEvent>]]>
</document>
  """
	Then the API status code is 200
#TODO Database verifications here

@EVENT_API @SOAP_API @DMP-2960 @regression @TODO
Scenario: Event for 2 cases from XHIBIT
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
      <messageId>{{seq}}4015</messageId>
      <type>10100</type>
      <document>
  <![CDATA[<be:DartsEvent xmlns:be="urn:integration-cjsonline-gov-uk:pilot:entities" ID="{{seq}}14015" Y="{{date-yyyy}}" M="{{date-mm}}" D="{{date-dd}}" H="12" MIN="04" S="10">
    <be:CourtHouse>Harrow Crown Court</be:CourtHouse>
    <be:CourtRoom>Room {{seq}}C</be:CourtRoom>
    <be:CaseNumbers>
      <be:CaseNumber>T{{seq}}205V</be:CaseNumber>
      <be:CaseNumber>T{{seq}}205W</be:CaseNumber>
    </be:CaseNumbers>
    <be:EventText>text {{seq}} CD2</be:EventText>
  </be:DartsEvent>]]>
</document>
  """
	Then the API status code is 200
#TODO Database verifications here

@EVENT_API @SOAP_API @DMP-2960 @regression
Scenario: Verify that VIQ cannot create an event
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
      <messageId>{{seq}}4015</messageId>
      <type>10100</type>
      <document>
  <![CDATA[<be:DartsEvent xmlns:be="urn:integration-cjsonline-gov-uk:pilot:entities" ID="{{seq}}14015" Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="12" MIN="04" S="10">
    <be:CourtHouse>Harrow Crown Court</be:CourtHouse>
    <be:CourtRoom>Room {{seq}}C</be:CourtRoom>
    <be:CaseNumbers>
      <be:CaseNumber>T{{seq}}206U</be:CaseNumber>
    </be:CaseNumbers>
    <be:EventText>text {{seq}} CD2</be:EventText>
  </be:DartsEvent>]]>
</document>
  """
	Then the API status code is 500

@EVENT_API @SOAP_API @DMP-2960 @regression
Scenario: Verify that a non-existant case is created
  Given I see table COURTCASE column COUNT(cas_id) is "0" where cas.case_number = "T{{seq}}207" and courthouse_name = "Harrow Crown Court"
    And I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
      <messageId>{{seq}}4015</messageId>
      <type>10100</type>
      <document>
  <![CDATA[<be:DartsEvent xmlns:be="urn:integration-cjsonline-gov-uk:pilot:entities" ID="{{seq}}14015" Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="12" MIN="04" S="10">
    <be:CourtHouse>Harrow Crown Court</be:CourtHouse>
    <be:CourtRoom>Room {{seq}}U</be:CourtRoom>
    <be:CaseNumbers>
      <be:CaseNumber>T{{seq}}207</be:CaseNumber>
    </be:CaseNumbers>
    <be:EventText>text {{seq}} CD2</be:EventText>
  </be:DartsEvent>]]>
</document>
  """
	Then the API status code is 200
   And I see table EVENT column count(eve_id) is "1" where cas.case_number = "T{{seq}}207" and courthouse_name = "Harrow Crown Court"

@EVENT_API @SOAP_API @DMP-2960 @regression
Scenario: Verify that an invalid courthouse fails
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action addDocument and body:
	"""
      <messageId>{{seq}}4015</messageId>
      <type>10100</type>
      <document>
  <![CDATA[<be:DartsEvent xmlns:be="urn:integration-cjsonline-gov-uk:pilot:entities" ID="{{seq}}14015" Y="{{yyyy-{{date-0}}}}" M="{{mm-{{date-0}}}}" D="{{dd-{{date-0}}}}" H="12" MIN="04" S="10">
    <be:CourtHouse>Non Existant Court House</be:CourtHouse>
    <be:CourtRoom>Room {{seq}}C</be:CourtRoom>
    <be:CaseNumbers>
      <be:CaseNumber>T{{seq}}206C</be:CaseNumber>
    </be:CaseNumbers>
    <be:EventText>text {{seq}} CD2</be:EventText>
  </be:DartsEvent>]]>
</document>
  """
	Then the API status code is 404


@EVENT_API @SOAP_EVENT @regression
Scenario Outline: Verify that a hearing courtroom can be modified by an event
																									where a case is added via daily lists (so a hearing record exists)
																									if the first event added is for a different courtroom
																									 then the existing hearing should be updated with the new courtroom
  Given I authenticate from the XHIBIT source system
  When I add a daily list
  | messageId                        | type | subType | documentName              | courthouse   | courtroom    | caseNumber   | startDate  | startTime | endDate    | timeStamp     |
  | 58b211f4-426d-81be-00{{seq}}901  | DL   | DL      | DL {{date+0/}} {{seq}}901 | <courthouse> | <courtroom>E | <caseNumber> | {{date+0}} | 16:00     | {{date+0}} | {{timestamp}} |
   And I process the daily list for courthouse <courthouse>
  Then I see table CASE_HEARING column hearing_is_actual is "f" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>E"

   And I create an event
    | message_id  | type   | sub_type  | event_id   | courthouse   | courtroom    | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>2    | <type> | <subType> | <eventId>2 | <courthouse> | <courtroom>F | <caseNumber> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
  Then I see table CASE_HEARING column hearing_is_actual is "t" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>F"
   And I see table CASE_HEARING column courtroom_name is "<courtroom>F" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>F"
# Following line fails due to DMP-3252 adding a new hearing rather than updating the existing hearing to teh new courtroom
# possibly verify that the hearing row is the same key if that is appropriate in the solution
   And I see table CASE_HEARING column COUNT(courtroom_name) is "0" where cas.case_number = "<caseNumber>" and courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>"

Examples:
  | courthouse         | courtroom    | caseNumber  | dateTime               | msgId      | eventId     | type   | subType | eventText     | caseRetention | totalSentence | text                                                                                                                                   | notes |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}208 | {{timestamp-10:00:00}} | {{seq}}450 | {{seq}}1450 | 1000   | 1001    | text {{seq}}E |               |               | Offences put to defendant                                                                                                              |       |


  @EVENT_API @SOAP_EVENT @regression @DMP-1941 @DMP-1928
  Scenario Outline: Create Poll Check events
  These tests will help populate the relevant section of the DARTS Dynatrace Dashboard each time they are executed
  NB: The usual 'Then' step is missing as the 'When' step includes the assertion of the API response code
    Given I authenticate from the <source> source system
    When  I create an event
      | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
      | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <caseRetention>             | <totalSentence>     |
    Examples:
      | source | courthouse         | courtroom    | caseNumbers     | dateTime               | msgId        | eventId       | type   | subType | eventText         | caseRetention | totalSentence |
      | CPP    | Harrow Crown Court | Room {{seq}} | T{{seq}}2070501 | {{timestamp-10:01:01}} | {{seq}}20705 | -{{seq}}20705 | 20705  |         | CPP Daily Test    |               |               |
      | XHIBIT | Harrow Crown Court | Room {{seq}} | T{{seq}}2070501 | {{timestamp-10:02:02}} | {{seq}}20705 | {{seq}}20705  | 20705  |         | Xhibit Daily Test |               |               |
