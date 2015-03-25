include "constants.asm"


section "Main", rom0

Main::
	call HelloWorld
.loop
	call Joypad
	call WaitVBlank
	jr .loop


section "Hello World", rom0

HelloWorld:
	ld bc, HelloWorldGfx
	ld de, $8800
	ld a, 10 * 4
	call QueueGfx

	ld a, bank(HelloWorldTilemap)
	ld hl, HelloWorldTilemap
	ld de, $9800 + 32 * 7 + 5
	ld b, 4
	ld c, 10
	call Callback

	call NormalPals

	ret


HelloWorldTilemap:

	ld h, d
	ld l, e

	ld de, 32
	ld a, e
	sub c
	ld e, a

	ld a, $80
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


HelloWorldGfx:
	INCBIN "gfx/hello_world.2bpp"


section "NormalPals", rom0

NormalPals:
	ld a, $e4
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rBGP], a
	ret
