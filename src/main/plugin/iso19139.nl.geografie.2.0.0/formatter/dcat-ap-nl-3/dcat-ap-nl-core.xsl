<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                exclude-result-prefixes="#all">

  <xsl:import href="./dcat-ap-nl-utils.xsl" />
  <xsl:import href="../../../iso19115-3.2018/formatter/eu-geodcat-ap/eu-geodcat-ap-core.xsl"/>
  <xsl:import href="../../../iso19115-3.2018/formatter/eu-dcat-ap-hvd/eu-dcat-ap-hvd-core.xsl"/>
  <xsl:import href="./dcat-ap-nl-core-access-and-use.xsl"/>
  <xsl:import href="./dcat-ap-nl-core-lineage.xsl"/>
  <xsl:import href="./dcat-ap-nl-core-distribution.xsl"/>
  <xsl:import href="./dcat-ap-nl-core-contact.xsl"/>
  <xsl:import href="./dcat-ap-nl-core-resource.xsl"/>


  <xsl:variable name="isoContactRoleToDcatCommonNames"
                as="node()*">
    <entry key="dct:creator" as="foaf">author</entry>
    <!-- Add this? -->
    <!--<entry key="dct:creator" as="foaf">originator</entry>-->
    <entry key="dct:publisher" as="foaf">publisher</entry>
    <entry key="dcat:contactPoint" as="vcard">pointOfContact</entry>
    <!-- Add this? -->
    <!--<entry key="dcat:contactPoint" as="vcard">owner</entry>-->
    <!--<entry key="dct:rightsHolder" as="foaf">owner</entry>--> <!-- TODO: Check if dcat or only in profile -->
    <!-- Others are prov:qualifiedAttribution -->
  </xsl:variable>

  <xsl:variable name="isMappingResourceConstraintsToEuVocabulary"
                as="xs:boolean"
                select="true()"/>

  <xsl:variable name="languageMap"
                as="node()*">
    <entry key="dut">nld</entry>
  </xsl:variable>

  <!--
Theme mapping
https://joinup.ec.europa.eu/collection/semantic-interoperability-community-semic/solution/dcat-application-profile-implementation-guidelines/discussion/di1-tools-dcat-ap
https://github.com/SEMICeu/iso-19139-to-dcat-ap/blob/master/alignments/iso-topic-categories-to-inspire-themes.rdf
-->
  <xsl:variable name="isoTopicToEuDcatApThemes"
                as="node()*">
    <entry key="http://publications.europa.eu/resource/authority/data-theme/AGRI">
      <inspire>http://inspire.ec.europa.eu/theme/af</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/af</inspire>
      <iso>farming</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/ECON">
      <inspire>http://inspire.ec.europa.eu/theme/cp</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/cp</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/lu</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/lu</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/mr</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/mr</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/pf</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/pf</inspire>
      <iso>economy</iso>
      <iso>planningCadastre</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/EDUC"></entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/ENER">
      <inspire>http://inspire.ec.europa.eu/theme/er</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/er</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/mr</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/mr</inspire>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/ENVI">
      <inspire>http://inspire.ec.europa.eu/theme/hy</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/hy</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/ps</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ps</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/lc</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/lc</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/am</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/am</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/ac</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ac</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/br</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/br</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/ef</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ef</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/hb</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/hb</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/lu</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/lu</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/mr</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/mr</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/nz</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/nz</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/of</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/of</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/sr</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/sr</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/so</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/so</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/sd</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/sd</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/mf</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/mf</inspire>
      <iso>biota</iso>
      <iso>environment</iso>
      <iso>inlandWaters</iso>
      <iso>oceans</iso>
      <iso>climatologyMeteorologyAtmosphere</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/GOVE">
      <inspire>http://inspire.ec.europa.eu/theme/au</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/au</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/us</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/us</inspire>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/HEAL">
      <inspire>http://inspire.ec.europa.eu/theme/hh</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/hh</inspire>
      <iso>health</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/INTR"></entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/JUST"></entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/OP_DATPRO"></entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/REGI">
      <inspire>http://inspire.ec.europa.eu/theme/ad</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ad</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/rs</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/rs</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/gg</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/gg</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/cp</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/cp</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/gn</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/gn</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/el</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/el</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/ge</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ge</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/oi</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/oi</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/bu</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/bu</inspire>
      <iso>planningCadastre</iso>
      <iso>boundaries</iso>
      <iso>elevation</iso>
      <iso>imageryBaseMapsEarthCover</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/SOCI">
      <inspire>http://inspire.ec.europa.eu/theme/pd</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/pd</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/su</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/su</inspire>
      <iso>location</iso>
      <iso>society</iso>
      <iso>disaster</iso>
      <iso>intelligenceMilitary</iso>
      <iso>extraTerrestrial</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/TECH">
      <inspire>http://inspire.ec.europa.eu/theme/hy</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/hy</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/ge</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/ge</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/oi</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/oi</inspire>
      <inspire>http://inspire.ec.europa.eu/theme/mf</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/mf</inspire>
      <iso>geoscientificInformation</iso>
    </entry>
    <entry key="http://publications.europa.eu/resource/authority/data-theme/TRAN">
      <inspire>http://inspire.ec.europa.eu/theme/tn</inspire>
      <inspire>http://www.eionet.europa.eu/gemet/nl/inspire-theme/tn</inspire>
      <iso>structure</iso>
      <iso>transportation</iso>
      <iso>utilitiesCommunication</iso>
    </entry>
  </xsl:variable>

  <!--
  Definition:	A language of the resource. This refers to the natural language used for textual metadata (i.e., titles, descriptions, etc.) of a cataloged resource (i.e., dataset or service) or the textual values of a dataset distribution

  Range:
  dcterms:LinguisticSystem
  Resources defined by the Library of Congress (ISO 639-1, ISO 639-2) SHOULD be used.

  If a ISO 639-1 (two-letter) code is defined for language, then its corresponding IRI SHOULD be used; if no ISO 639-1 code is defined, then IRI corresponding to the ISO 639-2 (three-letter) code SHOULD be used.

  Usage note:	Repeat this property if the resource is available in multiple languages.
  -->
  <!-- Map DUT to NLD -->
  <xsl:template mode="iso19115-3-to-dcat"
                match="mri:defaultLocale
                      |mri:otherLocale
                      |mdb:defaultLocale
                      |mdb:otherLocale">


    <xsl:variable name="languageValue"
                  as="xs:string?"
                  select="if ($languageMap[@key = current()/*/lan:language/*/@codeListValue])
                          then $languageMap[@key = current()/*/lan:language/*/@codeListValue]
                          else */lan:language/*/@codeListValue"/>

    <dct:language>
      <dct:LinguisticSystem rdf:about="{concat($europaPublicationLanguage, upper-case($languageValue))}"/>
    </dct:language>
  </xsl:template>


  <!-- Process all dataset dates and keep the first one -->
  <xsl:template mode="iso19115-3-to-dcat"
                match="cit:CI_Citation/cit:date[*/cit:date]">


    <!-- Process all dates when processing the first date -->
    <xsl:if test="count(preceding-sibling::cit:date) = 0">
      <xsl:variable name="issuedDateTypes" select="$isoDateTypeToDcatCommonNames[@key='dct:issued']" />

      <!-- issued dates -->
      <xsl:variable name="issuedDates">
        <xsl:for-each select="../cit:date/*/cit:date">
          <xsl:sort select="." order="descending" />

          <xsl:variable name="dateType"
                        as="xs:string?"
                        select="../cit:dateType/*/@codeListValue"/>
          <xsl:variable name="dcatElementName"
                        as="xs:string?"
                        select="$issuedDateTypes[. = $dateType]/@key"/>
          <xsl:if test="string($dcatElementName)">
            <xsl:call-template name="rdf-date">
              <xsl:with-param name="nodeName" select="$dcatElementName"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>

      <xsl:copy-of select="$issuedDates/*[1]"/>

      <!-- modified dates -->
      <xsl:variable name="modifiedDateTypes" select="$isoDateTypeToDcatCommonNames[@key='dct:modified']" />

      <xsl:variable name="modifiedDates">
        <xsl:for-each select="../cit:date/*/cit:date">
          <xsl:sort select="." order="descending" />
          <xsl:variable name="dateType"
                        as="xs:string?"
                        select="../cit:dateType/*/@codeListValue"/>
          <xsl:variable name="dcatElementName"
                        as="xs:string?"
                        select="$modifiedDateTypes[. = $dateType]/@key"/>
          <xsl:if test="string($dcatElementName)">
            <xsl:call-template name="rdf-date">
              <xsl:with-param name="nodeName" select="$dcatElementName"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>

      <xsl:copy-of select="$modifiedDates/*[1]"/>
    </xsl:if>

    <!--<xsl:choose>
      <xsl:when test="string($dcatElementName)">
        <xsl:call-template name="rdf-date">
          <xsl:with-param name="nodeName" select="$dcatElementName"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>WARNING: Unmatched date type <xsl:value-of select="$dateType"/>. If needed, add this type in dcat-variables.xsl and add the element to map to in isoDateTypeToDcatCommonNames.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>-->
  </xsl:template>

</xsl:stylesheet>
