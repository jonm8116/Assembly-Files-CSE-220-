.data 
	array: .word 123, 232, 43, 234, 234, 123, 2434, 234, 2123, 545
	size: .word 10
	key: .word 43
	stringfound: .asciiz "The value was found at: " 
.text
	la $t1, array
	li $t2, 0 #counter
	lw $t3, size #size of array
	lw $t5, key
	
	for_loop:
		beq $t2, $t3, notfound
		lw $t4, ($t1)	#get integer at position
		#li $v0, 1
		#syscall 
		beq $t5, $t4, found
		addi $t2, $t2, 1
		addi $t1, $t1, 4
		
		j for_loop
	
	found:
		la $a0, stringfound
		li $v0, 4
		syscall
		move $a0, $t2 #move counter to get index
		li $v0, 1
		syscall
		li $v0, 10
		syscall
		
	notfound:
		li $a0, -1 
		li $v0, 1
		syscall 
		
		li $v0, 10
		syscall
