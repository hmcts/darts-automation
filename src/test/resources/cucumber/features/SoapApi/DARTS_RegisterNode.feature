@regression
Feature: REGISTER NODE using SOAP

@SOAP_API @REGISTER_NODE
Scenario Outline: SOAP registerNode including create courtroom
	When I register a node
	| courthouse   | courtroom   | hostname   | ip_address   | mac_address   | type   |
	| <courthouse> | <courtroom> | <hostname> | <ip_address> | <mac_address> | <type> |
	Then I find node_id in the xml response at "node_id"
	 And I see table NODE_REGISTER column courthouse_name is "<courthouse>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column courtroom_name is "<courtroom>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column hostname is "<hostname>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column mac_address is "<mac_address>" where node_id = "{{node_id}}"
#TODO currently ip_address is set to darts-stub-services.staging.platform.hmcts.net in staging 
#	 And I see table NODE_REGISTER column ip_address is "<ip_address>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column node_type is "<type>" where node_id = "{{node_id}}"
	When I register a node
	| courthouse   | courtroom   | hostname   | ip_address   | mac_address   | type   |
	| <courthouse> | <courtroom> | <hostname> | <ip_address> | <mac_address> | <type> |
	Then I see table NODE_REGISTER column count(node_id) is "2" where courthouse_name = "<courthouse>" and courtroom_name = "<courtroom>" and mac_address = "<mac_address>" and hostname = "<hostname>"
	
Examples:
	| courthouse         | courtroom  | hostname            | ip_address                    | mac_address                       | type |
	| Harrow Crown Court | 1          | Harrow_DAR_{{seq}}1 | {{ip-address-10.101.101.111}} | {{mac-address-12-34-56-78-90-11}} | DAR  |
	| Harrow Crown Court | reg{{seq}} | Harrow_DAR_{{seq}}2 | {{ip-address-10.101.101.112}} | {{mac-address-12-34-56-78-90-12}} | DAR  |


@SOAP_API @REGISTER_NODE
Scenario Outline: SOAP registerNode successful baseline
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action registerNode and body:
"""
<document xmlns="">
<![CDATA[<node type="DAR">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>2</courtroom>
  <hostname>Harrow_DAR_12</hostname>
  <ip_address>10.11.12.112</ip_address>
  <mac_address>12-34-56-78-90-AB</mac_address>
</node>
]]>
</document>
"""
	Then the API status code is 200

@SOAP_API @REGISTER_NODE
Scenario Outline: SOAP registerNode invalid courthouse
  Given I authenticate from the VIQ source system
	When I call POST SOAP API using soap action registerNode and body:
"""
<document xmlns="">
<![CDATA[<node type="DAR">
  <courthouse>invalid</courthouse>
  <courtroom>2</courtroom>
  <hostname>Harrow_DAR_12</hostname>
  <ip_address>1.142.12.112</ip_address>
  <mac_address>09-96-93-78-90-12</mac_address>
</node>
]]>
</document>
"""
	Then the API status code is 404

@SOAP_API @REGISTER_NODE
Scenario Outline: SOAP registerNode cannot be accessed from XHIBIT
  Given I authenticate from the XHIBIT source system
	When I call POST SOAP API using soap action registerNode and body:
"""
<document xmlns="">
<![CDATA[<node type="DAR">
  <courthouse>Harrow Crown Court</courthouse>
  <courtroom>2</courtroom>
  <hostname>Harrow_DAR_12</hostname>
  <ip_address>1.142.12.112</ip_address>
  <mac_address>09-96-93-78-90-12</mac_address>
</node>
]]>
</document>
"""
	Then the API status code is 500
	
