GFX_QUEUE_LIMIT = 10
GFX_QUEUE_LENGTH = 2 + 2 + 1


section "gfx queue wram", wram0

wGfxQueue:
	ds 1
	ds GFX_QUEUE_LENGTH * GFX_QUEUE_LIMIT


section "gfx queue", rom0

QueueGfx::
; a:  length
; bc: source
; de: dest
	push hl

.add
	ld hl, wGfxQueue + 1
	push af
	ld a, [wGfxQueue]
	and a
	jr z, .ok
	cp GFX_QUEUE_LIMIT
	jr z, .exit

	push bc
	ld bc, GFX_QUEUE_LENGTH
.loop
	add hl, bc
	dec a
	jr nz, .loop
	pop bc
.ok
	pop af

	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl

	push af

	cp 8
	jr c, .good
	ld a, 8
.good
	ld [hli], a

	ld a, [wGfxQueue]
	inc a
	ld [wGfxQueue], a

	pop af

	sub 8
	jr c, .done
	jr z, .done

	push af

	ld a, $80
	add c
	ld c, a
	ld a, b
	adc 0
	ld b, a

	ld a, $80
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a

	pop af
	jr .add

.exit
	pop af
.done
	pop hl
	ret


LoadGfxQueue:
	ld hl, wGfxQueue
	ld a, [hli]
	and a
	ret z

	call LoadGfx

	ld a, [wGfxQueue]
	dec a
	ld [wGfxQueue], a

	call ShiftGfxQueue

	scf
	ret


LoadGfx:
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]

;	and a
;	ret z

	push hl
	ld l, e
	ld h, d
.loop
	ld e, a

	rept 16
	ld a, [bc]
	inc bc
	ld [hli], a
	endr

	ld a, e
	dec a
	jr nz, .loop
	pop hl

	ret


ShiftGfxQueue:
	ld hl, wGfxQueue + 1
	ld de, wGfxQueue + 1 + GFX_QUEUE_LENGTH
	ld c, (GFX_QUEUE_LIMIT - 1) * GFX_QUEUE_LENGTH
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop

;	xor a
;	rept GFX_QUEUE_LENGTH
;	ld [hli], a
;	endr

	ret
