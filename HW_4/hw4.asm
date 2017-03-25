##############################################################
# Homework #4
# name: MY_NAME
# sbuid: MY_SBU_ID
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

itof:	
	li $t2, 0
	li $t3, 0
	li $t4, 0 
	li $t5, 0
	move $t0, $a1	#$a0
	move $t7, $a0	#a1	#file descriptor
	li $t1, 10
	#FIX THIS PART 
	itof_reverse_int:
		mul $t2, $t2, $t1
       		div $t0, $t1
        	mfhi $t2 #holds value of the mod
        	add $t5, $t5, $t2 #adds mod value to 
        	mflo $t3
        	bne $t3, 0, itof_reverse_int
        	move $t3, $t5	#now the reverse value is stored in $t3	
        	la $a1, itof_string
        	move $t4, $a1
        itof_convert_to_string:
        	div $t3, $t1	#$lo=quotient	$hi = remainder
   		mflo $t3 	#places the new value (with last value dropped off)
   		mfhi $t1
   		addi $t2, $t1, '0'
   		sb $t2, ($t4)		#Instead of store byte, we are going to write to file w/ syscall
   		#WRITE SYSCALL $a0->fd	$a1-> addr output buffer	$a2->num of chars to write
   		li $v0, 15
   		move $a0, $t7
   		la $a1, itof_string
   		li $a2, 1
   		syscall
   		addi $t4, $t4, 1
		bne $t3, 0, itof_convert_to_string
		#beq $t3, 0, uitoa_jumpback_post
		jr $ra        	

preorder:
    #Load half word to get 16 node value
    #DEFINE:	$a0 = currNodeAddr
    #		$a1 = nodes (base address of nodes)
    #		$a2 = file descriptor 
    lh $t0, ($a0)	#load node value into $t0
    addi $sp, $sp, -16
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $ra, 12($sp)
    move $a0, $a2	#$t0
    move $a1, $t0	#$a2
    jal itof
    li $v0, 15
    move $a0, $t7
    la $a1, newline_string
    li $a2, 1
    syscall
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    #Now time to get the node index
    lh $t0, 2($a0)
    #DEFINE:	$t1 = left child
    #		$t2 = right child
    andi $t1, $t0, 65280	#and value to get just left value
    srl $t3, $t1, 8	#shift right and place value into $t3
    #andi $t0, $t0, 4278190080	#and the value to get the 
    #lb $t3, ($t1)	#used to get index of left child
    beq $t3, 255, preorder_cont
    #If (nodeIndex != 255) DO THIS
    #int leftNodeAddr	$t4
    li $t4, 4
    mul $t3, $t3, $t4	#leftoffset
    add $t4, $t3, $a1	#leftNodeAddr = nodes + offset
    addi $sp, $sp, -20
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    move $a0, $t4
    jal preorder
    #lw $a0, 0($sp)
    #lw $ra, 4($sp)
    #addi $sp, $sp, 8

    #ELSE
    preorder_cont:
    	#lh $t0, 2($a0)
    	#andi $t2, $t0, 255
        #beq $t2, 255, preorder_cont_after_right
    	
    	lw $a0, 0($sp)
    	lw $ra, 4($sp)
    	lw $t0, 8($sp)
    	lw $t1, 12($sp)
    	lw $t2, 16($sp)
    	addi $sp, $sp, 20
    	
    	lh $t0, 2($a0)
    	andi $t2, $t0, 255	#and to get right value
    	#lb $t3, ($t2)		#get right index
    	beq $t2, 255, preorder_cont_after_right
   	#If (nodeIndex != 255) DO THIS
    	#int leftNodeAddr	$t4
   	li $t4, 4
   	mul $t2, $t2, $t4	#rightoffset
    	add $t4, $t2, $a1	#rightNodeAddr = nodes + offset
    	#[DEBUG]
    	
    	addi $sp, $sp, -20
    	sw $a0, 0($sp)
    	#sw $a1, 4($sp)
    	#sw $a2, 8($sp)
    	sw $ra, 4($sp)
    	sw $t0, 8($sp)
    	sw $t1, 12($sp)
    	sw $t2, 16($sp)
    	move $a0, $t4
    	jal preorder
    	preorder_cont_after_right:
    	lw $a0, 0($sp)	#after returns from right child recursive call
    	lw $ra, 4($sp)
    	lw $t0, 8($sp)
    	lw $t1, 12($sp)
    	lw $t2, 16($sp)
    	addi $sp, $sp, 20
    	#preorder_cont_after_right:
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

linear_search:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -10
    ###########################################
    jr $ra

set_flag:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -20
    ###########################################
    jr $ra

find_position:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -30
    li $v1, -40
    ###########################################
    jr $ra

add_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -50
    ###########################################
	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

get_parent:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -60
    li $v1, -70
    ###########################################
    jr $ra

find_min:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -80
    li $v1, -90
    ###########################################
    jr $ra

delete_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -100
    ###########################################
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################

add_random_nodes:
    #Define your code here
    jr $ra



#################################################################
# Student defined data section
#################################################################
.data
itof_string: .asciiz ""	#string used to store into a file
newline_string: .asciiz "\n"
.align 2  # Align next items to word boundary

#place any additional data declarations here

