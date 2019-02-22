ORG := geo-location.org
BASE := $(shell sed -e '/^\#+RFC_NAME:/!d;s/\#+RFC_NAME: *\(.*\)/\1/' $(ORG))
VERSION := $(shell sed -e '/^\#+RFC_VERSION:/!d;s/\#+RFC_VERSION: *\([0-9]*\)/\1/' $(ORG))
ifeq ($(BASE),"")
	BASE := $(basename $(ORG))
endif
OUTPUT_BASE := ${BASE}-${VERSION}

all: $(OUTPUT_BASE).xml $(OUTPUT_BASE).txt $(OUTPUT_BASE).html $(OUTPUT_BASE).pdf

clean:
	rm ${BASE}-*.{xml,txt,html,pdf}

ox-rfc.el:
	curl -fLO 'https://raw.githubusercontent.com/choppsv1/org-rfc-export/master/ox-rfc.el'

$(OUTPUT_BASE).xml: $(ORG) ox-rfc.el
	emacs -Q --batch --eval '(setq org-confirm-babel-evaluate nil)' -l ./ox-rfc.el $< -f ox-rfc-export-to-xml

%.txt: %.xml
	xml2rfc --text -o $@ $<

%.html: %.xml
	xml2rfc --html -o $@ $<

%.pdf: %.xml
	xml2rfc --pdf -o $@ $<
