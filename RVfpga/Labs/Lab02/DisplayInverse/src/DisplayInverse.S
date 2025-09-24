#                    Universidad de Costa Rica
#                 Escuela de Ingenieria Electrica
#            IE0424 - Laboratorio de Circuitos Digitales
#                         Laboratorio 01

#               Autores: Jorge Loría / Gabriel Siles
#                     Carnet: C04406 / C17530
#                       Fecha: 09/04/2025

#define GPIO_SWs 0x80001400
#define GPIO_LEDs 0x80001404
#define GPIO_INOUT 0x80001408
.globl main

main:
    addi t1,zero,0          # Se limpia registro
    li t1, 0x0000           # Valor Ingresado
    li t3, 0xffff           # Mask para invertir
    xor t1, t1, t3          # Se aplica mask
    li t2, GPIO_INOUT       # Se carga dirección
    sw t1, 0(t2)            # Se guarda el resultado en memoria
next:
    li a1, GPIO_SWs         # Se carga dirreccion de switches
    lw t0, 0(a1)            # Se lee valor de switches en t0
    li a0, GPIO_LEDs        # Se carga direccion de LEDS
    srl t0, t0, 16          # SE desplaza 16 bits
    sw t0, 0(a0)            # Se escribe valor en los LEDS
    beq zero, zero, next    # Bucle infinito
.end