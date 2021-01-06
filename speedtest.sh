#!/bin/bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")

start=$(date  '+%Y%m%d %H:%M')
fastres=$(fast -u --single-line)
echo "$start,$(echo $fastres | cut -d ' ' -f 1,2),$(echo $fastres | cut -d ' ' -f 3,4)" >> $DIR/netflix.csv


# umobile kuala lumpur
KL=11557

speedtest --server $KL --csv >> $DIR/speedtest.csv
cd $DIR
gnuplot -p netflix.gnuplot && cp netflix.png /var/www/html/ && chgrp www-data /var/www/html/netflix.png
gnuplot -p speedtest.gnuplot && cp speedtest.png /var/www/html/ && chgrp www-data /var/www/html/speedtest.png

