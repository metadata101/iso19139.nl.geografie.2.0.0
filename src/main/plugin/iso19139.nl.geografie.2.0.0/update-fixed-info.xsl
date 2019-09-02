<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                version="2.0" exclude-result-prefixes="#all">
  <xsl:import href="../iso19139/update-fixed-info.xsl"/>

  <!-- Add codelist labels -->
  <xsl:template match="gmd:LanguageCode[@codeListValue]" priority="220">


    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
      <xsl:apply-templates select="@*[name(.)!='codeList']"/>

      <xsl:value-of select="java:getIsoLanguageLabel(@codeListValue, $mainLanguage)" />
    </gmd:LanguageCode>
  </xsl:template>


  <xsl:template match="gmd:*[@codeListValue]"  priority="200">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="codeList">
        <xsl:value-of
          select="concat('http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#',local-name(.))"/>
      </xsl:attribute>

      <xsl:if test="string(@codeListValue)">
      <xsl:value-of select="java:getCodelistTranslation(name(), string(@codeListValue), string($mainLanguage))"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <!-- Dutch profile uses gco:Date instead of gco:DateTime -->
  <xsl:template match="gmd:dateStamp" priority="99">
    <xsl:choose>
      <xsl:when test="/root/env/changeDate">
        <xsl:copy>
          <gco:Date>
            <xsl:value-of select="tokenize(/root/env/changeDate,'T')[1]" />
          </gco:Date>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="gmd:DQ_DataQuality">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:scope" />

      <!-- Sort reports by child content, required in metadata editor to render the reports in table format -->
      <xsl:for-each select="gmd:report">
        <xsl:sort select="*[1]/name()"/>
        <xsl:apply-templates select="." />
      </xsl:for-each>

      <xsl:apply-templates select="gmd:lineage" />
    </xsl:copy>

  </xsl:template>


  <!-- Online resources description: accessPoint, endPoint -->
  <xsl:template match="gmd:onLine/gmd:CI_OnlineResource" priority="200">

    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:variable name="protocol" select="gmd:protocol/*/text()" />

      <xsl:choose>
        <!-- Add request=GetCapabilities if missing -->
        <xsl:when test="geonet:contains-any-of($protocol, ('OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS'))">
          <xsl:variable name="url" select="gmd:linkage/gmd:URL" />
          <xsl:variable name="paramRequest" select="'request=GetCapabilities'" />

          <xsl:choose>
            <xsl:when test="not(contains(lower-case($url), lower-case($paramRequest)))">
              <xsl:choose>
                <xsl:when test="ends-with($url, '?')">
                  <gmd:linkage>
                    <gmd:URL><xsl:value-of select="concat($url, $paramRequest)" /></gmd:URL>
                  </gmd:linkage>
                </xsl:when>
                <xsl:when test="contains($url, '?')">
                  <gmd:linkage>
                    <gmd:URL><xsl:value-of select="concat($url, '&amp;', $paramRequest)" /></gmd:URL>
                  </gmd:linkage>
                </xsl:when>
                <xsl:otherwise>
                  <gmd:linkage>
                    <gmd:URL><xsl:value-of select="concat($url, '?', $paramRequest)" /></gmd:URL>
                  </gmd:linkage>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="gmd:linkage" />
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:linkage" />
        </xsl:otherwise>
      </xsl:choose>


      <xsl:apply-templates select="gmd:protocol" />
      <xsl:apply-templates select="gmd:applicationProfile" />
      <xsl:apply-templates select="gmd:name" />

      <!-- gmd:description -->
      <xsl:choose>
        <xsl:when test="gmd:description/*/text() = 'accessPoint'">
          <gmd:description>
            <gmx:Anchor
              xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/accessPoint">
              accessPoint</gmx:Anchor>
          </gmd:description>
        </xsl:when>

        <xsl:when test="gmd:description/*/text() = 'endPoint'">
          <gmd:description>
            <gmx:Anchor
              xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/endPoint">
              endPoint</gmx:Anchor>
          </gmd:description>
        </xsl:when>

        <!-- Empty: check the protocol -->
        <xsl:when test="not(string(gmd:description/*/text()))">
          <xsl:choose>
            <!-- Access points -->
            <xsl:when test="geonet:contains-any-of($protocol, ('OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'INSPIRE Atom',
          'landingpage', 'application', 'dataset', 'OGC:WPS', 'OGC:SOS',
          'OGC:SensorThings', 'OAS', 'W3C:SPARQL', 'OASIS:OData', 'OGC:CSW',
          'OGC:WCTS', 'OGC:WFS-G', 'OGC:SPS', 'OGC:SAS', 'OGC:WNS', 'OGC:ODS', 'OGC:OGS', 'OGC:OUS', 'OGC:OPS', 'OGC:ORS', 'UKST'))">

              <gmd:description>
                <gmx:Anchor
                  xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/accessPoint">
                  accessPoint</gmx:Anchor>
              </gmd:description>
            </xsl:when>

            <!-- End points -->
            <xsl:when test="geonet:contains-any-of($protocol, ('gml', 'geojson', 'gpkg', 'tiff', 'kml', 'csv', 'zip',
          'wmc', 'json', 'jsonld', 'rdf-xml', 'xml', 'png', 'gif', 'jp2', 'mapbox-vector-tile', 'UKMT'))">
              <gmd:description>
                <gmx:Anchor
                  xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/endPoint">
                  endPoint</gmx:Anchor>
              </gmd:description>
            </xsl:when>

            <!-- Other cases: copy current gmd:description element -->
            <xsl:otherwise>
              <xsl:apply-templates select="gmd:description" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <!-- Other cases: copy current gmd:description element -->
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:description" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="gmd:function" />
    </xsl:copy>
  </xsl:template>

  <!-- Search for any of the searchStrings provided -->
  <xsl:function name="geonet:contains-any-of" as="xs:boolean">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:param name="searchStrings" as="xs:string*"/>

    <xsl:sequence
      select="
      some $searchString in $searchStrings
      satisfies contains($arg,$searchString)
      "
    />
  </xsl:function>

  <xsl:function name="geonet:ends-with-any-of" as="xs:boolean">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:param name="searchStrings" as="xs:string*"/>

    <xsl:sequence
      select="
      some $searchString in $searchStrings
      satisfies ends-with($arg,$searchString)
      "
    />
  </xsl:function>

  <!-- remove gmd:identifier with gmx:Anchor inside gmd:code
    <xsl:template match="gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->
  <!-- remove gmd:identifier in gmd:thesaurusName with gmx:Anchor inside gmd:code -->
  <!--<xsl:template match="gmd:thesaurusName/*/gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->

  <!-- remove http://www.fao.org/geonetwork namespace
  <xsl:template match="*">
      <xsl:element name="{name()}">
          <xsl:copy-of select="namespace::*[not(. = 'http://www.fao.org/geonetwork')]"/>
          <xsl:apply-templates select="node()|@*"/>
      </xsl:element>
  </xsl:template>

  <xsl:template match="*[@xmlns:gn='http://www.fao.org/geonetwork']/@xmlns:gn|@xmlns:geonet='http://www.fao.org/geonetwork']/@xmlns:geonet" /> -->


  <xsl:template match="gmd:MD_DataIdentification" priority="200">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:citation" />
      <xsl:apply-templates select="gmd:abstract" />
      <xsl:apply-templates select="gmd:purpose" />
      <xsl:apply-templates select="gmd:credit" />
      <xsl:apply-templates select="gmd:status" />
      <xsl:apply-templates select="gmd:pointOfContact" />
      <xsl:apply-templates select="gmd:resourceMaintenance" />
      <xsl:apply-templates select="gmd:graphicOverview" />
      <xsl:apply-templates select="gmd:resourceFormat" />
      <xsl:apply-templates select="gmd:descriptiveKeywords" />
      <xsl:apply-templates select="gmd:resourceSpecificUsage" />

      <!-- Order resource constraints. Related schematron validations depends on the order of the constraints
          - gmd:MD_Constraints
          - gmd:MD_LegalConstraints
          - gmd:MD_SecurityConstraints
      -->
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_Constraints]" />
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_LegalConstraints]" />
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_SecurityConstraints]" />

      <xsl:apply-templates select="gmd:aggregationInfo" />
      <xsl:apply-templates select="gmd:spatialRepresentationType" />
      <xsl:apply-templates select="gmd:spatialResolution" />
      <xsl:apply-templates select="gmd:language" />
      <xsl:apply-templates select="gmd:characterSet" />
      <xsl:apply-templates select="gmd:topicCategory" />
      <xsl:apply-templates select="gmd:environmentDescription" />
      <xsl:apply-templates select="gmd:extent" />
      <xsl:apply-templates select="gmd:supplementalInformation" />
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
