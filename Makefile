# Makefile to build conference paper
# Rich Wareham (rjw57)
# $Id: Makefile,v 1.5 2002/12/05 13:47:30 rjw57 Exp $

# The name of the LaTeX file to compile
SOURCE = thesis
# List of _all_ LaTeX files
TEXFILES = thesis.tex

# The EPS files which need to come from .fig files
FIGS = 
# The EPS files which need to come from .png files
PNGS = 

# Paper-size
PAPER = a4

# Location of 'common' dir
COMMON = ../../common/

# Important include, must go here
include $(COMMON)/Makefile.paper

# Any hooks that should be implemented
clean-pre-hook:

