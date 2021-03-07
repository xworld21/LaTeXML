TARGETS=$(patsubst old-%.xsl,%.xsl,$(wildcard old-*.xsl))

all: $(TARGETS)

%.xsl: old-%.xsl simplify.xsl
	xsltproc simplify.xsl "$<" > "$@"
