<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">

  <!-- Return mimetype according to protocol and linkage extension -->
  <xsl:function name="geonet:protocolMimeType_iso19139.nl.geografie.2.0.0" as="xs:string">
    <xsl:param name="linkage" as="xs:string"/>
    <xsl:param name="protocol" as="xs:string?"/>
    <xsl:param name="mimeType" as="xs:string?"/>

    <xsl:choose>
      <xsl:when test="$mimeType != ''"><xsl:value-of select="$mimeType"/></xsl:when>

      <xsl:when test="$protocol!=''">
        <xsl:choose>
          <xsl:when test="$protocol='gml'">application/gml+xml</xsl:when>
          <xsl:when test="$protocol='kml'">application/vnd.google-earth.kml+xml</xsl:when>
          <xsl:when test="$protocol='geojson'">application/geo+json</xsl:when>
          <xsl:when test="$protocol='gpkg'">application/x-sqlite3</xsl:when>
          <xsl:when test="$protocol='json'">application/json</xsl:when>
          <xsl:when test="$protocol='jsonld'">application/ld+json</xsl:when>
          <xsl:when test="$protocol='rdf-xml'">application/rdf+xml</xsl:when>
          <xsl:when test="$protocol='xml'">application/xml</xsl:when>
          <xsl:when test="$protocol='zip'">application/zip</xsl:when>
          <xsl:when test="$protocol='png'">image/png</xsl:when>
          <xsl:when test="$protocol='gif'">image/gif</xsl:when>
          <xsl:when test="$protocol='jp2'">image/jp2</xsl:when>
          <xsl:when test="$protocol='tiff'">image/tiff</xsl:when>
          <xsl:when test="$protocol='csv'">text/csv</xsl:when>
          <xsl:when test="$protocol='mapbox-vector-tile'">application/vnd.mapbox-vector-tile</xsl:when>
          <xsl:when test="starts-with($protocol,'OGC:WMS')">application/vnd.ogc.wms_xml</xsl:when>
          <xsl:when test="$protocol='ESRI:AIMS-'">application/vnd.esri.arcims_axl</xsl:when>
          <xsl:otherwise><xsl:value-of select="$protocol"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$linkage!=''">
        <xsl:choose>
          <xsl:when test="ends-with($linkage, '.gml')">application/gml+xml</xsl:when>
          <xsl:when test="ends-with($linkage, '.kml')">application/vnd.google-earth.kml+xml</xsl:when>
          <xsl:when test="ends-with($linkage, '.geojson')">application/geo+json</xsl:when>
          <xsl:when test="ends-with($linkage, '.gpkg')">application/x-sqlite3</xsl:when>
          <xsl:when test="ends-with($linkage, '.json')">application/json</xsl:when>
          <xsl:when test="ends-with($linkage, '.jsonld')">application/ld+json</xsl:when>
          <xsl:when test="ends-with($linkage, '.rdf')">application/rdf+xml</xsl:when>
          <xsl:when test="ends-with($linkage, '.xml')">application/xml</xsl:when>
          <xsl:when test="ends-with($linkage, '.zip')">application/zip</xsl:when>
          <xsl:when test="ends-with($linkage, '.png')">image/png</xsl:when>
          <xsl:when test="ends-with($linkage, '.gif')">image/gif</xsl:when>
          <xsl:when test="ends-with($linkage, '.jp2')">image/jp2</xsl:when>
          <xsl:when test="ends-with($linkage, '.tiff')">image/tiff</xsl:when>
          <xsl:when test="ends-with($linkage, '.csv')">text/csv</xsl:when>
          <xsl:when test="ends-with($linkage, '.mvt')">application/vnd.mapbox-vector-tile</xsl:when>
          <xsl:when test="$protocol='ESRI:AIMS-'">application/vnd.esri.arcims_axl</xsl:when>
          <!-- fall back to the default content type -->
          <xsl:otherwise>text/plain</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- fall back to the default content type -->
      <xsl:otherwise>text/plain</xsl:otherwise>
    </xsl:choose>



  </xsl:function>
</xsl:stylesheet>
