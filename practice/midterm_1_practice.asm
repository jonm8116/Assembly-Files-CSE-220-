.data 
random: .asciiz "random"
random2: .asciiz "random2"
random3: .asciiz "random3"
random4: .asciiz "random4"
array_string: .word random, random2, random3, random4
array_int: .word 23, 432, 23, 43, 23

.text
	#la $a0, random
	#li $v0, 4
	#syscall
	la $t0, array_string #load in array before for loop
	li $t1, 0 #iterator
	li $t2, 0 
	j for_loop
	for_loop_string_array:
		beq $t1, 4, done

		lw $a0, 0($t0)
		addi $t1, $t1, 1
	
		li $v0, 4
		syscall
		li $a0, '\n'
		li $v0, 11
		syscall 
	
		addi $t0, $t0, 4
		j for_loop_string_array
	
	for_loop_int_array:
		
	
	done: 
		li $v0, 10
		syscall