
# Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload
# 17204,FarEasTone Telecom,Yuanlin City,2021-01-06T02:53:21.388032,2999.85158461577,73.129,12938314.25823103,13295071.550441066

set datafile separator ','
set xdata time # tells gnuplot the x axis is time data
set timefmt "%Y-%m-%dT%H:%M:%S" # specify our time string format
set key autotitle columnhead # use first line as title

set terminal png
set output 'speedtest.png'

# 
tz = 8

# Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload
# 17204,FarEasTone Telecom,Yuanlin City,2021-01-06T02:53:21.388032,2999.85158461577,73.129,12938314.25823103,13295071.550441066
# plot to get information of ranges
plot "speedtest.csv" using (timecolumn(4)+(3600*tz)):($7 / (1024*1024))  with lines, '' using (timecolumn(4)+3600*tz):($8 / (1024*1024)) with  lines

# sapan of data in x and y
xspan = GPVAL_DATA_X_MAX - GPVAL_DATA_X_MIN
yspan = (GPVAL_DATA_Y_MAX - GPVAL_DATA_Y_MIN)

set ylabel "Mbps"
set ytics yspan / 10

set format x "%m%d %H:%M" # otherwise it will show only MM:SS
set xlabel "Time"
set xtics xspan / 20 rotate

# define the values in x and y you want to be one 'equivalent:'
# that is, xequiv units in x and yequiv units in y will make a square plot
xequiv = 600 
yequiv = 2 

# aspect ratio of plot
ar = yspan/xspan * xequiv/yequiv

# dimension of plot in x and y (pixels)
# for constant height make ydim constant
ydim = 1600 * ar
xdim = 1600

# set the x and y ranges
set xrange [GPVAL_DATA_X_MIN:GPVAL_DATA_X_MAX]
set yrange [GPVAL_DATA_Y_MIN:GPVAL_DATA_Y_MAX]


set terminal png
set terminal png size xdim,ydim
set output 'speedtest.png'

set size ratio ar

set style data linespoints

replot
