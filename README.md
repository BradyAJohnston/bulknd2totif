# Batch .nd2 to .tif converter
---
Depending on the software package used to control a particular microscope, .nd2 or .tif files are commonly created. The MASH-FRET analysis package for smFRET experiments requires .tif files for processing. 

I wrote this simple ImageJ macro that: 
1. Opens all of the `.nd2` files in a given directory.
1. Saves an identically-named `.tif` file in the same location,
1. Operates on all sub-directories as well.

Simply point this at the folder where all of your movies are from the days experiments and wait for ImageJ to do the hard work for you.