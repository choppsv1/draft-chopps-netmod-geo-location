ORG := geo-location.org
BASE := $(shell sed -e '/^\#+RFC_NAME:/!d;s/\#+RFC_NAME: *\(.*\)/\1/' $(ORG))
VERSION := $(shell sed -e '/^\#+RFC_VERSION:/!d;s/\#+RFC_VERSION: *\([0-9]*\)/\1/' $(ORG))
VBASE := $(BASE)-$(VERSION)

all: $(BASE).xml $(VBASE).txt $(VBASE).html $(VBASE).pdf

clean:
	rm ${BASE}-*.{xml,txt,html,pdf}

ox-rfc.el:
	curl -fLO 'https://raw.githubusercontent.com/choppsv1/org-rfc-export/master/ox-rfc.el'

$(BASE).xml: $(ORG) ox-rfc.el
	emacs -Q --batch --eval '(setq org-confirm-babel-evaluate nil)' -l ./ox-rfc.el $< -f ox-rfc-export-to-xml

%-$(VERSION).txt: %.xml
	xml2rfc --text -o $@ $<

%-$(VERSION).html: %.xml
	xml2rfc --html -o $@ $<

%-$(VERSION).pdf: %.xml
	xml2rfc --pdf -o $@ $<

# NRL-NMF
# google maps api
# http://www.orekit.org/ - orekit
# https://w3c.github.io/geolocation-api/
