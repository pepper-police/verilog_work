.set noreorder

.global _start
_start:
	lw	$s0, 0($s7)
	lw	$s1, 4($s7)
	addi $t0, $s7, 8
	sw $s1, 0($t0)
loop:
	j loop
	
.data
a: .word 10
b: .word 20
array1: .space 16
