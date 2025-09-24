.globl main
.data 

A: .word 48,56,64,80,96,48

.equ N,6

.bss
B: .space 4*N

.text

#                    Universidad de Costa Rica
#                 Escuela de Ingenieria Electrica
#            IE0424 - Laboratorio de Circuitos Digitales
#                         Laboratorio 01

#               Autores: Jorge Loría / Gabriel Siles
#                     Carnet: C04406 / C17530
#                       Fecha: 09/04/2025

main:
  addi t0, zero, 0      # Contador i
  addi t1, zero , 0     # Contador j
  li t2, N              # Cargamos la direccion de N
  addi t2, t2,-1        # Hacemos el N-1
  la s1, A              # Cargamos la palabra A
  la s4, B              # Cargamos B
  
for:
  slt t3, t0, t2        # Condicion i<N-1
  beq t3, zero, fin     # Si t0 < (N-1) NO se cumple (t3==0), termina, de lo contrario sigue
  slli s0, t0, 2        # s0 = i * 4
  add s0, s0,s1
  lw a2, 0(s0)          # a2 = A[i]
  addi s3, t0, 1        # s3 = i+1
  slli s3, s3, 2        # s3 = (i+1)*4
  add s3, s3, s1        # s3 = base de A + (i+1)*4  
  lw a3, 0(s3)          # a3 = A[i+1]


  jal ra,MyFilter
  # Si no cumple con la condicion siga con el proximo elemento
  beqz a0, sumarContador 
  add t4, a2, a3        # t4 = A[i]+A[i+1]
  addi t4 , t4 , 2      # t4 = A[i]+A[i+1] + 2
  slli  t5, t1, 2       # j*4
  add t5, t5, s4        # B[i]
  sw t4, 0(t5)
  addi t1, t1, 1        # j++

sumarContador:
  addi t0, t0, 1        # i ++ 
  j for 

# 1 => Primer valor %16
# 1 => A[2] > A[1]
MyFilter:

  addi sp, sp, -16
  sw t0, 4(sp)
  sw ra, 8(sp)

  li t5, 0xF            # Valor de 16 (1111)
  and t5, t5, a2        # A[i] % 16 = 0 ?
  bnez t5, no_cumple    # A[i] no es multiplo 16
  bge a2, a3, no_cumple # A[i] > A[i+1]
  li a0, 1              # Si paso las condiciones anteriores devuelve 1
  
  lw ra, 8(sp)
  lw t0, 4(sp)
  addi sp, sp, 16
  jr ra                 # Volvemos al loop

no_cumple:              
  li a0, 0              # myFilter devuelve 0     
  lw ra, 8(sp)
  lw t0, 4(sp)
  addi sp, sp, 16
  j sumarContador

fin:
  li t3,0

.end