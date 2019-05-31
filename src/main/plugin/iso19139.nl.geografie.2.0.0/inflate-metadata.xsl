<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" >

  <xsl:template match="/root">
    <xsl:apply-templates select="gmd:MD_Metadata"/>
  </xsl:template>

  <!-- Inflate organisation name and role if required -->
  <xsl:template match="gmd:CI_ResponsibleParty">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:individualName" />

      <xsl:apply-templates select="gmd:organisationName" />

      <xsl:if test="not(gmd:organisationName)">
        <gmd:organisationName gco:nilReason='missing'>
          <gco:CharacterString></gco:CharacterString>
        </gmd:organisationName>
      </xsl:if>

      <xsl:apply-templates select="gmd:positionName" />
      <xsl:apply-templates select="gmd:contactInfo" />
      <xsl:if test="not(gmd:contactInfo)">
        <gmd:contactInfo>
          <gmd:CI_Contact>
            <gmd:address>
              <gmd:CI_Address>
                <gmd:electronicMailAddress gco:nilReason='missing'>
                  <gco:CharacterString></gco:CharacterString>
                </gmd:electronicMailAddress>
              </gmd:CI_Address>
            </gmd:address>
          </gmd:CI_Contact>
        </gmd:contactInfo>
      </xsl:if>

      <xsl:apply-templates select="gmd:role" />

      <xsl:if test="not(gmd:role)">
        <gmd:role>
          <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                           codeListValue=""/>
        </gmd:role>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:contactInfo/gmd:CI_Contact">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:phone" />
      <xsl:apply-templates select="gmd:address" />

      <xsl:if test="not(gmd:address)">
        <gmd:address>
          <gmd:CI_Address>
            <gmd:electronicMailAddress gco:nilReason='missing'>
              <gco:CharacterString></gco:CharacterString>
            </gmd:electronicMailAddress>
          </gmd:CI_Address>
        </gmd:address>
      </xsl:if>

      <xsl:apply-templates select="gmd:onlineResource" />
      <xsl:apply-templates select="gmd:hoursOfService" />
      <xsl:apply-templates select="gmd:contactInstructions" />
    </xsl:copy>
  </xsl:template>

  <!-- Inflate electronic mail address if required -->
  <xsl:template match="gmd:address">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:for-each select="gmd:CI_Address">
        <xsl:copy>
          <xsl:copy-of select="@*" />

          <xsl:apply-templates select="gmd:deliveryPoint" />
          <xsl:apply-templates select="gmd:city" />
          <xsl:apply-templates select="gmd:administrativeArea" />
          <xsl:apply-templates select="gmd:postalCode" />
          <xsl:apply-templates select="gmd:country" />
          <xsl:apply-templates select="gmd:electronicMailAddress" />

          <xsl:if test="not(gmd:electronicMailAddress)">
            <gmd:electronicMailAddress gco:nilReason='missing'>
              <gco:CharacterString></gco:CharacterString>
            </gmd:electronicMailAddress>
          </xsl:if>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


  <!-- ================================================================= -->
  <!-- copy everything else as is -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
