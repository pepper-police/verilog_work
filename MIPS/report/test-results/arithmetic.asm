.set noreorder

.global _start
_start:
	lw	$s0, 0($s7)
	lw	$s1, 4($s7)
	lw	$s2, 8($s7)
	add $t0, $s0, $s1
	add $s3, $t0, $s2
loop:
	j loop
	
.data
a: .word 1
b: .word 2
c: .word 3
d: .word 0
