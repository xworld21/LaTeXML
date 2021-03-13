<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:func="http://exslt.org/functions" xmlns:f="http://dlmf.nist.gov/LaTeXML/functions" extension-element-prefixes="func f">

  <xsl:output encoding="US-ASCII" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="utf-8"?&gt;&#x0A;</xsl:text>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- preserve entity &#x0A; in xsl:text -->
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

  <!-- preserve literal newlines and entity &#x0A; in attributes -->
  <xsl:template match="@*">
    <xsl:attribute name="{name()}" namespace="{namespace-uri()}">
      <xsl:call-template name="attribute-with-newlines">
        <xsl:with-param name="text" select="string(.)"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="attribute-with-newlines">
    <xsl:param name="text"/>
    <xsl:param name="mode"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <xsl:variable name="tail" select="substring($text,2)"/>
    <xsl:choose>
      <xsl:when test="$char=' '">
        <xsl:choose>
          <xsl:when test="$mode='space'">
            <xsl:value-of select="'&#x0D; '" disable-output-escaping="yes"/>
          </xsl:when>
          <xsl:when test="$mode='newline'">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$mode='space'">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$char='&#x0A;'">
            <xsl:text disable-output-escaping="yes">&amp;#x0A;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$char"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$tail != ''">
      <xsl:call-template name="attribute-with-newlines">
        <xsl:with-param name="text" select="$tail"/>
        <xsl:with-param name="mode">
          <xsl:choose>
            <xsl:when test="$char=' ' and $mode='space'">newline</xsl:when>
            <xsl:when test="$char=' ' and $mode='newline'">newline</xsl:when>
            <xsl:when test="$char=' '">space</xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
