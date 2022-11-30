<?xml version="1.0" encoding="UTF-8" ?>
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
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:daobs="http://daobs.org"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="../../iso19139/index-fields/index.xsl" />


  <xsl:template match="*" mode="index-extra-fields">
    <!--<xsl:message>Index extra fields</xsl:message>-->

    <xsl:variable name="licenseMap">
      <!-- valid licenses from Codelist INSPIRE LimitationsOnPublicAccess -->
      <!-- https://docs.geostandaarden.nl/md/mdprofiel-iso19119/#Codelijst-INSPIRE-LimitationsOnPublicAccess -->
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1a">INSPIRE_Directive_Article13_1a</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1b">INSPIRE_Directive_Article13_1b</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1c">INSPIRE_Directive_Article13_1c</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1d">INSPIRE_Directive_Article13_1d</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1e">INSPIRE_Directive_Article13_1e</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1f">INSPIRE_Directive_Article13_1f</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1g">INSPIRE_Directive_Article13_1g</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1h">INSPIRE_Directive_Article13_1h</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">noLimitations</license>

      <!-- INSPIRE codelist Conditions Applying To Access and Use -->
      <license value="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/noConditionsApply">noConditionsApply</license>
      <license value="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/conditionsUnknown">conditionsUnknown</license>

      <!-- http://creativecommons.org -->
      <license value="http://creativecommons.org/publicdomain/mark/">Public Domain</license>
      <license value="http://creativecommons.org/publicdomain/zero/">CC0</license>
      <license value="http://creativecommons.org/licenses/by/">CC BY</license>
      <license value="http://creativecommons.org/licenses/by-sa/">CC BY-SA</license>
      <license value="http://creativecommons.org/licenses/by-nc/">CC BY-NC</license>
      <license value="http://creativecommons.org/licenses/by-nc-sa/">CC BY-NC-SA</license>
      <license value="http://creativecommons.org/licenses/by-nd/">CC BY-ND</license>
      <license value="http://creativecommons.org/licenses/by-nc-nd/">CC BY-NC-ND</license>
    </xsl:variable>

    <xsl:for-each select="gmd:identificationInfo[1]/*[1]">
      <xsl:for-each select="gmd:resourceConstraints">
        <xsl:for-each select="*/gmd:otherConstraints">

          <xsl:variable name="otherConstrCS" select="gco:CharacterString"/>
          <xsl:variable name="otherConstrAnchor" select="./gmx:Anchor"/>

          <!-- Index a list of license information values usually stored
                    in gmd:otherConstraints. If no constraint of that type found
                    the item is dropped. -->
          <xsl:choose>
            <xsl:when test="$licenseMap/license[starts-with($otherConstrAnchor/@xlink:href, @value)]">
              <license><xsl:value-of select="$licenseMap/license[starts-with($otherConstrAnchor/@xlink:href, @value)]" /></license>
            </xsl:when>

            <xsl:when test="$licenseMap/license[starts-with($otherConstrCS, @value)]">
              <license><xsl:value-of select="$licenseMap/license[starts-with($otherConstrCS/@xlink:href, @value)]" /></license>
            </xsl:when>

            <xsl:when test="$otherConstrCS='Public Domain'
							or .='Open Database License (ODbL)'">
              <license><xsl:value-of select="$otherConstrCS" /></license>
            </xsl:when>

            <xsl:when test="contains(lower-case($otherConstrCS),'cc0')">
              <license>CC0</license>
            </xsl:when>

            <!-- This allow to index a gmx:Anchor with `geo gedeeld licentie` value and a random URL in xlink:href as a-->
            <xsl:when test="contains(lower-case($otherConstrCS),'geo gedeeld licentie') or contains(lower-case($otherConstrAnchor), 'geo gedeeld licentie')">
              <license>Geo Gedeeld licentie</license>
            </xsl:when>


            <xsl:when test="$otherConstrCS and normalize-space(lower-case($otherConstrCS))='geen beperkingen'">
              <!-- In case of a public domain or CC0 license please take
                            not into account the otherConstraint element containing
                            geen beperking.
                        -->
            </xsl:when>
            <xsl:otherwise>
              <!-- 14-11 JB: OtherConstraints no longer needed -->
              <!--Field name="license" string="OtherConstraints" store="true" index="true"/-->
            </xsl:otherwise>
          </xsl:choose>

        </xsl:for-each>
      </xsl:for-each>

    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
