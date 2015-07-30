include "constants.asm"


section "Hello World", rom0


HELLO_WORLD_START_TILE = $80 ; VChars1


HelloWorld:
	ld bc, HelloWorldGfx
	ld de, vChars1
	ld a, 10 * 4
	call QueueGfx

	ld de, vBGMap0 + BG_WIDTH * 7 + 5
	ld b, 4
	ld c, 10
	callback DrawHelloTilemap

	call NormalPals

	ret


DrawHelloTilemap:

	ld h, d
	ld l, e

	ld de, BG_WIDTH
	ld a, e
	sub c
	ld e, a

	ld a, HELLO_WORLD_START_TILE
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


NormalPals:
	ld a, %11100100 ; quaternary: 3210
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rBGP], a
	ret



section "Main", rom0


Main::
	call HelloWorld
.loop
	call Joypad
	call Scroll
	call RequestFrame
	jr .loop


RequestFrame:
	callback UpdateScroll
	call WaitVBlank
	ret


UpdateScroll:
	put [rSCY], [wSCY]
	put [rSCX], [wSCX]
	ret


Scroll:

if_button: macro
	ld a, [wJoy]
	and \1
	jr z, .ok\@
	\2
.ok\@
endm

	put b, [wSCY]
	put c, [wSCX]

	ld a, [wScrollReset]
	and a
	jr nz, .reset

	if_button START, jr .start

	if_button D_UP,    inc b
	if_button D_DOWN,  dec b
	if_button D_LEFT,  inc c
	if_button D_RIGHT, dec c
	jr .done

.start
	put [wScrollReset], 10
	jr .done

.reset
	dec a
	ld [wScrollReset], a

	ld a, b
	and %10000000 ; sign
	srl b
	or b
	ld b, a

	ld a, c
	and %10000000 ; sign
	srl c
	or c
	ld c, a

.done
	put [wSCY], b
	put [wSCX], c
	ret


section "main wram", wram0

wSCY: ds 1
wSCX: ds 1
wScrollReset: ds 1
