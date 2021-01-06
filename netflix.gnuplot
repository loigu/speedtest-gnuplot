set datafile separator ','

set xdata time # tells gnuplot the x axis is time data
set timefmt "%Y%m%d %H:%M" # specify our time string format
set key autotitle columnhead # use first line as title

set terminal png
set output 'netflix.png'

# plot to get information of ranges
plot "netflix.csv" using 1:2 with lines, '' using 1:3 with lines

# sapan of data in x and y
xspan = GPVAL_DATA_X_MAX - GPVAL_DATA_X_MIN
yspan = GPVAL_DATA_Y_MAX - GPVAL_DATA_Y_MIN

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
set output 'netflix.png'

set size ratio ar

set style data linespoints

replot
