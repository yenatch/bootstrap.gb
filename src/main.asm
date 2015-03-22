include "constants.asm"


section "Main", rom0

Main::

	ld bc, HelloWorldGfx
	ld de, $8800
	ld a, 10 * 4
	call QueueGfx

	ld a, bank(HelloWorldTilemap)
	ld hl, HelloWorldTilemap
	call Callback

	call NormalPals

.done
	halt
	jr .done


section "Hello World", rom0

HelloWorldTilemap:
	ld a, $80
	ld hl, $9800 + 32 * 7 + 5
	ld de, 32 - 10
	ld b, 4
.y
	ld c, 10
.x
	ld [hli], a
	inc a
	dec c
	jr nz, .x
	add hl, de
	dec b
	jr nz, .y
	ret

HelloWorldGfx:
	INCBIN "gfx/hello_world.2bpp"


section "NormalPals", rom0

NormalPals:
	ld a, $e4
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rBGP], a
	ret
