#!/usr/local/bin/bash

#convert espectro.png -fill red -draw "line 100,280 100,339 line 200,280, 200,339" -annotate +0+100 "200" -annotate +50+120 "220"  to.png

function usage(){
	printf "%s [freq ini] [bw MHz] [imagem] [saída: nome.extensao]\n" `basename $0`
	exit 1
}

[[ ! $1 ]] && usage

freqi=$1
bw=$2
img=$3
saida=$4
w=$(file $img | cut -d ' ' -f5 )
h=$(file $img | cut -d ' ' -f7 | grep -Eo "[0-9]*")
hi=$(printf "%i" `echo "scale=0; $h * 0.7" | bc` 2>/dev/null)
pxfreq=$(echo "scale=3; $bw/$w " | bc)
salto=5	#pixel

opts=""
yi=0
cores=("white" "red" "green" "blue" "orange" "lightblue" "pink")
corindex=0
for((x=0;x<=$w;x=x+$salto)); do
	# altura do label
	[[ $yi -gt $hi ]] && yi=0
	yi=$(echo "scale=0; $yi + $h/8 + 10" | bc )
	# label
	fi=$(echo "scale=3; $freqi + $pxfreq * $x  " | bc)
	# index de cor
	corindex=`expr $corindex + 1`
	[[ $corindex -gt  ${#cores} ]] && corindex=0
	cor=${cores[$corindex]}
	# desenho e labels:
	opts="$opts -fill $cor -draw \"line $x,$hi $x,$h \" -annotate +${x}+${yi} \"$fi\" "
done

eval convert $img $opts $saida
