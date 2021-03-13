<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:func="http://exslt.org/functions"
  xmlns:f="http://dlmf.nist.gov/LaTeXML/functions"
  extension-element-prefixes="func f">

  <!-- force non-ASCII characters to be output as entities
       and produce utf-8 declaration manually -->
  <xsl:output encoding="US-ASCII"
              omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="utf-8"?&gt;&#x0A;</xsl:text>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- copy all nodes over -->
  <xsl:template match="node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- preserve newlines as &#x0A; entities in xsl:text -->
  <xsl:template match="xsl:text">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="text()">
        <xsl:call-template name="newline-to-entity">
          <xsl:with-param name="text" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="newline-to-entity">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text,'&#x0A;')">
        <xsl:value-of select="substring-before($text,'&#x0A;')"/>
        <xsl:text disable-output-escaping="yes">&amp;#x0A;</xsl:text>
        <xsl:call-template name="newline-to-entity">
          <xsl:with-param name="text" select="substring-after($text,'&#x0A;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- detect and preserve newlines in attributes -->
  <!-- technique: detect sequences of multiple spaces and replace the first
       with &#x0D; (carriage return); since XSLT cannot produce newlines inside
       attributes, &#0D; must be converted to newline externally -->
  <xsl:template match="@*">
    <xsl:attribute name="{name()}" namespace="{namespace-uri()}">
      <xsl:call-template name="attribute-with-newlines">
        <xsl:with-param name="text" select="string(.)"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="attribute-with-newlines">
    <xsl:param name="text"/>
    <!-- $mode can be:
          - 'start' after the first character of a sequence of spaces
          - 'continue' after the second character of a sequence of spaces
          - '' at the beginning and after any non-space character -->
    <xsl:param name="mode"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <xsl:choose>
      <xsl:when test="$char=' '">
        <xsl:choose>
          <!-- two consecutive spaces: start a new line -->
          <xsl:when test="$mode='start'">
            <xsl:value-of select="'&#x0D; '" disable-output-escaping="yes"/>
          </xsl:when>
          <!-- within a sequence of spaces: preserve them -->
          <xsl:when test="$mode='continue'"><xsl:text> </xsl:text></xsl:when>
          <!-- first space in a sequence: omit the space for now -->
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- reintroduce the previous space if it was omitted -->
        <xsl:if test="$mode='start'"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="$char"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- continue as long as $text is non-empty -->
    <xsl:if test="$text != ''">
      <xsl:call-template name="attribute-with-newlines">
        <xsl:with-param name="text" select="substring($text,2)"/>
        <xsl:with-param name="mode">
          <xsl:if test="$char=' '">
            <xsl:choose>
              <xsl:when test="$mode != ''">continue</xsl:when>
              <xsl:otherwise>start</xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
