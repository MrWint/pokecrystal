BattleCommand55: ; 37618
; protect
	call ProtectChance
	ret c

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarPair
	set SUBSTATUS_PROTECT, [hl]

	call Function0x37e01

	ld hl, ProtectedItselfText
	jp StdBattleTextBox
; 3762c


ProtectChance: ; 3762c

	ld de, PlayerProtectCount
	ld a, [hBattleTurn]
	and a
	jr z, .asm_37637
	ld de, EnemyProtectCount
.asm_37637

	call Function0x36abf
	jr nz, .failed

; Can't have a substitute.

	ld a, BATTLE_VARS_SUBSTATUS4
	call CleanGetBattleVarPair
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .failed

; Halve the chance of a successful Protect for each consecutive use.

	ld b, $ff
	ld a, [de]
	ld c, a
.loop
	ld a, c
	and a
	jr z, .done
	dec c

	srl b
	ld a, b
	and a
	jr nz, .loop
	jr .failed
.done

.rand
	call BattleRandom
	and a
	jr z, .rand

	dec a
	cp b
	jr nc, .failed

; Another consecutive Protect use.

	ld a, [de]
	inc a
	ld [de], a

	and a
	ret


.failed
	xor a
	ld [de], a
	call Function0x37e77
	call PrintButItFailed
	scf
	ret
; 3766f

