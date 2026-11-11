<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:geonet="http://www.fao.org/geonetwork"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            queryBinding="xslt2">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">Waarschuwingen bij validatie tegen DCAT-AP NL 3</sch:title>

  <sch:ns uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
  <sch:ns uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
  <sch:ns uri="http://www.isotc211.org/2005/gmx" prefix="gmx"/>
  <sch:ns uri="http://www.opengis.net/gml" prefix="gml"/>
  <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
  <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
  <sch:ns uri="http://www.w3.org/2004/02/skos/core#" prefix="skos"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <sch:ns prefix="xslutil" uri="java:org.fao.geonet.schema.iso19139nl.util.XslUtil" />

  <sch:let name="lowercase" value="'abcdefghijklmnopqrstuvwxyz'"/>
  <sch:let name="uppercase" value="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>


  <sch:pattern>
    <sch:title>Waarschuwingen bij validatie tegen DCAT-AP NL 3 het DCAT-AP NL 3.0 metadata profiel</sch:title>

    <sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">

      <!-- Dataset language -->
      <sch:assert test="gmd:language">De taal van de dataset wordt aanbevolen</sch:assert>

      <!-- Dataset status present -->
      <sch:assert test="string(gmd:status/*/@codeListValue)">Status van de dataset aanbevolen</sch:assert>

      <!-- Dataset spatial -->
      <sch:assert test="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox[gmd:westBoundLongitude/gco:Decimal != '' and gmd:eastBoundLongitude/gco:Decimal != '' and gmd:southBoundLatitude/gco:Decimal != '' and gmd:northBoundLatitude/gco:Decimal != '']">Het geografische gebied waarop de gegevens in de dataset betrekking hebben, wordt aanbevolen</sch:assert>

      <!-- Dataset temporal coverage -->
      <sch:assert test="gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent//*[gml:beginPosition != '' or gml:endPosition != '']">De periode waarop de dataset betrekking heeft wordt aanbevolen</sch:assert>

      <!-- Keywords -->
      <sch:assert test="gmd:descriptiveKeywords/*/gmd:keyword[gmx:Anchor/@xlink:href != '' or gco:CharacterString != '']">Trefwoorden voor datasets worden aanbevolen</sch:assert>
    </sch:rule>

    <!-- Responsible organisation online resource URL.
         DCAT-AP NL 3.0 does not require this URL, so a value that is not a full URL is a
         recommendation and not an error. It is used as the URI of the organisation in the
         DCAT-AP NL output, so a value without http:// or https:// cannot identify it. -->
    <sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/*/gmd:pointOfContact[1]/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage">
      <sch:let name="url" value="normalize-space(gmd:URL)"/>

      <sch:let name="isFullUrl" value="($url = '') or starts-with(lower-case($url), 'http://') or starts-with(lower-case($url), 'https://')"/>

      <sch:assert test="$isFullUrl = true()">Voor de URL van de verantwoordelijke organisatie wordt een volledige URL aanbevolen die begint met https:// (of http://). Huidige waarde: <sch:value-of select="$url"/></sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
