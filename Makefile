# Makefile to build thesis
# Rich Wareham (rjw57)

# Variables we can alter
SUBDIRS:=global $(wildcard ch[0-9]*)

#### Default target ####
.PHONY: all documents
all: documents
	
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
	
.PHONY: clean maintainer-clean
.PHONY: environment clean-environment
.PHONY: subdirs $(SUBDIRS)

# Run twice to ensure labels etc.
$(PDFS): %.pdf : %.tex environment subdirs
	pdflatex $(<:.tex=)
	pdflatex $(<:.tex=)

$(PSS): %.ps : %.pdf 
	pdftops $<

dist-clean: clean
	rm -f $(PDFS) $(PSS)
	rm -f svg2pdf
	
clean: clean-environment 
	rm -f $(TEXFILES:.tex=.aux) $(TEXFILES:.tex=.toc)
	rm -f $(TEXFILES:.tex=.bak) $(TEXFILES:.tex=.log)
	rm -f $(TEXFILES:.tex=.out)

#### General environment

environment: svg2pdf 

clean-environment: clean-subdirs

#### svg2pdf
svg2pdf: svg2pdf.c
	$(CC) -o svg2pdf svg2pdf.c `pkg-config cairo --libs --cflags` -lsvg-cairo

#### subdirectories
CLEANSUBDIRS:=$(foreach dir,$(SUBDIRS),clean-$(dir))
	
subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean-subdirs: $(CLEANSUBDIRS)

$(CLEANSUBDIRS): 
	$(MAKE) -C $(subst clean-,,$@) clean

