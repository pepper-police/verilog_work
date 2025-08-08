.global _start
_start:
    jal		func				# jump to func and save position to $ra

loop:
    j		loop				# jump to loop

func:
    # check ALU res
    add     $a0, $ra, $zero
	# リターン
    jr      $ra