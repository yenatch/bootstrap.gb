NUM_CALLBACKS EQU 5
CALLBACK_LENGTH EQU 7


section "callback wram", wram0

wCallbacks:
	ds 1
	ds CALLBACK_LENGTH * NUM_CALLBACKS


section "callback", rom0

Callback::
; Call a:hl during the next vblank. Pass in bc and de.

	push bc
	push de

	ld b, a
	ld d, h
	ld e, l

	ld hl, wCallbacks
	ld a, [hli]
	and a
	jr z, .ok
	cp NUM_CALLBACKS
	jr nc, .exit

	push bc
	ld bc, CALLBACK_LENGTH
.loop
	add hl, bc
	dec a
	jr nz, .loop
	pop bc
.ok

	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl

	pop de
	pop bc

	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl

	ld a, [wCallbacks]
	inc a
	ld [wCallbacks], a
	ret

.exit
	pop de
	pop bc
	ret


;RunCallback:
;	ld hl, wCallbacks
;	ld a, [hli]
;	and a
;	ret z
;
;	put [wFarCallBank], [hli]
;	put [wFarCallAddress + 0], [hli]
;	put [wFarCallAddress + 1], [hli]
;	put b, [hli]
;	put c, [hli]
;	put d, [hli]
;	put e, [hli]
;
;	ld hl, wFarCallAddress
;	ld a, [hli]
;	ld h, [hl]
;	ld l, a
;
;	ld a, [hROMBank]
;	push af
;	ld a, [wFarCallBank]
;	rst Bankswitch
;
;	call __hl__
;
;	pop af
;	rst Bankswitch
;
;	ret


RunCallbacks:
	ld hl, wCallbacks
	ld a, [hli]
	and a
	ret z

.loop
	push af

	put [wFarCallBank], [hli]
	put [wFarCallAddress + 0], [hli]
	put [wFarCallAddress + 1], [hli]
	put b, [hli]
	put c, [hli]
	put d, [hli]
	put e, [hli]

	push hl

	ld hl, wFarCallAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hROMBank]
	push af
	ld a, [wFarCallBank]
	rst Bankswitch

	call __hl__

	pop af
	rst Bankswitch

	pop hl
	pop af
	dec a
	jr nz, .loop

	ld [wCallbacks], a
	ret
