#!/bin/bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
HTML_ROOT=/var/www/html
HTTP_GROUP="www-data"

NETFLIX_LOG=netflix.csv
SPEEDTEST_LOG=speedtest.csv
LOGS="$NETFLIX_LOG $SPEEDTEST_LOG"

NETFLIX_PLOT="netflix.png"
SPEEDTEST_PLOT="speedtest.png"
SPEEDTEST_PING_PLOT="speedtest-ping.png"
PLOTS="$NETFLIX_PLOT $SPEEDTEST_PLOT $SPEEDTEST_PING_PLOT"

run_netflix()
{
	start=$(date  '+%Y%m%d %H:%M')
	fastres=$(fast -u --single-line)
	[ "$?" != 0 ] && return 1

	DOWN=$(echo $fastres | cut -d ' ' -f 1)
	DOWN_UNIT=$(echo $fastres | cut -d ' ' -f 2)
	[ "$DOWN_UNIT" = "Gbps" ] && DOWN=$(expr $DOWN \* 1000)
	
	UP=$(echo $fastres | cut -d ' ' -f 3)

	expr $DOWN + $UP &>/dev/null || return 1
	
	echo "$start,$DOWN,$UP" >> "$DIR/$NETFLIX_LOG"
	gnuplot -p netflix.gnuplot
}

run_speedtest()
{
	# speedtest servers
	KL=11557 # umobile KL
	UNI=9593 # university Kuala Terengganu
	RES=$(speedtest --server $KL --csv)
	if [ $? = 0 ]; then
		echo "$RES" >> $DIR/speedtest.csv
	else
		RES=$(speedtest --server $UNI --csv)
		[ $? = 0 ] && echo "$RES" >> "$DIR/$SPEEDTEST_LOG" || return 1
	fi
	
	gnuplot -p speedtest.gnuplot 
	gnuplot -p speedtest-ping.gnuplot

}

install()
{
	cd "$DIR"
	cp "index.html" "$HTML_ROOT"
	chgrp $HTTP_GROUP "$HTML_ROOT/index.html"

	[ -f "netflix.csv" ] && mv "netflix.csv" netflix.csv.1
	echo 'date-time,down,up' > netflix.csv
	
	[ -f "speedtest.csv" ] && mv speedtest.csv speedtest.csv.1
	speedtest --csv-header > speedtest.csv

	# append our crontab to current user's crontab
	crontab -l > cr.tmp && tail -n 1 ./crontab >> cr.tmp && crontab cr.tmp && rm cr.tmp
}

publish()
{
	for f in $LOGS $PLOTS; do
		cp "$DIR/$f" "$HTML_ROOT/$f"
		chgrp $HTTP_GROUP "$HTML_ROOT/$f"
	done
}

cd $DIR

[ "$1" = '-h' ] && echo -e "$(basename $0) [-h] [-i]\n\t-i: install base files to html root" && exit 0
[ "$1" = '-i' ] && install

run_netflix
run_speedtest

publish

