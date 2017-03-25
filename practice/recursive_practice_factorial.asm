#RECURSIVE FUNCTION PRACTICE 
#FACTORIAL.ASM 
.text
main:
	li $a0, 5
	jal factorial
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

factorial:
	#Questions:	Is this used to make room every iteration
	#		
	addi $sp, $sp, -8	#make room 
	sw $a0, 4($sp)		#store $a0
	sw $ra, 0($sp)		#store $ra 
	li $t0, 1		#check if $a0 = 1
	bne $t0, $a0, else	#no: go to to else
	li $v0, 1		#yes: return 1
	addi $sp, $sp, 8	#restore $sp
	jr $ra 			#return
	
	else:
		addi $a0, $a0, -1	#n = n -1
		jal factorial		#recursive call
		lw $ra, 0($sp)		#restore $ra 
		lw $a0, 4($sp)		#restore $a0
		addi $sp, $sp, 8	#restore $sp
		mul $v0, $a0, $v0	#n * factorial(n-1)
		jr $ra 			#return