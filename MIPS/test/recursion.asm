.set noreorder

.global _start
_start:
  add $a0, $zero, $s0
  jal sum
  add $s1, $zero, $v0
loop:
	j loop
sum:addi $sp, $sp, -8
  sw $a0, 0($sp)
  sw $ra, 4($sp)
  slti $t0, $a0, 1  # Check if a0 < 1
  beq $t0, $zero, L1  # If a0 >= 1, go to L1
  lw $ra, 4($sp)
  lw $a0, 0($sp)
  add $v0, $zero, $zero
  addi $sp, $sp, 8
  jr $ra
L1: addi $a0, $a0, -1
  jal sum
  lw $a0, 0($sp)
  lw $ra, 4($sp)
  add $v0, $v0, $a0
  addi $sp, $sp, 8
  jr $ra
	
.data
a: .word 10
b: .word 20
array1: .space 40


