<?xml version="1.0" encoding="utf-8"?>
<!--
/=====================================================================\ 
|  LaTeXML-epub3.xsl                                                  |
|  Stylesheet for converting LaTeXML documents to ePub3               |
|=====================================================================|
| Part of LaTeXML:                                                    |
|  Public domain software, produced as part of work done by the       |
|  United States Government & not subject to copyright in the US.     |
|=====================================================================|
| Bruce Miller <bruce.miller@nist.gov>                        #_#     |
| http://dlmf.nist.gov/LaTeXML/                              (o o)    |
\=========================================================ooo==U==ooo=/
-->
<xsl:stylesheet
    version   = "1.0"
    xmlns     = "http://www.w3.org/1999/xhtml"
    xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
    xmlns:ltx = "http://dlmf.nist.gov/LaTeXML"
    exclude-result-prefixes="ltx">

  <!-- Include all LaTeXML to xhtml modules -->
  <xsl:import href="LaTeXML-all-xhtml.xsl"/>

  <!-- Override the output method & parameters -->
  <xsl:output
      method = "xml"
      encoding       = 'utf-8'
      media-type     = 'application/xhtml+xml'/>

  <!-- No namespaces; DO use HTML5 elements (include MathML & SVG) -->
  <xsl:param name="USE_NAMESPACES"  >true</xsl:param>
  <xsl:param name="USE_HTML5"       >true</xsl:param>

  <!-- Do not copy the RDFa prefix, but proceed as usual -->
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="doctype"/>
    <html>
      <xsl:apply-templates select="." mode="begin"/>
      <xsl:apply-templates select="." mode="head"/>
      <xsl:apply-templates select="." mode="body"/>
      <xsl:apply-templates select="." mode="end"/>
      <xsl:text>&#x0A;</xsl:text>
    </html>
  </xsl:template>

  <!-- RDFa is invalid in EPUB3, so just skip over it -->
  <xsl:template match="ltx:rdf">
  </xsl:template>

  <!-- Linking to a text/plain data URL is invalid in EPUB3,
       so just skip over it -->
  <xsl:template match="ltx:listing[@data]" mode="begin"/>

  <!-- strip prefixes -->
  <xsl:template match="/">
    <xsl:call-template name="alter">
      <xsl:with-param name="fragment">
        <xsl:apply-imports/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*" mode="alter">
    <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()" mode="alter"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
