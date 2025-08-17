.set noreorder

.global _start
_start:
	sll	$t0, $s0, 2
	add $t0, $s7, $t0
	lw	$s1, 0($t0)
	lw	$s2, 20($s7)
loop:
	j loop
	
.data
a: .word 10
b: .word 20
array1: .word 0,1,2,3,4,5,6,7,8,9
