#!/usr/bin/env bash
#
# Create an animated (glitched) GIF of an JPEG image with 5 frames and 5
# modified bytes each.
#
# $ glitch.sh in.jpg out.gif
#

sos=$(grep -abo $'\xff\xda' "$1" | cut -f1 -d:)
eoi=$(grep -abo $'\xff\xd9' "$1" | cut -f1 -d:)

cp "$1" "$2"
for i in {1..5}; do
	cp "$1" "$1-glitch-$i"
	for pos in $(shuf -i $sos-$eoi -n 5); do
		printf '\x00' | dd of="$1-glitch-$i" conv=notrunc bs=1 seek=$pos
	done
done
convert $1-glitch-* $2
rm $1-glitch-*
