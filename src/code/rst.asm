; rst vectors are single-byte calls.

; Here, farcall is used as a pseudoinstruction.
; The other vectors are free to use for any purpose.


section "rst Bankswitch", rom0 [Bankswitch]
	ld [hROMBank], a
	ld [MBC5_ROMBank], a
	ret

section "rst FarCall", rom0 [FarCall]
	jp FarCall_


section "rst $10", rom0 [$10]
section "rst $18", rom0 [$18]
section "rst $20", rom0 [$20]
section "rst $28", rom0 [$28]
section "rst $30", rom0 [$30]
section "rst $38", rom0 [$38]


section "farcall", rom0

FarCall_:
	ld  [wFarCallHold + 0], a
	put [wFarCallHold + 1], h
	put [wFarCallHold + 2], l

	pop hl
	put [wFarCallBank],        [hli]
	put [wFarCallTarget],      $c3 ; <jp>
	put [wFarCallAddress + 0], [hli]
	put [wFarCallAddress + 1], [hli]
	push hl

	ld hl, wFarCallHold + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hROMBank]
	push af
	ld a, [wFarCallBank]
	rst Bankswitch

	ld a, [wFarCallHold + 0]

	call wFarCallTarget

	push af

	add sp, 2
	pop af ; hROMBank
	add sp, -4
	rst Bankswitch

	pop af
	ret


section "farcall wram", wram0

wFarCallHold:    ds 3
wFarCallBank:    db
wFarCallTarget:  db ; jp
wFarCallAddress: dw
