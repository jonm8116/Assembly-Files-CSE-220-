.data #place to store the variables
str: .asciiz "Hello World"
.text 
.globl main #indicates the label
main:
	la $a0, str #loads in the address into the register
		    #Loading means RAM -> CPU
		    #Saving is CPU -> RAM 
	li $v0, 4   #Load immediate puts the actual immediate in the register
	syscall	    #asks the OS to perform an operation 
	li $v0, 10 #System exit
	syscall
