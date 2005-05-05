# Makefile to build thesis
# Rich Wareham (rjw57)

# Variables we can alter

# Main tex file
TEXFILES:=$(wildcard *.tex)
SUBDIRS:=$(wildcard ch[0-9]*) global
	
#### Variables generated from above ####

PDFS=$(TEXFILES:.tex=.pdf)
PSS=$(TEXFILES:.tex=.ps)
STEMS=$(TEXFILES:.tex=)

#### Variables required by build system ####
export PROJECTROOT=$(shell pwd)

#### Default target ####
all: $(MAINPDF) $(MAINPS)
	
#### Common operations ####
include Makefile.common

#### Main targets ####
	
.PHONY: all clean maintainer-clean
.PHONY: environment clean-environment
.PHONY: subdirs $(SUBDIRS)

$(PDFS): %.pdf : %.tex environment subdirs
	pdflatex $(<:.tex=)

$(PSS): %.ps : %.pdf 
	pdftops $<

maintainer-clean: clean
	rm -f $(PDFS) $(PSS)
	
clean: clean-environment 
	rm -f $(TEXFILES:.tex=.aux) $(TEXFILES:.tex=.toc)
	rm -f $(TEXFILES:.tex=.bak) $(TEXFILES:.tex=.log)
	rm -f $(TEXFILES:.tex=.out)

#### General environment

environment: svg2pdf 

clean-environment: clean-subdirs
	rm -f svg2pdf

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

