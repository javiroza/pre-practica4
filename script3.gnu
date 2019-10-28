# formato y nombre de la imagen
#set term png
#set output "P4-1920-fig3.png"

# muestra los ejes
set xzeroaxis
set yzeroaxis

# define el título
set title "Error f_2(x) vs. Error f_3(t)"

# define el rango de valores de los ejes que se muestra en pantalla
#set xrange[-0.01:0.4]
#set yrange[-0.1:1]

# define los títulos de los ejes
set xlabel "h (Kg/m)"
set ylabel "Error f_2,Error f_3 (kg)"

# format dels nombres de l'eix y: 2 decimals
set format y '%.0e'
set format x '%.0e'

set logscale y
set logscale x
set key bottom right

# plot 
plot "P4-1920-res3.dat" using 1:2 with points t "f_2 Trapezis" r, \
"P4-1920-res3.dat" using 1:3 with points t "f_2 Simpson", \
"P4-1920-res4.dat" using 1:2 with points t "f_3 Trapezis", \
"P4-1920-res4.dat" using 1:3 with points t "f_3 Trapezis"
pause -1
