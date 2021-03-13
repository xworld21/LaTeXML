SHELL=bash

OUTPUTS=$(patsubst orig-%,%,$(wildcard orig-*.xsl))

ORIGINS=$(patsubst %,orig-%,$(wildcard LaTeXML-*.xsl))

TRANSFORM=identity.xsl

all: $(OUTPUTS)

diff: $(addsuffix .diff,$(OUTPUTS))

orig: $(ORIGINS)

LaTeXML-%.xsl: orig-LaTeXML-%.xsl $(TRANSFORM) Makefile
	xsltproc $(TRANSFORM) $< | perl -p -e 's/&#13;/\n/g; s/&#([0-9]*);/"&#x".sprintf("%04X",$$1).";"/ge' > $@

orig-%.xsl: | %.xsl
	mv $*.xsl orig-$*.xsl

%.diff:
	-diff -u <(xmllint --c14n orig-$*) <(xmllint --c14n $*)
