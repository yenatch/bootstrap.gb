include "constants.asm"


section "Main", rom0

Main::
	call HelloWorld
.loop
	call Joypad
	call Scroll
	call HandleVBlank
	jr .loop

HandleVBlank:
	ld a, bank(MainCallback)
	ld hl, MainCallback
	call Callback
	call WaitVBlank
	ret

MainCallback:
	put [rSCY], [wSCY]
	put [rSCX], [wSCX]
	ret

Scroll:
button: macro
	ld a, [wJoy]
	and \1
endm
	put b, [wSCY]
	put c, [wSCX]

	button D_UP
	jr nz, .up
	dec b
.up
	button D_DOWN
	jr nz, .down
	inc b
.down
	button D_LEFT
	jr nz, .left
	dec c
.left
	button D_RIGHT
	jr nz, .right
	inc c
.right
	put [wSCY], b
	put [wSCX], c
	ret

section "main wram", wram0
wSCY: db
wSCX: db


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
