<?xml version="1.0" encoding="utf-8"?>
<!--
/=====================================================================\ 
|  LaTeXML-html5.xsl                                                  |
|  Stylesheet for converting LaTeXML documents to html5               |
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
    xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
    xmlns:ltx = "http://dlmf.nist.gov/LaTeXML"
    exclude-result-prefixes="ltx">

  <!-- Include all LaTeXML to xhtml modules -->
  <xsl:import href="LaTeXML-all-xhtml.xsl"/>

  <!-- Override the output method & parameters -->
  <xsl:output
      method = "html"
      omit-xml-declaration="yes"
      encoding       = 'utf-8'
      media-type     = 'text/html'/>

  <!-- No namespaces; DO use HTML5 elements (include MathML & SVG) -->
  <xsl:param name="USE_NAMESPACES"  ></xsl:param>
  <xsl:param name="USE_HTML5"       >true</xsl:param>

  <!-- Mobile-friendly default viewport setting. -->
  <xsl:param name="META_VIEWPORT">width=device-width, initial-scale=1, shrink-to-fit=no</xsl:param>

  <xsl:template match="/" mode="doctype">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
  </xsl:template>

  <xsl:template match="/" mode="head-content-type">
    <xsl:text>&#x0A;</xsl:text>
    <meta charset="UTF-8"/>
  </xsl:template>

  <!-- strip namespace and prefixes -->
  <xsl:template match="/">
    <xsl:call-template name="alter">
      <xsl:with-param name="fragment">
        <xsl:apply-imports/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*" mode="alter">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()" mode="alter"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
