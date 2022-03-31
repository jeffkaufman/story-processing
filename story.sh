#!/bin/bash

# ex:
#  ./story.sh ~/Google\ Drive/My\# Drive/tapes/AnneOfGreenGables/AnneOfGreenGablesPt 13 anne-of-green-gables fixed

set -euf

PREFIX="$1"
N_SECTIONS="$2"
SHORTNAME="$3"
FIXED=$(if [[ "$4" = "fixed" ]] ; then echo "-w" ; else echo "" ; fi)

SECTIONS=$(seq $FIXED 1 "$N_SECTIONS")

for section in $SECTIONS; do
  sox -G --norm -t mp3 "$PREFIX$section.mp3" "$SHORTNAME-$section.wav" remix 1
done

sox $(for section in $SECTIONS; do
          echo "$SHORTNAME-$section.wav"
      done) "$SHORTNAME.wav"

lame -b64 "$SHORTNAME.wav"

scp "$SHORTNAME.mp3" ps:jtk/stories/

for section in $SECTIONS; do
    rm "$SHORTNAME-$section.wav"
done
rm "$SHORTNAME.wav"
