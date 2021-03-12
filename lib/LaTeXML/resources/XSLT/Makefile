SHELL=bash

OUTPUTS=$(patsubst orig-%,%,$(wildcard orig-*.xsl))

all: $(OUTPUTS)

diff: $(addsuffix .diff,$(OUTPUTS))

LaTeXML-%.xsl: orig-LaTeXML-%.xsl identity.xsl
	xsltproc identity.xsl $< > $@

%.diff:
	-diff -u <(xmllint --c14n orig-$*) <(xmllint --c14n $*)
