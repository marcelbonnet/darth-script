#!/usr/local/bin/bash
# 2018-03-19
# Marcel Bonnet
# Based on https://www.imagemagick.org/Usage/layers/#layer_prog
# Polaroid effect image composition.

function usage(){
	printf "Usage 1:\n\t%s [0.1<=ratio<=1.0] [images]\n" "$(basename $0)"
	printf "Usage 2:\n\t%s [0.1<=ratio<=1.0] [file with labels, one per line] [images]\nThe result is persisted in /tmp.\n" "$(basename $0)"
	exit 1
}

center=0
ratio=$1; shift;
labels=""

[[ ! $1 ]] && usage;

if [ "$( file $1 | grep -Eo text )" == "text" ]; then
	labels=$1; shift;
fi



[[ ! ${ratio/./,} -gt 0 ]] && printf "\tThe first argument must be the ratio to resize the images, between 0.1 and 1 .\n" && exit 1 ;


count=1
  for image in $@ 
  do
	if [ ! ${labels} ]; then
		lbl='%t'
	else
		lbl="$( sed "${count}q;d" ${labels} )"
	fi
    w=`convert "${image}" -format "%w" info:`
	center=`echo \(${w}\*${ratio}/2\)+${center} | bc`
	#echo $center >&2
    # read image, add fluff, and using centered padding/trim locate the
    # center of the image at the next location (relative to the last).
    #
    convert "${image}" -thumbnail 50%  \
            -set caption "${lbl}" -bordercolor Lavender -background black \
            -pointsize 36  -density 96x96  +polaroid  -resize `echo ${ratio}\*100 | bc`% \
            -gravity center -background None -trim  \
			-repage +${center}+0\!  MIFF:-

	count=`expr $count + 1`
  done |
    # read pipeline of positioned images, and merge together
    convert -background "#333"   MIFF:-  -layers merge +repage \
            -bordercolor black -border 3x3   /tmp/overlapped_polaroids_$$.jpg
