#!/bin/bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
HTML_ROOT=/var/www/html

NETFLIX_LOG=netflix.csv
SPEEDTEST_LOG=speedtest.csv
LOGS="$NETFLIX_LOG $SPEEDTEST_LOG"

NETFLIX_PLOT="netflix.png"
SPEEDTEST_PLOT="speedtest.png"
SPEEDTEST_PING_PLOT="speedtest-ping.png"
PLOTS="$NETFLIX_PLOT $SPEEDTEST_PLOT $SPEEDTEST_PING_PLOT"

start=$(date  '+%Y%m%d %H:%M')
fastres=$(fast -u --single-line)
echo "$start,$(echo $fastres | cut -d ' ' -f 1,2),$(echo $fastres | cut -d ' ' -f 3,4)" >> "$DIR/$NETFLIX_LOG"


# speedtest servers
KL=11557 # umobile KL
UNI=9593 # university Kuala Terengganu
RES=$(speedtest --server $KL --csv)
if [ $? = 0 ]; then
	echo "$RES" >> $DIR/speedtest.csv
else
	RES=$(speedtest --server $UNI --csv)
	[ $? = 0 ] && echo "$RES" >> "$DIR/$SPEEDTEST_LOG"
fi

cd $DIR
gnuplot -p netflix.gnuplot
gnuplot -p speedtest.gnuplot 
gnuplot -p speedtest-ping.gnuplot

for f in $LOGS $PLOTS; do
	cp "$DIR/$f" "$HTML_ROOT/$f"
	chgrp www-data "$HTML_ROOT/$f"
done

