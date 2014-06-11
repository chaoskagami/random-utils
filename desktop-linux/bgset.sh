#!/bin/bash

FIRSTDONE="0"
TOGGLE="0"
IMGPATH=""
RES=""
FRES=""

rm ~/.bg.png

for f in `cat $1`; do
	if [ "$TOGGLE" -eq "1" ]; then

		# Res value.
		if [ "$f" -eq "1" ]; then
			FRES="1366"
			RES="x768"
		elif [ "$f" -eq "2" ]; then
			FRES="1280"
			RES="x1024"
		else
			exit
		fi

		# Crunch.
		convert $HOME/Pictures/$IMGPATH -resize "$RES" -gravity center -crop 			$FRES$RES+0+0 +repage $HOME/.app.png

		# Merge.
		if [ "$FIRSTDONE" -eq "1" ]; then
			convert $HOME/.bg.png $HOME/.app.png +append $HOME/.bg2.png
			mv $HOME/.bg2.png $HOME/.bg.png
			rm $HOME/.app.png
		else
			mv $HOME/.app.png $HOME/.bg.png
			FIRSTDONE=1
		fi

		# Toggle
		TOGGLE=0
	else
		# Path.
		IMGPATH="$f"

		# Toggle
		TOGGLE=1
	fi
done

gsettings set org.mate.background picture-filename $HOME/.bg.png
gsettings set org.mate.background picture-options 'spanned'
