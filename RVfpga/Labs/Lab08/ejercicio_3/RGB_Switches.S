#                    Universidad de Costa Rica
#                 Escuela de Ingenieria Electrica
#            IE0424 - Laboratorio de Circuitos Digitales
#                         Laboratorio 02

#               Autores: Jorge Loría / Gabriel Siles
#                     Carnet: C04406 / C17530
#                       Fecha: 08/05/2025

#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define LED_R       0x80001240
#define HRC_R       0x80001244
#define LRC_R       0x80001248
#define CTRL_R      0x8000124c

#define LED_B       0x80001280
#define HRC_B       0x80001284
#define LRC_B       0x80001288
#define CTRL_B      0x8000128c

#define LED_G       0x800012c0
#define HRC_G       0x800012c4
#define LRC_G       0x800012c8
#define CTRL_G      0x800012cc


.globl main
main:

# Enable
li t0, 0xFFFF
li t1, GPIO_INOUT
sw t0, 0(t1)

next:

    li  a1,    GPIO_SWs
    lw  t0, 0(a1)

    # RED
    li  a0, GPIO_LEDs
    srl t0, t0, 16
    sw  t0, 0(a0)

    li t1, HRC_R
    li t2, 0xF
    sw t2, 0(t1)

    and t2, t0, 0x1F
    add t2, t2, 0xF
    li t1, LRC_R
    sw t2, 0(t1)

    li t2, 0x80
    li t1, CTRL_R
    sw t2, 0(t1)
    li t2, 0x9
    li t1, CTRL_R
    sw t2, 0(t1)
  
    # BLUE
    li t1, HRC_B
    li t2, 0xF
    sw t2, 0(t1)

    srl t0, t0, 5
    and t2, t0, 0x1F
    add t2, t2, 0xF
    li t1, LRC_B
    sw t2, 0(t1)

    li t2, 0x80
    li t1, CTRL_B
    sw t2, 0(t1)
    li t2, 0x9
    li t1, CTRL_B
    sw t2, 0(t1)

    # GREEN
    li t1, HRC_G
    li t2, 0xF
    sw t2, 0(t1)

    srl t0, t0, 5
    and t2, t0, 0x1F
    add t2, t2, 0xF
    li t1, LRC_G
    sw t2, 0(t1)

    li t2, 0x80
    li t1, CTRL_G
    sw t2, 0(t1)
    li t2, 0x9
    li t1, CTRL_G
    sw t2, 0(t1)

    li  t3, 10000

    delay:
        add t3, t3, -1
        bge t3, zero, delay

    beq zero, zero, next

.end