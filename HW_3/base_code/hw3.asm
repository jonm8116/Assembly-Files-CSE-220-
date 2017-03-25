##############################################################
# Homework #3
# name: MY_NAME
# sbuid: MY_SBU_ID
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
    #Define your code here
    la $t0, 0xffff0000	#starting address of board
    la $t3, 0xffff00c7 #end of board
    li $t1, '\0' #value of null ascii char
    li $t2, 15 	 #value for default color (black background, color foreground)
    #create value for yellow
    
	reset_loop:
		sb $t1, ($t0)
		addi $t0, $t0, 1
		sb $t2, ($t0)
		beq $t0, $t3, smiley_eyes
		addi $t0, $t0, 1
		#beq $t0, $t3, smiley_eyes
		j reset_loop
    	smiley_eyes:
    		#insert values for eyes
    		#first part of left eye
    		la $t0, 0xffff002e
    		li $t1, 'b'
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		li $t2, 183
    		sb $t2, ($t0)
    		#second part of left eye
    		la $t0, 0xffff0042
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#first part of right eye
    		la $t0, 0xffff0034
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#second part of right eye
    		la $t0, 0xffff0048
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		j smiley_mouth
    	smiley_mouth:
    		#mouth 1
    		la $t0, 0xffff007c
    		li $t1, 'e'	#char value
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		li $t2, 31 	#color value
    		sb $t2, ($t0)
    		#mouth 2
    		la $t0, 0xffff0092
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#mouth 3
    		la $t0, 0xffff00a8
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#mouth 4
    		la $t0, 0xffff00aa
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#mouth 5
    		la $t0, 0xffff0098
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		#mouth 6
    		la $t0, 0xffff0086
    		sb $t1, ($t0)
    		addi $t0, $t0, 1
    		sb $t2, ($t0)
    		
    	
	jr $ra
##############################
# PART 2 FUNCTIONS
##############################

open_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    li $a1, 0 		#load in flag value (read only)
    li $a2, 0		#load in mode 
    li $v0, 13 		#load in value for syscall
    syscall
    #use $s0 to hold file descriptor?
    #actually already done in main
    
    ###########################################
    jr $ra

close_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    li $v0, 16 		#load sin value for close file syscall
    syscall
    ###########################################
    jr $ra

load_map:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    #jal open_file
    move $t0, $v0	#place file descriptor in $t0
    move $a0, $t0
    li $t0, 0
    li $t1, 0 
    li $t2, 0
    li $t3, 0
    read_from_file:
    #DEFINE VALUES:
    #$t0 = address of buffer string 
    #$t3 = where to store the java sum value
    	la $a1, load_map_buf_string
    	li $a2, 1		#max num of chars to read in at a time
    	li $v0, 14
    	syscall 
    	
    	beq $v0, $zero, load_map_after_file #check value of syscall
    	blt $v0, $zero, load_map_error
    	la $t0, load_map_buf_string	#[DEBUG]used to check what the value in the buffer screen is
    	lb $t1, 0($t0)		#the syscall places the char in the string buffer
    	blt $t1, '0', load_map_ignore
    	bgt $t1, '9', load_map_ignore
    	#move $a0, $t4		#to store the next letter that is read from the file
    				#then increment the pointer and add in a pair	
    	#java algorithm: sum = (sum * 10) + (char - ’0’)
    	#ascii value to use - '0' 
    	li $t2, -48 	#value of -'0'
    	add $t1, $t1, $t2 #(char - '0')
    	li $t4, 10
    	mul $t3, $t3, $t4 #(sum * 10)
    	add $t3, $t3, $t1 #(sum * 10) + (char - '0')
    	j read_from_file
    	
    load_map_ignore:	#ignore invalid char & jumpback
    	j read_from_file	
    load_map_after_file:
    	#DEFINE:
    	#$t1 = counter
    	#$t2 = 10
    	#$t3 = holds sum value (all digits from file)
    	#$t4 = will hold result of dividing by 10 
    	li $t1, 0
    	move $t4, $t3	#hold the value of $t3 (sum)
    	load_map_check_even_loop:
    		li $t2, 10	#now need to load
    		#$t3 holds the coordinates of the bomb space. Now to retrieve it
    		#Check FIRST condition: even num of digits in file
    		div $t4, $t2
    		mflo $t4
    		addi $t1, $t1, 0
    		beqz $t4, load_map_check_even
    		j load_map_check_even_loop
    	load_map_check_even:
    		li $t2, 2
    		div $t1, $t2
    		mfhi $t4
    		bnez $t4, load_map_error
    	load_map_arr_clear_bytes:
    		#DEFINE: $t0 = address of array
    		la $t0, cells_array
    		li $t1, 0	#used to clear byte values in arr
    		li $t2, 1 	#counter for loop
    		load_map_arr_clear_bytes_loop:
    			sb $t1, 0($t0)
    			addi $t0, $t0, 1
    			addi $t2, $t2, 1
    			beq $t2, 100, load_map_arr_continue
    			j load_map_arr_clear_bytes_loop
    	load_map_arr_continue:
    		#DEFINE: 
    		#	 $t0 = address of array
    		#	 $t1 = 10
    		#	 $t2 = (temp value) to hold sum
    		#	 $t3 = holds sum value of all coordinates
    		#	 $t4 = COLUMN value
    		# 	 $t5 = ROW value
    		#	 $t6 = coordinate address of bomb
    		#	 $t7 = decimal value for bomb byte
    		la $t0, cells_array
    		li $t1, 10
    		li $t6, 0
    		li $t7, 32 	#decimal value for bomb byte
    		move $t2, $t3	#use $t3 as temp value to save sum value
    		load_map_set_mines:
    			la $t6, cells_array #have address to create starting point
    			div $t2, $t1
    			mfhi $t4	#hold column value
    			mflo $t2	#move new quotient without column value
    			div $t2, $t1
    			mfhi $t5	#hold row value
    			mflo $t2 
    			mul $t5, $t5, $t1 #multiply row value by 10 (to go to proper address)
    			add $t6, $t6, $t5 #used to go to proper row address
    			add $t6, $t6, $t4 #used to go to column value
    			sb $t7, ($t6)	  #place mine at memory address
    			beqz $t2, set_mines_finish
    			j load_map_set_mines
    	set_mines_finish:
    		#Now need to load in the state of the rest of the mines
    		#Define values: $t0 = address of array
    		#		$t6 = temp address
    		#		$t1 = 
    		la $t6, cells_array
    		set_board_1:
    			
    	
    	jr $ra 	
    load_map_error:

    ###########################################
	jr $ra
	
     fill_default_boxes:
     	

##############################
# PART 3 FUNCTIONS
##############################

init_display:
    #Define your code here
    jr $ra

set_cell:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ###########################################
    jr $ra

reveal_map:
    #Define your code here
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
    #Define your code here
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cells_array: .space 100
cursor_row: .word -1
cursor_col: .word -1

#place any additional data declarations here
load_map_buf_string: .asciiz ""
load_map_coordinate_string: .asciiz "  "
