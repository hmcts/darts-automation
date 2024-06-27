Feature: REGISTER NODE using SOAP

@SOAP_API @REGISTER_NODE
Scenario Outline: SOAP registerNode
	When I register a node
	| courthouse   | courtroom   | hostname   | ip_address   | mac_address   | type   |
	| <courthouse> | <courtroom> | <hostname> | <ip_address> | <mac_address> | <type> |
	Then I find node_id in the xml response at "node_id"
	 And I see table NODE_REGISTER column courthouse_name is "<courthouse>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column courtroom_name is "<courtroom>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column hostname is "<hostname>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column mac_address is "<mac_address>" where node_id = "{{node_id}}"
#	 And I see table NODE_REGISTER column ip_address is "<ip_address>" where node_id = "{{node_id}}"
	 And I see table NODE_REGISTER column node_type is "<type>" where node_id = "{{node_id}}"
	
Examples:
	| courthouse         | courtroom  | hostname     | ip_address      | mac_address       | type |
	| Harrow Crown Court | 1          | Harrow_DAR_1 | 10.101.101.101  | 12-34-56-78-90-01 | DAR  |
	| Harrow Crown Court | 2          | Harrow_DAR_2 | 10.101.101.102  | 12-34-56-78-90-02 | DAR  |
