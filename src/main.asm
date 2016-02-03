include "constants.asm"


START_TILE = $80 ; This maps to vChars1.

; All values are in tiles.
IMAGE_WIDTH = 10
IMAGE_HEIGHT = 4
IMAGE_X = 5
IMAGE_Y = 7


section "Main", rom0

Main::
	call .Setup
.loop
	call WaitVBlank
	jr .loop

.Setup:
	ld bc, .Graphics
	ld de, vChars1
	ld a, IMAGE_WIDTH * IMAGE_HEIGHT
	call QueueGfx

	ld de, vBGMap0 + BG_WIDTH * IMAGE_Y + IMAGE_X
	ld b, IMAGE_HEIGHT
	ld c, IMAGE_WIDTH
	callback .DrawTilemap

	call .SetPalette

	ret

.DrawTilemap:
	ld h, d
	ld l, e

	ld de, BG_WIDTH
	ld a, e
	sub c
	ld e, a

	ld a, START_TILE
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

.Graphics:
	INCBIN "gfx/hello_world.2bpp"

.SetPalette:
	ld a, %11100100 ; quaternary: 3210
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rBGP], a
	ret

