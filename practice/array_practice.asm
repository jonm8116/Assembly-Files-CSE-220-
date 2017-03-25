#array practice 
.data 
	vinny: .asciiz "123"
	mrsuave: .asciiz "6969"
	array: .space 500

.text	
	la $t0, array
	la $t1, vinny
	la $t2, mrsuave
	sw $t1, ($t0)
	sw $t2, 4($t0) 
	la $a0, ($t0)
	li $v0, 4
	syscall
	