NUM_CALLBACKS EQU 5
CALLBACK_LENGTH EQU 3


section "callback wram", wram0

wCallbacks:
	ds 1
	ds CALLBACK_LENGTH * NUM_CALLBACKS


section "callback", rom0

Callback::
; Call a:hl during the next vblank.

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

	ld a, [wCallbacks]
	inc a
	ld [wCallbacks], a

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
;	ld a, [hROMBank]
;	push af
;	ld a, [hli]
;	rst Bankswitch
;
;	ld a, [hli]
;	ld h, [hl]
;	ld l, a
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

	ld c, a
	put b, [hROMBank]
.loop
	push bc

	ld a, [hli]
	rst Bankswitch

	ld a, [hli]
	ld b, a
	ld a, [hli]

	push hl
	ld h, a
	ld l, b

	call __hl__

	pop hl
	pop bc

	dec c
	jr nz, .loop

	ld a, b
	rst Bankswitch

	xor a
	ld [wCallbacks], a
	ret
