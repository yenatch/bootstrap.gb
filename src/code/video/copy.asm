section "video copy", rom0

DrawTilemapRect::
; Fill a cxb rectangle at bg map address hl with a++.

	push af
	ld a, BG_WIDTH
	sub c
	ld e, a
	ld d, 0
	pop af

.y
	push bc
.x
	ld [hli], a
	inc a
	dec c
	jr nz, .x
	pop bc

	add hl, de
	dec b
	jr nz, .y

	ret
