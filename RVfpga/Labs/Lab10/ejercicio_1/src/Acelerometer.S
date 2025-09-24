#                    Universidad de Costa Rica
#                 Escuela de Ingenieria Electrica
#            IE0424 - Laboratorio de Circuitos Digitales
#                         Laboratorio 03

#               Autores: Jorge Loría / Gabriel Siles
#                     Carnet: C04406 / C17530
#                       Fecha: 09/06/2025

#define SPCR            0x80001100
#define SPSR            0x80001108
#define SPDR            0x80001110
#define SPER            0x80001118
#define SPCS            0x80001120
#define EN_SEG          0x80001038
#define DISPLAY_SEG     0x8000103C

.globl main

.text

main:
# Se habilita segmento con 10100
    li t0, 0x24
    li t1, EN_SEG
    sb t0, 0(t1)

# Se limpia segmento
    li t0, DISPLAY_SEG
    li t1, 0x00
    sw t1, 0(t0)
    li s0, 100000
# Se inicia comunicacion SPI
    jal spiInit

ResfreshValues:

# ===== EJE X ====
# INICIO Comunicación SPI
    jal spiCSUp
# Se lee datos en X
    li a0, 0x0B
    jal spiSendGetData
# se obtienen datos en X
    li a0, 0x08         
    jal spiSendGetData
    jal spiSendGetData
# Se carga valor de relleno
    li a0, 0xFF          
    jal spiSendGetData
# FIN comunicacion SPI
    jal spiCSDown

# Reinicia el contador
    li t2, 0x00
    jal delay 

# Extrae los 8 bits menos significativos en a2
    li t0, 0xFF
    and a2, a1, t0

    # ===== EJE Y ====

# INICIO Comunicación SPI
    jal spiCSUp
# Se lee datos en Y
    li a0, 0x0B
    jal spiSendGetData
# se obtienen datos en Y
    li a0, 0x09        
    jal spiSendGetData
    jal spiSendGetData
# Se carga valor de relleno
    li a0, 0xFF          
    jal spiSendGetData
# FIN comunicacion SPI
    jal spiCSDown

# Reinicia el contador
    li t2, 0
    jal delay

# Extrae los 8 bits menos significativos en a3
    li t0, 0xFF
    and a3, a1, t0


   # ===== EJE Z ====
# INICIO Comunicación SPI
    jal spiCSUp
# Se lee datos en Z
    li a0, 0x0B
    jal spiSendGetData
# se obtienen datos en Z
    li a0, 0x12        
    jal spiSendGetData
    jal spiSendGetData
# Se carga valor de relleno
    li a0, 0xFF          
    jal spiSendGetData
# FIN comunicacion SPI
    jal spiCSDown

# Reinicia el contador
    li t2, 0
    jal delay

# Extrae los 8 bits menos significativos en a4
    li t0, 0xFF
    and a4, a1, t0

# ===== WORD DE 7 SEGMENTOS =====
# FORMATO [a2][a3][a4]

# Se desplaza valor de X
    slli a2, a2, 24
# Se desplaza valor de Y
    slli a3, a3, 12

# Se suma valores
    add a2, a2, a3
    add a2, a2, a4  
 
    li t0, DISPLAY_SEG
    sw a2, 0(t0)

    jal delay
    j ResfreshValues


delay:
    addi t2, t2, 1
    blt t2, s0, delay     
    jr ra

# Function: Inicializacion SPI peripheral
spiInit:
    li t1, SPCR
    li t0, 0x53
    sb t0, 0(t1)
    li t1, SPER
    li t0, 0x02
    sb t0, 0(t1)
ret

# Function: Levanta CS tanto como High/Low - Provides quick calls spiCSUp and spiCSDown
spiCS:
    li t0, SPCS
    sb a0, 0(t0)
ret

spiCSUp:
    li a0, 0x00
    j spiCS

spiCSDown:
    li a0, 0xFF
    j spiCS

# Function: Send byte through SPI and get the peripheral data back
spiSendGetData:

internalSpiClearIF:
    li t1, SPCR
    lb t0, 0(t1)
    ori t0,t0,0x80
    sb t0, 0(t1)

internalSpiActualSend:
    li t0, SPDR
    sb a0, 0(t0)

internalSpiTestIF:
    li t1, SPSR
    lb t0, 0(t1)
    andi t0,t0,0x80
    li t1,0x80
    bne t0, t1,internalSpiTestIF

internalSpiReadData:
    li t0, SPDR
    lb a1, 0(t0)
ret

.end