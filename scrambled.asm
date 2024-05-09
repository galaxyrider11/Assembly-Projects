.data
    arr0:       .byte       'M','L','I','_','E','_','P',')',':','!','S','U','R','S'
    arr1:       .byte       'L','Y','U','C','_','R','C','L','A','_','A','T','M','C','K','O','I','_','L','A','M','E','R','E','H','_','S','A','H','_','Y','S','U','I','C','E','D','Y','L','I','G'
    arr2:       .byte       'A','P','L','I','_','Z','K','F','Z','P','P','P','E','E','A','Z','I','_','Z','F','_','O','L','O','L','_','R','T','L','S','_','Z'
    arr3:       .byte       'I','_','D','L','T','O','_','_','D','W','H','A','_','E','L','G','S','T','_','R','O','_','E','H','C','E','T','T','_','K','I','!','!','N','I','O'
    sort_Arr0:  .space      14
    sort_Arr1:  .space      41
    sort_Arr2:  .space      32
    sort_Arr3:  .space      36

.text

.globl main

#############################################
#   a0  -   index                           #
#   a1  -   count                           #
#############################################
main:
    li $a0, 0           #Begins the recursion with (0, 0) as passed arguments
    li $a1, 0

    addi $sp, $sp, -20  #Makes room on the stack for 5 items
    sw $s0, 0($sp)      #Saves the 5 s registers we use in the procedure
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)

    jal TraverseTree

    lw $s0, 0($sp)      #Restores the 5 s registers we used in the procedure
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    addi $sp, $sp, 20   #Restores the stack pointer

    move $a1, $v0       #Copy return value (base address or sort_Array) into a1
    move $a2, $v1       #Copy return value (array length) into a2

    j Print

#############################################
#   s0  -   base address of arrX            #
#   s1  -   base address of sort_ArrX       #
#   s2  -   size (of array)                 #
#   a0  -   index                           #
#   a1  -   count                           #
#############################################
TraverseTree:
    addi $sp, $sp, -8   #Store the return address at the top of stack
    sw $ra, 4($sp)

    la $s0, arr0        #Change the number at the end depending on which
    la $s1, sort_Arr0   #array you want to unscramble
    li $s2, 14

    j Recurse           #Jump to Recruse, so the return address for the 
                        #recursion can be added to the stack next

#############################################
#   s0  -   base address of arrX            #
#   s1  -   base address of sort_ArrX       #
#   s2  -   size (of array)                 #
#   s3  -   finds offset of sort_arr0       #
#   s4  -   finds offset address of arr0    #
#   a0  -   index                           #
#   a1  -   count                           #
#   a2  -   child2                          #
#   a3  -   child1                          #
#############################################
SortMessage:
    addi $sp, $sp, -4   #Make space on the stack for 1 item1
    sw $ra, 0($sp)      #Save the return pointer at the top

    li $s3, 0x0000      #   input[index]
    add $s3, $s3, $a0   #Store the offset in t0
    add $s3, $s3, $s0   #Stores the address of that offset in t0
    lb $s3, 0($s3)      #The byte at that index gets saved to t0

    li $s4, 0x0000      #   output[count] = input[index]
    add $s4, $s4, $a1   #Stores the offset in t1
    add $s4, $s4, $s1   #Stores the address of that offset in t1
    sb $s3, 0($s4)      #Stores the byte from above in that memory location

    sll $s3, $a0, 1     #Multiplies index by 2
    addi $s3, $s3, 1    #Adds 1 to index (index * 2 + 1)
    move $a3, $s3       #Saves that value to child1

    addi $s3, $s3, 1    #Adds 1 more to index (since we already added 1 to it)
    move $a2, $s3       #Stores that value in child2

    addi $a1, $a1, 1    #count++

    slt $s3, $a2, $s2   #If child2 < size, t0 = 1
    move $a0, $a2       #Copy the value of child2 into the index argument reg
    bne $s3, $zero, AddToStack #Branch to AddToStack so we can add child1

    addi $sp, $sp, 4    #Remove what we add to the stack if we don't add a child

    jr $ra

#############################################
#   s0  -   base address of arrX            #
#   s1  -   base address of sort_ArrX       #
#   s2  -   size (of array)                 #
#   s3  -   used for branching calculations #
#   a0  -   index                           #
#   a1  -   count                           #
#   a2  -   child2                          #
#   a3  -   child1                          #
#############################################    
Recurse:
    jal  SortMessage

    slt $s3, $a3, $s2   #If child1 < size, t0 = 1
    move $a0, $a3
    bne $s3, $zero, Recurse

    lw $a3, 0($sp)      #Remove one set of items from the stack
    lw $ra, 4($sp)      #and recurse again if the previous child
    addi $sp, $sp, 8    #is within the bounds of the size of the array

    move $v0, $s1       #Copies base array address of sort_ArrX into v0
    move $v1, $s2       #Copies array size into v1

    jr $ra

#############################################
#   a3  -   child1                          #
#############################################
AddToStack:
    addi $sp, $sp, -4   #Make room on the stack for 1 item
    sw $a3, 0($sp)      #Store child1 on the stack and recurse again
    j Recurse

#############################################
#   s3  -   Acts as a counter for the loop  #
#############################################
Print:
    li $s3, 0           #Resets s3 to 0 - Not saved to stack since it's the end

#############################################
#   a1  -   base address of sort_ArrX       #
#   a2  -   size of array                   #
#   s3  -   Acts as a counter for the loop  #
#   a0  -   Stores the char to be printed   #
#############################################
PrintLoop:
    beq $s3, $a2, Exit  #Exits once we have printed every char of the array
    lb $a0, 0($a1)      #Load the chare at this address of the array
    li $v0, 11          #Print that char
    syscall
    addi $a1, $a1, 1    #Increase the index of the array by 1
    addi $s3, $s3, 1    #Increase the counter by 1
    j PrintLoop

Exit:
    li $v0,10
    syscall