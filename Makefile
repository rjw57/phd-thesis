# Makefile to build thesis
# Rich Wareham (rjw57)

# Variables we can alter

# Main tex file
MAINFILE=thesis.tex

# Dependent tex files
TEXFILES:=$(wildcard *.tex)

# SVG figures
SVGFILES:=$(wildcard *.svg)

# FIG figures
FIGFILES:=$(wildcard *.fig)

# PNG figures
PNGFILES:=$(wildcard *.png)

#### Variables generated from above ####

MAINPDF=$(MAINFILE:.tex=.pdf)
MAINPS=$(MAINFILE:.tex=.ps)
MAINSTEM=$(MAINFILE:.tex=)

#### Main targets ####
	
.PHONY: all clean maintainer-clean

all: $(MAINPDF) $(MAINPS)

$(MAINPDF): figures $(TEXFILES)
	pdflatex $(MAINSTEM)
	pdflatex $(MAINSTEM)

$(MAINPS): figures $(MAINPDF)
	pdftops $(MAINPDF)

maintainer-clean: clean
	rm -f $(MAINPDF) $(MAINPS)
	
clean: clean-figures 
	rm -f $(TEXFILES:.tex=.aux) $(TEXFILES:.tex=.toc)
	rm -f $(TEXFILES:.tex=.bak) $(TEXFILES:.tex=.log)

#### Figure handling ####
	
.PHONY: figures clean-figures 

figures: svg-figures fig-figures png-figures

clean-figures: clean-svg-figures clean-fig-figures clean-png-figures

#### EOF Figure handling ####

#### SVG figures ####

.PHONY: svg-figures clean-svg-figures

SVGPDFS := $(SVGFILES:.svg=.pdf)
SVGEPSS := $(SVGFILES:.svg=.eps)

svg-figures: $(SVGPDFS) $(SVGEPSS)

$(SVGEPSS) : %.eps : %.pdf
	pdftops $< $@
	       
$(SVGPDFS) : %.pdf : %.svg svg2pdf
	./svg2pdf $< $@

svg2pdf: svg2pdf.c
	$(CC) -o svg2pdf svg2pdf.c `pkg-config cairo --libs --cflags` -lsvg-cairo
		
clean-svg-figures:
	rm -f $(SVGPDFS) $(SVGEPSS)
	rm -f svg2pdf

#### EOF SVG figures ####
	
#### FIG figures ####

.PHONY: fig-figures clean-fig-figures

FIGPDFS := $(FIGFILES:.fig=.pdf)
FIGEPSS := $(FIGFILES:.fig=.eps)

fig-figures: $(FIGPDFS) $(FIGEPSS)

$(FIGEPSS) : %.eps : %.fig
	fig2ps --nogv --eps --bbox=dvips --add=epsfig $<
	       
$(FIGPDFS) : %.pdf : %.fig 
	fig2ps --nogv --pdf --bbox=dvips --add=epsfig $<

clean-fig-figures:
	rm -f $(FIGPDFS) $(FIGEPSS)

#### EOF FIG figures ####
		
#### PNG pngures ####

.PHONY: png-pngures clean-png-pngures

PNGEPSS := $(PNGFILES:.png=.eps)

png-figures: $(PNGEPS) 

$(PNGEPSS) : %.eps : %.png
	convert $< $@
	       
clean-png-figures:
	rm -f $(PNGEPSS)

#### EOF PNG pngures ####
