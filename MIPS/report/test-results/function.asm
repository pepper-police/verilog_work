.set noreorder

.global _start
_start:
  add $a0, $zero, $s0
  jal sum
  add $s1, $zero, $v0
loop:
	j loop
sum:addi $sp, $sp, -8
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  add $s1, $zero, $zero
  add $s0, $zero, $zero
L1: slt $t0, $s0, $a0
  beq $t0, $zero, N1
  add $s1, $s1, $s0
  addi $s1, $s1, 1
  addi $s0, $s0, 1
  j L1
N1:add $v0, $zero, $s1
  lw $s1, 4($sp)
  lw $s0, 0($sp)
  addi $sp, $sp, 8
  jr $ra
	
.data
a: .word 10
b: .word 20
array1: .space 40

