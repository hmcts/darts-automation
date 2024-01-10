Feature: Cases EndPoint using SOAP

  @DMP-1706
  Scenario: POST /addCase
    When I call POST SOAP API using SOAPAction addCase and encoded body:
    """
    <case type="1" id="SOAP20230001">
    <courthouse>Harrow Crown Court</courthouse>
    <courtroom>Rayners room</courtroom>
    <defendants>
      <defendant>test defendent11</defendant>
      <defendant>test defendent22</defendant>
    </defendants>
    <judges>
      <judge>test judge</judge>
    </judges>
    <prosecutors>
      <prosecutor>test prosecutor</prosecutor>
    </prosecutors>
   </case>
    """
    And the API status code is 200

