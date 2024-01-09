Feature: Test operation of post events

@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a case
  When I create a case
    | courthouse   | case_number   | defendants    | judges     | prosecutors     | defenders     |
    | <courthouse> | <caseNumbers> | defendant one | test judge | test prosecutor | test defender |
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId       | eventId     | type   | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:06:40}} | {{seq}}0001 | {{seq}}1001 | 20901  |         | text         |               |               | 


@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create standard events
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId       | eventId     | type   | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:00:00}} | {{seq}}001 | {{seq}}1001 | 1000 | 1001 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:00:20}} | {{seq}}002 | {{seq}}1002 | 1000 | 1002 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:00:40}} | {{seq}}003 | {{seq}}1003 | 1000 | 1003 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:01:00}} | {{seq}}004 | {{seq}}1004 | 1000 | 1004 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:01:20}} | {{seq}}005 | {{seq}}1005 | 1000 | 1005 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:01:40}} | {{seq}}006 | {{seq}}1006 | 1000 | 1006 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:02:00}} | {{seq}}007 | {{seq}}1007 | 1000 | 1007 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:02:20}} | {{seq}}008 | {{seq}}1008 | 1000 | 1009 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:02:40}} | {{seq}}009 | {{seq}}1009 | 1000 | 1010 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:03:00}} | {{seq}}010 | {{seq}}1010 | 1000 | 1011 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:03:20}} | {{seq}}011 | {{seq}}1011 | 1000 | 1012 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:03:40}} | {{seq}}012 | {{seq}}1012 | 1000 | 1014 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:04:00}} | {{seq}}013 | {{seq}}1013 | 1000 | 1022 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:04:20}} | {{seq}}014 | {{seq}}1014 | 1000 | 1024 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:04:40}} | {{seq}}015 | {{seq}}1015 | 1000 | 1026 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:05:00}} | {{seq}}016 | {{seq}}1016 | 1000 | 1027 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:05:20}} | {{seq}}017 | {{seq}}1017 | 1000 | 1028 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:05:40}} | {{seq}}018 | {{seq}}1018 | 1000 | 1029 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:06:00}} | {{seq}}019 | {{seq}}1019 | 1000 | 1051 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:06:20}} | {{seq}}020 | {{seq}}1020 | 1000 | 1052 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:06:40}} | {{seq}}021 | {{seq}}1021 | 1000 | 1053 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:07:00}} | {{seq}}022 | {{seq}}1022 | 1000 | 1054 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:07:20}} | {{seq}}023 | {{seq}}1023 | 1000 | 1056 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:07:40}} | {{seq}}024 | {{seq}}1024 | 1000 | 1057 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:08:00}} | {{seq}}025 | {{seq}}1025 | 1000 | 1058 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:08:20}} | {{seq}}026 | {{seq}}1026 | 1000 | 1059 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:08:40}} | {{seq}}027 | {{seq}}1027 | 1000 | 1062 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:09:00}} | {{seq}}028 | {{seq}}1028 | 1000 | 1063 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:09:20}} | {{seq}}029 | {{seq}}1029 | 1000 | 1064 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:09:40}} | {{seq}}030 | {{seq}}1030 | 1000 | 1065 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:10:00}} | {{seq}}031 | {{seq}}1031 | 1000 | 1066 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:10:20}} | {{seq}}032 | {{seq}}1032 | 1000 | 1067 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:10:40}} | {{seq}}033 | {{seq}}1033 | 1000 | 1068 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:11:00}} | {{seq}}034 | {{seq}}1034 | 1000 | 1069 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:11:20}} | {{seq}}035 | {{seq}}1035 | 1000 | 1070 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:11:40}} | {{seq}}036 | {{seq}}1036 | 2100 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:12:00}} | {{seq}}037 | {{seq}}1037 | 2198 | 3900 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:12:20}} | {{seq}}038 | {{seq}}1038 | 2198 | 3901 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:12:40}} | {{seq}}039 | {{seq}}1039 | 2198 | 3903 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:13:00}} | {{seq}}040 | {{seq}}1040 | 2198 | 3904 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:13:20}} | {{seq}}041 | {{seq}}1041 | 2198 | 3905 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:13:40}} | {{seq}}042 | {{seq}}1042 | 2198 | 3906 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:14:00}} | {{seq}}043 | {{seq}}1043 | 2198 | 3907 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:14:20}} | {{seq}}044 | {{seq}}1044 | 2198 | 3918 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:14:40}} | {{seq}}045 | {{seq}}1045 | 2198 | 3921 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:15:00}} | {{seq}}046 | {{seq}}1046 | 2198 | 3931 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:15:20}} | {{seq}}047 | {{seq}}1047 | 2198 | 3932 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:15:40}} | {{seq}}048 | {{seq}}1048 | 2198 | 3935 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:16:00}} | {{seq}}049 | {{seq}}1049 | 2198 | 3936 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:16:20}} | {{seq}}050 | {{seq}}1050 | 2198 | 3937 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:16:40}} | {{seq}}051 | {{seq}}1051 | 2198 | 3938 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:17:00}} | {{seq}}052 | {{seq}}1052 | 2198 | 3940 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:17:20}} | {{seq}}053 | {{seq}}1053 | 2198 | 3986 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:17:40}} | {{seq}}054 | {{seq}}1054 | 2199 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:18:00}} | {{seq}}055 | {{seq}}1055 | 2201 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:18:20}} | {{seq}}056 | {{seq}}1056 | 2902 | 3964 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:18:40}} | {{seq}}057 | {{seq}}1057 | 2906 | 3968 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:19:00}} | {{seq}}058 | {{seq}}1058 | 2907 | 3969 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:19:20}} | {{seq}}059 | {{seq}}1059 | 2908 | 3970 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:19:40}} | {{seq}}060 | {{seq}}1060 | 2909 | 3971 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:20:00}} | {{seq}}061 | {{seq}}1061 | 2910 | 3972 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:20:20}} | {{seq}}062 | {{seq}}1062 | 2912 | 3974 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:20:40}} | {{seq}}063 | {{seq}}1063 | 2913 | 3975 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:21:00}} | {{seq}}064 | {{seq}}1064 | 2914 | 3976 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:21:20}} | {{seq}}065 | {{seq}}1065 | 2918 | 3980 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:21:40}} | {{seq}}066 | {{seq}}1066 | 2920 | 3981 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:22:00}} | {{seq}}067 | {{seq}}1067 | 2933 | 3982 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:22:20}} | {{seq}}068 | {{seq}}1068 | 2934 | 3983 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:22:40}} | {{seq}}069 | {{seq}}1069 | 4101 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:23:00}} | {{seq}}070 | {{seq}}1070 | 4102 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:23:20}} | {{seq}}071 | {{seq}}1071 | 10200 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:23:40}} | {{seq}}072 | {{seq}}1072 | 10300 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:24:00}} | {{seq}}073 | {{seq}}1073 | 10400 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:24:20}} | {{seq}}074 | {{seq}}1074 | 20100 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:24:40}} | {{seq}}075 | {{seq}}1075 | 20101 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:25:00}} | {{seq}}076 | {{seq}}1076 | 20198 | 13900 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:25:20}} | {{seq}}077 | {{seq}}1077 | 20198 | 13901 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:25:40}} | {{seq}}078 | {{seq}}1078 | 20198 | 13902 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:26:00}} | {{seq}}079 | {{seq}}1079 | 20198 | 13903 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:26:20}} | {{seq}}080 | {{seq}}1080 | 20198 | 13904 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:26:40}} | {{seq}}081 | {{seq}}1081 | 20198 | 13905 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:27:00}} | {{seq}}082 | {{seq}}1082 | 20198 | 13906 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:27:20}} | {{seq}}083 | {{seq}}1083 | 20198 | 13907 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:27:40}} | {{seq}}084 | {{seq}}1084 | 20198 | 13908 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:28:00}} | {{seq}}085 | {{seq}}1085 | 20198 | 13909 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:28:20}} | {{seq}}086 | {{seq}}1086 | 20198 | 13910 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:28:40}} | {{seq}}087 | {{seq}}1087 | 20198 | 13911 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:29:00}} | {{seq}}088 | {{seq}}1088 | 20198 | 13912 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:29:20}} | {{seq}}089 | {{seq}}1089 | 20198 | 13913 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:29:40}} | {{seq}}090 | {{seq}}1090 | 20198 | 13914 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:30:00}} | {{seq}}091 | {{seq}}1091 | 20198 | 13915 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:30:20}} | {{seq}}092 | {{seq}}1092 | 20198 | 13916 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:30:40}} | {{seq}}093 | {{seq}}1093 | 20198 | 13917 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:31:00}} | {{seq}}094 | {{seq}}1094 | 20198 | 13918 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:31:20}} | {{seq}}095 | {{seq}}1095 | 20198 | 13919 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:31:40}} | {{seq}}096 | {{seq}}1096 | 20198 | 13920 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:32:00}} | {{seq}}097 | {{seq}}1097 | 20198 | 13921 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:32:20}} | {{seq}}098 | {{seq}}1098 | 20198 | 13922 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:32:40}} | {{seq}}099 | {{seq}}1099 | 20198 | 13923 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:33:00}} | {{seq}}100 | {{seq}}1100 | 20198 | 13924 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:33:20}} | {{seq}}101 | {{seq}}1101 | 20198 | 13925 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:33:40}} | {{seq}}102 | {{seq}}1102 | 20198 | 13926 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:34:00}} | {{seq}}103 | {{seq}}1103 | 20198 | 13927 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:34:20}} | {{seq}}104 | {{seq}}1104 | 20198 | 13928 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:34:40}} | {{seq}}105 | {{seq}}1105 | 20198 | 13929 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:35:00}} | {{seq}}106 | {{seq}}1106 | 20198 | 13930 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:35:20}} | {{seq}}107 | {{seq}}1107 | 20198 | 13931 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:35:40}} | {{seq}}108 | {{seq}}1108 | 20198 | 13932 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:36:00}} | {{seq}}109 | {{seq}}1109 | 20198 | 13933 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:36:20}} | {{seq}}110 | {{seq}}1110 | 20198 | 13934 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:36:40}} | {{seq}}111 | {{seq}}1111 | 20198 | 13935 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:37:00}} | {{seq}}112 | {{seq}}1112 | 20198 | 13936 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:37:20}} | {{seq}}113 | {{seq}}1113 | 20198 | 13937 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:37:40}} | {{seq}}114 | {{seq}}1114 | 20198 | 13938 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:38:00}} | {{seq}}115 | {{seq}}1115 | 20198 | 13939 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:38:20}} | {{seq}}116 | {{seq}}1116 | 20198 | 13940 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:38:40}} | {{seq}}117 | {{seq}}1117 | 20198 | 13941 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:39:00}} | {{seq}}118 | {{seq}}1118 | 20200 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:39:20}} | {{seq}}119 | {{seq}}1119 | 20501 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:39:40}} | {{seq}}120 | {{seq}}1120 | 20502 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:40:00}} | {{seq}}121 | {{seq}}1121 | 20503 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:40:20}} | {{seq}}122 | {{seq}}1122 | 20504 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:40:40}} | {{seq}}123 | {{seq}}1123 | 20601 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:41:00}} | {{seq}}124 | {{seq}}1124 | 20602 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:41:20}} | {{seq}}125 | {{seq}}1125 | 20603 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:41:40}} | {{seq}}126 | {{seq}}1126 | 20604 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:42:00}} | {{seq}}127 | {{seq}}1127 | 20605 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:42:20}} | {{seq}}128 | {{seq}}1128 | 20606 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:42:40}} | {{seq}}129 | {{seq}}1129 | 20607 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:43:00}} | {{seq}}130 | {{seq}}1130 | 20608 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:43:20}} | {{seq}}131 | {{seq}}1131 | 20609 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:43:40}} | {{seq}}132 | {{seq}}1132 | 20613 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:44:00}} | {{seq}}133 | {{seq}}1133 | 20701 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:44:20}} | {{seq}}134 | {{seq}}1134 | 20702 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:44:40}} | {{seq}}135 | {{seq}}1135 | 20703 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:45:00}} | {{seq}}136 | {{seq}}1136 | 20704 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:45:20}} | {{seq}}137 | {{seq}}1137 | 20705 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:45:40}} | {{seq}}138 | {{seq}}1138 | 20901 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:46:00}} | {{seq}}139 | {{seq}}1139 | 20902 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:46:20}} | {{seq}}140 | {{seq}}1140 | 20903 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:46:40}} | {{seq}}141 | {{seq}}1141 | 20904 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:47:00}} | {{seq}}142 | {{seq}}1142 | 20905 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:47:20}} | {{seq}}143 | {{seq}}1143 | 20906 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:47:40}} | {{seq}}144 | {{seq}}1144 | 20907 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:48:00}} | {{seq}}145 | {{seq}}1145 | 20908 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:48:20}} | {{seq}}146 | {{seq}}1146 | 20909 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:48:40}} | {{seq}}147 | {{seq}}1147 | 20910 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:49:00}} | {{seq}}148 | {{seq}}1148 | 20911 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:49:20}} | {{seq}}149 | {{seq}}1149 | 20912 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:49:40}} | {{seq}}150 | {{seq}}1150 | 20914 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:50:00}} | {{seq}}151 | {{seq}}1151 | 20915 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:50:20}} | {{seq}}152 | {{seq}}1152 | 20916 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:50:40}} | {{seq}}153 | {{seq}}1153 | 20918 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:51:00}} | {{seq}}154 | {{seq}}1154 | 20920 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:51:20}} | {{seq}}155 | {{seq}}1155 | 20933 | 10622 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:51:40}} | {{seq}}156 | {{seq}}1156 | 20934 | 10623 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:52:00}} | {{seq}}157 | {{seq}}1157 | 20935 | 10630 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:52:20}} | {{seq}}158 | {{seq}}1158 | 20935 | 10631 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:52:40}} | {{seq}}159 | {{seq}}1159 | 20935 | 10632 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:53:00}} | {{seq}}160 | {{seq}}1160 | 20935 | 10633 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:53:20}} | {{seq}}161 | {{seq}}1161 | 20936 | 10630 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:53:40}} | {{seq}}162 | {{seq}}1162 | 20936 | 10631 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:54:00}} | {{seq}}163 | {{seq}}1163 | 20936 | 10632 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:54:20}} | {{seq}}164 | {{seq}}1164 | 20936 | 10633 | text         |               |               |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:54:40}} | {{seq}}165 | {{seq}}1165 | 20937 | 10624 | text         |               |               |
#  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:55:00}} | {{seq}}166 | {{seq}}1166 | 20937 | 10625 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:55:20}} | {{seq}}167 | {{seq}}1167 | 21200 | 10311 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:55:40}} | {{seq}}168 | {{seq}}1168 | 21200 | 10312 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:56:00}} | {{seq}}169 | {{seq}}1169 | 21200 | 10313 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:56:20}} | {{seq}}170 | {{seq}}1170 | 21300 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:56:40}} | {{seq}}171 | {{seq}}1171 | 21400 | 12414 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:57:00}} | {{seq}}172 | {{seq}}1172 | 21400 | 12415 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:57:20}} | {{seq}}173 | {{seq}}1173 | 21500 | 13700 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:57:40}} | {{seq}}174 | {{seq}}1174 | 21500 | 13701 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:58:00}} | {{seq}}175 | {{seq}}1175 | 21500 | 13702 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:58:20}} | {{seq}}176 | {{seq}}1176 | 21500 | 13703 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:58:40}} | {{seq}}177 | {{seq}}1177 | 21500 | 13704 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:59:00}} | {{seq}}178 | {{seq}}1178 | 21500 | 13705 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:59:20}} | {{seq}}179 | {{seq}}1179 | 21600 | 13600 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:59:40}} | {{seq}}180 | {{seq}}1180 | 21600 | 13601 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:00:00}} | {{seq}}181 | {{seq}}1181 | 21600 | 13602 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:00:20}} | {{seq}}182 | {{seq}}1182 | 21600 | 13603 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:00:40}} | {{seq}}183 | {{seq}}1183 | 21600 | 13604 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:01:00}} | {{seq}}184 | {{seq}}1184 | 21600 | 13605 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:01:20}} | {{seq}}185 | {{seq}}1185 | 21600 | 13606 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:01:40}} | {{seq}}186 | {{seq}}1186 | 21600 | 13607 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:02:00}} | {{seq}}187 | {{seq}}1187 | 21600 | 13608 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:02:20}} | {{seq}}188 | {{seq}}1188 | 21600 | 13609 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:02:40}} | {{seq}}189 | {{seq}}1189 | 21800 | 12310 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:03:00}} | {{seq}}190 | {{seq}}1190 | 30601 | 11113 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:03:20}} | {{seq}}191 | {{seq}}1191 | 40203 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:03:40}} | {{seq}}192 | {{seq}}1192 | 40410 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:04:00}} | {{seq}}193 | {{seq}}1193 | 40601 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:04:20}} | {{seq}}194 | {{seq}}1194 | 40706 | 10305 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:04:40}} | {{seq}}195 | {{seq}}1195 | 40706 | 10308 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:05:00}} | {{seq}}196 | {{seq}}1196 | 40706 | 10309 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:05:20}} | {{seq}}197 | {{seq}}1197 | 40711 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:05:40}} | {{seq}}198 | {{seq}}1198 | 40720 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:06:00}} | {{seq}}199 | {{seq}}1199 | 40721 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:06:20}} | {{seq}}200 | {{seq}}1200 | 40722 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:06:40}} | {{seq}}201 | {{seq}}1201 | 40725 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:07:00}} | {{seq}}202 | {{seq}}1202 | 40726 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:07:20}} | {{seq}}203 | {{seq}}1203 | 40727 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:07:40}} | {{seq}}204 | {{seq}}1204 | 40730 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:08:00}} | {{seq}}205 | {{seq}}1205 | 40731 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:08:20}} | {{seq}}206 | {{seq}}1206 | 40732 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:08:40}} | {{seq}}207 | {{seq}}1207 | 40733 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:09:00}} | {{seq}}208 | {{seq}}1208 | 40736 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:09:20}} | {{seq}}209 | {{seq}}1209 | 40737 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:09:40}} | {{seq}}210 | {{seq}}1210 | 40738 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:10:00}} | {{seq}}211 | {{seq}}1211 | 40750 | 12309 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:10:20}} | {{seq}}212 | {{seq}}1212 | 40750 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:10:40}} | {{seq}}213 | {{seq}}1213 | 40751 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:11:00}} | {{seq}}214 | {{seq}}1214 | 40752 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:11:20}} | {{seq}}215 | {{seq}}1215 | 40753 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:11:40}} | {{seq}}216 | {{seq}}1216 | 40754 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:12:00}} | {{seq}}217 | {{seq}}1217 | 40755 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:12:20}} | {{seq}}218 | {{seq}}1218 | 40756 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:12:40}} | {{seq}}219 | {{seq}}1219 | 40791 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:13:00}} | {{seq}}220 | {{seq}}1220 | 60101 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:13:20}} | {{seq}}221 | {{seq}}1221 | 60102 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:13:40}} | {{seq}}222 | {{seq}}1222 | 60103 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:14:00}} | {{seq}}223 | {{seq}}1223 | 60104 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:14:20}} | {{seq}}224 | {{seq}}1224 | 60106 | 11317 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:14:40}} | {{seq}}225 | {{seq}}1225 | 60106 | 11318 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:15:00}} | {{seq}}226 | {{seq}}1226 | 302001 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:15:20}} | {{seq}}227 | {{seq}}1227 | 302002 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:15:40}} | {{seq}}228 | {{seq}}1228 | 302003 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:16:00}} | {{seq}}229 | {{seq}}1229 | 302004 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:16:20}} | {{seq}}230 | {{seq}}1230 | 407131 |      | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:16:40}} | {{seq}}231 | {{seq}}1231 | 407132 |      | text         |               |               |
@broken
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:54:40}} | {{seq}}165 | {{seq}}1165 | 20937 | 10624   | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-10:55:00}} | {{seq}}166 | {{seq}}1166 | 20937 | 10625   | text         |               |               |


@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a LOG event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId       | eventId     | type   | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:17:00}} | {{seq}}232  | {{seq}}1232 | LOG    |         | log text     |               |               |
        
@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a SetReportingRestriction event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:18:00}} | {{seq}}233 | {{seq}}1233 | 2198  | 3933  | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:18:20}} | {{seq}}234 | {{seq}}1234 | 21200 | 11000 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:18:40}} | {{seq}}235 | {{seq}}1235 | 21200 | 11001 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:19:00}} | {{seq}}236 | {{seq}}1236 | 21200 | 11002 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:19:20}} | {{seq}}237 | {{seq}}1237 | 21200 | 11003 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:19:40}} | {{seq}}238 | {{seq}}1238 | 21200 | 11004 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:20:00}} | {{seq}}239 | {{seq}}1239 | 21200 | 11006 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:20:20}} | {{seq}}240 | {{seq}}1240 | 21200 | 11007 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:20:40}} | {{seq}}241 | {{seq}}1241 | 21200 | 11008 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:21:00}} | {{seq}}242 | {{seq}}1242 | 21200 | 11009 | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:21:20}} | {{seq}}243 | {{seq}}1243 | 21201 |       | text         |               |               |

@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a SetInterpreterUsed event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:22:00}} | {{seq}}244 | {{seq}}1244 | 2917  | 3979    | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:22:20}} | {{seq}}245 | {{seq}}1244 | 20612 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:22:40}} | {{seq}}246 | {{seq}}1244 | 20917 |         | text         |               |               |

  
@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a StopAndClose event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:23:00}} | {{seq}}247 | {{seq}}1247 | 3000  |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:23:20}} | {{seq}}248 | {{seq}}1248 | 30500 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:23:40}} | {{seq}}249 | {{seq}}1249 | 30600 |         | text         |               |               |


@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a TranscriptionRequest event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:24:00}} | {{seq}}250 | {{seq}}1250 | 3010  |         | text         |               |               |

  
@EVENT_API @SOAP_EVENT @smoketest 
Scenario Outline: Create a Sentencing event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
#  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:25:00}} | {{seq}}251 | {{seq}}1251 | 2198  | 3934 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:25:20}} | {{seq}}252 | {{seq}}1252 | 40730 | 10808 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:25:40}} | {{seq}}253 | {{seq}}1253 | 40731 | 10808 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:26:00}} | {{seq}}254 | {{seq}}1254 | 40732 | 10808 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:26:20}} | {{seq}}255 | {{seq}}1255 | 40733 | 10808 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:26:40}} | {{seq}}256 | {{seq}}1256 | 40735 | 10808 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:27:00}} | {{seq}}257 | {{seq}}1257 | 40735 |       | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:27:20}} | {{seq}}258 | {{seq}}1258 | 40750 | 11504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:27:40}} | {{seq}}259 | {{seq}}1259 | 40750 | 11505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:28:00}} | {{seq}}260 | {{seq}}1260 | 40750 | 11506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:28:20}} | {{seq}}261 | {{seq}}1261 | 40750 | 11507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:28:40}} | {{seq}}262 | {{seq}}1262 | 40750 | 11508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:29:00}} | {{seq}}263 | {{seq}}1263 | 40750 | 11509 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:29:20}} | {{seq}}264 | {{seq}}1264 | 40750 | 11521 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:29:40}} | {{seq}}265 | {{seq}}1265 | 40750 | 11522 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:30:00}} | {{seq}}266 | {{seq}}1266 | 40750 | 11523 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:30:20}} | {{seq}}267 | {{seq}}1267 | 40750 | 11524 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:30:40}} | {{seq}}268 | {{seq}}1268 | 40750 | 11525 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:31:00}} | {{seq}}269 | {{seq}}1269 | 40750 | 11526 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:31:20}} | {{seq}}270 | {{seq}}1270 | 40750 | 11527 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:31:40}} | {{seq}}271 | {{seq}}1271 | 40750 | 11528 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:32:00}} | {{seq}}272 | {{seq}}1272 | 40750 | 11529 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:32:20}} | {{seq}}273 | {{seq}}1273 | 40750 | 12400 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:32:40}} | {{seq}}274 | {{seq}}1274 | 40750 | 12401 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:33:00}} | {{seq}}275 | {{seq}}1275 | 40750 | 13503 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:33:20}} | {{seq}}276 | {{seq}}1276 | 40750 | 13504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:33:40}} | {{seq}}277 | {{seq}}1277 | 40750 | 13505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:34:00}} | {{seq}}278 | {{seq}}1278 | 40750 | 13506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:34:20}} | {{seq}}279 | {{seq}}1279 | 40751 | 11504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:34:40}} | {{seq}}280 | {{seq}}1280 | 40751 | 11505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:35:00}} | {{seq}}281 | {{seq}}1281 | 40751 | 11506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:35:20}} | {{seq}}282 | {{seq}}1282 | 40751 | 11507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:35:40}} | {{seq}}283 | {{seq}}1283 | 40751 | 11508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:36:00}} | {{seq}}284 | {{seq}}1284 | 40751 | 11509 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:36:20}} | {{seq}}285 | {{seq}}1285 | 40751 | 11521 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:36:40}} | {{seq}}286 | {{seq}}1286 | 40751 | 11522 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:37:00}} | {{seq}}287 | {{seq}}1287 | 40751 | 11523 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:37:20}} | {{seq}}288 | {{seq}}1288 | 40751 | 11524 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:37:40}} | {{seq}}289 | {{seq}}1289 | 40751 | 11525 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:38:00}} | {{seq}}290 | {{seq}}1290 | 40751 | 11526 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:38:20}} | {{seq}}291 | {{seq}}1291 | 40751 | 11527 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:38:40}} | {{seq}}292 | {{seq}}1292 | 40751 | 11528 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:39:00}} | {{seq}}293 | {{seq}}1293 | 40751 | 11529 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:39:20}} | {{seq}}294 | {{seq}}1294 | 40751 | 12400 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:39:40}} | {{seq}}295 | {{seq}}1295 | 40751 | 12401 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:40:00}} | {{seq}}296 | {{seq}}1296 | 40751 | 13503 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:40:20}} | {{seq}}297 | {{seq}}1297 | 40751 | 13504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:40:40}} | {{seq}}298 | {{seq}}1298 | 40751 | 13505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:41:00}} | {{seq}}299 | {{seq}}1299 | 40751 | 13506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:41:20}} | {{seq}}300 | {{seq}}1300 | 40752 | 11504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:41:40}} | {{seq}}301 | {{seq}}1301 | 40752 | 11505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:42:00}} | {{seq}}302 | {{seq}}1302 | 40752 | 11506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:42:20}} | {{seq}}303 | {{seq}}1303 | 40752 | 11507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:42:40}} | {{seq}}304 | {{seq}}1304 | 40752 | 11508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:43:00}} | {{seq}}305 | {{seq}}1305 | 40752 | 11509 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:43:20}} | {{seq}}306 | {{seq}}1306 | 40752 | 11521 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:43:40}} | {{seq}}307 | {{seq}}1307 | 40752 | 11522 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:44:00}} | {{seq}}308 | {{seq}}1308 | 40752 | 11523 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:44:20}} | {{seq}}309 | {{seq}}1309 | 40752 | 11524 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:44:40}} | {{seq}}310 | {{seq}}1310 | 40752 | 11525 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:45:00}} | {{seq}}311 | {{seq}}1311 | 40752 | 11526 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:45:20}} | {{seq}}312 | {{seq}}1312 | 40752 | 11527 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:45:40}} | {{seq}}313 | {{seq}}1313 | 40752 | 11528 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:46:00}} | {{seq}}314 | {{seq}}1314 | 40752 | 11529 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:46:20}} | {{seq}}315 | {{seq}}1315 | 40752 | 12400 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:46:40}} | {{seq}}316 | {{seq}}1316 | 40752 | 12401 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:47:00}} | {{seq}}317 | {{seq}}1317 | 40752 | 13503 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:47:20}} | {{seq}}318 | {{seq}}1318 | 40752 | 13504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:47:40}} | {{seq}}319 | {{seq}}1319 | 40752 | 13505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:48:00}} | {{seq}}320 | {{seq}}1320 | 40752 | 13506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:48:20}} | {{seq}}321 | {{seq}}1321 | 40753 | 11504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:48:40}} | {{seq}}322 | {{seq}}1322 | 40753 | 11505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:49:00}} | {{seq}}323 | {{seq}}1323 | 40753 | 11506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:49:20}} | {{seq}}324 | {{seq}}1324 | 40753 | 11507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:49:40}} | {{seq}}325 | {{seq}}1325 | 40753 | 11508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:50:00}} | {{seq}}326 | {{seq}}1326 | 40753 | 11509 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:50:20}} | {{seq}}327 | {{seq}}1327 | 40753 | 11521 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:50:40}} | {{seq}}328 | {{seq}}1328 | 40753 | 11522 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:51:00}} | {{seq}}329 | {{seq}}1329 | 40753 | 11523 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:51:20}} | {{seq}}330 | {{seq}}1330 | 40753 | 11524 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:51:40}} | {{seq}}331 | {{seq}}1331 | 40753 | 11525 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:52:00}} | {{seq}}332 | {{seq}}1332 | 40753 | 11526 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:52:20}} | {{seq}}333 | {{seq}}1333 | 40753 | 11527 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:52:40}} | {{seq}}334 | {{seq}}1334 | 40753 | 11528 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:53:00}} | {{seq}}335 | {{seq}}1335 | 40753 | 11529 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:53:20}} | {{seq}}336 | {{seq}}1336 | 40753 | 12400 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:53:40}} | {{seq}}337 | {{seq}}1337 | 40753 | 12401 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:54:00}} | {{seq}}338 | {{seq}}1338 | 40753 | 13503 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:54:20}} | {{seq}}339 | {{seq}}1339 | 40753 | 13504 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:54:40}} | {{seq}}340 | {{seq}}1340 | 40753 | 13505 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:55:00}} | {{seq}}341 | {{seq}}1341 | 40753 | 13506 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:55:20}} | {{seq}}342 | {{seq}}1342 | 40750 | 11533 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:55:40}} | {{seq}}343 | {{seq}}1343 | 40750 | 11534 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:56:00}} | {{seq}}344 | {{seq}}1344 | 40750 | 13507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:56:20}} | {{seq}}345 | {{seq}}1345 | 40750 | 13508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:56:40}} | {{seq}}346 | {{seq}}1346 | 40751 | 11533 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:57:00}} | {{seq}}347 | {{seq}}1347 | 40751 | 11534 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:57:20}} | {{seq}}348 | {{seq}}1348 | 40751 | 13507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:57:40}} | {{seq}}349 | {{seq}}1349 | 40751 | 13508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:58:00}} | {{seq}}350 | {{seq}}1350 | 40752 | 11533 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:58:20}} | {{seq}}351 | {{seq}}1351 | 40752 | 11534 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:58:40}} | {{seq}}352 | {{seq}}1352 | 40752 | 13507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:59:00}} | {{seq}}353 | {{seq}}1353 | 40752 | 13508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:59:20}} | {{seq}}354 | {{seq}}1354 | 40753 | 11533 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-11:59:40}} | {{seq}}355 | {{seq}}1355 | 40753 | 11534 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:00:00}} | {{seq}}356 | {{seq}}1356 | 40753 | 13507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:00:20}} | {{seq}}357 | {{seq}}1357 | 40753 | 13508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:00:40}} | {{seq}}358 | {{seq}}1358 | 40754 | 11533 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:01:00}} | {{seq}}359 | {{seq}}1359 | 40754 | 11534 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:01:20}} | {{seq}}360 | {{seq}}1360 | 40754 | 13507 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:01:40}} | {{seq}}361 | {{seq}}1361 | 40754 | 13508 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:02:00}} | {{seq}}362 | {{seq}}1362 | DETTO | 11531 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:02:20}} | {{seq}}363 | {{seq}}1363 | STS   | 11530 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:02:40}} | {{seq}}364 | {{seq}}1364 | STS1821 | 11532 | [Defendant: DEFENDANT ONE] | 4             | 26Y0M0D       |

  
@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a DarStart event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
	| Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:03:00}} | {{seq}}364 | {{seq}}1364 | 1000  | 1055    | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:03:20}} | {{seq}}365 | {{seq}}1365 | 1100  |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:03:40}} | {{seq}}366 | {{seq}}1366 | 1500  |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:04:00}} | {{seq}}367 | {{seq}}1367 | 10100 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:04:20}} | {{seq}}368 | {{seq}}1368 | 10500 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:04:40}} | {{seq}}369 | {{seq}}1369 | 20913 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:05:00}} | {{seq}}370 | {{seq}}1370 | 1200  |         | text         |               |               |
  
  
@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a DarStop event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:06:00}} | {{seq}}371 | {{seq}}1371 | 1200  |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:06:20}} | {{seq}}372 | {{seq}}1372 | 1400  |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:06:40}} | {{seq}}373 | {{seq}}1373 | 30100 |         | text         |               |               |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:07:00}} | {{seq}}374 | {{seq}}1374 | 30300 |         | text         |               |               |
  
  
@EVENT_API @SOAP_EVENT @smoketest
Scenario Outline: Create a Null event
  When  I create an event
    | message_id  | type   | sub_type  | event_id  | courthouse   | courtroom   | case_numbers  | event_text  | date_time  | case_retention_fixed_policy | case_total_sentence |
    | <msgId>     | <type> | <subType> | <eventId> | <courthouse> | <courtroom> | <caseNumbers> | <eventText> | <dateTime> | <CaseRetention>             | <totalSentence>     |
#  Then I see table EVENT column event_text is "<eventText>" where cas.case_number = "<caseNumbers>" and courthouse_name = "<courthouse>" and message_id = "<msgId>"
Examples:
  | courthouse         | courtroom    | caseNumbers | dateTime               | msgId      | eventId     | type  | subType | eventText    | CaseRetention | totalSentence |
  | Harrow Crown Court | Room {{seq}} | T{{seq}}002 | {{timestamp-12:08:00}} | {{seq}}375 | {{seq}}1375 | 40790 |         | text         |               |               |


