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
	jr nc, .done

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
	jr .done

.done
	pop de
	pop bc
	ret


RunCallbacks:
	ld hl, wCallbacks
	ld a, [hli]
	and a
	jr z, .done
.loop
	push af

	ld a, [hli]
	ld [wFarCallBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hROMBank]
	push af
	ld a, [wFarCallBank]
	rst Bankswitch

	push hl
	call __hl__
	pop hl

	pop af
	rst Bankswitch

	pop af
	dec a
	jr nz, .loop
	ld [wCallbacks], a
.done
	ret
