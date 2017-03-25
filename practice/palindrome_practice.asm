#palindrome practice
.data
	palindrome_string: .asciiz "racecaR"
	length: .word 7
.text
	la $s0, palindrome_string #holds the address of the string
	lw $t1, length	#length of the string
	li $t2, 0 
	addi $t1, $t1, -1 #to get last char in string
	
	li $t3, 2
	div $t1, $t3
	mflo $t3
	
	for_loop:
		beq $t2, $t3, pal
		add $s0, $s0, $t2
		lb $t8, ($s0)
		sub $s0, $s0, $t2
		
		add $s0, $s0, $t1
		lb $t7, ($s0)
		sub $s0, $s0, $t1
		
		bne $t8, $t7, notpal
		
		addi $t1, $t1, -1
		addi $t2, $t2, 1
		
		j for_loop
	pal:
		li $a0, 'y'
		li $v0, 11
		syscall
		li $v0, 10
		syscall
	notpal:
		li $a0, 'n'
		li $v0, 11
		syscall
		li $v0, 10
		syscall
		