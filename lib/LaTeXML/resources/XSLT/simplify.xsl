<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version     = "1.0"
  xmlns:xsl   = "http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl  = "http://exslt.org/common"
  xmlns:f     = "http://dlmf.nist.gov/LaTeXML/functions"
  xmlns:func  = "http://exslt.org/functions"
  xmlns:str   = "http://exslt.org/strings"
  extension-element-prefixes = "exsl f func str">

  <xsl:import href="str.replace.function.xsl"/>

  <xsl:output
    encoding="utf-8"
    indent="yes"/>

  <func:function name="f:nsprefix">
    <xsl:param name="ns"/>
    <xsl:choose>
      <xsl:when test="$ns='{$html_ns}'"><func:result/></xsl:when>
      <xsl:when test="$ns='{$svg_ns}'"><func:result>svg:</func:result></xsl:when>
      <xsl:when test="$ns='{$mml_ns}'"><func:result>m:</func:result></xsl:when>
    </xsl:choose>
  </func:function>

  <func:function name="f:nsurl">
    <xsl:param name="ns"/>
    <xsl:choose>
      <xsl:when test="$ns='{$html_ns}'"><func:result>http://www.w3.org/1999/xhtml</func:result></xsl:when>
      <xsl:when test="$ns='{$svg_ns}'"><func:result>http://www.w3.org/2000/svg</func:result></xsl:when>
      <xsl:when test="$ns='{$mml_ns}'"><func:result>http://www.w3.org/1998/Math/MathML</func:result></xsl:when>
    </xsl:choose>
  </func:function>

  <xsl:template name="add_ns_decl">
    <xsl:param name="ns"/>
    <xsl:variable name="dummy">
      <xsl:element name="{concat(f:nsprefix($ns),'dummy')}" namespace="{f:nsurl($ns)}"/>
    </xsl:variable>
    <xsl:if test="//xsl:element[@namespace=$ns]">
      <xsl:copy-of select="exsl:node-set($dummy)/*/namespace::*"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:stylesheet">
    <xsl:element name="xsl:stylesheet">
      <xsl:call-template name="add_ns_decl">
        <xsl:with-param name="ns">{$html_ns}</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="add_ns_decl">
        <xsl:with-param name="ns">{$svg_ns}</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="add_ns_decl">
        <xsl:with-param name="ns">{$mml_ns}</xsl:with-param>
      </xsl:call-template>
      <xsl:copy-of select="namespace::*"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:element[not(starts-with(@name,'{'))]">
    <xsl:element name="{concat(f:nsprefix(@namespace),@name)}" namespace="{f:nsurl(@namespace)}">
      <xsl:apply-templates select="xsl:attribute[not(starts-with(@name,'{'))]" mode="inline"/>
      <xsl:apply-templates select="xsl:attribute[starts-with(@name,'{')]"/>
      <xsl:apply-templates select="node()[name() != 'xsl:attribute']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:element[starts-with(@name,&quot;{f:if(&#36;USE_HTML5,'&quot;)]">
    <xsl:variable name="name" select="substring-before(substring-after(@name,&quot;{f:if(&#36;USE_HTML5,'&quot;),&quot;'&quot;)"/>
    <xsl:element name="{concat(f:nsprefix(@namespace),$name)}" namespace="{f:nsurl(@namespace)}">
      <xsl:apply-templates select="xsl:attribute[not(starts-with(@name,'{'))]" mode="inline"/>
      <xsl:apply-templates select="xsl:attribute[starts-with(@name,'{')]"/>
      <xsl:apply-templates select="node()[name() != 'xsl:attribute']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()" mode="inline"/>

  <xsl:template match="xsl:attribute" mode="inline">
    <xsl:attribute name="{@name}" namespace="{@namespace}">
      <xsl:choose>
        <xsl:when test="xsl:value-of">
          <xsl:for-each select="text()|xsl:text|xsl:value-of">
            <xsl:choose>
              <xsl:when test="self::text()">
                <xsl:choose>
                  <xsl:when test="normalize-space(.)">
                    <xsl:value-of select="."/>
                  </xsl:when>
                  <xsl:when test=".">
                    <xsl:text> </xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="self::xsl:text">
                <xsl:value-of select="text()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('{',@select,'}')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="xsl:text">
    <xsl:copy>
      <xsl:value-of select="str:replace(text(),'&#x0A;','&amp;#x0A;')" disable-output-escaping="yes"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
