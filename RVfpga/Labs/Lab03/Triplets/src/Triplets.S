.globl main

.data
.equ N,4
A: .word 1, 2, 3, -4, -5, -6, 7, 8, 9, -10, -11, -12
B: .space 4*N
i: .word 0                  # contador global i
k: .word 0                  # contador global k

.text
#                    Universidad de Costa Rica
#                 Escuela de Ingenieria Electrica
#            IE0424 - Laboratorio de Circuitos Digitales
#                         Laboratorio 01

#               Autores: Jorge Loría / Gabriel Siles
#                     Carnet: C04406 / C17530
#                       Fecha: 09/04/2025


main:
    addi t1, zero, 0
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    # s0 -> $(i)
    lui s0, %hi(i)           # Upper bits de i
    addi s0, s0, %lo(i)      # lower bits de i
    # s1 -> $(k)
    lui s1, %hi(k)
    addi s1, s1, %lo(k)
    # s2 -> $(B)
    lui s2, %hi(B)
    addi s2, s2, %lo(B)

    sw zero, 0(s0)          # i = 0
    sw zero, 0(s1)          # k = 0

loop:
    lw t0, 0(s0)            # t0 = i
    li t1, N                # t1 = N = 3
    slt t4, t0, t1          # i < N
    beq t4, zero, main_end  # Sale del ciclo For  

    # a0 -> $(A)
    lui a0, %hi(A)          
    addi a0, a0, %lo(A)

    lw a1, 0(s1)            # a1 = k
    jal ra, res_triplet     

    lw t0, 0(s0)            # t0 = i         
    slli t1, t0, 2          # t1 -> i * 4 bytes
    add t2, s2, t1          # B[i]
    sw a0, 0(t2)            # B[i] = resultado

    lw t0, 0(s1)            # t0 = k
    addi t0, t0, 3          # k = k+3
    sw t0, 0(s1)            

    lw t0, 0(s0)            # t0 = i
    addi t0, t0, 1          # i++
    sw t0, 0(s0)            # save i -> word

    j loop

res_triplet:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    add s0, zero, zero
    add s0, zero, a0         # s0 = $(V)
    add s1, zero, a1         # s1 = pos
    
    li s2, 0                 # s2 = sum = 0
    li t0, 0                 # t0 = i = 0

res_triplet_loop:
    li t1, 3                 # t1 = 3
    slt t5, t0, t1           # i < 3
    beq t5, zero, res_triplet_abs   # if i < 3, res_triplet_abs

    add t2, s1, t0           # t2 = pos + i
    slli t2, t2, 2           # t2 -> i * 4 bytes
    add t2, s0, t2           # t2 = &V[pos+i]
    lw t3, 0(t2)             # t3 = V[pos+i]

    add s2, s2, t3           # sum = sum + V[pos+i]
    addi t0, t0, 1           # i++
    j res_triplet_loop       # repeat loop

res_triplet_abs:
    add a0, zero, s2         # a0 = sum
    jal ra, abs_funcion
    add s2, zero, a0         # s2 = abs(sum)

res_triplet_end:
    add a0, zero, s2         # return value = abs(sum)
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    jalr zero, ra, 0         # Return a loop

# abs(x)
abs_funcion:
    slt t0, a0, zero         # t0 = 1 if sum < 0
    beq t0, zero, abs_end    # if sum >= 0, skip negation
    sub a0, zero, a0         # sum = 0 - sum

abs_end:
    jalr zero, ra, 0         # Return to res_triplet_abs

main_end:
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

fin:
    li a0, 0

.end