# formato y nombre de la imagen
#set term png
#set output "P4-1920-fig2.png"

# muestra los ejes
set xzeroaxis
set yzeroaxis

# define el título
set title "Error en el càlcul de la massa"

# define el rango de valores de los ejes que se muestra en pantalla
#set xrange[-0.01:0.4]
#set yrange[-0.1:1]

# define los títulos de los ejes
set xlabel "h (Kg/m)"
set ylabel "Error (kg)"

# format dels nombres de l'eix y: 2 decimals
set format y '%.2e'
set format x '%.2e'

trapezis(x) = 126.32*x**2
simpson(x) = 126.32*x**4
set logscale y
set logscale x
set key bottom right

# plot 
plot "P4-1920-res3.dat" using 1:2 with points t "Trapezis", \
"P4-1920-res3.dat" using 1:3 with points t "Simpson", \
trapezis(x) t "Tendència esperada Trapezis",\
simpson(x) t "Tendència esperada Simpson"
pause -1
