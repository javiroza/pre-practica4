# formato y nombre de la imagen
#set term png
#set output "P4-1920-fig1.png"

# muestra los ejes
set xzeroaxis
set yzeroaxis

# define el título
set title "Error en el càlcul de làrea"

# define el rango de valores de los ejes que se muestra en pantalla
#set xrange[-0.01:0.4]
#set yrange[-0.001:0.02]

# define los títulos de los ejes
set xlabel "h (mm²)"
set ylabel "Error (mm²)"

# format dels nombres de l'eix y: 4 decimals
set format y '%.2e'
set format x '%.2e'

trapezis(x) = 2*pi*x**2
simpson(x) = 2*pi*x**4
set logscale y
set logscale x
set key top left

# plot 
plot "P4-1920-res2.dat" using 1:2 with points t "Error Trapezis", \
"P4-1920-res2.dat" using 1:3 with points t "Error Simpson", \
trapezis(x) with lines t "Tendència esperada Trapezis", \
simpson(x) with lines t "Tendència esperada Simpson"
pause -1
