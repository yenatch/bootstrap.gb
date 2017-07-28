section "stack", wram0 [$c080]

	ds $80 - 1
wStack::


section "init", rom0

Init:
	di

	cp $11
	ld a, 1
	jr z, .cgb
	xor a
.cgb
	ld [hGBC], a

	xor a
	ldx [rIF],  [rIE]
	ldx [rRP]
	ldx [rSCX], [rSCY]
	ldx [rSB],  [rSC]
	ldx [rWX],  [rWY]
	ldx [rBGP], [rOBP0], [rOBP1]
	ldx [rTMA], [rTAC]

	put [rTAC], rTAC_4096Hz

.wait
	ld a, [rLY]
	cp 144
	jr c, .wait

	xor a
	ld [rLCDC], a


	ld sp, wStack

	fill $c000, $2000, 0

	ld a, [hGBC]
	and a
	jr z, .cleared_wram

	ld a, 7
.wram_bank
	push af
	ld [rSVBK], a
	fill $d000, $1000, 0
	pop af
	dec a
	cp 1
	jr nc, .wram_bank
.cleared_wram

	ld a, [hGBC]
	push af
	fill $ff80, $7f, 0
	pop af
	ld [hGBC], a

; Filling vram is not really necessary.
;	fill $8000, $2000, 0

	fill $fe00, $a0, 0


	put [rJOYP], 0
	put [rSTAT], 8 ; hblank enable
	put [rWY], $90
	put [rWX], 7

	put [rLCDC], %11100011

if def(NormalSpeed) ; not implemented yet
	ld a, [hGBC]
	and a
	call nz, NormalSpeed
endc

	put [rIF], 0
	put [rIE], %1111

	ei

	halt

	call Main

	; if Main returns, restart the program
	jp Init
