##############################################################
# Homework #2
# name: Jonathan Mathai
# sbuid: 110320715
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

atoui:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, 0
	j atoui_loop
	############################################
	#jr $ra
atoui_loop:
	li $t4, 0 #reset counter for if statement
	lb $t2, 0($a0) #load in first character 
	addi $a0, $a0, 1 #used to go through 
	#store if-statement values in $t3 to check both conditions
	#Then add these values to $t4, if its true it will be 2
	#else it will be less then just jump back to original program
	slti $t3, $t2, 58 #57 is the value of 
	add $t4, $t4, $t3
	li $t5, '0'
	sge $t3, $t2, $t5 	#to keep track of both statements
	add $t4, $t4, $t3	
	blt $t4, 2, atoui_jumpback #branch back if $t4 counter ==2
	#java algorithm: sum = (sum * 10) + (char - ’0’)
	#values used
	#$v0 = sum register 
	#$t5 = 10 
	#$t3 = '0' (-48)
	#$t2 = ascii char
	#$t4 = counter for prior if statement
	li $t5, 10
	li $t3, -48
	mul $v0, $t5, $v0 #stores value of sum in $v0
	add $t7, $t2, $t3
	add $v0, $v0, $t7 #adding two parantheses in sum algorithm
	
	beq $t4, 2, atoui_loop #loopback to top	
	jr $ra		#jumpback to original program
atoui_jumpback:
	jr $ra #jumpback to original program
uitoa:
    #Define your code here
    li $v0, 0
    li $v1, 0
    li $t4, 0
    #Don't transfer values from $a registers
    #will take up more space
    blt $a0, 1, uitoa_jumpback_pre
    la $t3, ($a0)	#load in value for $t3
    j uitoa_check_input_size
    #jr $ra
uitoa_check_input_size:
	#load in the value from $a0
	#$t3 = value in $a0
	li $t0, 10
	div $t3, $t0
	mflo $t3
	addi $t4, $t4, 1		#increment counter 
	bne $t3, 0, uitoa_check_input_size  #used to loop back to label
	bgt $t4, $a2, uitoa_jumpback_pre
	la $t3, ($a0)
	li $t5, 0 #set $t5 to zero so that it fresh for the next label
	beq $t3, 0, uitoa_loop_main

uitoa_reverse_int:
	#$t3 contains value of int (use $t5 to hold reversed)
        #define values:
        #$t3 = int value
        #$t5 = hold reverse (make sure its zero)
        #$t0 = 10
        #$t2 = extra storage space
        mul $t5, $t5, $t0 #
        div $t3, $t0
        mfhi $t2 #holds value of the mod
        add $t5, $t5, $t2 #adds mod value to 
        mflo $t3
        bne $t3, 0, uitoa_reverse_int
        la $t3, ($t5)	#now the reverse value is stored in $t3
        #li $t9,0
        j uitoa_loop_main
        
uitoa_loop_main:
	#define values:
	#$a0 = value 
   	#$t0 = 10
   	#$t1 = remainder (last digit in value)
   	#$t2 = where digit gets stored 
   	#$t4 = counter for num digits in value ($a0)
   	div $t3, $t0	#$lo=quotient	$hi = remainder
   	mflo $t3 	#places the new value (with last value dropped off)
   	mfhi $t1
   	addi $t2, $t1, '0'
   	sb $t2, ($a1)
   	
   	addi $a1, $a1, 1
	bne $t3, 0, uitoa_loop_main
	beq $t3, 0, uitoa_jumpback_post
	
uitoa_jumpback_pre:
	la $v0, 0($a1)  #load return values before jumping back
	li $v1, 0    #unsuccessful (zero)
	jr $ra
uitoa_jumpback_post:
	la $v0, 0($a1)  #load return value
	li $v1, 1    #successful (one)
	jr $ra
##############################
# PART 2 FUNCTIONS 
##############################    
            
decodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0
    li $t3, 0
    #Define values: $t0 = a0 (letter)
    #$t1 = $a1 (runLength)
    #$t2 = $a2 (output)
    #$t3 = counter to check if statements (uppercase) (for alphabetical char)
    #$t4 = arbitrary char ascii value
    #$t5 = another counter check but for lower case
    lb $t0, 0($a0) #there was a zero before
    move $t1, $a1
    move $t2, $a2
    blt $t0, 1, dR_unsuccessful
    
    bgt $t0, 'z', dR_unsuccessful
    blt $t0, 'A', dR_unsuccessful
    ble $t0, 'Z', decodeRun_loop
    bge $t0, 'a', decodeRun_loop
    j dR_unsuccessful
    # bgt 122, not alphanumeric ('z')
    # blt 65, not alphanumeric ('A')
    # ble 90, alphanumeric ('Z')
    # bge 97, alphanumeric ('a')
    # NOTaLPHANUMERIC:
    # alphanumeric
    bne $t3, 2, dR_unsuccessful
    #Ugh come back to this
    li $t3, 0
    j decodeRun_loop
	
decodeRun_loop:
	#Define values: $t0 = a0 (letter)
	#$t1 = $a1 (runLength)
    	#$t2 = $a2 (output)
    	#$t3 = counter for loop
    	sb $t0, 0($a2)
    	addi $a2, $a2, 1 #keep adding on to string
    	addi $t3, $t3, 1
    	beq $t3, $a1, dR_success
    	bne $t3, $a1, decodeRun_loop #looping back condition
    	
dR_success:
	la $v0, ($a2)
	li $v1, 1
	jr $ra
dR_unsuccessful:
	la $v0, ($a2)
	li $v1, 0
	jr $ra

decodedLength:
    #Define your code here
    li $v0, 0
    li $v1, 0
    move $t0, $a0 #load in input
    move $t1, $a1 #load in flag value
    lb $t1, 0($t1) #used to try to get ascii value
    li $t2, 0	#use $t2 as counter
    # !#$%ˆ&*
    beq $t1, '!', decodedLength_first_counter	#check if flag is valid
    beq $t1, '#', decodedLength_first_counter
    beq $t1, '$', decodedLength_first_counter
    beq $t1, '%', decodedLength_first_counter
    beq $t1, '&', decodedLength_first_counter
    beq $t1, '*', decodedLength_first_counter 
    beq $t1, '@', decodedLength_first_counter
    
    #remember to create condition for if flag is alpha numeric char
    #then you must exit
    j dL_finish_zero
    #jr $ra
decodedLength_first_counter:
	#define values: $t0=input
	#$t1 = flag value
	#$s2 = counter
	#$t3 = store each char
	lb $t3, ($t0)
	addi $t0, $t0, 1
	beq $t3, $t1, dL_flagCaught
	addi $s2, $s2, 1
	bne $t3, 0, decodedLength_first_counter
	j dL_finish #after finish running through string
	#jr $ra

dL_flagCaught:
	#remember the counter is stored in $t2 DO NOT USE
	#before calling atoui need to store values onto the stack
	#values to store: $s2 = counter for letters(4 bytes)
	#$s3 = counter for flags caught (maybe use this?)
	#$ra = return address (4 bytes)
	#$a0 = input (4 bytes)
	#$a1 = flag char (1 byte)
	#$t0 = used input value
	addi $s3, $s3, 1 #increment num flags counter
	addi $t0, $t0, 1 #skip to next letter (in used input value)
	addi $sp, $sp, -16
	sw $t0, 12($sp) #load input value
	sw $s2, 8($sp) #store counter
	sw $ra, 4($sp) #store dL return address
	sw $a0, 0($sp) #store input
	move $a0, $t0  #put in rest of input into the arg register
	jal atoui	#calls atoui
	
	lw $t0, 12($sp) #load used input value
	lw $s2, 8($sp) #load counter
	lw $ra, 4($sp) #load dL return address
	lw $a0, 0($sp) #load input
	
	addi $sp, $sp, 16 #stated 12 before for putting back the stack pointer 
			  #THIS ONE MISTAKE WITH THE STACK POINTER
			  #COST YOU AN HOUR........
			  #Be careful next time
	move $t1, $v0 #put return value (the sum returned) in $t1
	#move $t1, $a1
	add $s2, $s2, $t1 #increase counter for letters
	
	j decodedLength_first_counter
	
dL_finish:
	beqz $s3, dL_finish_zero
	addi $s2, $s2, 1
	la $v0, ($s2)
	#Go back and check some things for this method
	jr $ra
	
dL_finish_zero: 
	li $v0, 0
	jr $ra
         
runLengthDecode:
    #Define your code here
    li $v0, 0
    #clear values
    #define values: $t0 = $a0 (input char[])
    #$t1 = $a1 (output char[])
    #$t2 = $a2 (outputsize int)
    #$t3 = $a3 (runFlag char)
    addi $sp, $sp, -20
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp) #char flag
    sw $ra, 0($sp)
    #PREPARE TO JUMP
    move $a1, $a3 #load char flag and jump
    li $s2, 0 #reset counter for $s2 in decoded length
    jal decodedLength #returns num bytes needed (unless its 0)
    move $t4, $v0
    lw $ra, 0($sp)
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    #lw $a0, 16($sp)
    #lw $a1, 12($sp)
    #lw $a2, 8($sp)
    #lw $a3, 4($sp) #char flag
    #lw $ra, 0($sp)
    addi $sp, $sp, 20
    blt $a2, $t4, rL_unsuccessful
    #move arg values into temp registers
    #insert after returning from method call
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3
    #check if char flag is alpha numeric char
    bgt $a3, 'z', rL_first_loop
    blt $a3, 'A', rL_first_loop
    ble $a3, 'Z', decodeRun_loop
    bge $a3, 'a', decodeRun_loop
    
rL_first_loop:
	#define values: $t0 = $a0 (input char[])
	#$t1 = $a1 (output char[])
	#$t2 = $a2 (outputsize int)
    	#$t3 = $a3 (runFlag char)
    	#$t4 = where to store char value
	lb $t4, ($t0)
	addi $t0, $t0, 1
	beq $t4, $a3, rL_pre_flagCaught
	bne $t4, 0, rL_first_loop
	
rL_pre_flagCaught:
	#lb $s1, ($t0) #store compressed letter value
	addi $t0, $t0, 1
	
rL_flagCaught:
	#values to hold onto
	#$s1 = compressed letter	$t6 = hold num char value
	#$t1 = $a1 (output char[])	$t7 = count 4 if statement
	#$t5 = hold arbitrary value			
	lb $t5, ($t1)
	addi $t1, $t1, 1
	#li $t6, '0'
	#sge $t7, $t5, $t6 #compares to see if greater than 
	#add $t7, $t7, $0
	#li $t6, '9'
	#sle $t6, $t5, $t6 #if $t7 is value of 2 then its 
	#add $t7, $t7, $t6 # a numeric character
	#PREPARE TO JUMP
	addi $sp, $sp, -24
	#sw $t4, 24($sp)
	sw $t1, 20($sp)
    	sw $a0, 16($sp)
    	sw $a1, 12($sp)
    	sw $a2, 8($sp)
    	sw $a3, 4($sp) #char flag
    	sw $ra, 0($sp)
    	#NOW REALLY TO PREPARE TO JUMP
    	la $a0, ($t0) #$t1 before
    	jal atoui
    	move $t6, $v0
    	#lw $t4, 24($sp)
	lw $t1, 20($sp)#loaded back
    	lw $a0, 16($sp)
    	lw $a1, 12($sp)
    	lw $a2, 8($sp)
    	lw $a3, 4($sp) #char flag
    	lw $ra, 0($sp)
    	addi $sp, $sp, 28
    	#PREPARE TO JUMP FOR DECODE RUN
    	addi $sp, $sp, -28
    	#sw $t4, 28($sp)
	sw $t6, 24($sp)
    	sw $t1, 20($sp)
    	sw $a0, 16($sp)
    	sw $a1, 12($sp)
    	sw $a2, 8($sp)
    	sw $a3, 4($sp) #char flag
    	sw $ra, 0($sp)
    	#load arguments into registers
    	addi $t0, $t0, -2
    	#la $a0, ($s1)
    	la $a0, ($t0)
    	la $a2, ($a1)#had $a2 before, might have just been a typo    	
    	la $a1, ($t6)
    	jal decodeRun
    	
    	#lw $t4, 28($sp)
    	lw $t6, 24($sp)	#load back in values from stack
    	lw $t1, 20($sp)
    	lw $a0, 16($sp)
    	lw $a1, 12($sp)
    	lw $a2, 8($sp)
    	lw $a3, 4($sp) #char flag
    	lw $ra, 0($sp)
    	addi $sp, $sp, 32
    	move $t2, $v0
    	
    	#beqz $t4, rL_successful
    	#j rL_first_loop
    	
rL_successful:
	li $v0, 1
	#sb $0, ($a1)
	jr $ra
    	
rL_unsuccessful:
	li $v0, 0
	jr $ra


##############################
# PART 3 FUNCTIONS 
##############################
    #encoding should be zero if:
    # (i) letter is a non-alphabetical character, or 
    #(ii) runFlag is an alphanumeric character, or 
    #(iii) runLength ? 0,             
encodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0
    li $t0, 0 
    li $t1, 0 
    li $t2, 0
    li $t3, 0
    #define values
    #$t0= char letter, 
    #$t1= int runLength, 
    #$t2= char[] output,
    #$t3= char runFlag
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3
    lb $t4, 0($t0) #load in first
    blt $t4, 'A', encodeRun_pre_end
    bgt $t4, 'z', encodeRun_pre_end
    ble $t4, 'Z', encodeRun_first_part
    bge $t4, 'a', encodeRun_first_part
    #check flags
    beq $t3, '!', encodeRun_first_part	#check if flag is valid
    beq $t3, '#', encodeRun_first_part
    beq $t3, '$', encodeRun_first_part
    beq $t3, '%', encodeRun_first_part
    beq $t3, '&', encodeRun_first_part
    beq $t3, '*', encodeRun_first_part
    beq $t3, '@', encodeRun_first_part
    #if runlength is negative
    blt $t1, 1, encodeRun_pre_end
    j encodeRun_pre_end 
    
encodeRun_first_part:
	blt $t1, 4, encodeRun_add_on
	#jal uitoa 
	#move $t0, $t2	#move the string ascii of the integer value
	lb $t1, 0($a3)	#load the runFlag	$t0= string digit
	#la $t2, ($a0)	#			$t1 = runFlag	$t3 = char letter
	lb $t3, ($a0)
	move $t5, $a2
	#lb $t3, ($t2)	#load in the char letter into the register
	#store bytes into $t4
	
	sb $t1, ($t5) 
	addi $t5, $t5, 1
	sb $t3, ($t5)
	addi $t5, $t5, 1
	
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	la $a0, ($a1) #$t1
	la $a1, ($t5)
	li $a2, 3
	
	jal uitoa
	
	move $t0, $v0
	#addi $t0, $t0, -1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	#sb $t0, 2($a2)
	j encodeRun_finish
	#have an iterator to go through loop

encodeRun_add_on:
	li $t4, 0
	lb $t0, ($t0)
	
encodeRun_add_on_loop:
	sb $t0, ($a2)
	addi $a2, $a2, 1
	addi $t4, $t4, 1
	bne $t4, $t1, encodeRun_add_on_loop
	
encodeRun_add_on_finish:
	la $v0, ($a2)
	li $v1, 1
	jr $ra	
	
encodeRun_pre_end:
	la $v0, ($a2) #load address of output
	li $v1, 0
	jr $ra 
encodeRun_finish:
	la $v0, ($t0) 	# was ($a2) before
	li $v1, 1
	jr $ra


encodedLength:
    #Define your code here
    li $v0, 0
    #define values: $t0 = $a0
    #$t1 = load each char value(first)
    #$t2 = load (second) char value
    #$t3 = counter for specfic char loop
    #$t4 = overall counter
    li $t1, 0	#beginning of encodedLength
    li $t2, 0
    li $t3, 0
    li $t4, 0
    move $t0, $a0
    lb $t1, 0($t0)
    beqz $t1, encodedLength_empty_string
encodedLength_loop:
	lb $t1, 0($t0)
	addi $t3, $t3, 1 #increment counter
	lb $t2, 1($t0)	
	beqz $t1, encodedLength_finish #finish loop
	addi $t0, $t0, 1 #go through char[]
	bne $t1, $t2, encodedLength_change_letter
	j encodedLength_loop
encodedLength_change_letter:
	blt $t3, 4, encodedLength_just_add #jump back to original loop if 
				       #value of counter is less than 4
				       #don't need to encode
	blt $t3, 10, encodedLength_single_digit 
	blt $t3, 100, encodedLength_double_digit
	blt $t3, 1000, encodedLength_triple_digit
encodedLength_just_add:
	add $t4, $t4, $t3	#doesn't need to be encoded. Jump back
	li $t3, 0
	j encodedLength_loop
encodedLength_single_digit:
	addi $t4, $t4, 3	#only need 3. (e.g. dddddd-> !d6)
	li $t3, 0
	j encodedLength_loop
encodedLength_double_digit:
	addi $t4, $t4, 4	
	li $t3, 0
	j encodedLength_loop
encodedLength_triple_digit:
	addi $t4, $t4, 5
	li $t3, 0
	j encodedLength_loop
encodedLength_finish:
	addi $t4, $t4, 1 #to correct value
	la $v0, ($t4)
	jr $ra
encodedLength_empty_string:
	li $v0, 0
	jr $ra

runLengthEncode:
    #Define your code here
    li $v0, 0
    #move values from args into temp registers
    #$t0= char[] input, 
    #$t1 = char[] output, 
    #$t2= int outputSize
    #$t3= char runFlag
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3
    #check flags
    beq $t3, '!', encodeRL_call_encode_length	#check if flag is valid
    beq $t3, '#', encodeRL_call_encode_length
    beq $t3, '$', encodeRL_call_encode_length
    beq $t3, '%', encodeRL_call_encode_length
    beq $t3, '&', encodeRL_call_encode_length
    beq $t3, '*', encodeRL_call_encode_length
    beq $t3, '@', encodeRL_call_encode_length
    j encodeRL_unsuccessful
    
encodeRL_call_encode_length:
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	#PREPARE TO JUMP
	jal encodedLength
	#place return value in $t5
	move $t5, $v0
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	#$t0= char[] input, 
   	#$t1 = char[] output, 
    	#$t2= int outputSize
    	#$t3= char runFlag
    	move $t0, $a0
    	move $t1, $a1
    	move $t2, $a2
    	move $t3, $a3
    	li $t7, 0
	bgt $t5, $a2, encodeRL_unsuccessful 

encodeRL_first_loop:
	lb $t4, ($t0)
	lb $t6, 1($t0)
	addi $t0, $t0, 1
	addi $t7, $t7, 1
	bne $t4, $t6, encodeRL_main_loop
	bne $t4, 0, encodeRL_first_loop

encodeRL_main_loop:
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	move $a2, $a1
	move $a1, $t7
	jal encodeRun
	move $t8, $a2
	move $t9, $a0
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)	
	addi $sp, $sp, 20
	move $a1, $t8
	
	li $t7, 0
	j encodeRL_first_loop
	
encodeRL_unsuccessful:
	li $v0, 1
	jr $ra
.data 
.align 2

