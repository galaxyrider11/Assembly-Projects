#############################################
#   Register Legend                         #
#                                           #
#   s0  -  a                                #
#   s1  -  b                                #
#   s2  -  base of array D                  #
#   t0  -  i                                #
#   t1  -  j                                #
#   t2  -  array modifier                   #
#   t3  -  for calculations                 #
#############################################
.data
    newline:    .asciiz     "\n"
    array:      .word       1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

.text

.globl main

main:
    li $t0, 0x0
    li $t1, 0x0
    li $s0, 0xA
    li $s1, 0x5
    la $s2, array

OuterLoop:
    li $t0, 0x0                 #resets i to 0 each time the inner loop runs

    slt $t3, $s1, $t1           #sets t2 to 0 if j < b
    bne $t3, $zero, Exit 

    addi $t1, $t1, 0x1          #j++

InnerLoop:
    slt $t3, $s0, $t0           #sets t2 to 0 if i < a
    bne $t3, $zero, OuterLoop   #goes back to the outerloop if i !< a

    sll $t3, $t1, 0x4           #t2 = 4*j
    add $t2, $t3, $s2           #t2 = address of D[4*j]

    sub $t3, $t0, $t1           #calculates i - j and stores it in t3
    sw $t3, 0($t2)              #D[4*j] = i - j

    addi $t0, $t0, 0x1          #i++

    j InnerLoop                 #starts the innerloop again

Exit:
    li $v0, 10                  #End the program
    syscall