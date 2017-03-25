##############################################################
# Homework #3
# name: Jonathan Mathai
# sbuid: 110320715
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
    move $t9, $a1	#place address of the array in $t9
    
    move $t0, $v0	#place file descriptor in $t0
    move $a0, $t0
    li $t0, 0
    li $t1, 0 
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    
    load_map_arr_clear_bytes:
    		#DEFINE: $t0 = address of array
    		la $t0, ($t9)
    		li $t1, 0	#used to clear byte values in arr
    		li $t2, 1 	#counter for loop
    		load_map_arr_clear_bytes_loop:
    			sb $t1, 0($t0)
    			addi $t0, $t0, 1
    			addi $t2, $t2, 1
    			beq $t2, 100, read_from_file
    			j load_map_arr_clear_bytes_loop
    
    read_from_file:
    #DEFINE VALUES:
    #$t0 = address of buffer string 
    #$t3 = where to store the java sum value
    	la $a1, load_map_buf_string
    	li $a2, 1		#max num of chars to read in at a time
    	li $v0, 14
    	syscall 
    	
    	#Changed label location
    	beq $v0, $zero, set_mines_finish #check value of syscall
    	blt $v0, $zero, load_map_error
    	la $t0, load_map_buf_string	#[DEBUG]used to check what the value in the buffer screen is
    	lb $t1, 0($t0)		#the syscall places the char in the string buffer
    	
    	#ADD CHECK FOR ALPHA Chars. IF SO SKIP FILE
    	
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
    	#Define counter so that it can keep track if two 
    	addi $t5, $t5, 1	#used to increment check counter 
    	beq $t5, 2, load_map_arr_continue
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
    		#	 $t8 = (TWO COUNTER) keep track if 2 digits were read in
    		la $t0, ($t9)
    		li $t1, 10
    		li $t6, 0
    		li $t7, 32 	#decimal value for bomb byte
    		move $t2, $t3	#use $t3 as temp value to save sum value
    		load_map_set_mines:
    			la $t6, ($t9) #have address to create starting point
    			#div $t2, $t1
    			#mfhi $t4	#hold column value
    			#mflo $t2	#move new quotient without column value
    			#div $t2, $t1
    			#mfhi $t5	#hold row value
    			#mflo $t2 
    			#mul $t5, $t5, $t1 #multiply row value by 10 (to go to proper address)
    			#add $t6, $t6, $t5 #used to go to proper row address
    			#add $t6, $t6, $t4 #used to go to column value
    			add $t6, $t6, $t2
    			sb $t7, ($t6)	  #place mine at memory address
    			
    			
    			set_mines_jumpback:
    				li $t3, 0	#clear sum
    				li $t5, 0	#clear two counter in read_file
    				j read_from_file
    			
    	set_mines_finish:
    		#Now need to load in the state of the rest of the mines
    		#Define values: $t0 = load byte at current address
    		#		$t5 = holds current address
    		#		$t6 = address of array
    		#		$t1 = (X) cursor
    		# 		$t2 = (Y) cursor 
    		#		$t3 = value of loaded byte from array
    		#		$t4 = mine counter
    		la $t6, ($t9)
    		li $t1, 0	# X cursor
    		li $t2, 0	# Y cursor
    		li $t4, 0	# mine counter
    		
    		check_mine:
    			beq $t1, 10, load_map_finish
    			lb $t3, ($t6)
    			bgt $t3, 31, set_board_1
    			addi $t6, $t6, 1
    			addi $t2, $t2, 1
    			beq $t2, 10, new_row
    			j check_mine
    			
    		
    		set_board_1:
    			#check all edge cases of board

    			beq $t1, 10, load_map_finish
    			blt $t1, 1, set_board_top_row_edge # (X-1)<0
    			blt $t2, 1, set_board_L_column # (Y-1)<0
    			bgt $t2, 8, set_board_R_column #(Y+1)>9
    			bgt $t1, 8, set_board_bottom_row_edge #(X+1) > 9
    			#first check to see if given box is a mine
    			lb $t3, ($t6)	#load in byte from array
    			#beq $t3, 32, add_one_for_mine 
    			j add_one_for_mine 
    			#addi $t2, $t2, 1	
    			#beq $t2, 10, new_row
    			j check_mine
    			    			
    		set_board_top_row_edge:
    			blt $t2, 1, set_board_top_L_corner
    			bgt $t2, 9, set_board_top_R_corner #(Y+1)>9
    			lb $t3, ($t6) 
    			beq $t3, 32, set_board_top_row_mine
    			addi $t2, $t2, 1	#increment y
    			beq $t2, 10, new_row	#jump to new row label
    			j check_mine		#jump back to top of loop
    			
    			set_board_top_row_mine:
    				#Right square
    				la $t5, ($t6) 		#load in current address into $t5
    				addi $t5, $t5, 1	#add to Right
    				lb $t0, ($t5)
    				addi $t0, $t0, 1	#increment right by one
    				sb $t0, ($t5)
    				#Left square 
    				la $t5, ($t6)
    				addi $t5, $t5, -1
    				lb $t0, ($t5)	
    				addi $t0, $t0, 1	#increment left
    				sb $t0, ($t5)
    				#Bottom square
    				la $t5, ($t6)
    				addi $t5, $t5, 10	#go to bottom square
    				lb $t0, ($t5)		#get byte from memory address
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#bottom left square 
    				la $t5, ($t6)
    				addi $t5, $t5, 9
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#bottom right square
    				la $t5, ($t6)
    				addi $t5, $t5, 11
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    				    				    				
    			set_board_top_L_corner:
    				#Right square
    				la $t5, ($t6) 		#load in current address into $t5
    				addi $t5, $t5, 1	#add to Right
    				lb $t0, ($t5)
    				addi $t0, $t0, 1	#increment right by one
    				sb $t0, ($t5)
    				#Bottom square
    				la $t5, ($t6)
    				addi $t5, $t5, 10	#go to bottom square
    				lb $t0, ($t5)		#get byte from memory address
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#bottom right square
    				la $t5, ($t6)
    				addi $t5, $t5, 11
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    				
    			set_board_top_R_corner:
    				#Left square 
    				la $t5, ($t6)
    				addi $t5, $t5, -1
    				lb $t0, ($t5)	
    				addi $t0, $t0, 1	#increment left
    				sb $t0, ($t5)
    				#Bottom square
    				la $t5, ($t6)
    				addi $t5, $t5, 10	#go to bottom square
    				lb $t0, ($t5)		#get byte from memory address
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#bottom left square 
    				la $t5, ($t6)
    				addi $t5, $t5, 9
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    		
    		set_board_L_column:
    			#Right square
    			la $t5, ($t6) 		#load in current address into $t5
    			addi $t5, $t5, 1	#add to Right
    			lb $t0, ($t5)
    			addi $t0, $t0, 1	#increment right by one
    			sb $t0, ($t5)
    			#Bottom square
    			la $t5, ($t6)
    			addi $t5, $t5, 10	#go to bottom square
    			lb $t0, ($t5)		#get byte from memory address
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top square
    			la $t5, ($t6)
    			addi $t5, $t5, -10
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5) 
    			#top right square
    			la $t5, ($t6)
    			addi $t5, $t5, -9
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#bottom right square
    			la $t5, ($t6)
    			addi $t5, $t5, 11
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			
    			addi $t2, $t2, 1	#increment column counter
    			beq $t2, 10, new_row	#goes to new row
    			addi $t6, $t6, 1
    			j check_mine	
    			
    		set_board_R_column:
    			#Left square 
    			la $t5, ($t6)
    			addi $t5, $t5, -1
    			lb $t0, ($t5)	
    			addi $t0, $t0, 1	#increment left
    			sb $t0, ($t5)
    			#Bottom square
    			la $t5, ($t6)
    			addi $t5, $t5, 10	#go to bottom square
    			lb $t0, ($t5)		#get byte from memory address
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top square
    			la $t5, ($t6)
    			addi $t5, $t5, -10
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top left square
    			la $t5, ($t6)
    			addi $t5, $t5, -11
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#bottom left square 
    			la $t5, ($t6)
    			addi $t5, $t5, 9
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    		
    			addi $t2, $t2, 1	#increment column counter
    			beq $t2, 10, new_row	#goes to new row
    			addi $t6, $t6, 1
    			j check_mine
    		
    		set_board_bottom_row_edge:
    			blt $t2, 1, set_board_bottom_L_corner
    			bgt $t2, 9, set_board_bottom_R_corner #(Y+1)>9
    			lb $t3, ($t6) 
    			beq $t3, 32, set_board_bottom_row_mine
    			addi $t2, $t2, 1	#increment y
    			beq $t2, 10, new_row	#jump to new row label
    			j set_board_1		#jump back to top of loop
    			
    			set_board_bottom_row_mine:
    				#Right square
    				la $t5, ($t6) 		#load in current address into $t5
    				addi $t5, $t5, 1	#add to Right
    				lb $t0, ($t5)
    				addi $t0, $t0, 1	#increment right by one
    				sb $t0, ($t5)
    				#Left square 
    				la $t5, ($t6)
    				addi $t5, $t5, -1
    				lb $t0, ($t5)	
    				addi $t0, $t0, 1	#increment left
    				sb $t0, ($t5)
    				#top left square
    				la $t5, ($t6)
    				addi $t5, $t5, -11
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#top right square
    				la $t5, ($t6)
    				addi $t5, $t5, -9
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    			
    			set_board_bottom_L_corner:
    				#Right square
    				la $t5, ($t6) 		#load in current address into $t5
    				addi $t5, $t5, 1	#add to Right
    				lb $t0, ($t5)
    				addi $t0, $t0, 1	#increment right by one
    				sb $t0, ($t5)
    				#top square
    				la $t5, ($t6)
    				addi $t5, $t5, -10
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				#top right square
    				la $t5, ($t6)
    				addi $t5, $t5, -9
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    				
    			set_board_bottom_R_corner: 
    				#Left square 
    				la $t5, ($t6)
    				addi $t5, $t5, -1
    				lb $t0, ($t5)	
    				addi $t0, $t0, 1	#increment left
    				sb $t0, ($t5)	
    				#top left square
    				la $t5, ($t6)
    				addi $t5, $t5, -11
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)	
    				#top square
    				la $t5, ($t6)
    				addi $t5, $t5, -10
    				lb $t0, ($t5)
    				addi $t0, $t0, 1
    				sb $t0, ($t5)
    				
    				addi $t2, $t2, 1	#increment column counter
    				beq $t2, 10, new_row	#goes to new row
    				addi $t6, $t6, 1
    				j check_mine
    		
    		add_one_for_mine:
    			#The current byte held in $t3 holds a mine
    			#Right square
    			la $t5, ($t6) 		#load in current address into $t5
    			addi $t5, $t5, 1	#add to Right
    			lb $t0, ($t5)
    			addi $t0, $t0, 1	#increment right by one
    			sb $t0, ($t5)
    			#Left square 
    			la $t5, ($t6)
    			addi $t5, $t5, -1
    			lb $t0, ($t5)	
    			addi $t0, $t0, 1	#increment left
    			sb $t0, ($t5)
    			#Bottom square
    			la $t5, ($t6)
    			addi $t5, $t5, 10	#go to bottom square
    			lb $t0, ($t5)		#get byte from memory address
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top square
    			la $t5, ($t6)
    			addi $t5, $t5, -10
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top left square
    			la $t5, ($t6)
    			addi $t5, $t5, -11
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#top right square
    			la $t5, ($t6)
    			addi $t5, $t5, -9
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#bottom left square 
    			la $t5, ($t6)
    			addi $t5, $t5, 9
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#bottom right square
    			la $t5, ($t6)
    			addi $t5, $t5, 11
    			lb $t0, ($t5)
    			addi $t0, $t0, 1
    			sb $t0, ($t5)
    			#AFTER FINISHING SET ADJACENT CIRCLE 
    			    			
    			addi $t2, $t2, 1	#increment column counter
    			beq $t2, 10, new_row	#goes to new row
    			addi $t6, $t6, 1
    			j check_mine
    		new_row:
    			addi $t1, $t1, 1	#increment row counter
    			li $t2, 0 		#reset column counter
    			addi $t6, $t6, 1
    			j check_mine		#jumpback 
    	load_map_finish:
    		move $t0, $a1
    		li $t2, 0
    		li $t4, 0
    		li $t5, 10
    		load_map_reset_mines_loop:
    			lb $t2, ($t0)
    			addi $t4, $t4, 1
    			beq $t4, 100, load_map_finish_1
    			bge $t2, 32, reset_mines
    			addi $t0, $t0, 1
    			j load_map_reset_mines_loop
    			reset_mines:
    				li $t3, 32
    				sb $t3, ($t0)
    				addi $t0, $t0, 1
    				j load_map_reset_mines_loop
    		
    		load_map_finish_1:
    		li $v0, 0
    		jr $ra 	
    load_map_error:
	li $v0, -1
    ###########################################
	jr $ra
	
     fill_default_boxes:
     	

##############################
# PART 3 FUNCTIONS
##############################

init_display:
    #Define your code here
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    
    la $t0, 0xffff0000	#starting address of board
    la $t3, 0xffff00c7 #end of board
    li $t1, '\0' #value of null ascii char
    li $t2, 119 	 #value for grey foreground and background
    #create value for yellow
	init_display_loop:
		sb $t1, ($t0)
		addi $t0, $t0, 1
		sb $t2, ($t0)
		beq $t0, $t3, init_display_continue
		addi $t0, $t0, 1
		#beq $t0, $t3, smiley_eyes
		j init_display_loop
    
    init_display_continue:
    	#Load address of both row and col cursor
    	#DEFINE: $t0 = row cursor address
    	#	 $t1 = col cursor address
    	#	 $t2 = row byte value
    	#	 $t3 = col byte value
    	#	 $t4 = offset to cursor address in board
    	#	 $t5 = 10
    	#	 $t6 = address of start of board
    	#	 $t7 = decimal value of binary 
    	# 	 $t8 = '\0'
    	la $t6, 0xffff0000
	li $t5, 10
    	#lw $t2, cursor_row	#origin $t0
    	#lw $t3, cursor_col	# origin $t1
    	li $t0, 0
    	li $t1, 0
    	sw $t0, cursor_row
    	sw $t1, cursor_col
    	#lb $t2, ($t0) #row byte value
    	#lb $t3, ($t1) #col byte value
    	li $t2, 0
    	li $t3, 0
    	mul $t4, $t2, $t5
    	add $t4, $t4, $t3
    	add $t6, $t6, $t4
    	li $t7, 183
    	#sb $t7, ($t6)
    	li $t8, '\0'
    	sb $t8, ($t6)
    	addi $t6, $t6, 1
    	sb $t7, ($t6)
    	
    init_display_finish:
       	jr $ra

set_cell:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    #DEFINE: 	$a0 = row #
    #		$a1 = col #
    #		$a2 = char
    #		$a3 = FG color
    #		$t0 = BG color (loaded from stack)
    #		$t1 = set to address of array
    lw $t0, 0($sp)	#load value from stack
    #should you reset the stack pointer???
    #addi $sp, $sp, 4
    #actually don't think you need to reset the pointer here
    
    blt $a0, 0, set_cell_invalid
    bgt $a0, 9, set_cell_invalid
    blt $a1, 0, set_cell_invalid
    bgt $a1, 9, set_cell_invalid
    blt $a3, 0, set_cell_invalid
    bgt $a3, 15, set_cell_invalid
    blt $t0, 0, set_cell_invalid
    bgt $t0, 15, set_cell_invalid
    
    la $t1, 0xffff0000	#beginning address of board
    li $t2,  10
    li $t3, 2
    mul $a1, $a1, $t3	#col * 2
    mul $a0, $a0, $t2	# row * 10
    mul $a0, $a0, $t3	#row * 2
    add $a0, $a0, $a1	#get offset for address
    add $t1, $a0, $t1	#offsetted address
    sb $a2, ($t1)	#store ascii value
    addi $t1, $t1, 1
    
    #li $t5, 0
    #li $t3, 16	#used to add foreground and background into one value
    #mul $t4, $a3, $t3		#mul $t4, $t0, $t3
    #add $t5, $a3, $t0		#add $t4, $t0, $a3
    #add $t4, $t4, $t5
    sll $t0, $t0, 4
    xor $t4, $a3, $t0
    sb $t4, ($t1)	#store color value in 
    #STILL need to put in the correct color values
    
    set_cell_valid:
    	li $v0, 0
    	jr $ra
    
    set_cell_invalid:
    	li $v0, -1
    	jr $ra
    
    ###########################################
    #jr $ra

reveal_map:
    #Define your code here
    #need to have a loop and create a bunch of branching statements
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    
    la $t0,  0xffff0000
    la $t1,  0xffff00c7
    move $t6, $a1
    #CHECK GAME STATUS
    beq $a0, -1, reveal_map_loop
    beq $a0, 1, go_to_smiley
    beq $a0, 0, reveal_map_loop_finish
    
    #this loop is used to change the reveal bit from 0 to 1
    #this is so that the value on the board can be displayed
    reveal_map_loop:
    	#DEFINE: $a0 = game status(1: won, 0: ongoing, -1: lost)
    	#	 $a1 = array
    	#	 $t0 = beginning address of board
    	#	 $t1 = end addresss of board
    	#	 $t2 = load byte from array into
    	#	 $t3 = row counter
    	#    	 $t4 = col counter 
    	#	 $t5 = ascii or color value
    	#	 $t6 = current address in array
    	#beq $t6, 100, reveal_map_loop_finish
    	beq $t0, $t1, reveal_map_loop_finish
	lb $t2, ($t6)		
	#branch to correct statements
	bge $t2, 32, reveal_map_mine_found	#branch to mine found 
	bge $t2, 16, reveal_map_flag_set	#flag set
	bgt $t2, 0, reveal_map_num_adjacent_mines	#num adjacent mines
	j reveal_map_blank_space
	#sb $t3, ($a0)
	#addi $a0, $a0, 1
	#addi $t4, $t4, 1
	#beq $t4, 100, reveal_map_loop
	reveal_map_increment:
		addi $t0, $t0, 2
		addi $t4, $t4, 1
		beq $t4, 10, reveal_map_new_row
		addi $t6, $t6, 1
		j reveal_map_loop
    	
    	#[ARGS] -> set cell
    	reveal_map_mine_found:
    		#decimal value for ascii char 
    		#li $t5, 'b'
    		#sb $t5, ($t0)
    		#addi $t0, $t0, 1
    		#li $t5, 3
    		#sb $t5, ($t0)
    		#addi $t0, $t0, 1
    		#addi $t3, $t3, 1	#increment col counter
    		#beq $t3, 10, reveal_map_new_row
    		
    		#Need to call set cell and use stack
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, 'b'
    		li $a3, 7
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    	
    	reveal_map_flag_set:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, 'f'
    		li $a3, 12
    		addi $sp, $sp, -32
    		li $t5, 7
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    			    	
    	reveal_map_num_adjacent_mines:
    		#DEFINE: $a0 = game status(1: won, 0: ongoing, -1: lost)
    	#	 $a1 = array
    	#	 $t0 = beginning address of array
    	#	 $t1 = end addresss of array
    	#	 $t2 = load byte from array into
    	#	 $t3 = row counter
    	#    	 $t4 = col counter 
    	#	 $t5 = ascii or color value
    		#lb $t2, ($t0)	#get num value from array (Don't need to do this)
    		beq $t2, 5, reveal_map_adj_mine_0
    		beq $t2, 1, reveal_map_adj_mine_1
    		beq $t2, 2, reveal_map_adj_mine_2
    		beq $t2, 3, reveal_map_adj_mine_3
    	    	beq $t2, 4, reveal_map_adj_mine_4
        	beq $t2, 5, reveal_map_adj_mine_5
    		beq $t2, 6, reveal_map_adj_mine_6
    		beq $t2, 7, reveal_map_adj_mine_7
    		beq $t2, 8, reveal_map_adj_mine_8
    		
    		reveal_map_adj_mine_0:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '0'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_1:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '1'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment	
    		
    		reveal_map_adj_mine_2:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '2'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_3:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '3'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_4:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '4'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_5:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '5'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_6:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '6'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_7:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '7'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    		reveal_map_adj_mine_8:
    		move $a0, $t3
    		move $a1, $t4
    		li $a2, '8'
    		li $a3, 13
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
		
	reveal_map_blank_space:
		move $a0, $t3
    		move $a1, $t4
    		li $a2, '\0'
    		li $a3, 15
    		addi $sp, $sp, -32
    		li $t5, 0
    		sw $t5, 0($sp)
    		sw $t0, 4($sp)
    		sw $t1, 8($sp)
    		sw $t2, 12($sp)
    		sw $t3, 16($sp)
    		sw $t4, 20($sp)
    		sw $ra, 24($sp)
    		sw $t6, 28($sp)
    		#JUMP TO SET CELL 
    		jal set_cell
    		
    		lw $t5, 0($sp)
    		lw $t0, 4($sp)
    		lw $t1, 8($sp)
    		lw $t2, 12($sp)
    		lw $t3, 16($sp)
    		lw $t4, 20($sp)
    		lw $ra, 24($sp)
    		lw $t6, 28($sp)
    		addi $sp, $sp, 32
    		    		
    		#addi $t0, $t0, 1
		#addi $t4, $t4, 1
		#addi $t6, $t6, 1	#increment through array
		#beq $t4, 10, reveal_map_new_row
    		j reveal_map_increment
    		
    	reveal_map_new_row:
    		#li $t4, -1
    		li $t4, 0
    		addi $t3, $t3, 1
    		addi $t0, $t0, 2
    		addi $t6, $t6, 1
    		j reveal_map_loop	
    	
    	
    reveal_map_loop_finish:
    
    jr $ra
    go_to_smiley:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal smiley
    	lw $ra, 0($sp)
    	jr $ra
    	

##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    #DEFINE:	$a0 = byte array
    #		$a1 = value of current char
    #First thing... Create branch statements
    
    lw $t1, cursor_row
    lw $t2, cursor_col
    
    beq $a1, 'w', move_up
    beq $a1, 'W', move_up
    beq $a1, 's', move_down
    beq $a1, 'S', move_down
    beq $a1, 'a', move_left
    beq $a1, 'A', move_left
    beq $a1, 'd', move_right
    beq $a1, 'D', move_right
    beq $a1, 'f', toggle_flag
    beq $a1, 'F', toggle_flag
    beq $a1, 'r', reveal_square
    beq $a1, 'R', reveal_square
    
    	move_up:
    		#DEFINE: $t1 = cursor row value
    		#	 $t2 = cursor col value
    		#	 $t3 = holds offset of address in board
    		#	 $t4 = 10
    		#	 $t5 = holds start address and current address of board
    		#	 cursor is yellow for FG and BG 
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		beq $t1, 0, do_not_increment
    		li $t4, 10
    		li $t8, 0
    		mul $t4, $t1, $t4
    		add $t8, $t4, $t2	#offset (FOR) address
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9
    		lb $t8, ($t9)
    		andi $t8, $t8, 16
    		beq $t8, 16, shift_up_no_reset
    		lb $t8, ($t9)
    		andi $t8, $t8, 64		#check if cell has been revealed
    		beq $t8, 64, shift_up_no_reset
    		#CASE for 
    		#before setting the color of the incremented position
    		#reset the color of the current cursor
    		li $t4, 10
    		mul $t3, $t1, $t4
    		add $t3, $t3, $t2
    		la $t5, 0xffff0000	#start address of board
    		add $t5, $t5, $t3	#offsetted address
    		li $t6, 7	#color arg for yellow
    		#This set cell is for the new incremented space in the board
    		#PREPARE TO JUMP
    		addi $sp, $sp, -24
    		sw $t6, 0($sp)
    		sw $a0, 4($sp)
    		sw $t5, 8($sp)
    		sw $ra, 12($sp)
    		sw $t1, 16($sp)
    		sw $t2, 20($sp)
    		move $a0, $t1	#loading in cursor row
    		move $a1, $t2	#move cursor col
    		lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    		move $a2, $t4
    		li $a3, 7
    		jal set_cell
    		lw $t6, 0($sp)
    		lw $a0, 4($sp)
    		lw $t5, 8($sp)
    		lw $ra, 12($sp)
    		lw $t1, 16($sp)
    		lw $t2, 20($sp)
    		addi $sp, $sp, 24
    		shift_up_no_reset:
    			addi $t1, $t1, -1	#use this to move up
			    			
    			la $t4, cursor_row
    			sw $t1, ($t4)		#put incremented cursor value back into mem
    			#now with both cursors get the offset of the address
    			li $t4, 10
    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			#TEST CASE: Check if flag/reveal is already there
    			#lb $t8, ($t9)
    			#andi $t8, $t8, 16
    			#beq $t8, 16, flag_no_reset
    			
    			lb $t4, ($t5)	#get ascii char from mmio board
    			li $t6, 11	#color arg for yellow
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			move $a2, $t4 	#get ascii value from other place
    			li $a3, 11
    			jal set_cell
    		
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24
    			
    			li $v0, 0
    			jr $ra    		
    	move_down:
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		beq $t1, 9, do_not_increment
    		li $t4, 10
    		li $t8, 0
    		mul $t4, $t1, $t4
    		add $t8, $t4, $t2	#offset
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9
    		lb $t8, ($t9)
    		andi $t8, $t8, 16
    		beq $t8, 16, shift_down_no_reset
    		lb $t8, ($t9)
    		andi $t8, $t8, 64		#checking if cell has been revealed
    		beq $t8, 64, shift_down_no_reset
    		
    		li $t4, 10
    		mul $t3, $t1, $t4
    		add $t3, $t3, $t2
    		la $t5, 0xffff0000	#start address of board
    		add $t5, $t5, $t3	#offsetted address
    		li $t6, 7	#color arg for yellow
    		#This set cell is for the new incremented space in the board
    		#PREPARE TO JUMP
    		addi $sp, $sp, -24
    		sw $t6, 0($sp)
    		sw $a0, 4($sp)
    		sw $t5, 8($sp)
    		sw $ra, 12($sp)
    		sw $t1, 16($sp)
    		sw $t2, 20($sp)
    		move $a0, $t1	#loading in cursor row
    		move $a1, $t2	#move cursor col
    		lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    		move $a2, $t4
    		li $a3, 7
    		jal set_cell
    		lw $t6, 0($sp)
    		lw $a0, 4($sp)
    		lw $t5, 8($sp)
    		lw $ra, 12($sp)
    		lw $t1, 16($sp)
    		lw $t2, 20($sp)
    		addi $sp, $sp, 24
    		
    		
    		shift_down_no_reset:
    			addi $t1, $t1, 1	#use this to move down
    			la $t4, cursor_row
    			sw $t1, ($t4)		#put incremented cursor value back into mem
    			#now with both cursors get the offset of the address
    			li $t4, 10
    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 11	#color arg for yellow
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    			move $a2, $t4
    			li $a3, 11
    			jal set_cell
    		
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24
    			
    			li $v0, 0
    			jr $ra    	
    
    	move_right:
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		beq $t2, 9, do_not_increment
    		li $t4, 10
    		li $t8, 0
    		mul $t4, $t1, $t4
    		
    		add $t8, $t4, $t2
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9
    		lb $t8, ($t9)
    		andi $t8, $t8, 16
    		beq $t8, 16, shift_right_no_reset
    		lb $t8, ($t9)
    		andi $t8, $t8, 64		 #check if cell revealed
    		beq $t8, 64, shift_right_no_reset
    		
    		li $t4, 10
    		mul $t3, $t1, $t4
    		add $t3, $t3, $t2
    		la $t5, 0xffff0000	#start address of board
    		add $t5, $t5, $t3	#offsetted address
    		li $t6, 7	#color arg for yellow
    		#This set cell is for the new incremented space in the board
    		#PREPARE TO JUMP
    		addi $sp, $sp, -24
    		sw $t6, 0($sp)
    		sw $a0, 4($sp)
    		sw $t5, 8($sp)
    		sw $ra, 12($sp)
    		sw $t1, 16($sp)
    		sw $t2, 20($sp)
    		move $a0, $t1	#loading in cursor row
    		move $a1, $t2	#move cursor col
    		lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    		move $a2, $t4
    		li $a3, 7
    		jal set_cell
    		lw $t6, 0($sp)
    		lw $a0, 4($sp)
    		lw $t5, 8($sp)
    		lw $ra, 12($sp)
    		lw $t1, 16($sp)
    		lw $t2, 20($sp)
    		addi $sp, $sp, 24
    		
    		shift_right_no_reset:
    			addi $t2, $t2, 1	#use this to move up
    			la $t4, cursor_col
    			sw $t2, ($t4)		#put incremented cursor value back into mem
    			#now with both cursors get the offset of the address
    			li $t4, 10
    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 11	#color arg for yellow
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    			move $a2, $t4
    			li $a3, 11
    			jal set_cell
    		
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24
    			
    			li $v0, 0
    			jr $ra    	
    
    	move_left:
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		beq $t2, 0, do_not_increment
    		li $t4, 10
    		li $t8, 0
    		mul $t4, $t1, $t4
    		add $t8, $t4, $t2
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9
    		lb $t8, ($t9)
    		andi $t8, $t8, 16
    		beq $t8, 16, shift_left_no_reset
    		lb $t8, ($t9)
    		andi $t8, $t8, 64
    		beq $t8, 64, shift_left_no_reset
    		
    		li $t4, 10
    		mul $t3, $t1, $t4
    		add $t3, $t3, $t2
    		sll $t3, $t3, 1
    		la $t5, 0xffff0000	#start address of board
    		add $t5, $t5, $t3	#offsetted address
    		li $t6, 7	#color arg for yellow
    		#This set cell is for the new incremented space in the board
    		#PREPARE TO JUMP
    		addi $sp, $sp, -24
    		sw $t6, 0($sp)
    		sw $a0, 4($sp)
    		sw $t5, 8($sp)
    		sw $ra, 12($sp)
    		sw $t1, 16($sp)
    		sw $t2, 20($sp)
    		move $a0, $t1	#loading in cursor row
    		move $a1, $t2	#move cursor col
    		lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    		    		
    		
    		#move $a2, $t4
    		li $a3, 7
    		jal set_cell
    		lw $t6, 0($sp)
    		lw $a0, 4($sp)
    		lw $t5, 8($sp)
    		lw $ra, 12($sp)
    		lw $t1, 16($sp)
    		lw $t2, 20($sp)
    		addi $sp, $sp, 24
    		
    		shift_left_no_reset:
    			addi $t2, $t2, -1	#use this to move up
    			la $t4, cursor_col
    			sw $t2, ($t4)		#put incremented cursor value back into mem
    			#now with both cursors get the offset of the address
    			li $t4, 10
    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 11	#color arg for yellow
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			lb $t4, ($t5)	#get ascii char from mmio board	  origin: li $a2, '\0'	#null ascii char
    			move $a2, $t4
    			#li $a3, 0
    			jal set_cell
    		
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24
    			
    			li $v0, 0
    			jr $ra    	
    	
    	toggle_flag:
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		li $t4, 10
    		li $t8, 0	#clear $t8
    		mul $t1, $t1, $t4
    		add $t1, $t1, $t2
    		add $t8, $t8, $t1
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9	#get the offsetted address
    		lb $t8, ($t9)
    		andi $t8, $t8, 16
    		beq $t8, 16, reset_flag
    		lb $t8, ($t9)
    		andi $t8, $t8, 64
    		beq $t8, 64, do_not_increment
    		
    		lb $t8, ($t9)	
    		addi $t8, $t8, 16
    		sb $t8, ($t9)
    		li $t8, 0	#clear $t8 value
    		
    		mul $t3, $t1, $t4
    		add $t3, $t3, $t2
    		la $t5, 0xffff0000	#start address of board
    		add $t5, $t5, $t3	#offsetted address
    		#lb $t7, ($t5)
    		#bge $t7, 16, reset_flag
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		li $t6, 7	#BG: grey 	FG: Bright Blue
    		#This set cell is for the new incremented space in the board
    		#PREPARE TO JUMP
    		addi $sp, $sp, -24
    		sw $t6, 0($sp)
    		sw $a0, 4($sp)
    		sw $t5, 8($sp)
    		sw $ra, 12($sp)
    		sw $t1, 16($sp)
    		sw $t2, 20($sp)
    		move $a0, $t1	#loading in cursor row
    		move $a1, $t2	#move cursor col
    		li $a2, 'f'	#null ascii char
    		li $a3, 12
    		jal set_cell
    		lw $t6, 0($sp)
    		lw $a0, 4($sp)
    		lw $t5, 8($sp)
    		lw $ra, 12($sp)
    		lw $t1, 16($sp)
    		lw $t2, 20($sp)
    		addi $sp, $sp, 24
    		
    		li $v0, 0
    		jr $ra
    		
    		reset_flag:
    			lw $t1, cursor_row
    			lw $t2, cursor_col
    			li $t4, 10
    			li $t8, 0	#clear $t8
    			mul $t1, $t1, $t4
    			add $t1, $t1, $t2
    			add $t8, $t8, $t1
    			move $t9, $a0	#move address of byte array into $t9
    			add $t9, $t8, $t9
    			lb $t8, ($t9)
    			addi $t8, $t8, -16
    			sb $t8, ($t9)	#reset the flag value
    			li $t8, 0	#clear the $t8 value
    			li $t4, 10
    			
    			lw $t1, cursor_row	#used to get the right row value
    			
    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 7	#color arg for yellow
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			#lw $t1, cursor_row
    			#lw $t2, cursor_col
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			li $a2, '\0'	#null ascii char
    			li $a3, 7
    			jal set_cell
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24 
    			
    			li $v0, 0
    			jr $ra
    			
    	reveal_square:
    		lw $t1, cursor_row
    		lw $t2, cursor_col
    		li $t4, 10
    		li $t8, 0	#clear $t8
    		mul $t1, $t1, $t4
    		add $t1, $t1, $t2
    		add $t8, $t8, $t1
    		move $t9, $a0	#move address of byte array into $t9
    		add $t9, $t8, $t9
    		lb $t8, ($t9)
    		bge $t8, 64, do_not_increment	#check to see if cell is already revealed
    		#use $t7 to hold temp value of what's in $t8
    		#addi $t7, $t8, -64
    		bge $t8, 32, reveal_mine_found
    		bge $t8, 16, reveal_flag_found
    		bge $t8, 8, reveal_square_8
    		bge $t8, 7, reveal_square_7
    		bge $t8, 6, reveal_square_6
    		bge $t8, 5, reveal_square_5
    		bge $t8, 4, reveal_square_4
    		bge $t8, 3, reveal_square_3
    		bge $t8, 2, reveal_square_2
    		bge $t8, 1, reveal_square_1
    		j reveal_square_blank
    		
    		reveal_mine_found:
    			addi $t8, $t8, 64
    			sb $t8, ($t9)
    			li $v0, 0
    			jr $ra
    			
    		reveal_flag_found:
    			
    			
    		reveal_square_8:
    			li $a2, '8'
    			j reveal_square_num_set
    		reveal_square_7:
    			li $a2, '7'
    			j reveal_square_num_set
    		
    		reveal_square_6:
    			li $a2, '6'
    			j reveal_square_num_set
    		
    		reveal_square_5:
    			li $a2, '5'
    			j reveal_square_num_set
    		
    		reveal_square_4:
    			li $a2, '4'
    			j reveal_square_num_set
    		
    		reveal_square_3:
    			li $a2, '3'
    			j reveal_square_num_set
    		
    		reveal_square_2:
    			li $a2, '2'
    			j reveal_square_num_set
    		
    		reveal_square_1:
    			li $a2, '1'
    			j reveal_square_num_set
    		
    		reveal_square_blank:
    			lw $t1, cursor_row
    			lw $t2, cursor_col
    			li $t4, 10
    			#li $t8, 0	#clear $t8
    			li $t5, 0
    			mul $t1, $t1, $t4
    			add $t1, $t1, $t2
    			add $t5, $t5, $t1
    			move $t9, $a0	#move address of byte array into $t9
    			add $t9, $t5, $t9
    				
    			#li $t8, 0	#clear the $t8 value
    			li $t4, 10
    			
    			lw $t1, cursor_row	#used to get the right row value

    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 0	#color arg for bright magenta
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			#lw $t1, cursor_row
    			#lw $t2, cursor_col
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			li $a2, '\0'	
    			li $a3, 0	
    			jal set_cell
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24 
    			j reveal_square_store_back
    		
    		reveal_square_num_set:
    			lw $t1, cursor_row
    			lw $t2, cursor_col
    			li $t4, 10
    			#li $t8, 0	#clear $t8
    			li $t5, 0
    			mul $t1, $t1, $t4
    			add $t1, $t1, $t2
    			add $t5, $t5, $t1
    			move $t9, $a0	#move address of byte array into $t9
    			add $t9, $t5, $t9
    			
    			#li $t8, 0	#clear the $t8 value
    			li $t4, 10
    			
    			lw $t1, cursor_row	#used to get the right row value

    			mul $t3, $t1, $t4
    			add $t3, $t3, $t2
    			la $t5, 0xffff0000	#start address of board
    			add $t5, $t5, $t3	#offsetted address
    			li $t6, 0	#color arg for bright magenta
    			#This set cell is for the new incremented space in the board
    			#PREPARE TO JUMP
    			#lw $t1, cursor_row
    			#lw $t2, cursor_col
    			addi $sp, $sp, -24
    			sw $t6, 0($sp)
    			sw $a0, 4($sp)
    			sw $t5, 8($sp)
    			sw $ra, 12($sp)
    			sw $t1, 16($sp)
    			sw $t2, 20($sp)
    			move $a0, $t1	#loading in cursor row
    			move $a1, $t2	#move cursor col
    			#li $a2, '8'	
    			li $a3, 13	#BG: Black (0)	FG: Bright Magenta (13)
    			jal set_cell
    			lw $t6, 0($sp)
    			lw $a0, 4($sp)
    			lw $t5, 8($sp)
    			lw $ra, 12($sp)
    			lw $t1, 16($sp)
    			lw $t2, 20($sp)
    			addi $sp, $sp, 24 
    			    			
    		reveal_square_store_back:
    			addi $t8, $t8, 64
    			sb $t8, ($t9)
    			li $v0, 0
    			jr $ra
    	    	
    	do_not_increment:
    		li $v0, -1
    		jr $ra
    ##########################################
    jr $ra

game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    li $v0, 1	#start off game status as 1 for win
    #DEFINE: 	$a0 = byte array	$t0 = temp byte array
    #		$t1 = hold loaded in value from array
    #		$t2 = counter for outer loop
    move $t0, $a0
    #FOR DEBUGGING PURPOSE ONLY:
    #li $v0, 0
    #jr $ra
   
    	game_status_loop:
    		beq $t2, 100, game_status_finish
    		lb $t1, 0($t0)
    		#addi $t1, $t1, 1
    		bge $t1, 32, game_status_mine_found
    		addi $t2, $t2, 1
    		addi $t0, $t0, 1
    		j game_status_loop
    	
    	game_status_mine_found:
    		#first check if there is a flag at the square
    		bge $t1, 96, game_status_mine_reveal
    		bge $t1, 48, game_status_flag_check
    		li $v0, 0
    		addi $t2, $t2, 1
    		addi $t0, $t0, 1
    		j game_status_loop
    		
    	game_status_mine_reveal:
    		li $v0, -1
    		jr $ra
    	
    	game_status_flag_check:
    		addi $t0, $t0, 1
    		addi $t2, $t2, 1
    		j game_status_loop
    		
    	game_status_finish:
    		jr $ra   
    ##########################################

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
cursor_row: .word -1
cursor_col: .word -1
#place any additional data declarations here
load_map_buf_string: .asciiz ""

