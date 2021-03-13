SHELL=bash

OUTPUTS=$(patsubst orig-%,%,$(wildcard orig-*.xsl))

ORIGINS=$(patsubst %,orig-%,$(wildcard LaTeXML-*.xsl))

TRANSFORM=identity.xsl

all: $(OUTPUTS)

diff: $(addsuffix .diff,$(OUTPUTS))

orig: $(ORIGINS)

# xsltproc $(TRANSFORM) $< | perl -p -e 's/&#13;/\n/g; s/&#([0-9]*);/"&#x".sprintf(($$1 > 255) ? "%04X" : "%02X" ,$$1).";"/ge; if (m/^( *)<xsl:(stylesheet|output)/) { my $$indent = $$1; s/(<xsl:(stylesheet|output)|") /$$1\n$$indent  /g; };' > $@

LaTeXML-%.xsl: orig-LaTeXML-%.xsl $(TRANSFORM) normalize.pl Makefile
	./normalize.pl $(TRANSFORM) $< > $@

orig-%.xsl: | %.xsl
	mv $*.xsl orig-$*.xsl

%.diff:
	-diff -u <(xmllint --c14n orig-$*) <(xmllint --c14n $*)
