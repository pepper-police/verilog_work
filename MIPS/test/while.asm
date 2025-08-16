.set noreorder

.global _start
_start:
L1:	slti	$t0, $s0, 10
	beq	$t0, $zero, N1
	sll	$t0, $s0, 2
	add	$t0, $s7, $t0
	sw	$s0, 0($t0)
	addi	$s0, $s0, 1
	j	L1
N1:	
loop:
	j loop
	
.data
a: .word 10
b: .word 20
array1: .space 40

