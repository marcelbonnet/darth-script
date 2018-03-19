#!/usr/local/bin/bash
# 2018-03-19
# Marcel Bonnet
# Based on https://www.imagemagick.org/Usage/layers/#layer_prog
# Polaroid effect image composition.

function usage(){
	printf "Usage:\n\t%s [0.1<=ratio<=1.0] [images]\n"
	exit 1
}

#ratio=0.3
ratio=$1; shift;

[[ ! $1 ]] && usage;

center=0   # Start position of the center of the first image.
             # This can be ANYTHING, as only relative changes are important.

  for image in $@ 
  do

    # Add 70 to the previous images relative offset to add to each image
    #
    #center=`convert xc: -format "%[fx: $center +70 ]" info:`
    w=`convert ${image} -format "%w" info:`
	center=`echo \(${w}\*${ratio}/2\)+${center} | bc`
	echo $center >&2
    # read image, add fluff, and using centered padding/trim locate the
    # center of the image at the next location (relative to the last).
    #
    convert "${image}" -thumbnail 50%  \
            -set caption '%t' -bordercolor Lavender -background black \
            -pointsize 36  -density 96x96  +polaroid  -resize `echo ${ratio}\*100 | bc`% \
            -gravity center -background None -trim  \
			-repage +${center}+0\!  MIFF:-


  done |
    # read pipeline of positioned images, and merge together
    convert -background "#333"   MIFF:-  -layers merge +repage \
            -bordercolor black -border 3x3   /tmp/overlapped_polaroids.jpg
