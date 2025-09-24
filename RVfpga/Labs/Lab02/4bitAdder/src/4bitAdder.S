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
#define DELAY 0x100000
.globl main

main:
    # Se limpian registros
    addi t1,zero,0
    addi t0,zero,0

    li x29, 0xFFFF      # t4 = 0xffff
    li x28, GPIO_INOUT  # t3 = GPIO_INOUT
    sw x29, 0(x28)      # &(GPIO_INOUT) = 0xffff

    addi s2,s2,0x10     # Patron a desplegar overflow
    li s4, DELAY        # s4 = DELAY

    # t0 valor a cambiar para suma
    li t0, 0x5555       
    # li t0, 0xFFFF

loop:
    # PILA (-12)
    addi sp, sp, -12    
    sw s1, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    li s1, 0xF000       # Mask para upper bits
    andi t1, t0, 0x000F # Mask para lower bits
    and t2, t0, s1      # Se aplica mask
    srli t2, t2, 12     # Se desplaza 12
    add t5, t2, t1      # Se aplica mask a lower bits

    # PILA (+12)
    lw s1, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp,sp,12

    li t1, 0xF          # Valor max de overflow 0b1111
    sltu s1, t1, t5     # s1 =1 if t5 > 15
    bne s1, zero, overflow 
    add s3, s3, t5      # Se suma t5 a s3

    not_overlow:
    li a1, GPIO_LEDs    #  Se carga direccion de LEDS
    sw s3, 0(a1)        # Se despliega resultado suma
    addi t2,zero,0      # Se limpia
    j wait_loop_1

    overflow:
    li a2, GPIO_LEDs    # Se carga direccion LEDS
    sw s2, 0(a2)        # Se despliega indicardor overflow
    addi t2,zero,0      # Se limpia
    j wait_loop_2

    wait_loop_1:
    addi t2,t2,1
    bne s4, t2, wait_loop_1
    j not_overlow

    wait_loop_2:
    addi t2,t2,1
    bne s4, t2, wait_loop_2
    j overflow
.end