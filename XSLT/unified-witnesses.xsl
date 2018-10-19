<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <!--Cria-se uma variável por cada um dos testemunhos que contem
    as transcrições destes-->
    
    <xsl:variable name="A"
        select="//div[@wit = '#A']"/>
    <xsl:variable name="B"
        select="//div[@wit = '#B']"/>
    <xsl:variable name="V"
        select="//div[@wit = '#V']"/>
    
    <xsl:template match="/">
        <xsl:result-document href="corpus-em-paralelo.xml">
            
        <!-- Aplicarão-se regras de transformação apenas a aquelas transcrições
        que estiverem presentes nos três testemunhos -->
            
            <xsl:element name="tei">
                <xsl:apply-templates select="//$A[@corresp = $B/@corresp]
                    [@corresp = $V/@corresp]"/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    
        <!--Cria-se um contentor <div> por cada cantiga -->
    
    <xsl:template match="div">
        <xsl:element name="div">
            <xsl:attribute name="type">poem</xsl:attribute>
            <xsl:attribute name="corresp" select="current()/@corresp"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
        <!-- Cria-se um elemento <l> por cada verso com
        a numeração correspondente -->
    
    <xsl:template match="l">
        <xsl:element name="l">
            <xsl:attribute name="n" select="count(preceding-sibling::l) + 1"/>
            
        <!--  Abre-se o aparato de variantes, criando um elemento <rdg> por cada 
        testemunho -->
            
            <xsl:element name="app">
                <xsl:element name="rdg">
                    <xsl:attribute name="wit">#A</xsl:attribute>
                    <xsl:copy-of select="current()/node()"/>
                </xsl:element>
                
         <!-- Para calcular qual é a lição correspondente, utiliza-se como
         referente o número de verso -->
                
                <xsl:element name="rdg">
                    <xsl:attribute name="wit">#B</xsl:attribute>
                    <xsl:sequence
                        select="$B[@corresp = current()/parent::*/@corresp]
                        /l[position() eq count(current()/preceding-sibling::l) + 1]/node()"
                    />
                </xsl:element>
                <xsl:if test="$V[@corresp = current()/parent::*/@corresp]">
                    <xsl:element name="rdg">
                        <xsl:attribute name="wit">#V</xsl:attribute>
                        <xsl:sequence
                            select="$V[@corresp = current()/parent::*/@corresp]
                            /l[position() eq count(current()/preceding-sibling::l) + 1]/node()"
                        />
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
