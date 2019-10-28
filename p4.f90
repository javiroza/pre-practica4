! -------------------------------- Pràctica 4 -------------------------------------- !
! Autor: Javier Rozalén Sarmiento
! Grup: B1B
! Data: 29/10/2019
!
! Funcionalitat: es desenvolupes algorismes d'integració numèrica i es posen a prova;
! també s'estudia l'error comès pels algorismes.

program practica3
    implicit none
    integer k
    double precision suma,h,pi,integral,A_0,r_0,fx,L,inttrap,intsimps
    double precision longitud,densitat,f3,trapezis22,simpson22
    parameter (A_0=0.35d0,r_0=0.42d0)
    common/cts/pi,L
    external longitud,densitat,f3
    10 format(e14.8,2x,e14.8,2x,e14.8)
    11 format(a18,x,f14.8,x,a4)
    12 format(a19,x,f14.8,x,a2)
    pi=acos(-1.d0)
    L=126.32d0/2.d0
    ! -------------------------------- Apartat 0 --------------------------------------- !
    ! Opció a)
    open(12,file="taula1.dat")
        suma = 0.d0
        do k=0,200000000
            if (mod(k,100000).eq.0) then
                write(12,*) suma
            endif
            suma = suma + 0.02d0
        enddo
    close(12)

    ! Opció b)
    open(13,file="taula2.dat")
        h = 1000.d0
        do k=0,2000
            write(13,*) 2.d0*k*h
    enddo
    close(13)
    ! Per la manera com es construeixen, les seqüències dels apartats a) i b)
    ! són la mateixa. Tanmateix, al primer apartat s'obliga al processador a 
    ! realitzar moltes més operacions, cosa que arrossega un error gran, i les
    ! operacions són amb nombres decimals, pel que s'està forçant el programa
    ! a realitzar-les; a l'apartat b) les operacions es basen en multiplicar enters  
    ! i afegir zeros a la dreta, pel que no s'arrossega error en aquest interval.
    ! A més, les operacions a realitzar són moltes menys.

    ! En efecte, en fer servir precisió simple la seqüència de b) es manté mentre
    ! que la seqüència d'a) degenera encara més.

    ! -------------------------------- Apartat 2 --------------------------------------- !
    open(14,file="P4-1920-res1.dat")   
        call trapezoids(-pi,pi,18,longitud,integral)
        write(14,11) "Area amb trapezis:",integral*A_0,"mm^2"
        call simpson(-pi,pi,18,longitud,integral)
        write(14,12) "Area amb Simpson:",integral*A_0,"mm^2"
        call trapezoids(-L,L,18,densitat,integral)
        write(14,11) "Massa amb trapezis:",integral*r_0,"kg"
        call simpson(-L,L,18,densitat,integral)
        write(14,12) "Massa amb simpson:",integral*r_0,"kg"
    close(14)

    ! -------------------------------- Apartat 3 --------------------------------------- !
    ! -------- Error comès -------- !
    ! L'error es prendrà com la diferència entre el valor per k=22 
    ! i el valor en qüestió

    ! Estudi de la convergència per a l'integral de la longitud
    open(15,file="P4-1920-res2.dat")
        call simpson(-pi,pi,22,longitud,integral)
        simpson22 = integral
        call trapezoids(-pi,pi,22,longitud,integral)
        trapezis22 = integral
        do k=4,22
            call trapezoids(-pi,pi,k,longitud,integral)
            inttrap=integral
            call simpson(-pi,pi,k,longitud,integral)
            intsimps=integral
            write(15,10) 2.d0*pi/2**k,abs(inttrap-trapezis22),abs(intsimps-simpson22)
        enddo
    close(15)

    ! Estudi de la convergència per a l'integral de la massa
    open(16,file="P4-1920-res3.dat")
        call simpson(-L,L,22,densitat,integral)
        simpson22 = integral
        call trapezoids(-L,L,22,densitat,integral)
        trapezis22 = integral
        do k=4,22
            call trapezoids(-L,L,k,densitat,integral)
            inttrap=integral
            call simpson(-L,L,k,densitat,integral)
            intsimps=integral
            write(16,10) 2.d0*L/2**k,abs(inttrap-trapezis22),abs(intsimps-simpson22)
        enddo
    close(16)

    ! -------- Error esperat -------- !
    ! L'error es prendrà com l'error teòric, que en el cas dels trapezis 
    ! va com h**2, i amb Simpson, com h**4. S'ha fet funcions dins dels 
    ! scripts de gnuplot per representar aquest error.

    ! -------------------------------- Apartat 4 --------------------------------------- !
    open(17,file="P4-1920-res4.dat")
        call simpson(-pi/2.d0,pi/2.d0,22,f3,integral)
        simpson22 = integral
        call trapezoids(-pi/2.d0,pi/2.d0,22,f3,integral)
        trapezis22 = integral
        do k=4,22
            call trapezoids(-pi/2.d0,pi/2.d0,k,f3,integral)
            inttrap=integral
            call simpson(-pi/2.d0,pi/2.d0,k,f3,integral)
            intsimps=integral
            write(17,10) pi/2**k,abs(inttrap-trapezis22),abs(intsimps-simpson22)
        enddo
    close(17)
end program practica3

! -------------------------------- Apartat 1 --------------------------------------- ! 
! Subrutina trapezoids --> Calcula una integral 1-D per trapezis
subroutine trapezoids(x1,x2,k,funci,integral)
    implicit none
    double precision x1,x2,integral,h,funci
    integer N,i,k
    N = 2**k
    h = (x2-x1)/dble(N)
    integral = 0.d0
    do i=1,N-1
        integral = integral + funci(x1+i*h)
    enddo
    integral = (integral + funci(x1)/2.d0 + funci(x2)/2.d0)*h
    return
end subroutine trapezoids

! Subrutina simpson --> Calcula una integral 1-D per Simpson
subroutine simpson(x1,x2,k,funci,integral)
    implicit none
    double precision x1,x2,integral,integral1,integral2,h,funci
    integer k,N,i
    N = 2**k
    h = (x2-x1)/dble(N)
    integral1=0.d0
    integral2=0.d0
    do i=1,N-1,2
        integral1=integral1+funci(x1+i*h)
    enddo
    integral1=integral1*4.d0
    do i=2,N-2,2
        integral2=integral2+funci(x1+i*h)
    enddo
    integral2=integral2*2.d0
    integral=(integral1+integral2+funci(x1)+funci(x2))*(h/3.d0)
    return
end subroutine simpson

! Funció longitud --> funció donada a l'apartat 2)
double precision function longitud(x)
    implicit none
    double precision x,terme_1,terme_2,pi,L
    common/cts/pi,L
    terme_1 = ((cos(x-2.d0))**2.d0)*exp((-x**2.d0)+sin(x))
    terme_2 = (pi-x)**0.5d0
    longitud = terme_2*(terme_1**2.d0)
    return
end function longitud

! Funció densitat --> funció donada a l'apartat 2)
double precision function densitat(x)
    implicit none
    double precision x,terme_1,terme_2,terme_3,L,pi
    common/cts/pi,L
    terme_1 = (1.d0-(x/L)**2.d0)**0.5d0
    terme_2 = (1.d0-x/L)
    terme_3 = (x/L)**2.d0+x/L+1.d0
    densitat = terme_1*terme_2*terme_3
    return
end function densitat

! Funció f3 --> funció obtinguda a l'apartat 4)
double precision function f3(t)
    implicit none
    double precision t
    f3 = dble(cos(t))*(1.d0-dble(sin(t)**3.d0))
    return
end function f3