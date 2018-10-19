<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!--Fazemos um índice de identificadores a partir da listagem elaborada
    após a eleição do corpus. Cada cantiga tem o seu correspondente elemento <bibl>. Exemplo:
    
    <bibl xml:id="A1B91">A1,B91</bibl>
    
    
    -->
    
    <xsl:key name="idByContent" match="bibl" use="tokenize(.,',')"/>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
     <!--Estabelecimento dos identificadores da cantiga a partir da coincidência parcial -->
    
    <xsl:template match="div/@corresp">
        <xsl:choose>
            <xsl:when test="key('idByContent',substring(current(),2))">
                <xsl:attribute name="corresp"
                    select="concat('#',key('idByContent',substring(current(),2))/@xml:id)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="corresp" select="current()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
