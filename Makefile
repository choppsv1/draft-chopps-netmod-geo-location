#
# pip install idnits pyang xml2rfc
# install oxtradoc (e.g., libstax pkg)
#
DRAFT := geo-location.org
OUTPUT_BASE := draft-chopps-netmod-geo-location

VERSION := $(shell sed -e '/^\#+RFC_VERSION:/!d;s/\#+RFC_VERSION: *\([0-9]*\)/\1/' $(DRAFT))
OUTPUT_BASE := ${OUTPUT_BASE}-${VERSION}

all: ${OUTPUT_BASE}.xml ${OUTPUT_BASE}.txt ${OUTPUT_BASE}.html ${OUTPUT_BASE}.pdf

clean:
	rm ${OUTPUT_BASE}.xml ${OUTPUT_BASE}.txt ${OUTPUT_BASE}.html ${OUTPUT_BASE}.pdf

%.xml: $(DRAFT)
	emacs --batch --eval '(setq org-confirm-babel-evaluate nil)' --load ~/.spacemacs.d/local-lisp/ob-yang.el --load ~/p/org-rfc-export/ox-rfc.el $< -f org-rfc-export-to-xml

%.txt: %.xml
	xml2rfc --text -o $@ $<

%.html: %.xml
	xml2rfc --html -o $@ $<

%.pdf: %.xml
	xml2rfc --pdf -o $@ $<
