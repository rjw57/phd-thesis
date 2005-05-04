#include <stdio.h>
#include <stdlib.h>
#include <cairo.h>
#include <cairo-features.h>
#include <cairo-ps.h>
#include <cairo-pdf.h>
#include <svg-cairo.h>

#define X_INCHES 2
#define Y_INCHES 2
#define X_PPI    300.0
#define Y_PPI    300.0

#define WIDTH    X_INCHES * X_PPI
#define HEIGHT   Y_INCHES * Y_PPI

int main(int argc, char** argv)
{
  FILE *pdfFile;
  char *svgFileName;
  cairo_t *cairo;
  svg_cairo_t* svgcr;
  unsigned int w,h;
  
  if(argc != 3)
  {
    fprintf(stderr, "%s: syntax '%s <svgfile> <pdffile>'\n", argv[0], argv[0]);
    exit(1);
  }
  
  svgFileName = argv[1];
  svg_cairo_create(&svgcr);
  svg_cairo_parse(svgcr, svgFileName);
  svg_cairo_get_size(svgcr, &w,&h);
  
  pdfFile = fopen(argv[2], "w");
  if(!pdfFile)
  {
    fprintf(stderr, "%s: error: Could not open file '%s' for writing.\n", 
                    argv[0], argv[1]);
    exit(2);
  }

  printf("Width: %i, Height: %i\n", w,h);
  cairo = cairo_create();
  cairo_set_target_pdf(cairo, pdfFile, w/X_PPI, h/Y_PPI, X_PPI, Y_PPI);
  cairo_save(cairo);
  
  svg_cairo_render(svgcr, cairo);
  
  cairo_show_page(cairo);
  cairo_restore(cairo);
  cairo_destroy(cairo);
  svg_cairo_destroy(svgcr);

  fclose(pdfFile);

  return 0;
}
