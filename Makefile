# Makefile to build thesis
# Rich Wareham (rjw57)

# Variables we can alter
SUBDIRS:=global introduction libcga visualisation noneuclid \
	 fractals exponential interpolation gpu conclusions
EVERYTHING=$(wildcard *)

#### Default target ####
.PHONY: all documents fixmes
all: documents fixmes
	
#### Common operations and variables ####
include Makefile.common
	
#### Variables generated from above ####

PDFS=$(TEXFILES:.tex=.pdf)
PSS=$(TEXFILES:.tex=.ps)
STEMS=$(TEXFILES:.tex=)

documents: $(PDFS) $(PSS)
	
#### Variables required by build system in subdirs ####
PROJECTROOT:=$(shell pwd)
SVG2PDF:=$(PROJECTROOT)/svg2pdf

export PROJECTROOT SVG2PDF

#### Main targets ####
	
.PHONY: clean 
.PHONY: environment clean-environment
.PHONY: subdirs $(SUBDIRS)

# Make sure TeX searches all our subdirs	
TEXINPUTS=$(shell echo ' $(strip $(SUBDIRS))' | sed -e 's/ /:/g')
export TEXINPUTS
	
# Run twice to ensure labels etc.
$(PDFS): %.pdf : %.bbl environment
	latex $(@:.pdf=) 
	pdflatex $(@:.pdf=)

$(PSS): %.ps : %.pdf 
	pdftops $<

%.bbl : %.tex environment $(wildcard *.bib)
	latex $(@:.bbl=)
	bibtex $(@:.bbl=)

fixmes : fixme2html.sh
	./fixme2html.sh fixme_list.html
#	scp fixme_list.html sirius:~/public_html/

#### Convenience targets
	
DATE=$(shell date +%Y%m%d)
DISTNAME=thesis-$(USER)-$(DATE)

.PHONY: publish backup dist dist-clean view wordcount.txt

# Remove single letter 'words' in an attempt to reduce errors.
wordcount.txt:
	touch wordcount.txt
	if [ ! -f $(PDFS) ]; then pdflatex $(TEXFILES:.tex=); fi
	pdftotext -nopgbrk $(PDFS)
	echo \\numprint{`cat $(PDFS:.pdf=.txt) | sed -e 's/ [^aAI] //g'| sed -e 's/[\\.][\\.]*//g' | wc -w | perl -e '$$_=<STDIN>; print $$_ - ($$_ % 50);'`}\% >wordcount.txt 2>/dev/null

acroview: $(PDFS)
	acroread $(PDFS)

view: $(PSS)
	gv $(PSS)

publish: all
	scp $(PDFS) $(PSS) sirius:~/public_html/drafts/

backup: dist
	scp $(DISTNAME).tar.gz sirius:~
	rm $(DISTNAME).tar.gz

dist: dist-clean
	mkdir $(DISTNAME)
	cp -rap $(EVERYTHING) $(DISTNAME)/
	tar czf $(DISTNAME).tar.gz $(DISTNAME)
	rm -rf $(DISTNAME)

dist-clean: clean
	rm -f $(PDFS) $(PSS)
	rm -f svg2pdf
	
clean: clean-environment 
	rm -f $(TEXFILES:.tex=.aux) $(TEXFILES:.tex=.toc)
	rm -f $(TEXFILES:.tex=.bak) $(TEXFILES:.tex=.log)
	rm -f $(TEXFILES:.tex=.out) 
	rm -f $(TEXFILES:.tex=.bbl) $(TEXFILES:.tex=.blg) 
	rm -f wordcount.txt

#### General environment

environment: svg2pdf  subdirs wordcount.txt

clean-environment: clean-subdirs

#### svg2pdf
svg2pdf: svg2pdf.c
	$(CC) -o svg2pdf svg2pdf.c args.c `pkg-config cairo --libs --cflags` -lsvg-cairo

#### subdirectories
CLEANSUBDIRS:=$(foreach dir,$(SUBDIRS),clean-$(dir))
	
subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean-subdirs: $(CLEANSUBDIRS)

$(CLEANSUBDIRS): 
	$(MAKE) -C $(subst clean-,,$@) clean

