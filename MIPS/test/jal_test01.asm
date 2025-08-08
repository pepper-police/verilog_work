.global _start
_start:
    jal		func				# jump to func and save position to $ra

loop:
    j		loop				# jump to loop

func:
	# スタック確保
    addi    $sp, $sp, -4
	# 戻りアドレス保存
    sw      $ra, 0($sp)
	# 戻りアドレス汚染
	addi	$ra, $zero, 0xff
	# 戻りアドレス復元
    lw      $ra, 0($sp)
	# スタック開放
    addi    $sp, $sp, 4
	# リターン
    jr      $ra