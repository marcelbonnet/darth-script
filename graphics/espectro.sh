#!/usr/local/bin/bash

#convert espectro.png -fill red -draw "line 100,280 100,339 line 200,280, 200,339" -annotate +0+100 "200" -annotate +50+120 "220"  to.png

function usage(){
	printf "%s [freq ini] [bw kHz] [imagem] [saída: nome.extensao] [resize]\n" `basename $0`
	exit 1
}

[[ ! $1 ]] && usage

freqi=$1
bw=$2
img=$3
saida=$4
resize=$5
w=$(file $img | cut -d ' ' -f5 ) 					; w=$(echo "$w * $resize" | bc)
h=$(file $img | cut -d ' ' -f7 | grep -Eo "[0-9]*")	; h=$(echo "$h * $resize" | bc)
hi=$(printf "%i" `echo "scale=0; $h * 0.7" | bc` 2>/dev/null)
pxfreq=$(echo "scale=3; $bw/$w " | bc)
salto=10	#pixel

opts="-resize $(echo "$resize * 100" | bc)% "
yi=10
cores=("white" "red" "#00ff00ff" "#3366ffff" "orange" "#ff0099ff" "#9900ffff" )
corindex=0
for((x=0;x<=$w;x=x+$salto)); do
	# altura do label
	[[ $yi -gt $hi ]] && yi=10
	yi=$(echo "scale=0; $yi + $h/8 + 10" | bc )
	# label
	fi=$(echo "scale=3; $freqi + $pxfreq * $x  " | bc)
	# index de cor
	[[ $corindex -gt  ${#cores} ]] && corindex=0
	cor=${cores[$corindex]}
	corindex=`expr $corindex + 1`
	# desenho e labels:
	h2=`expr $hi + $corindex \* 24`
	opts="$opts -fill \"$cor\" -draw \"stroke-opacity 0.0 path 'M $x,$h2 L $x,$h' \" -annotate +${x}+${yi} \"$fi\" "
done

eval convert $img $opts $saida
