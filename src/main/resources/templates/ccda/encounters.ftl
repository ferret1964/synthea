<#import "narrative_block.ftl" as narrative>
<#import "code_with_reference.ftl" as codes>
<component>
  <!--Encounters-->
  <section>
    <templateId root="2.16.840.1.113883.10.20.22.2.22" extension="2015-08-01"/> <!-- CCDA Template id -->
    <!--Encounters section template-->
    <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of encounters"/>
    <title>Encounters</title>
    <@narrative.narrative entries=ehr_encounters section="encounters"/>
    <#list ehr_encounters as entry>
    <entry typeCode="DRIV">
      <encounter classCode="ENC" moodCode="EVN">
		    <templateId root="2.16.840.1.113883.10.20.22.4.49"/>
        <!-- Encounter activity template -->
        <id root="${entry.uuid}"/>
        <@codes.code_section codes=entry.codes section="encounters" counter=entry?counter />
        <text>
          <reference value="#encounters-desc-${entry?counter}"/>
        </text>
        <effectiveTime>
          <low value="${entry.start?number_to_date?string["yyyyMMddHHmmss"]}"/>
          <#if entry.stop != 0><high value="${entry.stop?number_to_date?string["yyyyMMddHHmmss"]}"/></#if>
        </effectiveTime>
        <participant typeCode="LOC">
          <participantRole classCode="SDLOC">
            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
            <!-- Service Delivery Location template see https://terminology.hl7.org/5.1.0/CodeSystem-v3-RoleCode.html#v3-RoleCode-HOSP -->
            <id extension = "${entry.provider.npi}" />
            <#if entry.provider.cmsProviderType?has_content>
            <code code="${entry.provider.cmsProviderType}" codeSystem="http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType"
                  codeSystemName="RoleCode"
                  />
            </#if>
            <addr>
              <streetAddressLine>${entry.provider.address}</streetAddressLine>
              <city>${entry.provider.city}</city>
              <state>${entry.provider.state}</state>
              <postalCode>${entry.provider.zip}</postalCode>
            </addr>
            <#if entry.provider.telecom?has_content>
              <telecom value="${entry.provider.telecom}"/>
            </#if>
            <playingEntity classCode="PLC">
              <name>${entry.provider.name}</name>
            </playingEntity>
          </participantRole>
        </participant>
        <#if entry.reason??>
        <entryRelationship typeCode="RSON">
          <observation classCode="OBS" moodCode="EVN">
            <templateId root="2.16.840.1.113883.10.20.22.4.19" extension="2014-06-09"/>
            <templateId root="2.16.840.1.113883.10.20.22.4.19"/>
            <id extension="45678" root="1.3.6.1.4.1.42424242.4.99930.4.4.1.2.1"/>
            <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" code="282291009" displayName="Diagnosis"/>
            <text>
              <reference value="#TBD"/>
            </text>
            <statusCode code="completed"/>
            <effectiveTime>
              <low value="${entry.start?number_to_date?string["yyyyMMddHHmmss"]}"/>
              <#if entry.stop != 0><high value="${entry.stop?number_to_date?string["yyyyMMddHHmmss"]}"/></#if>
            </effectiveTime>
            <value xsi:type="CD" code="${entry.reason.code}" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="${entry.reason.display}"/>
          </observation>
        </entryRelationship>
        </#if>
      </encounter>
    </entry>
    </#list>
  </section>
</component>
