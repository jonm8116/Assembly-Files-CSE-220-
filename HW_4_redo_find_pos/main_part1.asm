#################################################################
# HW#4 Part 1: Testing Main for preorder
#################################################################
.text
.globl main

main:
	# open file
	li $v0, 13
	la $a0, file1
	li $a1, 1        # Open for writing (flags are 0: read, 1: write)
	li $a2, 0        # mode is ignored
	syscall          # open a file (file descriptor returned in $v0)
	move $s0, $v0    # save the file descriptor

	# Call preorder traversal of the tree starting at nodes2
	la $a0, nodes7		#before tree was nodes7
	move $a1, $a0		#after to test add_node, used bst_4
	move $a2, $s0
	jal preorder

	#print newline to file
	li $v0, 15
	move $a0, $s0
	la $a1, endl
	li $a2, 1
	syscall
	
	#ADD NODE TEST CASE 
	#la $a0, bst_4
	#li $a1, 2
	#li $a2, 4 	# add value 4
	#li $a3, 8 	# add to free index 8
	#addi $sp, $sp, -8
	#la $t0, flag_bst_4
	#sw $t0, 4($sp)
	#li $t0, 10
	#sw $t0, 0($sp)
	#jal add_node
	#addi $sp, $sp, 8
	#AFTER ADD NODE
	#TEST WITH PREORDER
	
	# Call preorder traversal of the tree starting at nodes2
	#la $a0, bst_4		#before tree was nodes7
	#move $a1, $a0		#after to test add_node, used bst_4
	#move $a2, $s0
	#jal preorder
	

	# close file
	li $v0, 16         # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file

done:
	li $v0, 10
	syscall

.data
file1: .asciiz "preorder.trav"
endl: .asciiz "\n"

#################################################################
# PART 1 Testing Trees
#################################################################
.align 2

nodes2: .word 0x01060008 0x02030003 0xFFFF0001 0x04050006 0xFFFF0004 0xFFFF0007 0xFF07000A 0x08FF000E 0xFFFF000D #root 0, sample tree

# Additional testing cases
nodes1: .word 0xFFFF0001 # root node with 0 children - root 0
nodes3: .word 0x01FF0001 0xFFFF0002 # root node with 1 left child - root 0
nodes4: .word 0xFF010001 0xFFFF0003 # root node with 1 right child - root 0
nodes5: .word 0xFF030001 0xFFFF000F 0xFF010007 0xFF020003 # completely unbalanced tree - linked list to right (with nodes mixed up) - root 0
nodes6: .word 0x02FF0001 0x03FF0004 0x01FF0002 0xFFFF0008 # completely unbalanced tree - linked list to left (with nodes mixed up) - root 0
nodes7: .word 0x01060008 0x0203FFFD 0xFFFF0001 0x0405FFFA 0xFFFF0004 0xFFFFFFF9 0xFF07000A 0x08FFFFF2 0xFFFF000D # sample tree w/ negative nodes - root 0
nodes8: .word 0xFFFF0004 0x02030003 0xFFFF0001 0x00050006 0x01060008 0xFFFF0007 0xFF07000A 0x08FF000E 0xFFFF000D # sample tree - root 4

#################################################################
# Student defined functions will be included starting here
#################################################################
.align 2
bst_4: .word 0xFED89999 0xF9041111 0x06030002 0x05FF0005 0xFFFF0003 0xFF040002 0x09070001 0xFFFF0001 0xFED77777 0xFFFFFFFF # root 2
	# valid indices = 2,3,4,5,6,7,9
	# maxSize = 10
	# preorder: 2 1 -1 1 5 2 3
.space 1
flag_bst_4: .byte 0xFC, 0x02 # first 10 bits valid, rest ignored

.include "hw4.asm"
