program schro_eq

    integer :: i, N, tiempo_total
    real ::  n_ciclos, lambda, s_tilda, k_0, norma, norma_inicial
    complex :: z_1,z_2,z_3
    complex, allocatable :: f(:), alfa(:), b(:), beta(:), xi(:), A_0(:)
    real, allocatable :: potencial(:)
    real, parameter :: pi = 3.1415927

    !Pedir al usuario datos de entrada
    print *, "N:"
    read *, N
    print *, "n_ciclos:"
    read *, n_ciclos
    print *, "lambda:"
    read *, lambda
    

    !Necesitamos un tiempo total para iterar, lo ponemos a 1000 por ejemplo
    tiempo_total = 5000

    allocate(f(N+1), potencial(N+1), alfa(N+1), beta(N+1),b(N+1), xi(N+1), A_0(N+1))

    open (1, file="norma_schro.txt", status="replace")
    open (2, file="funcion_onda.txt", status="replace")
    open (3, file="potencial.txt", status="replace")

    !Calcular k_0 y s_tilda
    k_0 = n_ciclos*2.0*pi/(N)
    s_tilda = 1.0/(4.0*k_0**2)
    z_1 = (0.0, 2.0)
    z_2 = (0.0, 1.0)
    z_3 = (0.0, 4.0)

    !Calcular el potencial
    do i=1, N+1
        if ((i.LE.(2.0*N/5.0)).OR.(i.GT.(3.0*N/5.0))) then
            potencial(i) = 0.0
        else
            potencial(i) = lambda*k_0**2
        end if
    end do

    do i=1, N+1
        write (3,*) i, potencial(i)
    end do
    
    A_0 = 0.0

    !Calcular A_0
    do i = 1, N+1
        A_0(i)=-2.0 + (z_1/s_tilda) - potencial(i) 
    end do

    !Calcular funcion de onda inicial
    do i=1, N+1
        f(i) = exp(z_2*(i-1)*k_0)*exp(-8.0*(4*(i-1)-N)**2/real(N)**2)
    end do

    f(1)=0.0
    f(N+1)=0.0

    norma_inicial = 0.0
    do i=1, N+1
        norma_inicial = norma_inicial + abs(f(i))**2
    end do



    !Calcular alfa
    alfa(N) = 0.0
    do i=N, 2, -1
        alfa(i-1) = -1.0/(A_0(i)+alfa(i))
    end do

   

    do i=1, tiempo_total

        !Calcular b
        do j=1,N+1
            b(j) = z_3*f(j)/s_tilda
        end do

        !Calcular beta
        beta(N) = 0.0
        
        do j=N,2,-1
            beta(j-1) = (b(j) - beta(j)) / (A_0(j) + alfa(j))
        end do 

        !Calcular xi
        xi(1) = 0.0
        do j=1,N
            xi(j+1)= alfa(j)*xi(j)+beta(j)
        end do

        !Actualizar la nueva funcion de onda
        do j=1,N+1
            f(j)=xi(j)-f(j)
            write (2,*) j, ABS(f(j))**2
        end do
        write (2,*) "SIGUIENTE"
        
        !Cálculo de la norma
        norma = 0.0
        do j=1,N+1
            norma = norma + abs(f(j))**2
        end do

        norma = norma / norma_inicial

        write (1,*) "Iteracion: ", i, " Norma: ", norma
        
    end do
    close(1)
    close(2)
    close(3)

end program schro_eq