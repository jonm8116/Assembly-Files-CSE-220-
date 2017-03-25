##############################################################
# Homework #4
# name: Jonathan Mathai
# sbuid: 110320715
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
	li $t6, 0
	move $t0, $a1	#$a0
	move $t7, $a0	#a1	#file descriptor
	andi $t1, $a1, 32768
	li $t2, 32768
	beq $t1, $t2, itof_neg_num
	
	li $t1, 10
	li $t2, 0
	
	itof_reverse_int:
		#make a separate counter to keep track of zeros	$t6
		mul $t5, $t5, $t1	#$t2 initial
       		div $t0, $t1
        	mfhi $t2 #holds value of the mod
        	add $t5, $t5, $t2 #adds mod value to 
        	mflo $t0	#$t3
        	#move $t3, $t5	#now the reverse value is stored in $t3	
        	addi $t6, $t6, 1
        	bne $t0, 0, itof_reverse_int	#$t3
        	move $t3, $t5	#now the reverse value is stored in $t3	
        	la $a1, itof_string
        	#move $t4, $a1 
        	la $t4, itof_string
        itof_convert_to_string:
        	div $t3, $t1	#$lo=quotient	$hi = remainder
   		mflo $t3 	#places the new value (with last value dropped off)
   		mfhi $t5	#$t1 
   		addi $t2, $t5, '0'	#$t1
   		sb $t2, ($t4)		#Instead of store byte, we are going to write to file w/ syscall
   		#WRITE SYSCALL $a0->fd	$a1-> addr output buffer	$a2->num of chars to write
   		li $v0, 15
   		move $a0, $t7
   		la $a1, itof_string
   		li $a2, 1
   		syscall
   		#addi $t4, $t4, 1
   		addi $t6, $t6, -1
		bne $t3, 0, itof_convert_to_string
		bgtz $t6, itof_add_extra_zeros	#incase any zeros were missed
		#beq $t3, 0, uitoa_jumpback_post
		jr $ra        	
	
	itof_add_extra_zeros:
		li $t5, '0'
		la $t4, itof_string
		sb $t5, ($t4)		
   		li $v0, 15
   		move $a0, $t7
   		la $a1, itof_string
   		li $a2, 1
   		syscall
   		#addi $t4, $t4, 1
   		addi $t6, $t6, -1	#decrement zero counter
   		bgtz $t6, itof_add_extra_zeros
   		
   		jr $ra
   	itof_neg_num:
   		li $t5, '-'
   		la $t4, itof_string
   		sb $t5, ($t4)
   		li $v0, 15
   		move $a0, $t7
   		la $a1, itof_string
   		li $a2, 1
   		syscall 
   		#convert it to positive 
   		li $t3, 65535
   		xor $t4, $t0, $t3
   		addi $t4, $t4, 1
   		
   		li $t1, 10
   		move $t0, $t4
   		j itof_reverse_int
			
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
    bne $t3, 255, preorder_left_trav
    preorder_after_left_trav:
    	andi $t2, $t0, 255	#and to get right value
    	#lb $t3, ($t2)		#get right index
    	bne $t2, 255, preorder_right_trav
    preorder_after_right_trav:
    jr $ra
    
    
    preorder_left_trav:
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
    	lw $a0, 0($sp)
    	lw $ra, 4($sp)
    	lw $t0, 8($sp)
    	lw $t1, 12($sp)
    	lw $t2, 16($sp)
    	addi $sp, $sp, 20
    	j preorder_after_left_trav
    	
    preorder_right_trav:
    	lh $t0, 2($a0)
    	andi $t2, $t0, 255	#and to get right value
    	#lb $t3, ($t2)		#get right index
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
    	lw $a0, 0($sp)	#after returns from right child recursive call
    	lw $ra, 4($sp)
    	lw $t0, 8($sp)
    	lw $t1, 12($sp)
    	lw $t2, 16($sp)
    	addi $sp, $sp, 20
    	j preorder_after_right_trav
    
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

linear_search:
    #Define your code here
    ############################################
    #DEFINE:	$a0 = byte[] flags	
    #		$a1 = int maxSize 
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    move $t0, $a0	#flags[]	#move flags arr to temp register
    move $t1, $a1	#maxSize
    addi $t1, $t1, -1
    li $t3, 1
    #Set aside three extra registers -> one for the counter 8 bits
    #			the second is used to and with each bit in byte to check for 0
    #			counter for bytes up to maxSize
    
    linear_search_loop:
    	#DEFINE	$t2 = counter for bytes up to maxSize
    	#	$t3 = used to and with each value
    	#	$t4 = used to count for bits up to byte size
    	#	$t5 = load byte from arr into here
    	lb $t5, ($t0)
    	and $t5, $t5, $t3
    	bne $t5, $t3, linear_search_zero_found
    	li $t6, 2
    	mul $t3, $t3, $t6
    	beq $t4, $t1, finish_search	#if goes past maxSize
    	addi $t4, $t4, 1
    	li $t6, 8
    	div $t4, $t6
    	mfhi $t6
    	beq $t6, 0, go_to_next_byte
    	j linear_search_loop
    	
    	go_to_next_byte:
    		li $t3, 1
    		addi $t0, $t0, 1	#increment thru bytes[] 
    		addi $t2, $t2, 1	#increment bytes counter
    		beq $t4, $t1, finish_search
    		j linear_search_loop
    		
    	finish_search:
    		li $v0, -1
    		jr $ra
    	
    	linear_search_zero_found:	
    	    	move $v0, $t4	#moves counter for num of bits into return register
    	    	jr $ra
    
    ###########################################

set_flag:
    #Define your code here
    ############################################
    #DEFINE:	$a0 = byte[] flags
    #		$a1 = int index
    #		$a2 = int setValue
    #		$a3 = int maxSize
    #Condition: First check if index is greater than maxSize
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    
    blt $a1, 0, set_flag_invalid
    bgt $a1, $a3, set_flag_invalid
    #have loop to go through arr and get to index
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3
    set_flag_loop:
    	#DEFINE:	$t4 = counter for loop
    	li $t6, 8
    	addi $t4, $t4, 1	#increment counter
    	div $t4, $t6
    	mfhi $t5
    	beq $t5, 0, set_flag_next_byte
    	beq $t4, $t1, set_flag_found_index
    	j set_flag_loop
	
	set_flag_next_byte:
		addi $t0, $t0, 1	#go to next byte in arr
		j set_flag_loop
	
	set_flag_found_index:
    		andi $t2, $t2, 1
    		beq $t2, 1, set_flag_set_1
    		beq $t2, 0, set_flag_set_0
    		
    		set_flag_set_1:
    			div $t4, $t6	#divide the total bit counter by 8 to see
    			mfhi $t5	#how far along the byte you should go to get the bit
    			lb $t6, ($t0)
    			li $t7, 1
    			li $t1, 2
    			set_flag_pow_2_loop:
    				beqz $t5, set_flag_set_1_cont
    				mul $t7, $t7, $t1
    				addi $t5, $t5, -1
    				j set_flag_pow_2_loop
    		set_flag_set_1_cont:
    			or $t6, $t6, $t7	#set that bit to 1
    			sb $t6, ($t0)
    			li $v0, 1
    			jr $ra
    			
    		set_flag_set_0:
    			div $t4, $t6	#divide the total bit counter by 8 to see
    			mfhi $t5	#how far along the byte you should go to get the bit
    			lb $t6, ($t0)
    			li $t7, 1
    			li $t1, 2
    			set_flag_pow_2_loop_1:
    				beqz $t5, set_flag_set_0_cont
    				mul $t7, $t7, $t1
    				addi $t5, $t5, -1
    				j set_flag_pow_2_loop_1
    		set_flag_set_0_cont:
    			li $t5, 255
    			sub $t5, $t5, $t7
    			and $t6, $t6, $t5
    			sb $t6, ($t0)
    			li $v0, 1
    			jr $ra
    
    set_flag_invalid:
    	li $v0, -1
    	jr $ra
    
    ###########################################
    jr $ra

find_position:	
    li $t0, 0	#start of find_position
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0	
    move $t0, $a0
    move $t1, $a1
    #Define your code here
    ############################################
    #DEFINE:	$a0 = Node[] nodes
    #		$a1 = int currIndex
    #		$a2 = int newValue
    #sign extend the first 16 bits newValue
    move $t2, $a2
    li $t4, 32768
    and $t2, $t2, $t4
    beq $t2, $t4, find_pos_sign_extend_value
    j find_pos_cont
    
    find_pos_sign_extend_value:
    	move $t2, $a2		#find_pos_sign_extend_value
    	ori $t2, $t2, 4294901760
    
    find_pos_cont:
    	#if (newValue < nodes[currIndex].value )
    	move $t0, $a0
    	move $t1, $a1
    	#$t2 holds the new newValue
    	find_pos_loop:
    		beqz $t1, find_pos_loop_exit	#find_pos_loop
    		addi $t0, $t0, 1
    		addi $t1, $t1, -1
    		j find_pos_loop
    		
    	find_pos_loop_exit:
    		#addi $t0, $t0, 4
    		li $t5, 65535
    		and $t4, $t0, $t5
    		lh $t4, ($a0)	#nodes[currIndex].value	($t0)
    		#li $a0, ' '	#[DEBUG]
    		#li $v0, 11
    		#syscall
    		bgt $t2, $t4, newVal_less_than_nodes_val
    		j newVal_more_than_nodes_val 		
    		
    		
    	newVal_less_than_nodes_val:
    		#move $t6, $t0
    		#srl $t6, $t6, 16
    		#and $t6, $t6, $t5
    		li $t6, 4		#newVal_less_than_nodes_val
    		mul $t6, $a1, $t6	#offset= index * size_of_element
    		add $t6, $t6, $a0	#addr_of_node = base_addr + offset
    		lh $t4, 2($a0)		#lh $t4, 2($t0)
    		andi $t4, $t4, 65280	#and value to get just left value
    		srl $t4, $t4, 8
    		#move $t4, $t6
    		beq $t4, 255, find_pos_left_base_case
    		#recursive call 
    		addi $sp, $sp, -20
    		sw $a0, 0($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $t4, 12($sp)
    		sw $ra, 16($sp)
    		move $a0, $t6	#get new nodes address
    		move $a1, $t4
    		move $a2, $t2
    		
    		jal find_position
    		
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $t4, 12($sp)
    		lw $ra, 16($sp)
    		addi $sp, $sp, 20
    		
    		jr $ra 
    		
    		find_pos_left_base_case:
    			move $v0, $a1
    			li $v0, 0
    			jr $ra
    	
    	newVal_more_than_nodes_val:
    		li $t6, 4		#newVal_more_than_nodes_val
    		mul $t6, $a1, $t6	#offset= index * size_of_element
    		add $t6, $t6, $a0	#addr_of_node = base_addr + offset
    		
    		lh $t4, 2($a0)		#$t0
    		andi $t4, $t4, 255
    		move $t6, $t0
    		#srl $t6, $t6, 16
    		#and $t6, $t6, $t5
    		#move $t4, $t6
    		beq $t4, 255, find_pos_right_base_case
    		
    		#recursive call 
    		addi $sp, $sp, -20
    		sw $a0, 0($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $t4, 12($sp)
    		sw $ra, 16($sp)
    		move $a0, $t6
    		move $a1, $t4
    		move $a2, $t2
    		
    		jal find_position
    		
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $t4, 12($sp)
    		lw $ra, 16($sp)
    		addi $sp, $sp, 20
    		
    		jr $ra 
    		
    		find_pos_right_base_case:
    			move $v0, $a1
    			li $v1, 1
    			jr $ra
    
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
.space 4
newline_string: .asciiz "\n"
#.space 4
zero_string: .asciiz "0"
.align 2  # Align next items to word boundary

#place any additional data declarations here

