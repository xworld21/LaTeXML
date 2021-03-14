SHELL=bash

OUTPUTS=$(patsubst orig-%,%,$(wildcard orig-*.xsl))

ORIGINS=$(patsubst %,orig-%,$(wildcard LaTeXML-*.xsl))

all: $(OUTPUTS)

diff: $(addsuffix .diff,$(OUTPUTS))

orig: $(ORIGINS)

LaTeXML-%.xsl: orig-LaTeXML-%.xsl xsltlint Makefile
	./xsltlint $< > $@

orig-%.xsl: | %.xsl
	mv $*.xsl orig-$*.xsl

%.diff:
	-diff -u <(xmllint --c14n orig-$*) <(xmllint --c14n $*)
