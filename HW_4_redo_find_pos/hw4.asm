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
   		li $t3, 4294967295
   		xor $t4, $t0, $t3
   		addi $t4, $t4, 1
   		
   		li $t1, 10
   		move $t0, $t4
   		li $t5, 0
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
    	bgt $t4, $t1, finish_search	#if goes past maxSize	was beq before
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
    		bgt $t4, $t1, finish_search	#before was beq 
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
    li $t0, 0	#start set_flag
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
		beq $t4, $t1, set_flag_found_index
		addi $t0, $t0, 1	#go to next byte in arr
		#beq $t4, $t1, set_flag_found_index
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
    	li $v0, 0
    	jr $ra
    
    ###########################################
    jr $ra

find_position:
    li $t3, 0	#start of find_position
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0	
    #Define your code here
    ############################################
    #DEFINE:	$a0 = Node[] nodes	($t0)
    #		$a1 = int currIndex	($t1)
    #		$a2 = int newValue	($t2)
    #		$t3 = temp register to store nodes[curIndex].value
    #sign extend the first 16 bits newValue
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    #pseudo:	newValue = toSignedHalfWord(newValue);
    li $t5, 4
    mul $t1, $t1, $t5
    add $t0, $t0, $t1
    
    move $t1, $a1
    
    andi $t2, $t2, 65535	#test case = 19
    #pseudo:	if (newValue < nodes[currIndex].value )
    lh $t3, ($t0)
    blt $t2, $t3, newVal_greater_than_node	#$t3	$t2
    
    newVal_less_than_node_else:
    	#Doing this twice
    	#li $t5, 4		#newVal_less_than_nodes_val
    	#mul $t5, $t1, $t5	#offset= index * size_of_element
    	#add $t0, $t0, $t5	#addr_of_node = base_addr + offset	add $t5, $t5, $t0
    
    	lb $t3, 2($t0)
    	#andi $t3, $t3, 255	#pseudo: int rightIndex = nodes[curIndex].right;    
    	beq $t3, 255, right_index_255	#pseudo: if (rightIndex == 255) {
    	beq $t3, -1, right_index_255
	#pseudo:	else { return find_position(nodes, rightIndex, newValue);
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)

    	#move $a0, $t0		#first arg
    	move $a1, $t3
    	move $a2, $t2		#newVal
    	
    	jal find_position
    	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $ra, 16($sp)
    	addi $sp, $sp, 20
    	jr $ra
	
	right_index_255:
		#pseudo:	return currIndex, 1; // No right child, add here
    		move $v0, $a1
    		li $v1, 1
    		jr $ra
    
    newVal_greater_than_node:
        #li $t5, 4		#newVal_less_than_nodes_val
    	#mul $t5, $t1, $t5	#offset= index * size_of_element
    	#add $t0, $t0, $t5	#addr_of_node = base_addr + offset	add $t5, $t5, $t0
    	#move $a0, $t5		#first arg
    	#move $a1, $t3
    	#move $a2, $t2		#newVal
        
    	#Pseudo:	int leftIndex = nodes[currIndex].left;
	lb $t3, 3($t0)
    	#srl $t3, $t3, 8
    	#andi $t3, $t3, 255
    	#pseudo:	if (leftIndex == 255) {
    	beq $t3, 255, left_index_255
    	beq $t3, -1, left_index_255
    	#pseudo:	 else { return find_position(nodes, leftIndex, newValue);
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)
	#move $a0, $t0		#first arg
    	move $a1, $t3
    	move $a2, $t2		#newVal
    	
    	jal find_position
    	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $ra, 16($sp)
    	addi $sp, $sp, 20
    	jr $ra
    	#pseudo:	if (leftIndex == 255) {
    	left_index_255:
    		move $v0, $a1
    		li $v1, 0
    		jr $ra
    		
    ###########################################

add_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -50
    #jr $ra
    #(Node[] nodes, int rootIndex, int newValue, int newIndex, byte[] flags, int maxSize
    #DEFINE:	$a0= Node[] nodes
    #		$a1= int rootIndex
    #		$a2= int newValue
    #		$a3= int newIndex
    #		$t0= byte[] flags	(ON STACK)
    #		$t1= int maxSize	(ON STACK)
    lw $t0, 4($sp)	#get args off stack
    lw $t1, 0($sp)
    #pseudo:	rootIndex = toUnsignedByte(rootIndex);
    andi $a1, $a1, 255	#ignore 24 most significant bits
    #pseudo:	newIndex = toUnsignedByte(newIndex);
    andi $a3, $a3, 255	#newIndex = toUnsignedByte(newIndex);
    #pseudo:	if (rootIndex >= maxSize || newIndex >= maxSize)
    bge $a1, $t1, rootInd_greater_than_max	#rootIndex >= maxSize
    bge $a3, $t1, rootInd_greater_than_max	#newIndex >= maxSize
    #pseudo:	newValue = toSignedHalfWord(newValue);
    andi $a2, $a2, 65535	#ignore 16 MSB
    #pseudo:	boolean validRoot = nodeExists(rootIndex);
    #	$t3 = rootIndex	(div/8)	$t2 = 8
    li $t2, 8
    div $a1, $t2	#rootIndex/8
    mflo $t3	#lo from rootIndex/8
    mfhi $t4	#hi from rootIndex/8
    add $t5, $t0, $t3	#adds the lo to the flags[]
    lb $t5, ($t5)
    li $t2, 2
    li $t3, 1
    add_node_pow_2_loop:
    	beqz $t4, add_node_pow_2_loop_ext
    	mul $t3, $t3, $t2	#get pow of 2
    	addi $t4, $t4, -1
    	j add_node_pow_2_loop
    add_node_pow_2_loop_ext:
    	and $t5, $t5, $t3
    	seq $t3, $t3, $t5 
    	#pseudo:	if (validRoot) { // if a valid root node already exists
    	beq $t3, 1, valid_root	#if (validRoot)
    	#pseudo:	else { // we must add newValue as a root node instead
    	#pseudo:	newIndex = rootIndex;
    	move $a3, $a1	#newIndex = rootIndex;
    	j add_node_cont
    	
    	#pseudo:	if (validRoot) { // if a valid root node already exists
    	valid_root:
    		#int parentIndex, leftOrRight = find_position(nodes, rootIndex, newValue);
		#$a0->	nodes[] (already there)
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		jal find_position  #find_position(nodes, rootIndex, newValue)
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		addi $sp, $sp, 12
		#	$t3= parentIndex
		#	$t4= leftOrRight
		move $t3, $v0
		move $t4, $v1	#0 == left	1 == right
    		#pseudo:	if (leftOrRight == left) {
    		beq $t4, 0, add_node_go_left	#was 1 before
    		#pseudo:	else{// update parent’s Right Node index
    		#pseudo:	nodes[parentIndex].right = newIndex;
		li $t4, 4
    		mul $t4, $t4, $t3 #offset = index * size (4)
    		move $t6, $a0
    		add $t6, $t6, $t4 #currAddr = base_addr + offset
    		#lb $t4, 0($t6)	#nodes[parentIndex].right
    		sb $a3, 2($t6)	#nodes[parentIndex].right = newIndex;
    		j add_node_cont
    		#pseudo:	if (leftOrRight == left) {
    		add_node_go_left:
    			#pseudo:	nodes[parentIndex].left = newIndex;
    			li $t4, 4	#nodes[parentIndex].left = newIndex;
    			mul $t4, $t4, $t3 #offset = index * size (4)
    			move $t6, $a0
    			add $t6, $t6, $t4 #currAddr = base_addr + offset
    			#lb $t4, 3($t6)	#nodes[parentIndex].left
    			sb $a3, 3($t6)	#nodes[parentIndex].left = newIndex;
    			
    add_node_cont:
    	#pseudo:	nodes[newIndex].LeftNode = 255;
	li $t4, 4	#nodes[newIndex].LeftNode = 255;
    	mul $t4, $t4, $t3 #offset = index * size (4)
    	move $t6, $a0
	add $t6, $t6, $t4 #currAddr = base_addr + offset
	li $t4, 255
	sb $t4, 3($t6)	  #nodes[newIndex].LeftNode = 255;
	#pseudo:	nodes[newIndex].RightNode = 255; // two 255’s create a leaf node
	li $t4, 4	#nodes[newIndex].RightNode = 255
    	mul $t4, $t4, $t3 #offset = index * size (4)
    	move $t6, $a0
	add $t6, $t6, $t4 #currAddr = base_addr + offset
	li $t4, 255
	sb $t4, 2($t6)	  #nodes[newIndex].RightNode = 255;
	#pseudo:	nodes[newIndex] = newValue;
	li $t4, 4
    	mul $t4, $t4, $t3 #offset = index * size (4)
    	move $t6, $a0
	add $t6, $t6, $t4 #currAddr = base_addr + offset
	sh $a2, 0($t6)	#nodes[newIndex] = newValue;
	
	#pseudo:	return set_flag(flags, newIndex, 1, maxSize);
	addi $sp $sp, -12
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	move $a0, $t0
	move $a1, $a3
	li $a2, 1
	move $a3, $t1
	jal set_flag
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
    
    rootInd_greater_than_max:
    	li $v0, 0
    	jr $ra
    ###########################################
	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

get_parent:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -60
    #li $v1, -70	(Node[] nodes, int currIndex, int childValue, int childIndex)
    #DEFINE:	$a0= Node[] nodes
    #		$a1= currIndex
    #		$a2= childValue
    #		$a3= childIndex
    #pseudo:	childIndex = toUnsignedByte(childIndex);	discard 24 MSB
    andi $a3, $a3, 255	#childIndex = toUnsignedByte(childIndex);
    #pseudo:	childValue = toSignedHalfWord(childValue);	discard 16 MSB
    andi $a2, $a2, 65535#childValue = toSignedHalfWord(childValue);
    
    andi $t4, $a2, 32768
    srl $t4, $t4, 15
    beq $t4, 1, get_parent_sign_extend
    j get_parent_cont
    
    get_parent_sign_extend:
    	ori $a2, $t4, 4294901760
    	
    get_parent_cont:
    #pseudo:	if (childValue < nodes[curIndex].value) {
    li $t4, 4
    mul $t4, $t4, $a1	#offset = currIndex * size_of_element (4)
    move $t0, $a0
    add $t0, $t0, $t4	#$t0 = offsetted addr
    lh $t4, ($t0)	#nodes[curIndex].value
    blt $a2, $t4, childVal_less_than_node_val	#if (childValue < nodes[curIndex].value) {
    #pseudo:	else{	int rightIndex = nodes[curIndex].right;
    lb $t4, 2($t0)	#int rightIndex = nodes[curIndex].right
    #pseudo:	if (rightIndex == 255) {
    beq $t4, 255, get_parent_rightIndex_255	#if (rightIndex == 255) {
    beq $t4, $a3, get_parent_rightIndex_childIndex
    #pseudo:	else { return get_parent(nodes, rightIndex, childValue, childIndex)
    move $a1, $t4	#moves rightIndex to currIndex parameter
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t4, 4($sp)
    jal get_parent
    lw $ra, 0($sp)
    lw $t4, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
    get_parent_rightIndex_255:
    	li $v0, -1
    	jr $ra
    
    get_parent_rightIndex_childIndex:
    	move $v0, $a1	#return currIndex, 1;
	li $v1, 1
	jr $ra
    
    
    childVal_less_than_node_val:
    	#pseudo:	int leftIndex = nodes[curIndex].left;
    	lb $t4, 3($t0)	#$t4 = leftIndex
    	#pseudo:	if (leftIndex == 255) {
    	beq $t4, 255, get_parent_leftIndex_255 #if (leftIndex == 255) {
    	beq $t4, $a3, get_parent_leftIndex_childIndex #else if (leftIndex == childIndex) {
    	#pseudo:	else{ return get_parent(nodes, leftIndex, childValue, childIndex);
    	move $a1, $t4	#moves leftIndex into second parameter
    	addi $sp, $sp, -8
    	sw $ra, 0($sp)
    	sw $t4, 4($sp)
    	jal get_parent
    	lw $ra, 0($sp)
    	lw $t4, 4($sp)
    	addi $sp, $sp, 8
    	
    	jr $ra		#finished first large if block
    	
    	get_parent_leftIndex_255:
    		li $v0, -1	#return -1;
    		jr $ra
    	get_parent_leftIndex_childIndex:
    		move $v0, $a1	#return currIndex, 0;
    		li $v1, 0
    		jr $ra	
    	
    ###########################################

find_min:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -80
    #li $v1, -90
    #DEFINE:	$a0 = Node[] nodes	($t0)
    #		$a1 = int currIndex	($t1)
    #pseudo:	int leftIndex = nodes[currIndex].left;	($t2)
    move $t0, $a0	#find_min start
    move $t1, $a1
    li $t4, 4
    mul $t1, $t1, $t4	#offset = index * size (4)
    add $t0, $t0, $t1	#currAddr = base_addr + offset    
    lb $t5, 3($t0)
    #pseudo:	if (leftIndex == 255) {
    #li $t4, 255
    beq $t5, 255, find_min_left_index_255
    beq $t5, -1, find_min_left_index_255
    #pseudo:	else
    #pseudo:	return find_min(nodes, leftIndex);
    move $a1, $t5	#move leftIndex to $a1
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    jal find_min
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    #pseudo:	if (leftIndex == 255) {
    find_min_left_index_255:
    	#pseudo:	return currIndex, isLeaf(nodes[currIndex]);
    	lb $t5, 3($t0)
    	beq $t5, 255, is_leaf_1
    	beq $t5, -1, is_leaf_1
    	is_leaf_not:
    		move $v0, $a1	#move currIndex to return register
    		li $v1, 0
    		jr $ra
    	is_leaf_1:
    		lb $t5, 2($t0)
    		beq $t5, 255, is_leaf_2
    		beq $t5, -1, is_leaf_2
    		j is_leaf_not
    	is_leaf_2:
    		move $v0, $a1
    		li $v1, 1
    		jr $ra
    ###########################################

delete_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -100
    #delete_node(Node[] nodes, int rootIndex, int deleteIndex, byte[] flags, int maxSize)
    #DEFINE:	$a0 = Node[] nodes
    #		$a1 = int rootIndex
    #		$a2 = int deleteIndex
    #		$a3 = byte[] flags
    #		$t0 = int maxSize	ON STACK
    #pseudo:	rootIndex = toUnsignedByte(rootIndex);	DISCARD 24 MSB
    lw $t0, 0($sp)	#take arg off stack MAXSIZE
    andi $a1, $a1, 255	#rootIndex = toUnsignedByte(rootIndex)
    #pseudo:	deleteIndex = toUnsignedByte(deleteIndex);
    andi $a2, $a2, 255	#deleteIndex = toUnsignedByte(deleteIndex);
    #pseudo:	if (rootIndex >= maxSize || delete >= maxSize)
    bge $a1, $t0, delete_node_rootInd_greater_than_maxSize	#rootIndex >= maxSize
    bge $a2, $t0, delete_node_rootInd_greater_than_maxSize	#delete >= maxSize
    #pseudo:	boolean validRoot = nodeExists(rootIndex);
    #TO TEST IF ROOTINDEX IS VALID:
    li $t2, 8
    div $a1, $t2	#rootIndex/8
    mflo $t3	#lo from rootIndex/8
    mfhi $t4	#hi from rootIndex/8
    add $t5, $a3, $t3	#adds the lo to the flags[]
    li $t2, 2
    li $t3, 1
    move $t6, $t5 #move offsetted address
    lb $t5, ($t6) #load byte into $t5
    delete_node_pow_2_loop:
    	beqz $t4, delete_node_pow_2_loop_ext	#was accidentally referring to wrong label (add_node label)
    	mul $t3, $t3, $t2	#get pow of 2
    	addi $t4, $t4, -1
    	j add_node_pow_2_loop
    delete_node_pow_2_loop_ext:
    	and $t5, $t5, $t3
    	seq $t3, $t3, $t5 	#$t3 holds the value of validRoot
    #TO TEST IF DELETEINDEX IS VALID:
    li $t2, 8
    div $a2, $t2	#rootIndex/8
    mflo $t6	#lo from rootIndex/8
    mfhi $t4	#hi from rootIndex/8
    add $t5, $a3, $t6	#adds the lo to the flags[]
    li $t2, 2
    li $t6, 1
    move $t7, $t5 #move offsetted address
    lb $t5, ($t7) #load byte into $t5
    delete_node_pow_2_loop_1:
    	beqz $t4, delete_node_pow_2_loop_ext_1
    	mul $t6, $t6, $t2	#get pow of 2
    	addi $t4, $t4, -1
    	j delete_node_pow_2_loop_1
    delete_node_pow_2_loop_ext_1:
    	and $t5, $t5, $t6
    	seq $t6, $t6, $t5 	#$t6 holds the value of validDel
    #pseudo:	if (!validRoot || !validDel)
    beq $t6, 0, not_valid_root	#!validDel
    beq $t3, 0, not_valid_root	#!validRoot
    #pseudo:	if (isLeaf(nodes[deleteIndex])) {
    li $t2, 4		#FIRST BIG IF
    mul $t2, $t2, $a2	#deleteIndex * 4
    add $t2, $t2, $a0	#nodes[deleteIndex]
    #start checking isLeaf
    lb $t4, 2($t2)	#isLeaf(nodes[deleteIndex])	check right index
    
    beq $t4, 255, deleteIndex_isLeaf
    beq $t4, -1, deleteIndex_isLeaf
    deleteIndex_isLeaf_cont:
    #pseudo:	else if (hasOneChild(nodes[deleteIndex])) {
    lb $t4, 3($t2)	#nodes[deleteIndex].left
    beq $t4, 255, delete_node_one_child
    beq $t4, -1, delete_node_one_child
    j delete_node_else
    
    deleteIndex_isLeaf:
    	#check if index is null for suspected leaf
    	lb $t4, 3($t2)	#nodes[deleteIndex].left
    	beq $t4, 255, isLeaf_nodes_deleteIndex
    	beq $t4, -1, isLeaf_nodes_deleteIndex
    	j delete_node_one_child
    	#pseudo:	if (isLeaf(nodes[deleteIndex])) {
    	isLeaf_nodes_deleteIndex:
    		#pseudo:	set_flag(flags, deleteIndex, 0, maxSize); // remove flag from flags
    		addi $sp, $sp, -24
    		sw $a0, 0($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $a3, 12($sp)
    		sw $t0, 16($sp)
    		sw $ra, 20($sp)
    		move $a0, $a3	#move flags to $a0
    		move $a1, $a2	#move deleteIndex to $a2
    		li $a2, 0
    		move $a3, $t0	#move maxSize to $a3
    		jal set_flag	#set_flag(flags, deleteIndex, 0, maxSize)
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $a3, 12($sp)
    		lw $t0, 16($sp)
    		lw $ra, 20($sp)
    		addi $sp, $sp, 24
    	#pseudo:	if (deleteIndex == rootIndex)
    	beq $a1, $a2, deleteInd_equal_rootInd	#if (deleteIndex == rootIndex)
    	j deleteInd_equal_rootInd_cont
    	deleteInd_equal_rootInd:	
    		li $v0, 1
    		jr $ra
    	deleteInd_equal_rootInd_cont:#					$a0	$a1		$a2			$a3
    		#pseudo:	int parentIndex, leftOrRight = get_parent(nodes, rootIndex, nodes[deleteIndex].value, deleteIndex)
    		#get value for $a2-> nodes[deleteIndex].value
    		li $t1, 4
    		mul $t1, $t1, $a2	#[deleteIndex]
    		add $t1, $t1, $a0	#nodes[deleteIndex]
    		lh $t2, ($t1)		#nodes[deleteIndex].value
    		addi $sp, $sp, -24
    		sw $a0, 0($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $a3, 12($sp)
    		sw $t0, 16($sp)
    		sw $ra, 20($sp)    		
    		move $a3, $a2		#move deleteIndex to $a3
    		move $a2, $t2		#move nodes[deleteIndex].value to $a2
    		jal get_parent
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $a3, 12($sp)
    		lw $t0, 16($sp)
    		lw $ra, 20($sp)
    		addi $sp, $sp, 24
    		#int parentIndex($t1)	int leftOrRight ($t2)
    		move $t1, $v0	#parentIndex
    		move $t2, $v1	#leftOrRight
    		#pseudo:	if (leftOrRight == left) //delete left reference from parent node
    		beq $t2, 0, delete_node_delete_left	#if (leftOrRight == left)
    		#pseudo:	else // Delete right reference from parent node
		#pseudo:	nodes[parentIndex].right = 255;
    		li $t3, 4
    		mul $t3, $t3, $t1	#parentIndex * 4
    		add $t3, $t3, $a0
    		li $t4, 255
    		sb $t4, 2($t3)	#nodes[parentIndex].right = 255;
    		li $v0, 1
    		jr $ra		#return 1;
    		
    		delete_node_delete_left:
    			#pseudo:	nodes[parentIndex].left = 255;
    			li $t3, 4
    			mul $t3, $t3, $t1	#parentIndex * 4
    			add $t3, $t3, $a0
    			li $t4, 255
    			sb $t4, 3($t3)	#nodes[parentIndex].left = 255;
    			li $v0, 1
    			jr $ra		#return 1;
    #pseudo:	else if (hasOneChild(nodes[deleteIndex]))
    delete_node_one_child:
    	    	#Node childNode;
		#int childIndex;
		#pseudo:	if (hasALeftChild(nodes[deleteIndex]))
    		#nodes[deleteIndex] = $t2
    		lb $t5, 2($t2)	#nodes[deleteIndex].right
    		#check if right index is null. Then there is no right index, so there is a left child
    		beq $t5, 255, one_child_has_left_child
    		beq $t5, -1, one_child_has_left_child
    		#DEFINE:	$t1 = childIndex	keep as that
    		#		$t3 = childNode
    		

    		#pseudo:	else // Node has a right child only
    		#pseudo:	childIndex = nodes[deleteIndex].right;
    		lb $t1, 2($t2)	#childIndex = nodes[deleteIndex].right;
    		j delete_node_one_child_cont
    		#pseudo:	if (hasALeftChild(nodes[deleteIndex]))
    		one_child_has_left_child:
    		#pseudo:	childIndex = nodes[deleteIndex].left;
    			lb $t1, 3($t2)	#childIndex = nodes[deleteIndex].left;
    			j delete_node_one_child_cont
    	delete_node_one_child_cont:
    	#pseudo:	if (deleteIndex == rootIndex) {
    		beq $a2, $a1, delete_node_deleteInd_equal_rootInd
    		j delete_node_one_child_cont_1
    		#DEFINE:	$t3 = childNode
    		delete_node_deleteInd_equal_rootInd:	#if (deleteIndex == rootIndex) {
    			#pseudo:	childNode = nodes[childIndex];
    			li $t4, 4
    			mul $t4, $t4, $t1	#childIndex *4
    			add $t4, $t4, $a0	#nodes[childIndex]
    			move $t3, $t4		#childNode = nodes[childIndex]
    			#pseudo:	nodes[deleteIndex] = childNode;
    			li $t4, 4
    			mul $t4, $t4, $a2	
    			add $t4, $t4, $a0	#nodes[childIndex]
    			sw $t3, ($t4)		#nodes[deleteIndex] = childNode;
    			#pseudo:	set_flag(flags, childIndex, 0, maxSize);
    			addi $sp, $sp, -32
    			sw $a0, 0($sp)
    			sw $a1, 4($sp)
    			sw $a2, 8($sp)
    			sw $a3, 12($sp)
    			sw $t0, 16($sp)
    			sw $ra, 20($sp)
    			sw $t1, 24($sp)
    			sw $t3, 28($sp)
    			move $a0, $a3	#move flags[] to $a0
    			move $a1, $t1	#move childIndex to $a1
    			li $a2, 0
    			move $a3, $t0	#move maxSize to $a3
    			jal set_flag		
    			lw $a0, 0($sp)
    			lw $a1, 4($sp)
    			lw $a2, 8($sp)
    			lw $a3, 12($sp)
    			lw $t0, 16($sp)
    			lw $ra, 20($sp)
    			lw $t1, 24($sp)
    			lw $t3, 28($sp)
    			addi $sp, $sp, 32
    			
    			li $v0, 1
    			jr $ra
    		delete_node_one_child_cont_1:#					#$a0	$a1		$a2			$a3
    			#pseudo:	int parentIndex, leftOrRight = get_parent(nodes, rootIndex, nodes[deleteIndex].value, deleteIndex)
    			li $t4, 4
    			mul $t4, $t4, $a2	#deleteIndex * 4
    			add $t4, $t4, $a0
    			lh $t5, ($t4)		#nodes[deleteIndex].value
    			addi $sp, $sp, -32
    			sw $a0, 0($sp)
    			sw $a1, 4($sp)
    			sw $a2, 8($sp)
    			sw $a3, 12($sp)
    			sw $t0, 16($sp)
    			sw $ra, 20($sp)
    			sw $t1, 24($sp)
    			sw $t3, 28($sp)			
    			move $a3, $a2	#move deleteIndex into $a3
    			move $a2, $t5	#move nodes[deleteIndex].value into $a2
    			jal get_parent
    			lw $a0, 0($sp)
    			lw $a1, 4($sp)
    			lw $a2, 8($sp)
    			lw $a3, 12($sp)
    			lw $t0, 16($sp)
    			lw $ra, 20($sp)
    			lw $t1, 24($sp)
    			lw $t3, 28($sp)		
    			addi $sp, $sp, 32
    			#DEFINE:	$t4 = int parentIndex
    			#		$t5 = leftOrRight
    			move $t4, $v0	#parentIndex
    			move $t5, $v1	#leftOrRight
    			#pseudo:	if (leftOrRight == left)
    			beqz $t5, delete_node_one_child_go_left
    			#else // Change parent’s right reference to found child index
			#pseudo:	nodes[parentIndex].right = childIndex;
			li $t6, 4
    			mul $t6, $t6, $t4
    			add $t6, $t6, $a0	#nodes[parentIndex]
    			sb $t1, 2($t6)		#nodes[parentIndex].right = childIndex;
    			j delete_node_one_child_call_setflag
    			delete_node_one_child_go_left:	
    				#pseudo:	nodes[parentIndex].left = childIndex;
    				li $t6, 4
    				mul $t6, $t6, $t4
    				add $t6, $t6, $a0	#nodes[parentIndex]
    				sb $t1, 3($t6)		#nodes[parentIndex].left = childIndex;
    				    				
    			delete_node_one_child_call_setflag:
    			#pseudo:	set_flag(flags, deleteIndex, 0, maxSize);
    			addi $sp, $sp, -32
    			sw $a0, 0($sp)
    			sw $a1, 4($sp)
    			sw $a2, 8($sp)
    			sw $a3, 12($sp)
    			sw $t0, 16($sp)
    			sw $ra, 20($sp)
    			sw $t1, 24($sp)
    			sw $t3, 28($sp)	
    			move $a0, $a3	#move flags[] to $a0
    			move $a1, $a2	#move deleteIndex to $a1
    			li $a2, 0
    			move $a3, $t0	#move maxSize to $a3
    			jal set_flag	#set_flag(flags, deleteIndex, 0, maxSize);
    			lw $a0, 0($sp)
    			lw $a1, 4($sp)
    			lw $a2, 8($sp)
    			lw $a3, 12($sp)
    			lw $t0, 16($sp)
    			lw $ra, 20($sp)
    			lw $t1, 24($sp)
    			lw $t3, 28($sp)
    			addi $sp, $sp, 32
    			li $v0, 1	#return 1
    			jr $ra
    
    delete_node_else:
    	#pseudo:	int minIndex, minIsLeaf = find_min(nodes, nodes[deleteIndex].right);
    	#DEFINE:	$t2 = nodes[deleteIndex]
    	addi $sp, $sp, -24
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $ra, 20($sp)
    	
    	lb $t4, 2($t2)
    	move $a1, $t4
    	jal find_min
    	
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $ra, 20($sp)
    	addi $sp, $sp, 24
    	#DEFINE:	$t4 = minIndex
    	#		$t5 = minIsLeaf
    	move $t4, $v0	#minIndex
    	move $t5, $v1	#minIsLeaf
    	#pseudo:	int parentIndex, leftOrRight = get_parent(nodes, deleteIndex, nodes[minIndex].value, minIndex);
    	addi $sp, $sp, -32
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $ra, 20($sp)
    	sw $t4, 24($sp)
    	sw $t5, 28($sp)
    	li $t6, 4
    	mul $t6, $t6, $t4
    	add $t6, $t6, $a0
    	move $a1, $a2
    	lh $a2, ($t6)
    	move $a3, $t4
    	jal get_parent
    	
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $ra, 20($sp)
    	lw $t4, 24($sp)
    	lw $t5, 28($sp)
    	#DEFINE:	$t6= parentIndex
    	#		$t7= leftOrRight
    	move $t6, $v0	#parentIndex
    	move $t7, $v1	#leftOrRight
    	#pseudo:	if (minIsLeaf == true) { // The minimum node is a leaf (1 IS TRUE; 0 IS FALSE)
    	beq $t5, 1, minIsLeaf_true
    	j minLeaf_false
    	minIsLeaf_true:	#if-statement
    	#pseudo:	if (leftOrRight == left) 
    		beq $t7, 0, minIsLeaf_true_go_left
    		#pseudo:	else // Min is right of it’s parent
		#pseudo:	nodes[parentIndex].right = 255;
		li $t8, 4 
    		mul $t8, $t8, $t6
    		add $t8, $t8, $a0
    		li $t9, 255
    		sb $t9, 2($t8)	#nodes[parentIndex].right = 255;
    		j minIsLeaf_cont
    		minIsLeaf_true_go_left: #if (leftOrRight == left 
    		#pseudo:	nodes[parentIndex].left = 255;
    			li $t8, 4 
    			mul $t8, $t8, $t6
    			add $t8, $t8, $a0
    			li $t9, 255
    			sb $t9, 3($t8)	#nodes[parentIndex].left = 255;
    		j minIsLeaf_cont
	minLeaf_false:	#else-statement
		#pseudo:	if (leftOrRight == left)
		beq $t7, 0, minLeaf_false_go_left
		#else{
		#pseudo:	nodes[parentIndex].right = nodes[minIndex].right;
		li $t8, 4 
    		mul $t8, $t8, $t6
    		add $t8, $t8, $a0	#nodes[parentIndex]
    		
    		li $t9, 4
    		mul $t9, $t9, $t4
    		add $t9, $t9, $a0	#nodes[minIndex]
    		lb $t2, 2($t9)
    		
    		sb $t2, 2($t8)	#nodes[parentIndex].right = nodes[minIndex].right;
    		j minIsLeaf_cont
    		
		minLeaf_false_go_left:	#if (leftOrRight == left)
			#pseudo:	nodes[parentIndex].left = nodes[minIndex].right;
			li $t8, 4 
    			mul $t8, $t8, $t6
    			add $t8, $t8, $a0	#nodes[parentIndex]
    			
    			li $t9, 4
    			mul $t9, $t9, $t4
    			add $t9, $t9, $a0	#nodes[minIndex]
    			lb $t2, 2($t9)
    			
    			sb $t2, 3($t8)	#nodes[parentIndex].left = nodes[minIndex].right;
    			j minIsLeaf_cont
    			
    minIsLeaf_cont:
    	#pseudo:	nodes[deleteIndex].value = nodes[minIndex].value;
    	#$t7-$t9 free
    	li $t7, 4
    	mul $t7, $t7, $a2
    	add $t7, $t7, $a0	#nodes[deleteIndex]
    	
    	li $t8, 4
    	mul $t8, $t8, $t4	
    	add $t8, $t8, $a0	#nodes[minIndex]
    	lh $t8, ($t8)		#nodes[minIndex].value
    	
    	sh $t8, 0($t7)		#nodes[deleteIndex].value = nodes[minIndex].value;
    	#pseudo:	// Remove the flag from the min node’s position
	#pseudo:	set_flag(flags, minIndex, 0, maxSize);
	addi $sp, $sp, -32
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $ra, 20($sp)
    	sw $t4, 24($sp)
    	sw $t5, 28($sp)
    	
    	move $a0, $a3	#move flags array into first arg
    	move $a1, $t4	#move minIndex into $a1
    	li $a2, 0
    	move $a3, $t0	#move maxSize into $a3
    	jal set_flag
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $ra, 20($sp)
    	lw $t4, 24($sp)
    	lw $t5, 28($sp)
    	addi $sp, $sp, 32
    	li $v0, 1
    	jr $ra
    			
    	
    not_valid_root:
    	li $v0, 0
    	jr $ra	
    
    delete_node_rootInd_greater_than_maxSize:
    	li $v0, 0	#return 0;
    	jr $ra
    
    ###########################################

##############################
# EXTRA CREDIT FUNCTION
##############################

add_random_nodes:
    #Define your code here
    #public static void add_random_nodes(Node[] nodes, int maxSize, int rootIndex, byte[] flags, int seed, int fd)
    #DEFINE:	$a0= Node[] nodes
    #		$a1= int maxSize
    #		$a2= int rootIndex
    #		$a3= byte[] flags
    #		$t0= int fd	ON STACK
    #		$t1=int seed	ON STACK
    #pseudo:	if (rootIndex < 0 || rootIndex >= maxSize) return;
    lw $t0, 0($sp)	#int fd
    lw $t1, 4($sp)	#int seed
    
    blt $a2, 0, rootInd_less_than_zero
    bge $a2, $a1, rootInd_less_than_zero
    j rootInd_less_than_zero_cont
    
    rootInd_less_than_zero:
    	jr $ra
    
    rootInd_less_than_zero_cont:
    #pseudo:	Random generator = new Random(0, seed);
    addi $sp, $sp, -16
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    li $v0, 40		#use syscall to generate random numbers
    li $a0, 0
    move $a1, $t1
    syscall
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    addi $sp, $sp, 16
    #pseudo:	int newIndex = linear_search(flags, maxSize);
    addi $sp, $sp, -28
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $ra, 24($sp)
    
    move $a0, $a3	#move flags to $a3
    jal linear_search
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    
    move $t2, $v0
    #DEFINE:	$a0= Node[] nodes
    #		$a1= int maxSize
    #		$a2= int rootIndex
    #		$a3= byte[] flags
    #		$t0= int fd	ON STACK
    #		$t1=int seed	ON STACK
    #		$t2 = newIndex
    #		$t3 = newValue
    bne $t2, -1, add_rand_while_loop
    j add_rand_while_loop_exit
    add_rand_while_loop:
    	#pseudo:	newValue = generator.nextInt(-32768,32767);
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	
    	li $v0, 42
    	li $a0, 0
    	li $t3, 65535
    	move $a1, $t3	#move upper range of random generator
    	syscall
    	move $t3, $a0	#move generated int into $t3
    	addi $t3, $t3, -32768
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	
    	#move $t3, $a0	#move generated int into $t3
    	addi $sp, $sp, -36
  	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $t2, 24($sp)
    	sw $t3, 28($sp)
    	sw $ra, 32($sp)
    	#pseudo:	parentIndex,leftOrRight = find_position(nodes, rootIndex, newValue);
    	move $a1, $a2	#move rootIndex to $a1
    	move $a2, $t3
    	jal find_position
    	
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $t2, 24($sp)
    	lw $t3, 28($sp)
    	lw $ra, 32($sp)
    	addi $sp, $sp, 36
    	#DEFINE:	$a0= Node[] nodes
    	#		$a1= int maxSize
    	#		$a2= int rootIndex
    	#		$a3= byte[] flags
    	#		$t0= int fd	ON STACK
    	#		$t1=int seed	ON STACK
    	#		$t2 = newIndex
    	#		$t3 = newValue
    	move $t4, $v0	#parentIndex
    	move $t5, $v1	#leftOrRight
    	#pseudo:	write(fd, "New value: ", 11);
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, new_value_str
	li $a2, 11
	syscall
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
    	addi $sp, $sp, 12
    	#pseudo:	itof(fd, newValue)
    	addi $sp, $sp, -44
  	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $t2, 24($sp)
    	sw $t3, 28($sp)
    	sw $t4, 32($sp)
    	sw $t5, 36($sp)
    	sw $ra, 40($sp)
    	
    	move $a0, $t0	#move fd into $a0
    	move $a1, $t3	#move newValue into $a1
    	jal itof
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $t2, 24($sp)
    	lw $t3, 28($sp)
    	lw $t4, 32($sp)
    	lw $t5, 36($sp)
    	lw $ra, 40($sp)
    	addi $sp, $sp, 44
    	#pseudo:	write(fd, "\n", 1);
    	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
    	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, newline_string
	li $a2, 1
	syscall
    	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	#pseudo:	write(fd, "Parent index: ", 14);
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, parent_index_str
	li $a2, 14
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	#pseudo:	itof(fd, parentIndex);
	addi $sp, $sp, -44
  	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $t2, 24($sp)
    	sw $t3, 28($sp)
    	sw $t4, 32($sp)
    	sw $t5, 36($sp)
    	sw $ra, 40($sp)
    	move $a0, $t0
    	move $a1, $t4	#move parentIndex
    	
    	jal itof
    	
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $t2, 24($sp)
    	lw $t3, 28($sp)
    	lw $t4, 32($sp)
    	lw $t5, 36($sp)
    	lw $ra, 40($sp)
    	addi $sp, $sp, 44
    	
    	#pseudo:	write(fd, "\n", 1);
    	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, newline_string
	li $a2, 1
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	#pseudo:	write(fd, "Left (0) or right (1): ", 23);
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, left_or_right_str
	li $a2, 23
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	
	#pseudo:	itof(fd, leftOrRight);
	addi $sp, $sp, -44
  	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $t2, 24($sp)
    	sw $t3, 28($sp)
    	sw $t4, 32($sp)
    	sw $t5, 36($sp)
    	sw $ra, 40($sp)
    	
    	move $a0, $t0
    	move $a1, $t5	#move leftOrRight into $a1
	
	jal itof
	
	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $t2, 24($sp)
    	lw $t3, 28($sp)
    	lw $t4, 32($sp)
    	lw $t5, 36($sp)
    	lw $ra, 40($sp)
    	addi $sp, $sp, 44
    	#pseudo:	write(fd, "\n\n", 2);
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	li $v0, 15
	move $a0, $t0	#move fd
	la $a1, newline_str_2
	li $a2, 2
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
    	#pseudo:	add_node(nodes, rootIndex, newValue, newIndex, flags, maxSize);
	addi $sp, $sp, -44
	sw $a1, 0($sp)
	sw $a3, 4($sp)
	sw $a2, 8($sp)
	sw $a0, 12($sp)
	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $t2, 24($sp)
    	sw $t3, 28($sp)
    	sw $t4, 32($sp)
    	sw $t5, 36($sp)
    	sw $ra, 40($sp)
	move $a1, $a2
	move $a2, $t3
	move $a3, $t2
	
	jal add_node
	
	lw $a1, 0($sp)
	lw $a3, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $t2, 24($sp)
    	lw $t3, 28($sp)
    	lw $t4, 32($sp)
    	lw $t5, 36($sp)
    	lw $ra, 40($sp)
	
	addi $sp, $sp, 44
	
	#DEFINE:	$a0= Node[] nodes
    	#		$a1= int maxSize
    	#		$a2= int rootIndex
    	#		$a3= byte[] flags
    	#		$t0= int fd	ON STACK
    	#		$t1=int seed	ON STACK
    	#		$t2 = newIndex
    	#		$t3 = newValue
    	#move $t4, $v0	#parentIndex
    	#move $t5, $v1	#leftOrRight
	
	#pseudo:	newIndex = linear_search(flags, maxSize);
	addi $sp, $sp, -36
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	sw $t5, 28($sp)
	sw $ra, 32($sp)
	move $a0, $a3
	jal linear_search
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	lw $t4, 24($sp)
	lw $t5, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	move $t2, $v0	#move to newIndex
	
    	bne $t2, -1, add_rand_while_loop
    	
    add_rand_while_loop_exit:
    	#pseudo:	preorder(address of nodes[rootIndex], nodes, fd);
    	li $t7, 4
    	mul $t7, $t7, $a2
    	add $t7, $t7, $a0	#address of nodes[rootIndex]
    	addi $sp, $sp, -36
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	sw $t5, 28($sp)
	sw $ra, 32($sp)
	
	move $a1, $a0
	move $a0, $t7
	move $a2, $t0
	
	jal preorder
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	lw $t4, 24($sp)
	lw $t5, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	
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
add_rand_extra_credit: .asciiz ""
new_value_str: .asciiz "New value: "
parent_index_str: .asciiz "Parent index: "
left_or_right_str: .asciiz "Left (0) or right (1): "
newline_str_2:	.asciiz "\n\n"
.align 2  # Align next items to word boundary

#place any additional data declarations here

