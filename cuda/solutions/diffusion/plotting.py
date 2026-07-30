#!/usr/bin/env -S uv run --script --python-preference only-managed
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "matplotlib>=3.11.0",
#     "numpy>=2.4.6",
#     "sixel",
# ]
# ///
#
# Plotting program, to use to visualize the output of the mini-app
# CSCS - Summer School 2026
# Written by Jean M. Favre
#
# Tested on daint, with python/2.7.6
# Date: Thu May 21 14:11:38 CEST 2015
#

import argparse, os, sys

ap = argparse.ArgumentParser(description="Plot the mini-app output (writes output.png).")
ap.add_argument("--show", choices=["x", "sixel"], default=None,
                help="x: open an interactive window (needs ssh -X / DISPLAY); "
                     "sixel: draw the plot inline in a sixel-capable terminal. "
                     "Default: just write output.png.")
args = ap.parse_args()

import matplotlib
if args.show != "x":            # only the interactive window needs a GUI backend
    matplotlib.use('Agg')

import pylab as pl
import numpy as np

# change filename below as appropriate
headerFilename =  "output.bov"
headerfile = open(headerFilename, "r")
header = headerfile.readlines()
headerfile.close()

rawFilename = header[1].split()[1]

res_x, res_y = [int(x) for x in header[2].strip().split()[1:3]]
print('xdim %s' % res_x)
print('ydim %s' % res_y)

data = np.fromfile(rawFilename, dtype=np.double, count=res_x*res_y, sep='')
#assert data.shape[0] == res_x * res_y, "raw data array does not match the resolution in the header"

x = np.linspace(0., 1., res_x)
y = np.linspace(0., 1.*res_y/res_x, res_y)
X, Y = np.meshgrid(x, y)

# number of contours we wish to see
V = [-0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.01]

# Set figure size proportional to the data shape so tall/slim domains
# are not squashed into matplotlib's default 8x6 inch canvas.
dpi = 72.0
max_pixels = 4096
width_px = res_x
height_px = res_y
if max(width_px, height_px) > max_pixels:
    scale = max_pixels / max(width_px, height_px)
    width_px *= scale
    height_px *= scale

pl.figure(figsize=(width_px / dpi, height_px / dpi))
pl.axes().set_aspect('equal')
pl.contourf(X, Y, data.reshape(res_y, res_x), V, alpha=.75, cmap='jet')
pl.contour(X, Y, data.reshape(res_y, res_x), V, colors='black')

pl.savefig("output.png", dpi=dpi, bbox_inches='tight', pad_inches=0)

if args.show == "x":
    if os.environ.get("DISPLAY"):
        pl.show()
    else:
        print("--show x given but DISPLAY is unset; wrote output.png only.", file=sys.stderr)
elif args.show == "sixel":
    from sixel import converter
    converter.SixelConverter("output.png").write(sys.stdout)
