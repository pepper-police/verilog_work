.global _start
_start:
    # init
    addi	$a0, $zero, 3			# $a0 = $zero + 3
    addi	$a1, $zero, 3			# $a1 = $zero + 3
    addi	$a2, $zero, 0			# $a2 = $zero + 0
    addi    $a3, $zero, 0           # $a3 = $zero + 0
    # call
    jal		hanoi				# jump to hanoi and save position to $ra

loop:
    j		loop				# jump to loop

hanoi:
    addi	$sp, $sp, -20			# $sp = $sp + -20
    sw		$a0, 0($sp)
    sw      $a1, 4($sp)
    sw      $a2, 8($sp)
    sw      $a3, 12($sp)
    sw      $ra, 16($sp)
    slti	$t0, $a0, 2			# $t0 = ($a0 < 2) ? 1 : 0
    beq		$t0, $zero, L1	    # if $t0 == $zero then goto L1
    add		$a2, $a3, $zero		# $a2 = $a3 + $zero
    lw		$a2, 8($sp)
    lw      $ra, 16($sp)
    addi	$sp, $sp, 20			# $sp = $sp + 20
    jr		$ra					# jump to $ra
L1:
    addi	$a0, $a0, -1			# $a0 = $a0 + -1
    lw      $a2, 12($sp)
    lw      $a3, 8($sp)
    jal		hanoi				# jump to hanoi and save position to $ra
    lw      $a0, 0($sp)
    addi	$a0, $a0, -1			# $a0 = $a0 + -1
    lw      $a1, 8($sp)
    lw      $a2, 4($sp)
    lw      $a3, 12($sp)
    jal		hanoi				# jump to hanoi and save position to $ra
    lw      $a0, 0($sp)
    lw      $a1, 4($sp)
    lw      $a2, 8($sp)
    lw      $a3, 12($sp)
    lw      $ra, 16($sp)
    addi	$sp, $sp, 20			# $sp = $sp + 20
    jr		$ra					# jump to $ra
