#Homework 1
#Name: Jonathan Mathai
#ID: 110320715
.data
.align 2 
numargs: .word 0 #number of arguments from command line
arg1: .word 0 
arg2: .word 0 
arg3: .word 0 
arg2_string: .asciiz "ARG2: "
arg3_string: .asciiz "ARG3: " 
part2_string: .asciiz "Part 2: "
part3_string: .asciiz "Part 3: "
finish_string: .asciiz "finished loop"
space_string: .asciiz " "
newline_char: .asciiz "\n"
ham_string: .asciiz "Hamming distance: "
Err_string: .asciiz "ARGUMENT ERROR" 
last_drawn_string: .asciiz "Last value drawn: "
total_value_string: .asciiz "Total Values: "
num_even_string: .asciiz "# of Even: "
num_odd_string: .asciiz "# of Odd: "
pow_2_string: .asciiz "Power of 2: "
mul_2_string: .asciiz "Multiple of 2: "
mul_4_string: .asciiz "Multiple of 4: "
mul_8_string: .asciiz "Multiple of 8: "
#Helper macro for grabbing command line arguments 
.macro load_args
	sw $a0, numargs	#save word puts word from CPU -> RAM
	lw $t0, 0($a1)
	sw $t0, arg1
	lw $t0, 4($a1)
	sw $t0, arg2
	lw $t0, 8($a1)
	sw $t0, arg3
.end_macro

.text
.globl main
main:
	load_args() #Only do this once
	lw $t0, numargs
	bgt $t0, 3, exception 
	blt $t0, 2, exception
	#Unicode for:
	# a:  97
	# A: 65
	#R: 82
	#r: 114 
	lw $t0, arg1  #Saves the value of the first arg string
	lb $t1, 0($t0) #loads in the first char of the string
	lb $t2, 1($t0) #loads to see if there is a second char
		       #if there is, then take exception branch
	bnez $t2, exception #if arg1 > 1 char. Then take branch
	beq $t1, 'a', part2  # take part2 branch if 'A' or 'a' 
	beq $t1, 'A', part2
	beq $t1, 'R', part3  # take part3 branch if 'R' or 'r'
	beq $t1, 'r', part3
	bne $t1, 0, exception #If none of the branches are taken 
				#then take exception
	
	li $v0, 10
	syscall
exception: 
	la $a0, Err_string #print error string
	li $v0, 4
	syscall
	
	li $v0, 10	#system exit
	syscall	
part2:
	#la $a0, part2_string #print string "part 2 :"
	#li $v0, 4 
	#syscall
	
	#la $a0, ($t1)		print out part 1 stuff
	#li $v0, 11  		syscall 11 is used to print out single char
	#syscall
	lw $t0, numargs 
	blt $t0, 3, exception #if there is less than 3 args, branch exception
	
	#ARG2 SECTION:
	#$t5 = 4 characters for arg2
	lw $t0, arg2 #place the entire word into $t0 (make sure its arg2)
	lb $t1, 3($t0) #place the last 4 bytes of the first 4 bytes of the argument
	add $t5, $t5, $t1 #use offset 3 to place the 4th letter of the first 4 (and so on)
	sll $t5, $t5, 8
	lb $t1, 2($t0) #into individual registers
	add $t5, $t5, $t1
	sll $t5, $t5, 8 #shift left logical to shift each char over one byte
	lb $t1, 1($t0)
	add $t5, $t5, $t1 
	sll $t5, $t5, 8
	lb $t1, 0($t0) 
	add $t5, $t5, $t1
	
	la $a0, arg2_string #print out str "ARG2: " 
	li $v0, 4
	syscall 
	#print out binary value
	la $a0, ($t5)
	li $v0, 35
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall 
	#print out hex value
	la $a0, ($t5)
	li $v0, 34
	syscall
	#print out space
	la $a0, space_string
	li $v0, 4
	syscall
	#print out two's complement
	la $a0, ($t5)
	li $v0, 1
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall
	#print out one's complement
	la $a0, ($t5)
	li $v0, 100
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall
	#print signed magnitude
	la $a0, ($t5)
	li $v0, 101
	syscall
	#print newline character
	la $a0, newline_char
	li $v0, 4
	syscall
	#reset all values for previous temp registers
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	#add $t5, $zero, $zero
	#ARG3 SECTION:
	# $t6 = 4 characters for arg3
	lw $t0, arg3 #place the entire word into $t0 (make sure its arg3)
	lb $t6, 3($t0) #place the last 4 bytes of the first 4 bytes of the argument
	add $t6, $t6, $t1
	sll $t6, $t6, 8
	lb $t1, 2($t0) #into individual registers
	add $t6, $t6, $t1
	sll $t6, $t6, 8 #shift left logical to shift each char over one byte
	lb $t1, 1($t0)
	add $t6, $t6, $t1 
	sll $t6, $t6 8
	lb $t1, 0($t0) 
	add $t6, $t6, $t1
	
	la $a0, arg3_string #print out str "ARG3: " 
	li $v0, 4
	syscall 
	#print out binary value
	la $a0, ($t6)
	li $v0, 35
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall 
	#print out hex value
	la $a0, ($t6)
	li $v0, 34
	syscall
	#print out space
	la $a0, space_string
	li $v0, 4
	syscall
	#print out two's complement
	la $a0, ($t6)
	li $v0, 1
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall
	#print out one's complement
	la $a0, ($t6)
	li $v0, 100
	syscall
	#print space
	la $a0, space_string
	li $v0, 4
	syscall
	#print signed magnitude
	la $a0, ($t6)
	li $v0, 101
	syscall
	#Hamming Distance
	#$t5 = arg2
	#$t6 = arg3
	# print space
	#la $a0, space_string
	#li $v0, 4
	#syscall
	#initialize values for the loop
	li $t1, 0 #counter
	li $t2, 1 #iterator (i)
	li $t3, 1 #position
	#xor values in order to check
	#where bits were opposite
	xor $t0, $t5, $t6
	j increment
	
	#system exit
	li $v0, 10 
	syscall
increment: 
	#xor value in $t0
	#representative bit $t7
	#Values to keep track:
	#$t0 = xor value
	#$t1 = counter 
	#$t2 = iterator for loop
	#$t3 = position in bits
	and $t7, $t0, $t3 #and position and xor value
	beqz $t7, no_increment
	addi $t1, $t1, 1 #increment counter (if bit==1)
	
no_increment: 
	sll $t3, $t3, 1  #shift position by 1 bit
	addi $t2, $t2, 1 #increment iterator  
	blt $t2, 33, increment #33 end of iteration because loop starts at 1
	j part_2_finish

part_2_finish: 
	#print newline
	la $a0, newline_char
	li $v0, 4
	syscall
	#print hamming string
	la $a0, ham_string
	li $v0, 4
	syscall
	#print hamming distance value
	move $a0, $t1
	li $v0, 1
	syscall
	#system exit
	li $v0, 10
	syscall
part3:	
	#print "Part 3: "
	#la $a0, part3_string
	#li $v0, 4
	#syscall 
	#la $a0, ($t1)		Section to print
	#li $v0, 11		out stuff for part 1
	#syscall
	lw $t0, numargs
	bgt $t0, 2, exception #check for exception in num of args
	#load in arg2
	lw $t0, arg2
	j arg2_check_string
	
	li $v0, 10
	syscall

arg2_check_string:
	#$t0 contains the word for arg2
	#now need to load in, individual bytes 
	#This is done to get each individual char		
	#$s0 = sum						
	#$t2 = bytes for each char				
	#la $t1, ($t0)	#load address of arg2 to $t1
	#lb $t2, 0($t1) 	#use sll by 8 bit to check next byte 
	#bgt $t2, 9, after_string_check
	#blt  $t2, 0, after_string_check
	#address register = $t0
	#char register = $t1
	#sum register = $t2
	#value 10 = $t3
	#value of char '0' = $t4
	#ascii value of '0' is 48, so do -48 to subtract '0'
	li $t3, 10
	li $t4, -48
	lb $t1, 0($t0)
	bgt $t1, '9', after_string_check #check for invalid chars
	blt $t1, '0', after_string_check
	addi $t0, $t0, 1		 #increment through chars
	#java algorithm: sum = (sum * 10) + (char - ’0’)
	mul $t2, $t2, $t3
	#add $t2, $t1, $t4
	add $t5, $t1, $t4
	add $t2, $t2, $t5
		
	bnez $t1, arg2_check_string
	j after_string_check
	
after_string_check: 	
	#finish 1st half of part 3
	#Now set seed for drawing random values
	la $a0, 0	#standard value for $a0 for random #s
	la $a1, ($t2)	#used to set seed
	li $v0, 40
	syscall
	#values defined by each range:
	#total num values drawn = $t0
	#total odd values drawn = $t1
	#total even values drawn = $t3
	#total num of power of 2 values = $t4
	#total num of power of 4 values = $t5
	#total num of power of 8 values = $t6
	#set random int range
	#value of 2 = $t7
	#hold remainder = $t8
	#stop drawing powers of 2 and less than 64
	li $t0, 0	#total num
	li $t1, 0	#odd
	li $t3, 0	#even
	li $t4, 0	#power 2
	li $t5, 0	#mulitple of 4
	li $t6, 0 	#multiple of 8
	li $t8, 0 	#remainder
	j part_3_loop
	
part_3_loop: 
	li $t7, 2    #beginning of part 3 loop
	li $a0, 0
	li $a1, 1024 #system call to generate 
	li $v0, 42   #random value
	syscall
	addi $a0, $a0, 1 #increment value in $a0
			 #so value is between 1-1024
	addi $t0, $t0, 1 #increment value for total num of values drawn
	div $a0, $t7 	#divide by 2 to check
	mfhi $t8	#remainder to check for odd
			#or even
	beqz $t8, part_3_even
	beq $t8, 1, part_3_odd
	
part_3_even:
	addi $t3, $t3, 1 #increment even counter
	li $t7, 4
	div $a0, $t7	#divide by 4 to check 
	mfhi $t8	#divisibility by 4
	beqz $t8, part_3_mul_4
	li $t7, 8
	div $a0, $t7 	#divide by 8 to check
	mfhi $t8
	beqz $t8, part_3_mul_8
	
	#check if power of 2		
	beq $a0, 1, part_3_pow_2
	beq $a0, 2, part_3_pow_2
	beq $a0, 4, part_3_pow_2
	beq $a0, 8, part_3_pow_2	#all of this is used
	beq $a0, 16, part_3_pow_2	#to check if the value
	beq $a0, 32, part_3_pow_2	#is a power of 2
	beq $a0, 64, part_3_pow_2
	beq $a0, 128, part_3_pow_2
	beq $a0, 256, part_3_pow_2
	beq $a0, 512, part_3_pow_2
	beq $a0, 1024, part_3_pow_2
	#bgt $a0, 64, part_3_loop
	j part_3_loop
part_3_odd: 
	addi $t1, $t1, 1 #increment odd counter
	beq $a0, 1, part_3_pow_2 #check if 1
	j part_3_loop
	
part_3_pow_2: 
	addi $t4, $t4, 1
	bgt $a0, 63, part_3_loop #branch to loop
	j done
			
part_3_mul_4: 
	addi $t5, $t5, 1 #increment mul 4 counter
	li $t7, 8
	div $a0, $t7 	#divide by 8 to check
	mfhi $t8
	beq $t8, 0, part_3_mul_8
	#bgt $a0, 64, part_3_loop
	beq $a0, 1, part_3_pow_2
	beq $a0, 2, part_3_pow_2
	beq $a0, 4, part_3_pow_2
	beq $a0, 8, part_3_pow_2	#all of this is used
	beq $a0, 16, part_3_pow_2	#to check if the value
	beq $a0, 32, part_3_pow_2	#is a power of 2
	beq $a0, 64, part_3_pow_2
	beq $a0, 128, part_3_pow_2
	beq $a0, 256, part_3_pow_2
	beq $a0, 512, part_3_pow_2
	beq $a0, 1024, part_3_pow_2
	j part_3_loop
	
part_3_mul_8:
	addi $t6, $t6, 1 #increment mul 8 counter
	beq $a0, 1, part_3_pow_2
	beq $a0, 2, part_3_pow_2
	beq $a0, 4, part_3_pow_2
	beq $a0, 8, part_3_pow_2	#all of this is used
	beq $a0, 16, part_3_pow_2	#to check if the value
	beq $a0, 32, part_3_pow_2	#is a power of 2
	beq $a0, 64, part_3_pow_2
	beq $a0, 128, part_3_pow_2
	beq $a0, 256, part_3_pow_2
	beq $a0, 512, part_3_pow_2
	beq $a0, 1024, part_3_pow_2
	#bgt $a0, 64, part_3_loop
	j part_3_loop
done:
	#li $t0, 0	#total num
	#li $t1, 0	#odd
	#li $t3, 0	#even
	#li $t4, 0	#power 2
	#li $t5, 0	#mulitple of 4
	#li $t6, 0 	#multiple of 8
	la $t2, ($a0) 	#print string
	
	#print last drawn value
	la $a0, last_drawn_string
	li $v0, 4
	syscall
	la $a0, ($t2)
	li $v0, 1
	syscall
	la $a0, newline_char #newline character
	li $v0, 4
	syscall
	#print total num values
	la $a0, total_value_string
	li $v0, 4
	syscall
	la $a0, space_string
	li $v0, 4
	syscall
	#print total num values
	la $a0, ($t0)
	li $v0, 1
	syscall
	la $a0, newline_char #newline character
	li $v0, 4
	syscall
	#print even number
	la $a0, num_even_string
	li $v0, 4
	syscall
	la $a0, ($t3)	#load in num of evens
	li $v0, 1
	syscall
	la $a0, newline_char
	li $v0, 4
	syscall
	#print odd
	la $a0, num_odd_string
	li $v0, 4
	syscall
	la $a0, ($t1)	#load in num of odds
	li $v0, 1
	syscall 
	la $a0, newline_char
	li $v0, 4
	syscall
	#print power of 2
	#keep value blank for right now
	la $a0, pow_2_string
	li $v0, 4
	syscall
	la $a0, ($t4)	#load in num of power of 2
	li $v0, 1
	syscall
	la $a0, newline_char
	li $v0, 4
	syscall
	#Print multiple of 2
	la $a0, mul_2_string
	li $v0, 4
	syscall
	la $a0, ($t3)	#load in num of mul of 2
	li $v0, 1
	syscall
	la $a0, newline_char
	li $v0, 4
	syscall
	#print multiple of 4
	la $a0, mul_4_string
	li $v0, 4
	syscall
	la $a0, ($t5)
	li $v0, 1
	syscall
	la $a0, newline_char
	li $v0, 4
	syscall
	#print multiple of 8 
	la $a0, mul_8_string
	li $v0, 4
	syscall
	la $a0, ($t6)
	li $v0, 1
	syscall
	#system exit
	li $v0, 10
	syscall
	
	
