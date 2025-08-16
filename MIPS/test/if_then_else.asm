.set noreorder

.global _start
_start:
	beq	$s0, $s1, L1
	add	$s2, $zero, $s0
	j	N1
L1:	add	$s2, $zero, $s1
N1:	
loop:
	j loop
	
.data
a: .word 10
b: .word 20
array1: .word 0,1,2,3,4,5,6,7,8,9

