/* svg2pdf - Render an SVG image to a PDF image (using cairo)
 *
 * Copyright © 2002 USC/Information Sciences Institute
 *
 * Permission to use, copy, modify, distribute, and sell this software
 * and its documentation for any purpose is hereby granted without
 * fee, provided that the above copyright notice appear in all copies
 * and that both that copyright notice and this permission notice
 * appear in supporting documentation, and that the name of
 * Information Sciences Institute not be used in advertising or
 * publicity pertaining to distribution of the software without
 * specific, written prior permission.  Information Sciences Institute
 * makes no representations about the suitability of this software for
 * any purpose.  It is provided "as is" without express or implied
 * warranty.
 *
 * INFORMATION SCIENCES INSTITUTE DISCLAIMS ALL WARRANTIES WITH REGARD
 * TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL INFORMATION SCIENCES
 * INSTITUTE BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
 * OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 * Author: Carl Worth <cworth@isi.edu>
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include <cairo.h>
#include <cairo-pdf.h>

#include <svg-cairo.h>

#include "args.h"

#define MIN(a, b)     (((a) < (b)) ? (a) : (b))

static svg_cairo_status_t
render_to_pdf (FILE *svg_file, FILE *pdf_file, double scale, int width, int height);

int 
main (int argc, char **argv)
{
    args_t args;
    args_parse (&args, argc, argv);
    FILE *svg_file, *pdf_file;
    svg_cairo_status_t status;

    if (strcmp (args.svg_filename, "-") == 0) {
	svg_file = stdin;
    } else {
	svg_file = fopen (args.svg_filename, "r");
	if (svg_file == NULL) {
	    fprintf (stderr, "%s: failed to open %s: %s\n",
		     argv[0], args.svg_filename, strerror(errno));
	    return 1;
	}
    }

    if (strcmp (args.pdf_filename, "-") == 0) {
	pdf_file = stdout;
    } else {
	pdf_file = fopen (args.pdf_filename, "w");
	if (pdf_file == NULL) {
	    fprintf (stderr, "%s: failed to open %s: %s\n",
		     argv[0], args.pdf_filename, strerror (errno));
	    return 1;
	}
    }
	       
    status = render_to_pdf (svg_file, pdf_file, args.scale, args.width, args.height);
    if (status) {
	fprintf (stderr, "%s: failed to render %s\n", argv[0], args.svg_filename);
	return 1;
    }

    if (svg_file != stdin)
	fclose (svg_file);
    if (pdf_file != stdout)
	fclose (pdf_file);

    return 0;
}

static cairo_status_t
write_callback (void *closure, const unsigned char *data, unsigned int length)
{
    size_t written;
    FILE *file = closure;

    written = fwrite (data, 1, length, file);

    if (written == length)
	return CAIRO_STATUS_SUCCESS;
    else
	return CAIRO_STATUS_WRITE_ERROR;
}

static svg_cairo_status_t
render_to_pdf (FILE *svg_file, FILE *pdf_file, double scale, int width, int height)
{
    unsigned int svg_width, svg_height;

    svg_cairo_status_t status;
    cairo_t *cr;
    svg_cairo_t *svgc;
    cairo_surface_t *surface;
    double dx = 0, dy = 0;

    status = svg_cairo_create (&svgc);
    if (status) {
	fprintf (stderr, "Failed to create svg_cairo_t. Exiting.\n");
	exit(1);
    }

    status = svg_cairo_parse_file (svgc, svg_file);
    if (status)
	return status;

    svg_cairo_get_size (svgc, &svg_width, &svg_height);

    if (width < 0 && height < 0) {
	width = (svg_width * scale + 0.5);
	height = (svg_height * scale + 0.5);
    } else if (width < 0) {
	scale = (double) height / (double) svg_height;
	width = (svg_width * scale + 0.5);
    } else if (height < 0) {
	scale = (double) width / (double) svg_width;
	height = (svg_height * scale + 0.5);
    } else {
	scale = MIN ((double) width / (double) svg_width, (double) height / (double) svg_height);
	/* Center the resulting image */
	dx = (width - (int) (svg_width * scale + 0.5)) / 2;
	dy = (height - (int) (svg_height * scale + 0.5)) / 2;
    }

    surface = cairo_pdf_surface_create_for_stream (write_callback, pdf_file,
                    width, height);
    cr = cairo_create (surface);
    
    /*
    cairo_save (cr);
    cairo_set_operator (cr, CAIRO_OPERATOR_CLEAR);
    cairo_paint (cr);
    cairo_restore (cr);
    */

    cairo_translate (cr, dx, dy);
    cairo_scale (cr, scale, scale);

    /* XXX: This probably doesn't need to be here (eventually) */
    cairo_set_source_rgb (cr, 1, 1, 1);

    status = svg_cairo_render (svgc, cr);

    //status = write_surface_to_pdf_file (surface, pdf_file);
    cairo_show_page (cr);
    cairo_surface_destroy (surface);
    cairo_destroy (cr);
    
    if (status)
	return status;

    svg_cairo_destroy (svgc);

    return status;
}
