.data
    enterrows:      .asciiz     "Enter Rows (0 to exit): "
    enterbits:      .asciiz     "Enter bits per row: "
    shapedesign:    .asciiz     "Enter shape design: "
    exit:           .asciiz     "Goodbye!"
    error:          .asciiz     "The number of rows * the number of bits is too long!"
    newline:        .asciiz     "\n"
    asterisk:       .asciiz     "*"
    space:          .asciiz     " "

.text
.globl main

main:
    jal promptFormat            #Jump to the procedure for getting number of rows and bits per row
    move $s0, $v0
    move $s1, $v1

    jal promptDesign            #Jump to the procedure for getting the shape design
    move $s2, $v0

    jal ErrorCheck              #Jump to the procedure for checking 

    li $s3, 0                   #Tracker for keeping track of the row number in PrintRow
    j PrintRow

promptFormat:
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, enterrows           #Prompt user for the number of rows
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    beq $s0, $zero, Exit        #Exit the program if the user input zero

    la $a0, enterbits           #Prompt the user for the amount of bits
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    move $v0, $s0
    move $v1, $s1

    jr $ra

promptDesign:
    la $a0, shapedesign         #Prompt the user for the number design
    li $v0, 4
    syscall

    li $v0, 5                   #Save that value in v0
    syscall
    
    jr $ra

ErrorCheck:
    mul $t1, $s0, $s1           #Stores the value of rowInput x bitInput in t0
    slti $t0, $t1, 33           #Sets t0 to a 1 if that value is equal to or less than 32
    beq $t0, $zero, Error       #If it's a 0, we know $s0 x $s1 is larger than the No. of bits in $s2
    jr $ra

PrintRow:
    la $a0, newline             #Prints a new line
    li $v0, 4
    syscall

    li $s4, 0                   #Tracker for keeping track of which bit number we're at
    beq $s3, $s0, main          #Jump back to main if we have printed all the rows
    mul $t2, $s3, $s1           #Get the amount the shift by multiplying row number by length of row
    srlv $s5, $s2, $t2          #Shift that amount to the right and store it in s5
    addi $s3, $s3, 1            #Add 1 to the row number                 

PrintLine:
    beq $s4, $s1, PrintRow      #Once we hit the Number of bits, Jump back to Draw

    srlv $t0, $s5, $s4          #Shift the bits by bit number 
    andi $t1, $t0, 1            #Get the value of the Least Significant Bit

    addi $s4, $s4, 1            #Add 1 to the Bit Tracker

    beq $t1, $zero, Print0      #Jump to the Print0 procedure to print a space if there is a 0 in the LSB 
    bne $t1, $zero, Print1      #Jump to the Print1 procedure to print a * if there is a 1 in the LSB

Print1:                         
    la $a0, asterisk            #Prints an asterisk and jumps back to PrintLine
    li $v0, 4
    syscall

    j PrintLine                 

Print0:                         
    la $a0, space               #Prints a space and jumps back to PrintLine
    li $v0, 4
    syscall

    j PrintLine                 

Error:                          
    la $a0, error               #Prints the error message
    li $v0, 4
    syscall

Exit:
    a $a0, newline              #Prints a new line
    li $v0, 4
    syscall
    
    la $a0, exit                #Prints the exit message
    li $v0, 4
    syscall

    li $v0, 10                  #Exits the program
    syscall