#####################################################
#   Secret Code                                     #
#                                                   #
#   Author: Brandon Owen                            #
#   Date: 09/13/23                                  #
#   Description: Prompts for two numbers, finds a   #
#       secret value for each one, and then returns #
#       the difference of the two at the bit level  #
#####################################################

.data
    promptOne:      .asciiz     "Enter the first number: "
    promptTwo:      .asciiz     "Enter the second number: "
    hidValue:       .asciiz     "Hidden value: "
    valueDiff:      .asciiz     "Hidden value diff: "
    newline:        .asciiz     "\n"

.text
.globl main
main:

    #####################################################
    #   Register Legend                                 #
    #                                                   #
    #   s0 - Stores 111111 to AND the bits 0-5          #
    #   s1 - Stores the first number                    # 
    #   s2 - Stores the second number                   #
    #   s3 - Stores the hidden value of first number    #
    #   s4 - Stores the hidden value of second number   #
    #                                                   #
    #   t0 - Used for manipulation                      #
    #   t1 - Used for manipulation                      #
    #####################################################

#VARIABLES
    #Stores the binary value 111111 in s4 to AND inputs
    li $s0, 0x1F
    li $s5, 4

#FIRST NUMBER INPUT
    #Prints the prompt for the first number
    la $a0, promptOne
    li $v0, 4
    syscall

    #Stores the value of that number and moves it to s1
    li $v0, 5
    syscall
    move $s1, $v0
#FIRST HIDDEN NUMBER    
    #Calculates the location of the hidden number by bit masking the first 6 bits
    and $t0, $s1, $s0
    #Subtracts 4 from that value to get shift amount
    sub $t0, $t0, $s5
    #Shifts the first number to the right based on shift amount
    srlv $t0, $s1, $t0
    #Masks the number to get only the 5 bits of the hidden number
    and $s1, $t0, $s0

    #Prints the hidden value
    li $v0, 1
    move $a0, $s1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

#FINISH
    #Exits the program
    li $v0,10
    syscall