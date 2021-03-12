<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:func="http://exslt.org/functions" xmlns:f="http://dlmf.nist.gov/LaTeXML/functions" extension-element-prefixes="func f">

  <xsl:output encoding="US-ASCII"/>

  <xsl:template match="@*|node()|/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:text">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="text()">
        <xsl:call-template name="entity-newline">
          <xsl:with-param name="text" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="entity-newline">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text,'&#x0A;')">
        <xsl:value-of select="substring-before($text,'&#x0A;')"/>
        <xsl:text disable-output-escaping="yes">&amp;#x0A;</xsl:text>
        <xsl:call-template name="entity-newline">
          <xsl:with-param name="text" select="substring-after($text,'&#x0A;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
