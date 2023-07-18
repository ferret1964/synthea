<#import "narrative_block.ftl" as narrative>
<#import "code_with_reference.ftl" as codes>
<component>
  <!--Medications-->
  <section>
	<templateId root="2.16.840.1.113883.10.20.22.2.1.1" extension="2014-06-09"/>
    <code code="10160-0" displayName="History of medication use" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
    <title>Medications</title>
    <@narrative.narrative entries=ehr_medications section="medications"/>
    <#list ehr_medications as entry>
    <entry>
      <!--CCD Medication activity - Required-->
      <substanceAdministration classCode="SBADM" moodCode="EVN">
        <templateId root="2.16.840.1.113883.10.20.22.4.16"/>
        <templateId root="2.16.840.1.113883.10.20.22.4.16" extension="2014-06-09"/>
        <id root="${entry.uuid}"/>
        <statusCode code="completed"/>
        <effectiveTime xsi:type="IVL_TS">
          <low value="${entry.start?number_to_date?string["yyyyMMddHHmmss"]}"/>
          <#if entry.stop != 0>
          <high value="${entry.stop?number_to_date?string["yyyyMMddHHmmss"]}"/>
          <#else>
          <high nullFlavor="UNK"/>
          </#if>
        </effectiveTime>
        <doseQuantity value="1"/>
        <consumable>
          <!--CCD Product - Required-->
          <manufacturedProduct classCode="MANU">
            <templateId root="2.16.840.1.113883.10.20.22.4.23"/>
            <templateId root="2.16.840.1.113883.10.20.22.4.23" extension="2014-06-09"/>
            <manufacturedMaterial>
              <@codes.code_section codes=entry.codes section="medications" counter=entry?counter />
              <name>${entry.codes[0].display}</name>
            </manufacturedMaterial>
          </manufacturedProduct>
        </consumable>
        <type administration="${entry.administration?c}"/>
        <!-- Put Supply here for orders -->
        <#if entry.prescriptionDetails??>
          <entryRelationship typeCode="REFR">
            <supply classCode="SPLY" moodCode="INT">
              <templateId root="2.16.840.1.113883.10.20.22.4.17" extension="2014-06-09" />
              <id root="aba2fc75-1a43-435f-8309-d24e4be5f1cd" />
              <statusCode code="completed" />
              <effectiveTime xsi:type="IVL_TS">
                <low value="${entry.start?number_to_date?string["yyyyMMddHHmmss"]}"/>
                <#if entry.stop != 0>
                  <high value="${entry.stop?number_to_date?string["yyyyMMddHHmmss"]}"/>
                <#else>
                  <high nullFlavor="UNK"/>
                </#if>
              </effectiveTime>
              <repeatNumber value="1" />
              <quantity value="1" />
              <product>
                <manufacturedProduct classCode="MANU">
                  <templateId root="2.16.840.1.113883.10.20.22.4.23" extension="2014-06-09" />
                </manufacturedProduct>
              </product>
              <entryRelationship typeCode="SUBJ" inversionInd="true">
                <act classCode="ACT" moodCode="INT">
                  <templateId root="2.16.840.1.113883.10.20.22.4.20" extension="2014-06-09" />
                </act>
              </entryRelationship>
            </supply>
          </entryRelationship>
        </#if>
      </substanceAdministration>
    </entry>
    </#list>
  </section>
</component>
