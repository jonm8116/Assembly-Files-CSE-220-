#sample hw_2 test out 
#test out ideas
.data 
num_string: .asciiz "123"


.text
	la $t1, num_string
	lb $t2, 0($t1)